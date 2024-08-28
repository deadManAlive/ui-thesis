#import "../config.typ":cfg

#let intro = [
  #show par: set block(spacing: 1.5em)
  #set par(justify: true)

  = Kata Pengantar

  #include "../intro.typ"

  #[
    #set align(right)
    #grid(
      columns: 1,
      align: center,
      [#cfg.location, #cfg.time],
      [#v(2.5em) Penulis],
    )
  ]
]