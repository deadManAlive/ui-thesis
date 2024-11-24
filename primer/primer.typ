#let primer(doc) = {
  set text(
    font: "Times New Roman",
    size: 12pt,
    lang: "id"
  )
  set page(
    paper: "a4",
    margin: (x: 3cm, y: 3cm),
  )
  set block(spacing: 1em)
  show heading: set text(size: 12pt)
  set par(justify: true)

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
          #context counter(page).at(here()).first()
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

  set figure(
    numbering: (..nums) => {
      let ch = str(counter(heading).get().first())
      let fc = nums.pos().map(str).join(".")

      ch + "." + fc
    }
  )

  show figure.caption: it => [
    #set text(size: 10pt)
    #it.supplement
    #context it.counter.display(it.numbering):
    #it.body\.
  ]

  show figure.where(
    kind: image
  ): set figure(
    supplement: [Gambar],
    placement: auto
  )

  show figure.where(
    kind: table
  ): set figure(
    supplement: [Tabel],
  )

  show figure.where(
    kind: table
  ): set figure.caption(position: top)

  set math.equation(
    numbering: (..nums) => {
      let ch = str(counter(heading).get().first())
      let fc = nums.pos().map(str).join(".")

      "(" + ch + "." + fc + ")"
    },
    supplement: []
  )

  show heading.where(level: 1): head => context [
    #counter(figure.where(kind: image)).update(0)
    #counter(figure.where(kind: table)).update(0)
    #counter(math.equation).update(0)

    #set align(center)
    #set par(leading: 0.75em)
    #upper([#counter(heading).display()])
    \
    #upper([#head.body])
    #v(1.5em)
  ]

  show heading.where(level: 1): set heading(
    numbering: (..nums) => "Bab " + str(nums.pos().first())
  )
  
  set par(justify: true, first-line-indent: 2em, leading: 1.5em)
  set block(spacing: 1.5em)
  set heading(numbering: "1.1.1.")
  set text(lang: "id")
  show heading: set block(spacing: 1.5em)

  body
}