// bettervibe — The Vibe Coder's Guide to Agentic Engineering · design template
// This file is prepended to the Pandoc-generated body before Typst compilation.
//
// Page geometry: 154 × 216 mm = A5 (148×210) + 3mm bleed on all sides.
// Content margins are shifted +3mm so the readable area stays at the same
// distance from the trim line as before. Post-trim, the visual layout is
// identical to the previous A5-no-bleed version.

// ─── Page ────────────────────────────────────────────────────
// fill colors the ENTIRE page including margins — no white border possible
#set page(
  width: 154mm,
  height: 216mm,
  fill: rgb("#0D0F11"),
  margin: (top: 17mm, bottom: 17mm, left: 17mm, right: 19mm),
  footer: context [
    #grid(
      columns: (1fr, 1fr),
      [
        #text(font: "JetBrains Mono", size: 9pt, weight: 500)[
          #text(fill: rgb("#E8E4DF"))[bettervibe]#text(fill: rgb("#DA7756"))[.]#text(fill: rgb("#E8E4DF"))[org]
        ]
      ],
      align(right)[
        #text(font: "JetBrains Mono", size: 9pt, weight: 400, fill: rgb("#6B6660"))[
          #counter(page).display("1")
        ]
      ]
    )
  ]
)

// ─── Base text ───────────────────────────────────────────────
#set text(font: "JetBrains Mono", fill: rgb("#C8C4BF"), size: 9.5pt, weight: 300)
#set par(leading: 0.95em, spacing: 1.6em, justify: false)

// ─── Horizontal rule (Pandoc outputs #horizontalrule for ---) ─
#let horizontalrule = {
  v(0.15em)
  line(length: 100%, stroke: 0.5pt + rgb("#ffffff14"))
  v(0.15em)
}

// ─── H1 — Part dividers: outline-only, decorative content rendered separately ─
// Part dividers carry a hidden level-1 heading so the TOC can list them.
// Their visible "Part I — Plan." page is hand-laid in the chapter file itself.
#show heading.where(level: 1): none

// ─── H2 — principles: amber, // prefix, uppercase ────────────
// \/\/ renders as // in Typst markup mode (avoids code-mode comment parsing)
#let slashprefix = text(fill: rgb("#C4623E66"), weight: 300)[\/\/ ]

#show heading.where(level: 2): it => {
  pagebreak(weak: true)
  block(above: 0em, below: 1em)[
    #text(font: "JetBrains Mono", fill: rgb("#DA7756"), size: 8.5pt, weight: 600, tracking: 1.5pt)[
      #slashprefix#upper(it.body)
    ]
  ]
}

// ─── H3 — Watch For callout: amber sidebar, tinted bg ────────
#show heading.where(level: 3): it => block(above: 2em, below: 0.9em, width: 100%)[
  #block(
    fill: rgb("#DA775619"),
    width: 100%,
    inset: (x: 8pt, y: 5pt),
    stroke: (left: 2pt + rgb("#DA7756"))
  )[
    #text(font: "JetBrains Mono", fill: rgb("#E8E4DF"), size: 8.5pt, weight: 600, tracking: 1.5pt)[
      #upper(it.body)
    ]
  ]
]

// ─── H4 — subsection within a chapter ───────────────────────
#show heading.where(level: 4): it => block(above: 1.4em, below: 0.4em)[
  #text(font: "JetBrains Mono", fill: rgb("#E8E4DF"), size: 9.5pt, weight: 600)[#it.body]
]

// ─── Blockquote — Tip admonition: teal box, label in teal ───
#show quote.where(block: true): it => block(above: 2em, below: 2em, width: 100%)[
  #block(
    fill: rgb("#4A9EB519"),
    width: 100%,
    inset: (x: 12pt, y: 10pt),
    stroke: (left: 2pt + rgb("#4A9EB5"))
  )[
    #show strong: it => text(fill: rgb("#4A9EB5"), size: 8.5pt, weight: 600, tracking: 1.5pt)[#upper(it.body)]
    #it.body
  ]
]

// ─── Inline code ─────────────────────────────────────────────
#show raw.where(block: false): it => box(
  fill: rgb("#ffffff0f"),
  inset: (x: 4pt, y: 1.5pt),
  radius: 3pt,
  baseline: 1pt
)[#text(fill: rgb("#7EC699"), size: 8pt)[#it]]

// ─── Lists ───────────────────────────────────────────────────
#set list(marker: text(fill: rgb("#DA7756"))[▸], indent: 0pt, body-indent: 10pt, spacing: 1.1em)

// ─── Strong ──────────────────────────────────────────────────
#show strong: it => text(fill: rgb("#E8E4DF"), weight: 600)[#it.body]

// ─── Emph — subtitle and secondary text ──────────────────────
#show emph: it => text(fill: rgb("#9B9690"), style: "normal", size: 8pt, tracking: 0.5pt)[#it.body]
