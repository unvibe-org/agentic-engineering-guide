#!/usr/bin/env python3
"""Rewrite the front-cover footer (site URL + version) in place.

The front cover is a pre-rendered raster (illustration + baked text); cover.typ
only places that image full-bleed. So the footer strings — `unvibe.org` (amber
dot) bottom-left and `vX.Y · YYYY` bottom-right — cannot be edited in Typst.
This script erases those two strings and redraws them in real JetBrains Mono at
the same pixel positions, on all three cover assets:

  vibecoders_guide_cover_a5_bleed_300dpi.png   (RGB source, with bleed)
  vibecoders_guide_cover_a5_300dpi.png         (RGB source, no bleed)
  vibecoders_guide_cover_a5_bleed_cmyk.jpg     (CMYK, the file the build uses)

The illustration is left untouched; only the two footer strips are repainted,
so the CMYK JPG keeps its embedded ISO Coated v2 300% profile.

Usage:
    python3 rebrand_cover_footer.py --version v1.1 --year 2026 [--url unvibe.org]

Idempotent: the erase boxes cover the current footer text, so re-running with a
new version just repaints it. If the cover ARTWORK is ever regenerated, the
LAYOUTS coordinates below must be re-measured (they are pixel-specific).

Requires: Pillow, JetBrains Mono installed (JetBrainsMono-Medium.ttf).
"""
import argparse
import glob
import os
import sys

from PIL import Image, ImageDraw, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
FONT_CANDIDATES = [
    os.path.expanduser("~/Library/Fonts/JetBrainsMono-Medium.ttf"),
    "/Library/Fonts/JetBrainsMono-Medium.ttf",
]

ASSETS = [
    "vibecoders_guide_cover_a5_bleed_300dpi.png",
    "vibecoders_guide_cover_a5_300dpi.png",
    "vibecoders_guide_cover_a5_bleed_cmyk.jpg",
]

# Authors credited on the front cover (bottom, above the footer), alphabetical by
# last name. Joined with " • ".
AUTHORS = ["Adam Charnock", "Luca Dombetzki", "Dominik Grusemann", "Traun Leyden"]

# Footer + authors layout per image geometry, measured from the cover artwork.
#   erN/aut_er = erase boxes (ex0, ex1, ey0, ey1, src_x0, src_x1) — the last two
#               give a clean same-row background band to sample the fill from.
#   uv_*   = unvibe.org: left ink x, ascender-top y, font size.
#   ver_*  = version:    right ink x, top y, font size.
#   aut_*  = authors row: erase box, left ink x, ascender-top y, font size.
LAYOUTS = {
    (1819, 2551): dict(  # bleed
        er1=(255, 720, 2412, 2482, 760, 1480), er2=(1515, 1712, 2432, 2468, 1120, 1450),
        uv_x=266, uv_top=2427, uv_size=42, ver_right=1703, ver_top=2440, ver_size=26,
        aut_er=(255, 1620, 2358, 2404, 1650, 1800), aut_x=265, aut_top=2365, aut_size=32),
    (1748, 2480): dict(  # no bleed
        er1=(244, 700, 2346, 2414, 740, 1420), er2=(1455, 1645, 2364, 2400, 1080, 1400),
        uv_x=255, uv_top=2360, uv_size=40, ver_right=1636, ver_top=2372, ver_size=25,
        aut_er=(244, 1560, 2292, 2338, 1580, 1730), aut_x=255, aut_top=2299, aut_size=31),
}

# Colours sampled from the original artwork.
RGB = dict(cream=(232, 232, 232), amber=(255, 120, 60), muted=(154, 154, 154))
CMYK = dict(cream=(0, 0, 0, 23), amber=(0, 137, 195, 0), muted=(0, 0, 0, 101))


def font(size):
    for p in FONT_CANDIDATES:
        if os.path.exists(p):
            return ImageFont.truetype(p, size)
    sys.exit("JetBrainsMono-Medium.ttf not found — install JetBrains Mono.")


def inpaint(im, ex0, ex1, ey0, ey1, sx0, sx1):
    """Erase a box by copying, per row, the median background pixel from a clean band."""
    px = im.load()
    chans = im.getpixel((0, 0))
    n = len(chans) if isinstance(chans, tuple) else 1
    for y in range(ey0, ey1):
        s = [px[x, y] for x in range(sx0, sx1)]
        mid = len(s) // 2
        fill = int(sorted(s)[mid]) if n == 1 else tuple(int(sorted(v[c] for v in s)[mid]) for c in range(n))
        for x in range(ex0, ex1):
            px[x, y] = fill


def draw(im, segments, x0, baseline, size, right=None):
    """Draw coloured monospace segments; right-align to `right` if given."""
    f = font(size)
    pen = x0 if right is None else right - f.getlength("".join(t for t, _ in segments))
    for text, color in segments:
        mask = Image.new("L", im.size, 0)
        ImageDraw.Draw(mask).text((pen, baseline), text, fill=255, font=f, anchor="ls")
        im.paste(Image.new(im.mode, im.size, color), (0, 0), mask)
        pen += f.getlength(text)


def rebrand(im, url, version, year, authors):
    col = CMYK if im.mode == "CMYK" else RGB
    L = LAYOUTS[im.size]
    # authors row (muted, above the footer)
    inpaint(im, *L["aut_er"])
    draw(im, [(" • ".join(authors), col["muted"])],
         L["aut_x"], L["aut_top"] + font(L["aut_size"]).getmetrics()[0] - 2, L["aut_size"])
    # footer: unvibe.org (amber dot) + version
    inpaint(im, *L["er1"])
    inpaint(im, *L["er2"])
    host, _, tld = url.partition(".")
    draw(im, [(host, col["cream"]), (".", col["amber"]), (tld, col["cream"])],
         L["uv_x"], L["uv_top"] + font(L["uv_size"]).getmetrics()[0] - 2, L["uv_size"])
    draw(im, [(f"{version} • {year}", col["muted"])],
         0, L["ver_top"] + font(L["ver_size"]).getmetrics()[0] - 1, L["ver_size"],
         right=L["ver_right"])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--version", required=True, help="e.g. v1.1")
    ap.add_argument("--year", required=True, help="e.g. 2026")
    ap.add_argument("--url", default="unvibe.org")
    ap.add_argument("--authors", default=" • ".join(AUTHORS),
                    help='author names separated by " • " (default: the credited authors)')
    args = ap.parse_args()
    authors = [a.strip() for a in args.authors.split("•") if a.strip()]
    for name in ASSETS:
        path = os.path.join(HERE, name)
        im = Image.open(path)
        icc = im.info.get("icc_profile")
        if im.mode != "CMYK":
            im = im.convert("RGB")
        rebrand(im, args.url, args.version, args.year, authors)
        if im.mode == "CMYK":
            im.save(path, quality=95, **({"icc_profile": icc} if icc else {}))
        else:
            im.save(path)
        print(f"updated {name} → {args.url}  {args.version} • {args.year}")


if __name__ == "__main__":
    main()
