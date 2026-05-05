
// bettervibe — The Vibe Coder's Guide to Agentic Engineering · front cover
// A5 + 3mm bleed → 154 × 216 mm, no margins (positioning manual via #place).
// Renders the pre-designed PNG cover image full-bleed.
// Image is sized to A5+bleed (154×216mm at 300dpi = 1819×2551px).
//
// Lives at .claude/skills/guide-pdf/references/cover.typ
// Compiled standalone, then merged with the body PDF (see generate-guide-pdf.sh).

#set page(
  width: 154mm,
  height: 216mm,
  margin: 0mm,
)

#image(
  "vibecoders_guide_cover_a5_bleed_cmyk.jpg",
  width: 154mm,
  height: 216mm,
  fit: "cover",
)
