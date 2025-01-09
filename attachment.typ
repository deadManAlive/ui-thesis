#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#codly(languages: codly-languages)

#set raw(block: true)
#show raw: set text(size: 8pt)
#show heading.where(level: 2): set heading(outlined: false)

#let files = (
  "src/compute/rs",
  "src/fps.rs",
  "src/fresnel.rs",
  "src/icon.rs",
  "src/interaction.rs",
  "src/main.rs",
  "src/objects.rs",
  "src/plot.rs",
  "src/receiver.rs",
  "src/reception_sphere.rs",
  "src/sbr.rs",
  "src/walls_reader.rs",
)

= Lampiran

== `Cargo.toml`

#raw(read("fray/Cargo.toml"), lang: "toml")

#for file in files [
  #no-codly[
    == #raw(file)
  ]
  #let f = "fray/" + str(file)
  #raw(read(f), lang: "rs")
]
