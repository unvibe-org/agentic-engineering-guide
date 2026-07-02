// unvibe — The Vibe Coder's Guide to Agentic Engineering · Typst template
// Requires JetBrains Mono (system font)

// ─── Page ────────────────────────────────────────────────────
#set page(
  paper: "a5",
  fill: rgb("#0D0F11"),
  margin: (top: 14mm, bottom: 14mm, left: 14mm, right: 16mm),
  footer: context [
    #set align(right)
    #set text(
      font: "JetBrains Mono",
      fill: rgb("#DA7756"),
      size: 7pt,
      tracking: 0.5pt,
      weight: 400
    )
    unvibe.
  ]
)

// ─── Base text ───────────────────────────────────────────────
#set text(
  font: "JetBrains Mono",
  fill: rgb("#C8C4BF"),
  size: 9.5pt,
  weight: 300
)

#set par(leading: 0.75em, spacing: 0.75em)

// ─── Horizontal rule (emitted by Pandoc for --- in markdown) ─
#let horizontalrule = {
  v(0.2em)
  line(length: 100%, stroke: 0.5pt + rgb("#ffffff14"))
  v(0.2em)
}

// ─── H1 (document title) ─────────────────────────────────────
#show heading.where(level: 1): it => block(below: 0.3em)[
  #text(
    font: "JetBrains Mono",
    fill: rgb("#E8E4DF"),
    size: 19pt,
    weight: 700,
    tracking: -0.5pt
  )[#it.body#text(fill: rgb("#DA7756"))[.]]
]

// ─── H2 (principles) — amber, // prefix, uppercase ───────────
#show heading.where(level: 2): it => block(above: 1.6em, below: 0.4em)[
  #text(
    font: "JetBrains Mono",
    fill: rgb("#DA7756"),
    size: 8.5pt,
    weight: 600,
    tracking: 1.5pt
  )[#text(
    fill: rgb("#C4623E").transparentize(60%),
    weight: 300
  )[// ]#upper(it.body)]
]

// ─── H3 (Watch For callout) ──────────────────────────────────
#show heading.where(level: 3): it => block(above: 1.4em, below: 0.4em, width: 100%)[
  #block(
    fill: rgb("#DA7756").transparentize(87%),
    width: 100%,
    inset: (x: 8pt, y: 5pt),
    stroke: (left: 2pt + rgb("#DA7756"))
  )[
    #text(
      font: "JetBrains Mono",
      fill: rgb("#E8E4DF"),
      size: 8.5pt,
      weight: 600,
      tracking: 1.5pt
    )[#upper(it.body)]
  ]
]

// ─── Inline code ─────────────────────────────────────────────
#show raw.where(block: false): it => box(
  fill: rgb("#ffffff0f"),
  inset: (x: 4pt, y: 1pt),
  radius: 3pt,
  baseline: 1pt
)[#text(fill: rgb("#7EC699"), size: 8pt)[#it]]

// ─── Lists ───────────────────────────────────────────────────
#set list(
  marker: text(fill: rgb("#DA7756"))[▸],
  indent: 0pt,
  body-indent: 10pt
)

// ─── Strong ──────────────────────────────────────────────────
#show strong: it => text(fill: rgb("#E8E4DF"), weight: 600)[#it.body]

// ─── Emph (subtitle / secondary text) ────────────────────────
#show emph: it => text(
  fill: rgb("#9B9690"),
  style: "normal",
  size: 8pt,
  tracking: 0.5pt
)[#it.body]

// ─── Body ────────────────────────────────────────────────────
$body$
