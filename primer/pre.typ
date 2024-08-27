#import "cover.typ": cover

#set par(leading: 1em)
#set page(numbering: "i")
#set page(
  footer: context [
    #set align(center)
    #counter(page).display("i") \
    #set align(right)
    #text("Universitas Indonesia", font: "Arial", size: 10pt, weight: "bold")
  ]
)
#set outline(title: none, depth: 3, indent: auto)
#show heading.where(level: 1): head => context [
  #set align(center)
  #head.body
  #v(1.5em)
]

#cover()
#pagebreak(weak: true)

#counter(page).update(1)

= Daftar Isi
#[
  #show outline.entry.where(
    level: 1
  ): it => {
    strong(it)
  }
  #outline()
]
#pagebreak(weak: true)

= Daftar Persamaan
#outline(target: figure.where(kind: "Equation"))