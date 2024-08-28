#import "../config.typ": cfg

#let valid = [
  #set align(left)
  
  = Halaman Pengesahan

  #table(
    columns: 3,
    stroke: none,
    [Skripsi ini diajukan oleh], [:], [],
    [Nama], [:], [#cfg.name],
    [NPM], [:], [#cfg.npm],
    [Program Studi], [:], [#cfg.program],
    [Judul Skripsi], [:], [#cfg.title],
  )

  #v(4em)

  #[
    #set text(weight: "bold")

    Telah berhasil dipertahankan di hadapan Dewan Penguji dan diterima sebagai bagian persyaratan yang diperlukan untuk memperoleh gelar #cfg.degree pada Program Studi #cfg.program #cfg.faculty, Universitas Indonesia.
  ]

  #v(4em)

  #[
    #set align(center)
    #strong([DEWAN PENGUJI])
  ]

  #[
    #let dpad = 15pt
    #table(
      columns: 4,
      stroke: none,
      inset: (dpad, dpad, dpad, (x: 25pt, y: dpad)),
      ..for a in cfg.advisors {
        ([Pembimbing], [:], a, [(......tanda tangan......)])
      },
      ..for a in cfg.examiners {
        ([Penguji], [:], a, [(......tanda tangan......)])
      }
    )
  ]

  #v(4em)

  #table(
    columns: 2,
    stroke: none,
    [Ditetapkan di], [: #cfg.location],
    [Tanggal], [: #cfg.time]
  )
]