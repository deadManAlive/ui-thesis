#let post(attach: bool) = [
  #[
    #show heading.where(level: 1): set heading(
      numbering: none
    )

    #show heading.where(level: 1): head => context [
      #set align(center)
      #set par(leading: 0.75em)
      #upper([#head.body])
      #v(1.5em)
    ]

    #[
      #set par(leading: 1em)
      #set block(spacing: 1em)
      #bibliography("../sources.bib", style: "ieee", title: [Daftar Pustaka])
      #pagebreak(weak: true)
    ]

    #if attach [
      #include "../attachment.typ"
    ]
  ]
]