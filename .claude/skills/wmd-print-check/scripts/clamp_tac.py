#!/usr/bin/env python3
"""Clamp a JPEG's per-pixel Total Area Coverage to a target ceiling.

Workflow: convert RGB → CMYK via ICC profile (using ImageMagick), then scale
any pixel whose C+M+Y+K sum exceeds the ceiling so the sum lands exactly at
the ceiling. Channels are scaled proportionally to preserve hue.

Usage:
  clamp_tac.py <input.jpg> <output.jpg> [--ceiling 290] [--icc <profile.icc>]

If --icc is omitted, defaults to the ISOcoated_v2_300_eci.icc that ships with
the guide-pdf skill. Input may be RGB or CMYK; output is always CMYK JPEG.
"""
import argparse
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

import numpy as np
from PIL import Image

DEFAULT_ICC = Path.home() / "Code/vibe-coding-workshop/.claude/skills/guide-pdf/references/ISOcoated_v2_300_eci.icc"


def to_cmyk_via_icc(src: Path, dst: Path, icc: Path) -> None:
    if shutil.which("magick") is None:
        raise SystemExit("ImageMagick (`magick`) is required for RGB→CMYK conversion. brew install imagemagick")
    subprocess.run(
        ["magick", str(src), "-colorspace", "sRGB", "-profile", str(icc), "-colorspace", "CMYK", str(dst)],
        check=True,
    )


def clamp(in_path: Path, out_path: Path, ceiling: float) -> None:
    im = Image.open(in_path)
    if im.mode != "CMYK":
        raise SystemExit(f"expected CMYK input, got {im.mode}")
    arr = np.asarray(im, dtype=np.float32)
    total = arr.sum(axis=2, keepdims=True)
    limit = ceiling / 100.0 * 255.0
    scale = np.where(total > limit, limit / np.maximum(total, 1e-6), 1.0)
    arr_clamped = np.clip(arr * scale, 0, 255).astype(np.uint8)
    out = Image.fromarray(arr_clamped, mode="CMYK")
    out.save(out_path, "JPEG", quality=92)
    before = float(total.max()) / 255.0 * 100.0
    after = float(arr_clamped.astype(np.uint32).sum(axis=2).max()) / 255.0 * 100.0
    print(f"{in_path.name}: max TAC {before:.1f}% → {after:.1f}% (ceiling {ceiling:.0f}%)")


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("input", type=Path)
    ap.add_argument("output", type=Path)
    ap.add_argument("--ceiling", type=float, default=290.0, help="TAC ceiling in percent (default 290)")
    ap.add_argument("--icc", type=Path, default=DEFAULT_ICC, help="ICC profile for RGB→CMYK conversion")
    args = ap.parse_args()

    if not args.input.is_file():
        print(f"file not found: {args.input}", file=sys.stderr)
        return 2

    src = args.input
    cleanup = None
    if Image.open(src).mode != "CMYK":
        if not args.icc.is_file():
            print(f"ICC profile not found: {args.icc}", file=sys.stderr)
            return 2
        tmp = Path(tempfile.mkstemp(suffix=".cmyk.jpg")[1])
        cleanup = tmp
        to_cmyk_via_icc(src, tmp, args.icc)
        src = tmp

    try:
        clamp(src, args.output, args.ceiling)
    finally:
        if cleanup and cleanup.exists():
            cleanup.unlink()
    return 0


if __name__ == "__main__":
    sys.exit(main())
