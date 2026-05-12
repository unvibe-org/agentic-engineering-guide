#!/usr/bin/env bash
# Generates The Vibe Coder's Guide to Agentic Engineering PDF via Pandoc + Typst.
#
# Output: cover (page 1) + body chapters (pages 2..N) merged into one PDF.
#
# Usage:
#   ./generate-guide-pdf.sh                                 # default: chapters dir → final guide PDF
#   ./generate-guide-pdf.sh input.md [output.pdf]           # single chapter file
#   ./generate-guide-pdf.sh chapters-dir/ [output.pdf]      # all *.md, sorted
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INPUT="${1:-$SCRIPT_DIR/chapters}"
SKILL_REFS="$SCRIPT_DIR/.claude/skills/guide-pdf/references"
DESIGN="$SKILL_REFS/design.typ"
COVER_TYP="$SKILL_REFS/cover.typ"

BACK_COVER_TYP="$SKILL_REFS/back-cover.typ"
BLANK_PAGE_TYP="$SKILL_REFS/blank-page.typ"
ICC_PROFILE="$SKILL_REFS/ISOcoated_v2_300_eci.icc"
EMBED_INTENT="$SKILL_REFS/embed_output_intent.py"

TMP_BODY_TYP="$(mktemp /tmp/guide-body-XXXXXX.typ)"
TMP_COVER_PDF="$(mktemp /tmp/guide-cover-XXXXXX.pdf)"
TMP_BODY_PDF="$(mktemp /tmp/guide-body-XXXXXX.pdf)"
TMP_BLANK_PAGE_PDF="$(mktemp /tmp/guide-blank-XXXXXX.pdf)"
TMP_BACK_COVER_PDF="$(mktemp /tmp/guide-back-cover-XXXXXX.pdf)"
TMP_MERGED_PDF="$(mktemp /tmp/guide-merged-XXXXXX.pdf)"
TMP_CMYK_PDF="$(mktemp /tmp/guide-cmyk-XXXXXX.pdf)"

cleanup() { rm -f "$TMP_BODY_TYP" "$TMP_COVER_PDF" "$TMP_BODY_PDF" "$TMP_BLANK_PAGE_PDF" "$TMP_BACK_COVER_PDF" "$TMP_MERGED_PDF" "$TMP_CMYK_PDF"; }
trap cleanup EXIT

# 1. Compile the front cover
typst compile "$COVER_TYP" "$TMP_COVER_PDF"

# 2. Compile the body (Pandoc → Typst → PDF, prepending design.typ)
if [[ -d "$INPUT" ]]; then
  OUTPUT="${2:-$SCRIPT_DIR/agentic-engineering-guide.pdf}"
  mapfile -t INPUTS < <(find "$INPUT" -maxdepth 1 -name '*.md' | sort)
  if [[ ${#INPUTS[@]} -eq 0 ]]; then
    echo "No .md files found in $INPUT" >&2
    exit 1
  fi
  pandoc "${INPUTS[@]}" -t typst -o "$TMP_BODY_TYP"
else
  OUTPUT="${2:-${INPUT%.md}.pdf}"
  pandoc "$INPUT" -t typst -o "$TMP_BODY_TYP"
fi

cat "$DESIGN" "$TMP_BODY_TYP" | typst compile - "$TMP_BODY_PDF"

# 3. Compute page numbers
COVER_PAGES=$(qpdf --show-npages "$TMP_COVER_PDF")
BODY_PAGES=$(qpdf --show-npages "$TMP_BODY_PDF")
BLANK_PAGE=$(( COVER_PAGES + BODY_PAGES + 1 ))
BACK_COVER_PAGE=$(( BLANK_PAGE + 1 ))

# 4. Compile blank page with correct page number
typst compile --input page="$BLANK_PAGE" "$BLANK_PAGE_TYP" "$TMP_BLANK_PAGE_PDF"

# 5. Compile back cover with the correct continued page number
typst compile --input page="$BACK_COVER_PAGE" "$BACK_COVER_TYP" "$TMP_BACK_COVER_PDF"

# 6. Merge cover + body + blank + back cover
qpdf --empty --pages "$TMP_COVER_PDF" "$TMP_BODY_PDF" "$TMP_BLANK_PAGE_PDF" "$TMP_BACK_COVER_PDF" -- "$TMP_MERGED_PDF"

# 7. Convert to CMYK with Ghostscript
gs -q -dBATCH -dNOPAUSE -dNOSAFER \
   -sDEVICE=pdfwrite \
   -dCompatibilityLevel=1.6 \
   -dProcessColorModel=/DeviceCMYK \
   -dColorConversionStrategy=/CMYK \
   -sDefaultCMYKProfile="$ICC_PROFILE" \
   -sOutputFile="$TMP_CMYK_PDF" \
   "$TMP_MERGED_PDF"

# 8. Embed ISOcoated v2 300% as PDF OutputIntent
python3 "$EMBED_INTENT" "$TMP_CMYK_PDF" "$ICC_PROFILE" "$OUTPUT"
