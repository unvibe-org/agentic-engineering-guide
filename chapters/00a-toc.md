```{=typst}
#pagebreak()

#v(0.5em)
#text(font: "JetBrains Mono", fill: rgb("#DA7756"), size: 8.5pt, weight: 600, tracking: 1.5pt)[\/\/ CONTENTS]
#v(1.4em)

#show outline.entry: it => {
  if it.element.level == 1 {
    block(above: 2.4em, below: 1.2em)[
      #link(it.element.location())[
        #text(font: "JetBrains Mono", fill: rgb("#DA7756"), size: 8.5pt, weight: 600, tracking: 1.8pt)[
          #upper(it.element.body)
        ]
      ]
    ]
  } else {
    block(above: 1.4em, below: 1.4em)[
      #link(it.element.location())[
        #grid(
          columns: (auto, 1fr, auto),
          align: (left + horizon, center + horizon, right + horizon),
          column-gutter: 0.6em,
          [#text(fill: rgb("#C8C4BF"), size: 9.5pt)[#it.element.body]],
          [#text(fill: rgb("#ffffff22"))[#repeat[.#h(3pt)]]],
          [#text(fill: rgb("#DA7756"), size: 9.5pt, weight: 500)[#counter(page).at(it.element.location()).first()]]
        )
      ]
    ]
  }
}

#outline(title: none, depth: 2, target: heading.where(level: 1).or(heading.where(level: 2)))

#pagebreak()
```
