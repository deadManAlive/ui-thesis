#import "primer/primer.typ": main, primer
#import "primer/pre.typ": pre
#import "primer/post.typ": post

#show: doc => primer(doc)

#pre

#main()[
  #include "chapters/ch1.typ"
  #pagebreak(weak: true)

  #include "chapters/ch2.typ"
  #pagebreak(weak: true)

  #include "chapters/ch3.typ"
  #pagebreak(weak: true)

  #include "chapters/ch4.typ"
  #pagebreak(weak: true)

  #include "chapters/ch5.typ"
  #pagebreak(weak: true)
]

#post(attach: false)
