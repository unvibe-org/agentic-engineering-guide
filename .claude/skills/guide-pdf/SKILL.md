---
name: guide-pdf
description: Convert The Vibe Coder's Guide to Agentic Engineering markdown chapters into a brand-compliant printable PDF using Pandoc + Typst and the unvibe design system. Includes the front cover and back cover. Use this skill when the user asks to generate, export, regenerate, or produce a PDF of the guide — or to update the cover (authors, version, date).
---

# Guide PDF Generation Skill

Produces *The Vibe Coder's Guide to Agentic Engineering* as a single A5 PDF: front cover (page 1) + body chapters (pages 2..N) + back cover (last page), all on the unvibe terminal design system.

## Toolchain: Pandoc + Typst + qpdf

**Why not browser-based tools?** `@page` margin areas in Chrome's PDF engine render outside the HTML canvas and can't be painted by CSS — leaves white borders. Typst solves this at the root: `fill` on `#set page()` colors the entire physical page including margins.

**Why qpdf for merging?** The cover is a single-page Typst doc with its own page geometry (A5 + 3mm bleed). The body uses different page rules. Compiling them separately keeps each clean; qpdf concatenates the resulting PDFs.

### Install (one-time)

```bash
brew install typst pandoc qpdf
```

### Check

```bash
typst --version && pandoc --version && qpdf --version
```

---

## Generate the PDF

```bash
bash generate-guide-pdf.sh
```

Default output: `agentic-engineering-guide.pdf`. The script does four things:
1. Typst compiles `references/cover.typ` → `cover.pdf`
2. Pandoc converts `chapters/*.md` (sorted by filename) → Typst body, then prepends `references/design.typ` and Typst compiles → `body.pdf`
3. Typst compiles `references/back-cover.typ` → `back-cover.pdf`
4. qpdf merges `cover.pdf` + `body.pdf` + `back-cover.pdf` → final PDF

Explicit paths are also supported:

```bash
bash generate-guide-pdf.sh chapters out.pdf   # directory
bash generate-guide-pdf.sh some-file.md     out.pdf   # single file
```

---

## Files

All styling lives in `.claude/skills/guide-pdf/references/`:

| File | Purpose |
|---|---|
| `cover.typ` | Standalone front-cover Typst doc, A5 + 3mm bleed (154×216 mm), no margins. Manual `#place` positioning for typographic precision. |
| `back-cover.typ` | Standalone back-cover Typst doc, same A5 + 3mm bleed spec. Terminal prompt, hook/body text, instructor bios, QR code, unvibe.org CTA. |
| `bettervibe-qr.png` | QR code image used by `back-cover.typ`. |
| `design.typ` | Body styling — page setup, headings, code, lists. Prepended to Pandoc's Typst output before compilation. |

### Cover spec

- Page: 154 × 216 mm (A5 + 3mm bleed on all sides). Trim is 148 × 210 mm.
- Background: `rgb("#0D0F11")` full bleed
- Font: JetBrains Mono (system), all weights
- Layout: terminal prompt at top, three-line title (`vibe` / `coder's` / `guide.`) with amber period, subtitle, authors row, footer with `unvibe.org` (amber dot) and version

To change the authors, version, or workshop date: edit `cover.typ` directly. The values are hard-coded near the bottom of the file.

### Body spec (existing)

- Page: A5 with 14/16/14/14 mm margins, full-page dark fill
- H1: guide title with amber dot
- H2: amber `// PRINCIPLE` callouts in uppercase, page-break before
- H3: amber-bordered, tinted-bg "watch for" callouts
- Blockquote: teal-bordered, tinted-bg "tip" admonition (bold first line renders as teal label)
- Inline code: green on faint white wash
- Footer: `unvibe.` amber, right-aligned on every page

To update brand tokens, edit `references/design.typ` only.

---

## Updating the Guide

**Content (chapters):**
1. Edit (or add/remove) chapter files in `chapters/` — order is controlled by the `NN-` numeric prefix
2. Re-run the script

**Cover (rare):**
1. Edit `references/cover.typ` — version string, author list, or workshop date
2. Re-run the script

**Visual design (body):**
1. Edit `references/design.typ`
2. Re-run the script — no other changes needed

---

## Print specification (wir-machen-druck.de)

The cover is built with 3 mm bleed (`MediaBox` = 154 × 216 mm, trim = 148 × 210 mm). When ordering, select the option for "Datei mit Beschnitt" (file includes bleed) so the cutter knows to trim 3 mm from each edge.

The body currently does **not** include bleed. If chapter pages have content extending to the edge (full-bleed dark backgrounds qualify), update `design.typ` to use 154×216 mm with bleed and shift the margins by 3 mm. This is a known follow-up.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `typst: command not found` | `brew install typst` |
| `pandoc: command not found` | `brew install pandoc` |
| `qpdf: command not found` | `brew install qpdf` |
| Font missing warning | Install JetBrains Mono from jetbrains.com/lp/mono |
| White border on cover | Cover uses `margin: 0mm` and `fill: rgb("#0D0F11")` — verify both are set in `cover.typ` |
| `~` rendered as space in cover prompt | Typst treats `~` as non-breaking space; must be escaped as `\~` |
| Title lines crash into each other | Each title line is `#place`-d at explicit `dy:` rather than relying on `par(leading)` — see `cover.typ` |

---

## Markdown Conventions

### Tip admonition

Use a blockquote with a bold `💡 Tip` label as the first line:

```markdown
> **💡 Tip**
>
> Your tip body here. The entire blockquote renders as a contained teal box,
> so text before and after is clearly outside the tip.
```

### Watch For callout

Use H3 for warnings or things to avoid:

```markdown
### Watch For: name of the issue
```
