#!/usr/bin/env python3
"""Per-pixel Total Area Coverage (TAC) check for a CMYK PDF.

Renders CMYK separations via Ghostscript's tiffsep device, then for each page
computes the maximum per-pixel sum of C+M+Y+K. Fails if any page exceeds the
limit (default 300%, matching ISO Coated v2 300%).

Usage: tac_check.py <file.pdf> [--limit 300] [--dpi 150]
Exit: 0 = all pages within limit, 1 = limit exceeded, 2 = tool error.
"""
import argparse
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

import numpy as np
from PIL import Image

CMYK_NAMES = ("Cyan", "Magenta", "Yellow", "Black")


def render_separations(pdf: Path, out_dir: Path, dpi: int) -> None:
    cmd = [
        "gs", "-dSAFER", "-dBATCH", "-dNOPAUSE", "-q",
        f"-r{dpi}",
        "-sDEVICE=tiffsep",
        "-dPDFFitPage=false",
        f"-sOutputFile={out_dir}/page-%d.tif",
        str(pdf),
    ]
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode != 0:
        sys.stderr.write(res.stderr)
        raise SystemExit(2)


def page_files(out_dir: Path) -> dict[int, dict[str, Path]]:
    """Group separation TIFFs by page number."""
    pages: dict[int, dict[str, Path]] = {}
    pat = re.compile(r"page-(\d+)\(([^)]+)\)\.tif$")
    for p in out_dir.iterdir():
        m = pat.match(p.name)
        if not m:
            continue
        page_num = int(m.group(1))
        chan = m.group(2)
        if chan in CMYK_NAMES:
            pages.setdefault(page_num, {})[chan] = p
    return pages


def max_tac(channels: dict[str, Path]) -> tuple[float, tuple[int, int]]:
    """Return (max_tac_percent, (x, y)) for one page."""
    total = None
    for name in CMYK_NAMES:
        path = channels.get(name)
        if path is None:
            continue
        # tiffsep separations are stored inverted: 255 = no ink, 0 = full ink.
        # Invert so higher value = more ink.
        arr = 255 - np.asarray(Image.open(path), dtype=np.uint16)
        total = arr if total is None else total + arr
    if total is None:
        return 0.0, (0, 0)
    idx = int(np.argmax(total))
    y, x = divmod(idx, total.shape[1])
    peak = float(total.max()) / 255.0 * 100.0
    return peak, (x, y)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("pdf", type=Path)
    ap.add_argument("--limit", type=float, default=300.0, help="TAC limit in percent")
    ap.add_argument("--dpi", type=int, default=150, help="Render resolution")
    ap.add_argument("--quiet", action="store_true")
    args = ap.parse_args()

    if not args.pdf.is_file():
        print(f"File not found: {args.pdf}", file=sys.stderr)
        return 2

    with tempfile.TemporaryDirectory(prefix="tac-") as tmp:
        tmp_path = Path(tmp)
        render_separations(args.pdf, tmp_path, args.dpi)
        pages = page_files(tmp_path)
        if not pages:
            print("No CMYK separations produced. Is the PDF actually CMYK?", file=sys.stderr)
            return 2

        worst_page = 0
        worst_tac = 0.0
        worst_xy = (0, 0)
        offenders = []
        for n in sorted(pages):
            tac, xy = max_tac(pages[n])
            if tac > worst_tac:
                worst_tac, worst_page, worst_xy = tac, n, xy
            if tac > args.limit:
                offenders.append((n, tac, xy))

    if not args.quiet:
        print(f"Pages scanned: {len(pages)}  (rendered at {args.dpi} dpi)")
        print(f"Worst TAC: {worst_tac:.1f}% on page {worst_page} at pixel {worst_xy}")
        if offenders:
            print(f"Pages exceeding {args.limit:.0f}% TAC:")
            for n, tac, (x, y) in offenders:
                print(f"  page {n}: {tac:.1f}% at pixel ({x}, {y})")
        else:
            print(f"All pages ≤ {args.limit:.0f}% TAC.")

    return 1 if offenders else 0


if __name__ == "__main__":
    sys.exit(main())
