#import "cover.typ": cover
#import "title.typ": title

#let pre = [
  #set par(leading: 1em)
  #set page(numbering: "i")
  #set outline(title: none, depth: 3, indent: auto)
  #show heading.where(level: 1): head => context [
    #set align(center)
    #head.body
    #v(1.5em)
  ]

  #set page(footer: [])

  #cover

  #title
  
  #counter(page).update(1)

  // with Footer (from abstract)
  #set page(
    footer: context [
      #set align(center)
      #counter(page).display("i") \
      #set align(right)
      #text("Universitas Indonesia", font: "Arial", size: 10pt, weight: "bold")
    ]
  )

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

]
