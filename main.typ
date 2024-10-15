#import "primer/primer.typ": main, primer
#import "primer/pre.typ": pre

#show: doc => primer(doc)

#pre

#main()[
  #include "chapters/ch1.typ"
  #pagebreak(weak: true)

  #include "chapters/ch2.typ"
  #pagebreak(weak: true)

  #[
    #set par(leading: 1em)
    #set block(spacing: 1em)
    #bibliography("sources.bib", style: "ieee", title: [Daftar Pustaka])
  ]
]