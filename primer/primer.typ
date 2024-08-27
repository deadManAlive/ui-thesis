#let primer(doc) = {
  set text(
    font: "Times New Roman",
    size: 12pt,
  )
  set page(
    paper: "a4",
    margin: (x: 3cm, y: 3cm),
  )
  set block(spacing: 1em)

  doc
}

#let main(body) = {
  set page(
    header: context {
      let intro = query(<intro>).first()
      if intro.location().page() == here().page() {
        counter(page).update(1)
      }

      let matches = query(heading.where(level: 1))
      let h = here().page()
      let m = matches.map(val => val.location().page())
      let has-h1 = m.any(val => val == h)

      if not has-h1 {
        [
          #set align(right)
          #locate(loc => counter(page).at(loc).first())
        ]
      }
    },
    header-ascent: 1.5cm,
    footer: context {
      let matches = query(heading.where(level: 1))
      let h = here().page()
      let m = matches.map(val => val.location().page())
      let has-h1 = m.any(val => val == h)
      set align(center)
      if has-h1 {
        counter(page).display()
      }
      // [ \ ]
      set align(right)
      text("Universitas Indonesia", font: "Arial", size: 10pt, weight: "bold")
    }
  )
  

  show heading.where(level: 1): head => context [
    #set align(center)
    #set par(leading: 0.75em)
    #upper([#counter(heading).display()])
    \
    #upper([#head.body])
    #v(1.5em)
  ]

  show heading.where(level: 1): set heading(
  numbering: (..nums) => "Bab " + nums
    .pos()
    .map(str)
    .join(".")
  )
  
  set par(justify: true, first-line-indent: 2em, leading: 1.5em)
  set block(spacing: 1.5em)
  set heading(numbering: "1.1.1.")
  set text(lang: "id")
  show heading: set block(spacing: 1.5em)

  body
}