// unvibe — The Vibe Coder's Guide to Agentic Engineering · back cover
// A5 + 3mm bleed → 154 × 216 mm, no margins (positioning manual via #place).
//
// Lives at .claude/skills/guide-pdf/references/back-cover.typ
// Compiled standalone, then merged after the body PDF (see generate-guide-pdf.sh).

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
  #text(fill: dim)[\~/unvibe ]#text(fill: amber)[\$]#text(fill: text-c)[ cat about.md]
]

// divider under prompt
#place(top + left, dx: safe, dy: safe + 9mm)[
  #line(length: 154mm - 2 * safe, stroke: 0.4pt + hairline)
]

// ─── hook ────────────────────────────────────────────────────────────────────
#place(top + left, dx: safe, dy: safe + 18mm)[
  #block(width: 154mm - 2 * safe)[
    #set text(font: "JetBrains Mono", weight: 400, size: 14pt, fill: text-c)
    #set par(leading: 0.55em)
    AI can get you to a demo fast.
    Engineering judgment is what keeps it
    running in production. unvibe
    teaches the craft in between.
  ]
]

// ─── body ────────────────────────────────────────────────────────────────────
#place(top + left, dx: safe, dy: safe + 56mm)[
  #block(width: 154mm - 2 * safe)[
    #set text(font: "JetBrains Mono", weight: 300, size: 10.5pt, fill: muted)
    #set par(leading: 0.7em)
    A recurring hands-on workshop in Munich
    for developers who already ship with AI.
    Bring your laptop and a real project. We
    work it together: planning, agent
    orchestration, review loops, and the
    engineering judgment AI still requires.
    You leave with code in your repo and a
    methodology you can use the next morning.
  ]
]

// ─── instructors section ─────────────────────────────────────────────────────
// section header — matches the body H2 style (amber, // prefix, uppercase)
#place(top + left, dx: safe, dy: safe + 100mm)[
  #set text(font: "JetBrains Mono", fill: amber, size: 8.5pt, weight: 600, tracking: 1.5pt)
  #text(fill: rgb("#C4623E66"), weight: 300)[\/\/ ]#upper[Instructors]
]

#let avatar-size = 11mm
#let instructor(photo, name, body) = block(width: 154mm - 2 * safe, below: 0.7em)[
  #grid(
    columns: (avatar-size, 1fr),
    column-gutter: 3mm,
    align: (horizon, horizon),
    box(
      clip: true,
      radius: 50%,
      width: avatar-size,
      height: avatar-size,
      image(photo, width: avatar-size, height: avatar-size, fit: "cover"),
    ),
    [
      #set par(leading: 0.6em)
      #text(font: "JetBrains Mono", size: 9.5pt, weight: 600, fill: text-c)[#name]
      #text(font: "JetBrains Mono", size: 9.5pt, weight: 300, fill: muted)[ — #body]
    ],
  )
]

#place(top + left, dx: safe, dy: safe + 109mm)[
  #instructor(
    "adam-photo.cmyk.jpg",
    "Adam Charnock",
    [Founder, Lithus. Eighteen years of production infrastructure (Twitter, Blocknative).]
  )
  #instructor(
    "dominik-photo.cmyk.jpg",
    "Dominik Grusemann",
    [Cofounder, Marbles AI. Former CTO of Chatchamp (acquired 2023). Previously led BMW's autonomous driving department toward agile.]
  )
  #instructor(
    "traun-photo.cmyk.jpg",
    "Traun Leyden",
    [Cofounder, Fluensy.app - Speak As Brilliantly As You Think. Twenty years shipping backend systems (Databricks, Couchbase).]
  )
]

// ─── CTA + QR ────────────────────────────────────────────────────────────────
// divider above CTA
#place(bottom + left, dx: safe, dy: -(safe + 44mm))[
  #line(length: 154mm - 2 * safe, stroke: 0.4pt + hairline)
]

// CTA copy on the left
#place(bottom + left, dx: safe, dy: -(safe + 22mm))[
  #set text(font: "JetBrains Mono", size: 9pt, fill: muted, weight: 300)
  Next dates and registration:
]
#place(bottom + left, dx: safe, dy: -(safe + 17mm))[
  #set text(font: "JetBrains Mono", size: 14pt, weight: 600)
  #text(fill: text-c)[unvibe]#text(fill: amber)[.]#text(fill: text-c)[org]
]

// QR card on the right — warm-white background for maximum scanner reliability
#let qr-size = 24mm
#place(bottom + right, dx: -safe, dy: -(safe + 12mm))[
  #box(
    fill: rgb("#E8E4DF"),
    inset: 2mm,
    radius: 1mm,
    image("unvibe-qr.png", width: qr-size, height: qr-size)
  )
]

// ─── footer — same layout as body pages ──────────────────────────────────────
#let page-num = sys.inputs.at("page", default: "")
#place(bottom + left, dx: safe, dy: -(safe - 1mm))[
  #block(width: 154mm - 2 * safe)[
    #grid(
      columns: (1fr, 1fr),
      [
        #text(font: "JetBrains Mono", size: 9pt, weight: 500)[
          #text(fill: text-c)[unvibe]#text(fill: amber)[.]#text(fill: text-c)[org]
        ]
      ],
      align(right)[
        #text(font: "JetBrains Mono", size: 9pt, weight: 400, fill: dim)[#page-num]
      ]
    )
  ]
]
