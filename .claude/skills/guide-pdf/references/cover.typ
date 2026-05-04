// bettervibe — The Vibe Coder's Guide to Agentic Engineering · front cover
// A5 + 3mm bleed → 154 × 216 mm, no margins (positioning manual via #place).
//
// Lives at .claude/skills/guide-pdf/references/cover.typ
// Compiled standalone, then merged with the body PDF (see generate-guide-pdf.sh).

#set page(
  width: 154mm,
  height: 216mm,
  margin: 0mm,
  fill: rgb("#0D0F11"),
)

// ─── tokens ──────────────────────────────────────────────────────────────────
#let text-c   = rgb("#E8E4DF")
#let muted    = rgb("#9B9690")
#let dim      = rgb("#6B6660")
#let amber    = rgb("#DA7756")
#let hairline = rgb("#2A2E33")
#let safe     = 8mm

// ─── prompt ──────────────────────────────────────────────────────────────────
#place(top + left, dx: safe, dy: safe + 4mm)[
  #set text(font: "JetBrains Mono", size: 9pt)
  #text(fill: dim)[\~/bettervibe ]#text(fill: amber)[\$]#text(fill: text-c)[ cat vibe-coders.guide]#h(2pt)#box(fill: amber, width: 5pt, height: 9pt)
]

// divider under prompt
#place(top + left, dx: safe, dy: safe + 9mm)[
  #line(length: 154mm - 2 * safe, stroke: 0.4pt + hairline)
]

// ─── title ───────────────────────────────────────────────────────────────────
#let title-text(word, period: false) = {
  text(font: "JetBrains Mono", weight: 700, size: 54pt, tracking: -1.6pt, fill: text-c)[#word]
  if period {
    text(font: "JetBrains Mono", weight: 700, size: 54pt, fill: amber)[.]
  }
}

// title baselines are spaced 20mm apart — matches the reportlab cover (1.04 × 54pt)
#place(top + left, dx: safe, dy: 32mm)[#title-text("vibe")]
#place(top + left, dx: safe, dy: 52mm)[#title-text("coder's")]
#place(top + left, dx: safe, dy: 72mm)[#title-text("guide", period: true)]

// ─── subtitle ────────────────────────────────────────────────────────────────
#place(top + left, dx: safe, dy: 113mm)[
  #text(font: "JetBrains Mono", weight: 300, size: 12pt, fill: muted)[
    to agentic engineering — with AI agents.
  ]
]

// ─── authors ─────────────────────────────────────────────────────────────────
#place(bottom + left, dx: safe, dy: -(safe + 14mm))[
  #text(font: "JetBrains Mono", size: 9pt, fill: muted)[
    Adam Charnock  ·  Dominik Grusemann  ·  Traun Leyden
  ]
]

// divider above footer
#place(bottom + left, dx: safe, dy: -(safe + 10mm))[
  #line(length: 154mm - 2 * safe, stroke: 0.4pt + hairline)
]

// ─── footer ──────────────────────────────────────────────────────────────────
// bettervibe.org — bottom left
#place(bottom + left, dx: safe, dy: -(safe))[
  #text(font: "JetBrains Mono", weight: 500, size: 9pt)[
    #text(fill: text-c)[bettervibe]#text(fill: amber)[.]#text(fill: text-c)[org]
  ]
]

// version — bottom right
#place(bottom + right, dx: -safe, dy: -(safe))[
  #text(font: "JetBrains Mono", size: 9pt, fill: dim)[v1.0 · 2026]
]
