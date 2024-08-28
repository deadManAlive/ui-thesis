#import "../config.typ": cfg

#let publ = [
  = Halaman Pernyataan Persetujuan Publikasi Tugas Akhir Untuk Kepentingan Akademis

  Sebagai sivitas akademika Universitas Indonesia, saya yang bertanda tangan di bawah ini:

  #table(
    columns: 3,
    stroke: none,
    [Nama], [:], [#cfg.name],
    [NPM], [:], [#cfg.npm],
    [Program Studi], [:], [#cfg.program],
    [Fakultas],[:],[#cfg.faculty],
    [Jenis Karya], [:], [Skripsi],
  )

  demi mengembangkan ilmu pengetahuan, menyetujui untuk memberikan kepada Universitas Indonesia *Hak Bebas Royalti Noneksklusif (_Non-Exclusive Royalty-Free Right_)* atas karya ilmiah saya yang berjudul:

  #v(1em)

  #[
    #set align(center)
    #strong(cfg.title)
  ]

  #v(1em)

  beserta perangkat yang ada (jika diperlukan). Dengan Hak Bebas Royalti Noneksklusif ini, Universitas Indonesia berhak menyimpan, mengalihmedia/format-kan, mengelola dalam bentuk pangkalan data (_database_), merawat, dan memublikasikan tugas akhir saya selama tetap mencatumkan nama saya sebagai penulis/pencipta dan sebagai pemilik Hak Cipta.

  Demikian pernyataan ini saya buat dengan sebenarnya.

  #[
    #set align(center)
    #table(
      columns: 3,
      stroke: none,
      align: left,
      [Dibuat di], [:], [#cfg.location],
      [Pada tanggal], [:], [#cfg.time],
    )
    Yang menyatakan,
    #v(3em)
    (#cfg.name)
  ]
]