#let cover(
  title: "Judul",
  name: "Name",
  npm: "NPM",
  faculty: "Fakultas",
  program: "Program",
  location: "Tempat",
  time: "Agustus 2024") = {
  [
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

    *#upper(title)*

    #v(6em)

    *SKRIPSI*

    #v(8em)

    *#upper(name)*

    *#npm*

    #v(8em)

    *#upper(faculty)*

    *#upper(program)*

    *#upper(location)*

    *#upper(time)*
  ]
}