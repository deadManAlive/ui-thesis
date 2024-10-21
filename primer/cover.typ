#import "../config.typ": cfg

#let cover = [
  #set align(center)
  #set par(justify: false)
  #set text(
    size: 14pt
  )

  #image(
    "assets/makara_color.png",
    width: 2.5cm,
  )

  *UNIVERSITAS INDONESIA*

  #v(2em)
  
  *#upper(cfg.title)*

  #v(4em)

  *SKRIPSI*

  #v(6em)

  *#upper(cfg.name)*

  *#cfg.npm*

  #v(6em)

  *#upper(cfg.faculty)*

  *#upper(cfg.program)*

  #v(2em)

  *#upper(cfg.location)*

  *#upper(cfg.time)*
]