#!/usr/bin/env bash
# WIRmachenDRUCK pre-flight check for a PDF file.
# Usage: ./check_wmd.sh <file.pdf> [expected_width_mm] [expected_height_mm]
# Defaults to A5 + 3mm bleed all sides: 154x216mm

set -euo pipefail

PDF="${1:-}"
EXPECTED_W="${2:-154}"  # mm — final format + 3mm bleed each side
EXPECTED_H="${3:-216}"

RED='\033[0;31m'
YLW='\033[1;33m'
GRN='\033[0;32m'
RST='\033[0m'

pass() { echo -e "  ${GRN}✓${RST} $1"; }
warn() { echo -e "  ${YLW}⚠${RST}  $1"; }
fail() { echo -e "  ${RED}✗${RST} $1"; FAILURES=$((FAILURES+1)); }

if [[ -z "$PDF" ]]; then
  echo "Usage: $0 <file.pdf> [expected_width_mm] [expected_height_mm]"
  exit 1
fi

if [[ ! -f "$PDF" ]]; then
  echo "File not found: $PDF"
  exit 1
fi

FAILURES=0

echo ""
echo "WIRmachenDRUCK pre-flight: $(basename "$PDF")"
echo "────────────────────────────────────────────"

# ── 1. pdfinfo ────────────────────────────────────────────────────────────────
if ! command -v pdfinfo &>/dev/null; then
  warn "pdfinfo not found (install poppler: brew install poppler). Skipping dimension + version checks."
else
  INFO=$(pdfinfo "$PDF" 2>/dev/null)

  # PDF version
  PDF_VER=$(echo "$INFO" | grep "^PDF version" | awk '{print $NF}')
  if [[ -n "$PDF_VER" ]]; then
    pass "PDF version: $PDF_VER"
  else
    warn "Could not detect PDF version."
  fi

  # Page size (pdfinfo gives pts; 1pt = 0.352778mm)
  SIZE_LINE=$(echo "$INFO" | grep "^Page size" | head -1)
  if [[ -n "$SIZE_LINE" ]]; then
    W_PT=$(echo "$SIZE_LINE" | grep -oE '[0-9]+(\.[0-9]+)?' | sed -n '1p')
    H_PT=$(echo "$SIZE_LINE" | grep -oE '[0-9]+(\.[0-9]+)?' | sed -n '2p')
    W_MM=$(echo "scale=1; $W_PT * 0.352778" | bc)
    H_MM=$(echo "scale=1; $H_PT * 0.352778" | bc)
    echo "  Page size: ${W_MM}×${H_MM} mm (expected ${EXPECTED_W}×${EXPECTED_H} mm)"
    W_OK=$(echo "$W_MM >= $((EXPECTED_W-1)) && $W_MM <= $((EXPECTED_W+1))" | bc -l)
    H_OK=$(echo "$H_MM >= $((EXPECTED_H-1)) && $H_MM <= $((EXPECTED_H+1))" | bc -l)
    if [[ "$W_OK" == "1" && "$H_OK" == "1" ]]; then
      pass "Dimensions match expected ${EXPECTED_W}×${EXPECTED_H} mm (±1mm)"
    else
      fail "Dimensions ${W_MM}×${H_MM} mm do not match expected ${EXPECTED_W}×${EXPECTED_H} mm"
    fi
  else
    warn "Could not parse page size."
  fi

  # Page count
  PAGES=$(echo "$INFO" | grep "^Pages" | awk '{print $NF}')
  if [[ -n "$PAGES" ]]; then
    if (( PAGES % 2 == 0 )); then
      pass "Page count: $PAGES (even — OK for print)"
    else
      fail "Page count: $PAGES (odd — print requires even page count)"
    fi
  fi
fi

# ── 2. Font embedding (pdffonts) ──────────────────────────────────────────────
if ! command -v pdffonts &>/dev/null; then
  warn "pdffonts not found (install poppler). Skipping font checks."
else
  FONT_ISSUES=$(pdffonts "$PDF" 2>/dev/null | tail -n +3 | awk '$5 == "no" {print $0}')
  if [[ -z "$FONT_ISSUES" ]]; then
    pass "All fonts embedded"
  else
    fail "Unembedded fonts detected:"
    echo "$FONT_ISSUES" | while read -r line; do
      echo "      $line"
    done
  fi
fi

# ── 3. Raster image resolution (pdfimages) ────────────────────────────────────
if ! command -v pdfimages &>/dev/null; then
  warn "pdfimages not found (install poppler). Skipping image DPI checks."
else
  LOW_RES=$(pdfimages -list "$PDF" 2>/dev/null | tail -n +3 | awk '
    NR>0 {
      xppi=$13; yppi=$14
      if (xppi ~ /^[0-9]+$/ && yppi ~ /^[0-9]+$/) {
        if (xppi+0 < 300 || yppi+0 < 300)
          print "  page " $2 ": " xppi "×" yppi " ppi — below 300 dpi minimum"
      }
    }
  ')
  if [[ -z "$LOW_RES" ]]; then
    pass "All raster images ≥ 300 ppi"
  else
    fail "Low-resolution images found:"
    echo "$LOW_RES"
  fi
fi

# ── 4. ICC / colour profile ───────────────────────────────────────────────────
# Primary: check PDF catalog OutputIntents via Python (pikepdf)
ICC=""
if command -v python3 &>/dev/null && python3 -c "import pikepdf" 2>/dev/null; then
  ICC=$(python3 - "$PDF" <<'PYEOF'
import sys, pikepdf
try:
    pdf = pikepdf.open(sys.argv[1])
    intents = pdf.Root.get("/OutputIntents", [])
    for intent in intents:
        obj = pdf.get_object(intent.objgen) if hasattr(intent, "objgen") else intent
        desc = str(obj.get("/OutputConditionIdentifier", obj.get("/Info", "")))
        if desc:
            print(desc)
            break
except Exception:
    pass
PYEOF
)
fi

# Fallback: exiftool XMP ProfileDescription (covers directly embedded ICC streams)
if [[ -z "$ICC" ]] && command -v exiftool &>/dev/null; then
  ICC=$(exiftool -ProfileDescription "$PDF" 2>/dev/null | awk -F': ' '{print $2}' | head -1)
fi

if echo "$ICC" | grep -qi "ISOcoated\|ISO Coated"; then
  pass "ICC profile: ISOcoated detected"
  if echo "$ICC" | grep -qi "300\|eci"; then
    pass "  Profile: $ICC"
  else
    warn "  Could not confirm '300%' variant — confirm it's ISOcoated v2 300%, not the 390% version"
  fi
elif echo "$ICC" | grep -qi "CMYK"; then
  warn "CMYK profile present but not ISOcoated v2 300%. WIRmachenDRUCK requires ISOcoated v2 300%."
elif echo "$ICC" | grep -qi "sRGB\|RGB"; then
  fail "RGB colour profile detected. Convert to CMYK with ISOcoated v2 300%."
elif [[ -z "$ICC" ]]; then
  if ! command -v python3 &>/dev/null || ! python3 -c "import pikepdf" 2>/dev/null; then
    warn "pikepdf not available (pip3 install pikepdf). Could not check PDF OutputIntents."
  else
    warn "No ICC profile detected. Embed ISOcoated v2 300% before upload."
  fi
else
  warn "Unknown profile: $ICC"
fi

# ── 5. Crop marks (gs text scan) ─────────────────────────────────────────────
if command -v gs &>/dev/null; then
  # Naive heuristic: crop mark PostScript operators in content stream
  MARKS=$(gs -dBATCH -dNOPAUSE -sDEVICE=txtwrite -sOutputFile=- -q "$PDF" 2>/dev/null | \
    grep -ci "TrimBox\|CropBox\|BleedBox" || true)
  if [[ "$MARKS" -gt 0 ]]; then
    warn "TrimBox/CropBox/BleedBox entries found — confirm no visible crop marks are drawn in content (WIRmachenDRUCK adds their own)."
  else
    pass "No crop mark indicators found in content stream"
  fi
fi

# ── 6. PDF/X conformance ──────────────────────────────────────────────────────
# Layer 1: XMP claim via exiftool (what Acrobat's Properties dialog reads)
PDFX_VER=""
PDFX_CONF=""
if command -v exiftool &>/dev/null; then
  PDFX_VER=$(exiftool -s3 -GTS_PDFXVersion "$PDF" 2>/dev/null | head -1 || true)
  PDFX_CONF=$(exiftool -s3 -GTS_PDFXConformance "$PDF" 2>/dev/null | head -1 || true)
fi

if [[ -n "$PDFX_VER" ]]; then
  if echo "$PDFX_VER" | grep -qiE "PDF/X-(4|1a)"; then
    pass "PDF/X claim: $PDFX_VER${PDFX_CONF:+ ($PDFX_CONF)}"
  else
    fail "PDF/X claim is '$PDFX_VER' — WIRmachenDRUCK expects PDF/X-4 or PDF/X-1a"
  fi
else
  fail "No PDF/X conformance claim in XMP metadata. Re-export as PDF/X-4 or PDF/X-1a."
fi

# Layer 2: Ghostscript semantic check (soft warning — gs is strict and noisy)
if command -v gs &>/dev/null; then
  GS_ERR=$(gs -dPDFX -dBATCH -dNOPAUSE -dNOOUTERSAVE -sDEVICE=nullpage "$PDF" 2>&1 1>/dev/null | grep -iE "error|warning" | head -5 || true)
  if [[ -n "$GS_ERR" ]]; then
    warn "Ghostscript -dPDFX reported issues (review manually):"
    echo "$GS_ERR" | while read -r line; do
      echo "      $line"
    done
  else
    pass "Ghostscript -dPDFX semantic check clean"
  fi
fi

# ── 7. Total Area Coverage (per-pixel TAC) ────────────────────────────────────
TAC_SCRIPT="$(dirname "$0")/tac_check.py"
if command -v gs &>/dev/null && command -v python3 &>/dev/null \
    && python3 -c "import numpy, PIL" 2>/dev/null \
    && [[ -f "$TAC_SCRIPT" ]]; then
  TAC_OUT=$(python3 "$TAC_SCRIPT" "$PDF" --quiet 2>&1; echo "RC=$?")
  TAC_RC=$(echo "$TAC_OUT" | tail -1 | sed 's/RC=//')
  TAC_BODY=$(echo "$TAC_OUT" | sed '$d')
  if [[ "$TAC_RC" == "0" ]]; then
    pass "Total Area Coverage ≤ 300% on all pages"
  elif [[ "$TAC_RC" == "1" ]]; then
    fail "Total Area Coverage exceeds 300% on some pages:"
    # re-run verbose to print page list
    python3 "$TAC_SCRIPT" "$PDF" 2>/dev/null | sed 's/^/      /' || true
  else
    warn "TAC check failed to run:"
    echo "$TAC_BODY" | sed 's/^/      /'
  fi
else
  warn "TAC check skipped (needs gs + python3 with numpy + Pillow)."
fi

# ── 8. Summary ────────────────────────────────────────────────────────────────
echo ""
echo "────────────────────────────────────────────"
if [[ "$FAILURES" -eq 0 ]]; then
  echo -e "${GRN}All automated checks passed.${RST}"
  echo ""
  echo "Manual checks still required:"
  echo "  □ Upload via WIRmachenDRUCK Profi-Check (paid) for full preflight"
  echo "  □ Order a single physical proof copy before the full print run"
  echo "  □ Verify no spreads (single pages only)"
  echo "  □ Visual bleed check at corners (no white slivers)"
  echo "  □ Safe zone: critical content ≥ 3–5 mm inside trim"
else
  echo -e "${RED}$FAILURES check(s) failed. Fix before uploading.${RST}"
  echo ""
  echo "After fixing, re-run this script, then:"
  echo "  □ Upload via WIRmachenDRUCK Profi-Check for full preflight"
fi
echo ""
