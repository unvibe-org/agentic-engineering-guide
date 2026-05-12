# The Vibe Coder's Guide to Agentic Engineering

The Vibe Coder's Guide to Agentic Engineering is a practical handbook on how to
build software with AI agents in the loop. It is written by the instructors of
the bettervibe Agentic Engineering Workshop and is handed out to every
participant in print.

The source of truth lives in `chapters/`. The build pipeline produces a
print-ready A5 PDF with 3 mm bleed, CMYK colors, and an embedded ISOcoated v2
ICC profile so it can be sent straight to a print shop.

## Build the PDF

```bash
./generate-guide-pdf.sh
```

Output: `vibe-coders-guide.pdf` at the repo root.

Requirements: `pandoc`, `typst`, `qpdf`, `ghostscript`, `python3`. On macOS:

```bash
brew install pandoc typst qpdf ghostscript
```

All styling assets (Typst templates, ICC profile, instructor photos, fonts
references) live in `.claude/skills/guide-pdf/references/`. To change brand
tokens, edit `references/design.typ`. To change the cover, edit
`references/cover.typ`.

## Repo layout

```
chapters/                  Numbered markdown chapters (build input)
assets/                    Instructor photos used inside chapters
adam/, dominik/, traun/    Personalized variants of the guide
future-versions/           Drafts and chapters not yet shipped
generate-guide-pdf.sh      Build pipeline
.claude/skills/guide-pdf/  Typst templates, ICC profile, helper scripts
```

## Style rules

- **American English** throughout (`organize`, `optimize`, `toward`, `color`).
- **Vibe Coding Hangover** is a defined concept: always Title Case, no italics,
  both singular and plural. Same rule for **Vibe Coding** and
  **Agentic Engineering** when used as named concepts.

## About bettervibe

This guide accompanies the bettervibe Agentic Engineering Workshop. More at
[bettervibe.org](https://bettervibe.org).
