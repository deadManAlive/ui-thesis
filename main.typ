#import "primer/primer.typ": main, primer

#show: doc => primer(doc)

#include "primer/pre.typ"

#main()[
  #include "chapters/ch1.typ"
  #pagebreak(weak: true)

  #include "chapters/ch2.typ"
  #pagebreak(weak: true)
]