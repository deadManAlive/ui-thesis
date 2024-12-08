#import "../config.typ": cfg
#import "../abstract.typ": abstract_id, abstract_en

#let abs_id = [
  = Abstrak

    #table(
    columns: 3,
    stroke: none,
    [Nama], [:], [#cfg.name],
    [Program Studi], [:], [#cfg.program],
    [Judul],[:],[#cfg.title],
    [Pembimbing], [:], [
      #for adv in cfg.advisors [
        #adv \
      ]
    ],
  )

  #abstract_id.abstract

  \

  Kata kunci:

  #abstract_id.keywords.sorted(key: s => {
    lower(s.match(regex("[A-Za-z0-9].*")).text)
  }).enumerate().map(k => {
    let (i, kk) = k
    if i == 0 {
      "[" + kk.replace(regex("[A-Za-z]"), upper(kk.match(regex("[A-Za-z0-9].*")).text.first()), count: 1) + "]"
    } else {
      "[" +kk + "]"
    }
  }).map(it => eval(it)).join(", ")\.
]

#let abs_en = [
  #heading(outlined: false)[Abstract]

  #table(
    columns: 3,
    stroke: none,
    [Name], [:], [#cfg.name],
    [Department], [:], [#cfg.program],
    [Title],[:],[#cfg.title_en],
    [Advisor], [:], [
      #for adv in cfg.advisors [
        #adv \
      ]
    ],
  )

  #abstract_en.abstract

  \

  Keywords:

  #abstract_en.keywords.sorted(key: s => {
    lower(s.match(regex("[A-Za-z0-9].*")).text)
  }).enumerate().map(k => {
    let (i, kk) = k
    if i == 0 {
      "[" + kk.replace(regex("[A-Za-z]"), upper(kk.match(regex("[A-Za-z0-9].*")).text.first()), count: 1) + "]"
    } else {
      "[" +kk + "]"
    }
  }).map(it => eval(it)).join(", ")\.
]