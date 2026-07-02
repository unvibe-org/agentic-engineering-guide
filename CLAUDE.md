# A Vibe Coder's Guide to Agentic Engineering

Source for *The Vibe Coder's Guide to Agentic Engineering* — a printed handbook
for the unvibe Agentic Engineering Workshop. The repo is content-first
(markdown in `chapters/`) plus a small build pipeline that turns that content
into a print-ready A5 PDF (3 mm bleed, CMYK, embedded ISOcoated v2 ICC).

There is no application code, no test suite, no lint — the only "build" is the
PDF generation.

## Build

```bash
./generate-guide-pdf.sh                            # chapters/ → agentic-engineering-guide.pdf
./generate-guide-pdf.sh chapters/03-foo.md         # single chapter → 03-foo.pdf
./generate-guide-pdf.sh chapters/ out.pdf          # explicit output path
```
