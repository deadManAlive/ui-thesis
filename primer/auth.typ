#import "../config.typ": cfg

#let auth = [
  #set align(center)

  = Halaman Pernyataan Orisinalitas

  #v(6em)

  *Skripsi ini adalah hasil karya saya sendiri, \ dan semua sumber baik yang dikutip maupun dirujuk \ telah saya nyatakan dengan benar.*

  #v(6em)

  #table(
    columns: 3,
    align: (left, left + horizon, left + horizon),
    stroke: none,
    [Nama], [:], [#cfg.name],
    [NPM], [:], [#cfg.npm],
    [
      #v(1em)
      Tanda Tangan
      #v(1em)
    ], [:], [......],
    [Tanggal], [:], [#cfg.time]
  )
]