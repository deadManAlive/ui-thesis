#import "../config.typ": cfg

#let title = [
  #set align(center)
  #set text(
    size: 14pt
  )

  #image(
      "assets/makara_black.png",
      width: 2.5cm,
    )

  *UNIVERSITAS INDONESIA*

  #v(2em)

  *#upper(cfg.title)*

  #v(6em)

  *SKRIPSI*

  #v(1em)

  *Diajukan sebagai salah satu syarat memperoleh gelar #cfg.degree*

  #v(4em)

  *#upper(cfg.name)*

  *#cfg.npm*

  #v(6em)

  *#upper(cfg.faculty)*

  *#upper(cfg.program)*

  #v(2em)

  *#upper(cfg.location)*

  *#upper(cfg.time)*
]