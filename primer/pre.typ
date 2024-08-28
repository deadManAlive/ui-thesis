#import "cover.typ": cover
#import "title.typ": title
#import "auth.typ": auth
#import "valid.typ": valid
#import "intro.typ": intro
#let pre = [
  #set par(leading: 1em)
  #set page(numbering: "i")
  #set outline(title: none, depth: 3, indent: auto)
  #show heading.where(level: 1): head => context [
    #set align(center)
    #upper(head.body)
    #v(1.5em)
  ]

  #set page(footer: [])

  #cover
  
  #pagebreak(weak: true)
  #counter(page).update(1)

  #title

  #pagebreak(weak: true)

  // roman numbering start after title page
  #set page(
    footer: context [
      #set align(center)
      #counter(page).display("i")
    ]
  )

  #auth

  #pagebreak(weak: true)

  #valid

  #pagebreak(weak: true)

  #intro

  #pagebreak(weak: true)

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
