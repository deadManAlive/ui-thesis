#import "../config.typ": cfg

#let cover = [
    #set align(center)
    #set text(
      size: 14pt
    )
    #set page(
      footer: []
    )

    #image(
      "assets/makara_color.png",
      width: 2.5cm,
    )

    *UNIVERSITAS INDONESIA*

    #v(2em)

    *#upper(cfg.title)*

    #v(6em)

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