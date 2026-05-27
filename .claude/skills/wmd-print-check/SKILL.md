---
name: wmd-print-check
description: Pre-flight check of a PDF against WIRmachenDRUCK (wir-machen-druck.de) print requirements before upload. Runs automated checks for dimensions/bleed, font embedding, image DPI, ICC colour profile, crop marks, and page count parity, then lists the manual checks that remain. Use when the user says "check the PDF for print", "WIRmachenDRUCK check", "pre-flight the guide", or is about to upload a PDF to WIRmachenDRUCK.
---

# WIRmachenDRUCK Print Pre-flight

Run `scripts/check_wmd.sh` to perform automated checks, then work through the manual checklist below.

## WIRmachenDRUCK requirements (reference)

| Requirement | Spec |
|---|---|
| Colour mode | CMYK |
| ICC profile | **ISOcoated v2 300%** (not the 390% variant) |
| Bleed | **3 mm** on all sides — upload size = final format + 6mm each dimension |
| Resolution | **300 ppi minimum** for raster images up to A3 |
| Fonts | All embedded or converted to outlines |
| PDF standard | PDF/X-4 or PDF/X-1a |
| Crop marks | **Do not add** — WIRmachenDRUCK places them automatically |
| Page layout | Single pages only — no reader spreads |
| Page count | Must be even for any bound product |
| Ink coverage | Total ink ≤ 300% (enforced by ISOcoated v2 300% profile) |

For the bettervibe guide specifically:
- Final format: **A5 (148 × 210 mm)**
- Upload format (with bleed): **154 × 216 mm**
- Default check uses these dimensions

## Step 1 — Run the automated check

```bash
bash ~/.claude/skills/wmd-print-check/scripts/check_wmd.sh <path/to/file.pdf>
```

For a non-A5 format, pass the expected upload dimensions (final + 3mm bleed each side) as additional args:

```bash
bash ~/.claude/skills/wmd-print-check/scripts/check_wmd.sh file.pdf 210 297   # A4 example
```

The script checks (requires poppler and optionally exiftool):
- **Dimensions** — upload size matches expected (±1mm tolerance)
- **Page count** — even (required for bound products)
- **Font embedding** — all fonts embedded
- **Image DPI** — all raster images ≥ 300 ppi
- **ICC profile** — ISOcoated detected (needs `exiftool`: `brew install exiftool`)
- **Crop marks** — no visible crop mark content streams
- **PDF/X conformance** — XMP claim of PDF/X-4 or PDF/X-1a (via `exiftool`), plus a Ghostscript `-dPDFX` semantic pass (soft warning)
- **Total Area Coverage** — per-pixel TAC ≤ 300% on every page. Renders CMYK separations at 150 dpi via Ghostscript `tiffsep`, then sums C+M+Y+K per pixel and reports the worst offender. Needs `python3` with `numpy` + `Pillow` (`pip3 install numpy Pillow`).

## Step 2 — Install missing tools if needed

If the script warns about missing tools:

```bash
brew install poppler    # pdfinfo, pdffonts, pdfimages
brew install exiftool   # ICC profile detection
```

Re-run after installing.

## Step 3 — Fix any failures

Common fixes:

**Odd page count** — add a blank page at the end before exporting.

**Low-resolution images** — identify the source file and replace with a 300 ppi version. For photos, 288 ppi is the most common culprit (72 dpi × 4 or 96 dpi scaled). In Typst, avoid scaling raster images up significantly from their source resolution.

**Unembedded fonts** — re-export with font embedding enabled. In Typst this is on by default; if fonts are missing at export time, Typst substitutes — check that all fonts are installed on the build machine.

**Wrong dimensions** — check the Typst page size declaration and the bleed settings in the export pipeline.

**RGB / wrong ICC profile** — raster images embedded in the PDF may be RGB even when the document colour space is CMYK. Re-export source images as CMYK with ISOcoated v2 300% before embedding, or use Acrobat's "Convert Colors" preflight fixup.

**TAC > 300%** — a CMYK-converted PDF can still have small over-inked regions even with the ISOcoated v2 300% profile attached, especially on cover backgrounds and dark image edges. Run the TAC check standalone for a pixel coordinate (`scripts/tac_check.py file.pdf`), then locate the offending page in the source. For deep-black backgrounds, ensure the colour is built as e.g. `C50 M40 Y40 K100` (rich black ≤ 300%) rather than mixing all four channels at full strength.

For raster images (avatars, photos, dark JPEGs embedded in the PDF), use the `clamp_tac.py` helper. It converts RGB → CMYK via the ICC profile and proportionally scales any over-inked pixel down to the target ceiling (channels scaled together, hue preserved):

```bash
python3 ~/.claude/skills/wmd-print-check/scripts/clamp_tac.py input.jpg output.cmyk.jpg --ceiling 290
```

Save next to the original (e.g. `adam-photo.cmyk.jpg`) and update the source to reference the new file. Default ceiling is 290% to leave headroom for downstream rendering. Requires `imagemagick` (`brew install imagemagick`) plus `numpy` + `Pillow`.

> **Coordinate sanity check:** when the TAC checker reports a pixel like `(171, 1029)`, those coordinates are in the tiffsep render — at the renderer's chosen resolution, not necessarily the page DPI you expect. Compute the offending location in mm via `x/render_width * page_width_mm`, not `x/dpi * 25.4`. Getting this wrong sends you hunting for the wrong element on the page.

**Missing PDF/X claim** — the file is structurally fine but doesn't advertise PDF/X-4 in its XMP metadata. Re-export with PDF/X-4 enabled in the export pipeline (Typst+Pandoc: pass `--pdf-engine-opt=...` or post-process with Ghostscript `gs -dPDFX -sOutputFile=out.pdf -sColorConversionStrategy=CMYK -sProcessColorModel=DeviceCMYK ...`).

## Step 4 — Manual checks (can't be automated)

Work through these after the script passes:

- [ ] **Single pages** — open the PDF in Preview/Acrobat and confirm no spreads.
- [ ] **Visual bleed check** — zoom to a corner. Background colour/imagery should extend to the page edge (the bleed area). No white slivers.
- [ ] **Safe zone** — important content (text, logos) is at least 3–5 mm inside the trim line. Nothing critical sits in the bleed zone.
- [ ] **Karpathy quote and all proper names** — one last eyeball pass on the epigraph, instructor bios, and anywhere names appear.

## Step 5 — Upload

1. Upload to WIRmachenDRUCK.
2. Select **Profi-Check** (paid) — not just Basis-Check. Profi-Check catches colour profile mismatches, overprint issues, and fine hairlines that the Basis-Check misses.
3. Review the Profi-Check report before approving.
4. Order **one physical proof copy** before the full print run.
