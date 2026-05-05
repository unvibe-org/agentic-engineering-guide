// Blank page inserted before back cover to keep even page count.
// Matches the body page layout: same background, margins, and footer.

#let page-num = sys.inputs.at("page", default: "")

#set page(
  width: 154mm,
  height: 216mm,
  fill: cmyk(60%, 50%, 50%, 100%),
  margin: (top: 17mm, bottom: 17mm, left: 17mm, right: 19mm),
  footer: [
    #grid(
      columns: (1fr, 1fr),
      [
        #text(font: "JetBrains Mono", size: 9pt, weight: 500)[
          #text(fill: rgb("#E8E4DF"))[bettervibe]#text(fill: rgb("#DA7756"))[.]#text(fill: rgb("#E8E4DF"))[org]
        ]
      ],
      align(right)[
        #text(font: "JetBrains Mono", size: 9pt, weight: 400, fill: rgb("#6B6660"))[#page-num]
      ]
    )
  ]
)
