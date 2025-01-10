#import "@preview/drafting:0.2.1": absolute-place
#import "@preview/lovelace:0.3.0": *
#import "@local/fletcher:0.5.3" as fletcher: diagram, node, edge, shapes


#set page(paper: "presentation-16-9", margin: (x: 3.2cm, y: 3.6cm))
#set text(size: 20pt)
#import "config.typ": cfg
#set page(header: [
    #set align(left)
    #set text(fill: white)
    #move(dx: -5em, dy: 0em,
    rect(fill: blue, width: 150%, [
      #move(dx: 1em,
        [
        #table(
          columns: 2,
          align: (center + horizon, left + horizon),
          stroke: (x, y) => if x == 0 {
            (right: 2pt + yellow)
          },
          inset: (x: 10pt),
          [
            #set text(size: 6pt)
            #set block(spacing: 0.4em)
            #image("primer/assets/makara_color.png", width: 6em)
            Universitas \ Indonesia
          ],
          [
            #set par(leading: 0.22em)
            #text(size: 8pt, tracking: 2pt)[DEPARTEMEN] \
            #text(size: 12pt)[*TEKNIK ELEKTRO*]
          ]
        )
        ]
      )
    ]
    )
    )
    ], footer: move(dx: -5%, dy: 50%, rect(fill: blue, width: 110%, height: 4%))
)

#let bup(v) = [$upright(bold(#v))$]

#show figure.caption: it => [
  #set text(size: 12pt)
  #it.supplement
  #context it.counter.display(it.numbering):
  #it.body\.
]

#show figure.where(
    kind: image
): set figure(
  supplement: [Gambar],
  placement: auto
)

#let pbr = pagebreak(weak: true)

// title slide
#[
  #set page(header: [
    #set align(left)
    #move(dx: -4em, dy: 0em,
      table(
        columns: 2,
        align: (center + horizon, left + horizon),
        stroke: (x, y) => if x == 0 {
          (right: 2pt + blue)
        },
        inset: (x: 10pt),
        [
          #set text(size: 6pt)
          #set block(spacing: 0.4em)
          #image("primer/assets/makara_color.png", width: 6em)
          Universitas \ Indonesia
        ],
        [
          #set par(leading: 0.22em)
          #text(size: 8pt, tracking: 2pt)[DEPARTEMEN] \
          #text(size: 12pt)[*TEKNIK ELEKTRO*]
        ]
      )
    )
    ], footer: move(dx: 0pt, dy: 50%, rect(fill: blue, width: 150%, height: 100%))
  )

  #set align(center + horizon)
  #show heading.where(level: 1): set text(size: 24pt) 
  = #cfg.title

  \

  #cfg.name (#cfg.npm)

  #[
    #show table: set text(size: 16pt)
    #table(
      columns: 2,
      align: left,
      stroke: none,
      inset: (x: 24pt),
      [Pembimbing], [#cfg.advisors.at(0)],
      [Penguji], [#cfg.examiners.at(0)],
      [Penguji], [#cfg.examiners.at(1)],

    )
  ]
]

#pbr

// slide 2
#[
  == Latar Belakang

  + Kebutuhan akan konektivitas internet tetap dan/atau dalam ruang yang semakin meningkat.
  + Tantangan dalam mendesain ruangan yang mengoptimasi penggunaan titik akses dalam menyediakan akses Wi-Fi.
  + Solusi yang ada selain berupa piranti lunak berbayar yang mahal (Altair, Remcom, MATLAB) ataupun membutuhkan keahlian dalam penggunaannya (Meeps, OpenEMS, FEniCS).
]

#pbr

// slide 3
#[
  == Rumusan Masalah

  + Bagaimana _ray-tracing_ memodelkan propagasi gelombang radio?
  + Bagaimana menerapkan _ray-tracing_ ke dalam bentuk algoritma yang dapat melakukan perhitungan daya yang diterima dan rugi jalur dari satu sumber pada ruang 2 dimensi?
  + Bagaimana menyusun antarmuka grafis untuk algoritma program yang telah disusun?
  + Bagaimana pengaruh pemodelan interaksi-interaksi gelombang dengan lingkungan mempengaruhi hasil pemodelan?
]

#pbr

#[
  == Dasar Teori: _Ray Tracing_ Sebagai CEM

  #absolute-place(
    figure(
      image("chapters/assets/compem.png", width: 18em),
      caption: [CEM]
    ),
    dx: 22em,
    dy: 6em
  )

  #absolute-place(
    box([
      - _Ray-tracing_ memanfaatkan sinar/garis untuk menganalisis aliran energi.
      - Berbagai macam bentuk energi teradiasi:
        - akustik
        - seismik
        - pelensaan gravitasional
      - Pada EM, _ray-tracing_ didasarkan kepada GO/UTD.
      - _Ray-tracing_ termasuk ke dalam metode frekuensi tinggi dari CEM.
    ], width: 18em),
    dx: 4.8em,
    dy: 7em

  )
]

#pbr

// slide 4
#[
  == Dasar Teori: Dari Persamaan Maxwell Ke GO/UTD

  #set align(center)
  #set text(size: 12pt)

  #absolute-place(
    diagram(
      node-stroke: black,
      node((-2,0), [
        $
          nabla dot bup(E) &= 0 \
          nabla dot bup(B) &= 0 \
          nabla times bup(E) &= - (partial bup(B))/(partial t) \
          nabla times bup(B) &= mu_0 epsilon_0 (partial bup(E))/(partial t)
        $
      ], shape: rect),
      edge("-|>", [persamaan \ gelombang]),
      node((0,0), [$ partial^2 / (partial t^2) bup(E)  = c^2 nabla^2 bup(E) $]),
      edge("-|>", [$ cal(F) $]),
      node((2,0), [$ (nabla^2 + k^2) hat(bup(E)) = 0 $]),
      edge("-|>", [$ hat(bup(E)) = e^(-j k phi.alt(bup(r)))  sum_n hat(bup(E))_i/(j omega)^n $], label-side: right),
      node((2,2), [$ norm( nabla phi.alt(bup(r))) = n $]),
      edge("-|>", [$ angle.l bup(S) angle.r = 1/(2 mu_0) Re[bup(E) times dash(bup(B))] $], label-side: right),
      node((-1,2), [$ angle.l bup(S) angle.r = 2 c angle.l w_c angle.r nabla phi.alt(bup(r)) $]),
      edge("-|>", [$ integral.cont_(diff Sigma) bup(E) dot d bup(cal(l)) = - upright(d) / (upright(d) t) integral.double_Sigma bup(B) dot d bup(S) $], corner: left),
      node((-2,4), [$ Gamma, T $]),
      node((-1,4), [$ D $], shape: rect),
      edge((-1,2), (-1,4), "-|>", [$bup(E)_"total" = f(bup(E)_i, bup(E)_r, bup(E)_d)$], label-side: left)

    ),
    dx: 12em,
    dy: 11em
  )
]

#pbr

// slide 5
#[
  == Dasar Teori: Metode-Metode _Ray Tracing_

  #absolute-place(
    box([
      - Pemodelan propagasi energi dalam bentuk sinar-sinar jalur.
      - Terdapat dua metode utama: _shooting and bouncing rays_ (SBR) dan _image_.
      - SBR bekerja dengan meluncurkan sinar-sinar homogen dari sumber.
      - Total medan adalah super posisi dari setiap sinar.
    ], width: 16em),
    dx: 4em,
    dy: 7em
  )


  #absolute-place(
    figure(
      image("chapters/assets/image.jpg", width: 40%),
      caption: [SBR]
    ), 
    dx: 24em,
    dy: 6em
  )

  #absolute-place(
    figure(
      image("present/assets/sbr.png", width: 40%),
      caption: [SBR]
    ), 
    dx: 24em,
    dy: 14em
  )

]

#pbr

#[
  == Pengembangan Aplikasi

  #absolute-place(
    box([
      - Terdiri dari dua tahap:
        - Kerangka program dan SBR
        - Dasar pemodelan dan pengukuran
      - Tahap I
        - Dasar teori
        - Dasar dan lingkungan pemrograman
        - SBR dengan refleksi
      - Tahap II
        - Refleksi, transmisi, dan difraksi
        - Kalkulasi 
    ], width: 18em),
    dx: 5em,
    dy: 7em
  )
  
  #absolute-place(
    [
      #set text(size: 12pt)
      #let g = green.lighten(70%)
      #let r = blue.lighten(70%)
      
      #diagram(
        node-stroke: black,
        spacing: (2em, 2em),
        node((0,0), [Mulai], shape: shapes.circle),
        edge("-|>"),
        node((0,1), [Studi \ literatur], fill: g),
        edge("-|>"),
        node((0,2), [Penulisan \ kerangka \ program], shape: rect, fill: g),
        edge("-|>"),
        node((0, 3), [Penulisan \ algoritma \ SBR], shape: rect, fill: g),
        edge((0, 3), "r,u,u,u,r", "-|>"),
        node((2, 0), [Pemodelan \ $Gamma$, $T$, dan $D$], shape: rect, fill: r),
        edge("-|>"),
        node((2, 1), [Penulisan \ algoritma \ perhitungan], fill: r),
        edge("-|>"),
        node((2, 2), [Validasi \ cukup \ baik?], shape: shapes.diamond),
        edge("-|>", [Ya]),
        node((2, 3), [Membandingkan \ dengan hasil \ pengukuran]),
        edge("-|>"),
        node((2, 4), [Selesai], shape: shapes.circle),
        edge((2, 2), "r,u,u,l", "-|>", [Tidak])
      )
    ],
    dx: 26em,
    dy: 5em,
  )
]

#pbr

#[
  == Tahap I: Diagram Alir Algoritma

  #absolute-place(
    box([
      - Terdiri atas dua alur
        - alur utama (`main`)
        - alur SBR
    ], width: 16em),
    dx: 5em,
    dy: 7em
  )

  #absolute-place(
    [
      #set text(size: 8pt)
      #diagram(
        spacing: (2em, 2em),
        node-stroke: black,
        {
          let g = green.lighten(70%)
          let r = blue.lighten(70%)
          let sp = shapes.parallelogram
          let sd = shapes.diamond
          (
            node((-1, 0), [Mulai], shape: shapes.pill),
            node((1, 0), [Memuat denah \ ruangan], shape: sp, fill: g),
            node((2, 0), [Membaca \ parameter simulasi], shape: sp, fill: g),
            node((3, 0), [Membaca input \ posisi Rx dan Tx], shape: sp, fill: g),
            node((4, 0), [*SBR*], extrude: (-3,0), inset: 10pt, fill: g),
            node((5, 0), [Batas \ iterasi \ tercapai?], shape: sd, inset: 8pt, fill: g)
          ).intersperse(edge("-|>")).join()
          edge((5, 0), "-|>", (7, 0), [Ya])
          edge((5, 0), "u,l,d","-|>", [Tidak])
          node((7, 0), [Menyaring sinar-sinar \ valid], fill: r)
          edge((7, 0), "r,u,r", "-|>")
          edge((7, 0), "r,d,r", "-|>")
          node((9, -1), [Menghitung RSSI], fill: r)
          node((9, 1), [Menghitung \ rugi jalur], fill: r)
          edge((9,-1), "r,d,r", "-|>")
          edge((9, 1), "r,u,r", "-|>")
          (
            node((11, 0), [Menampilkan \ hasil perhitungan], fill: r),
            node((12, 0), [Selesai], shape: shapes.pill)
          ).intersperse(edge("-|>")).join()
        }
      )
    ],
    dx: 2em,
    dy: 12em
  )
]

#pbr

#[
  == Tahap I: Diagram Alir Algoritma...

  #absolute-place(
    [
      #set text(size: 8pt)
      #diagram(
        spacing: (2em, 2em),
        node-stroke: black,
        {
          let g = green.lighten(70%)
          let r = blue.lighten(70%)
          let sp = shapes.parallelogram
          let sd = shapes.diamond
          (
            node((-1, 3), [*SBR*], extrude: (-3,0), inset: 10pt),
            node((0, 3), [Mulai], shape: shapes.pill),
            node((1, 3), [Menentukan \ sudut sinar], fill: g),
            node((2, 3), [Menentukan \ titik potong \ sinar-reflektor], fill: g),
            node((3, 3), [Sinar \ memotong \ reflektor?], shape: sd, fill: g)
          ).intersperse(edge("-|>")).join()
          edge("-|>", [Ya])
          node((5, 3), [Mengenai \ sudut?], shape: sd, inset: 8pt, fill: r)
          edge("-|>", corner: right, [Tidak], label-pos: 0.75)
          node((7, 2), [Sinar \ refleksi?], shape: sd, fill: r)
          edge((7, 2), corner: left, "-|>", (10, 3), [Tidak])
          edge("-|>", [Ya])
          node((9, 2), [Menghitung \ sudut refleksi], fill: g)
          edge("-|>")
          node((10, 2), [Menghitung \ koefisien refleksi \ $Gamma$], fill: r)
          node((10, 3), [Menghitung \ koefisien transmisi \ $T$], fill: r)
          edge("-|>")
          edge((10, 2), "r,d")
          node((12, 3), [Menghitung jarak \ sinar dengan \ penerima], fill: g)
          edge((5, 3), corner: left, "-|>", (7, 4), [Ya], label-pos: 0.75)
          node((7, 4), [*Pemodelan* \ *difraksi*], extrude: (0, -3), fill: r)
          edge("-|>")
          node((10, 4), [Menghitung \ koefisien difraksi \ $D$], fill: r)
          edge((10, 4), "r,u")
          edge((12, 3), "r,d", "-|>")
          edge((3,3), "u,u,r,r,r,r,r,r,r,r,r,r,d,d", [Tidak], label-pos: 0.2)
          node((13, 4), [Selesai], shape: shapes.pill)
        }
      )
    ],
    dx: 2em,
    dy: 9em
  )
]

#pbr

#[
  == Tahap I: Lingkungan Pemrograman

  #absolute-place(
    box([
      #set text(size: 19pt)
      - Aplikasi grafis natif
      - Ditulis dalam bahas Rust:
        - Lingkungan Pengembangan
        - Performa
        - Keamanan memori dan tipe
      - Pada _benchmark_ SBR, Rust memiliki performa rata-rata terbaik
        - CPU i5 Gen8 4C/8T
        - 16GB DDR4
    ], width: 12em),
    dx: 5em,
    dy: 7em
  )

  #absolute-place(
    figure(
      image("chapters/assets/benchmark.png", width: 70%)
    ),
    dx: 18em,
    dy: 7em,
  )
]

#pbr

#[
  == Tahap I: Algoritma SBR

  #absolute-place(
    box([
      - Menggunakan suatu objek sinar dan objek segmen
      - Didasarkan kepada hukum Snell
      - Terdiri dari operasi-operasi vektor sederhana
      - Representasi sinar:
      $ bup(R) = (bup(o), bup(d)) $
      - Representasi segmen:
      $ bup(w) = (bup(s), bup(e)) $
    ], width: 18em),
    dx: 5em,
    dy: 7em
  )

  #absolute-place(
    figure(
      image("present/assets/alg.png", height: 18em)
    ),
    dx: 22em,
    dy: 3.6em,
  )
]

#pbr

#[
  == Tahap I: Kerangka Pemrograman

  #absolute-place(
    box([
      - Pemilihan lingkungan dan konfigurasi lingkungan pengembangan
      - Penulisan kerangka grafis
      - Pengintegrasian algoritma SBR dengan kerangka grafis
    ], width: 10em),
    dx: 5em,
    dy: 7em
  )

  #absolute-place(
    figure(
      image("present/assets/environment.png", width: 70%)
    ),
    dx: 16em,
    dy: 7em
  )
]

#pbr

#[
  == Tahap II: Integrasi Pemodelan

  #absolute-place(
    box([
      - Melakukan perhitungan terhadap koefisien Fresnel dan koefisien difraksi
      - Kalkulasi koefisien Fresnel diintegrasikan langsung ke SBR
      - Kalkulasi koefisien difraksi:
        - Koefisien difraksi pada SBR.
        - Pemancaran sinar sekunder di sekitar sudut.
      - Representasi sinar:
      $ bup(R) = (bup(o), bup(d), bup(Gamma), bup(T), bup(D), s) $
    ], width: 18em),
    dx: 5em,
    dy: 7em
  )

  #absolute-place(
    figure(
      image("present/assets/algnew.png", height: 18em)
    ),
    dx: 24em,
    dy: 3.6em,
  )
]

#pbr

#[
  == Tahap II: Perhitungan

  #set text(size: 16pt)
  #show math.equation: set text(size: 14pt)

  - Atenuasi medan sebagai produk dari koefisien-koefisien interaksi dan medan sumber
  $ E_R = E_0 [product_i Gamma_i product_j T_j product_k D_k ] e^(-j k s)/s $
  - Total medan adalah superposisi dari medan-medan sinar valid
  $ E_"total" = sum_i E_(R,"valid")[i] $
  - Rugi jalur merupakan fungsi dari total medan dan frekuensi
  $ L = P_R/P_T = 1/(8 P_0) abs(E_"total")^2/eta_0 lambda^2/pi $
]

#pbr

#[
  == Hasil Simulasi: Denah Sederhana

  #absolute-place(
    figure(
      image("chapters/assets/simplefray.png", height: 10em),
    ), 
    dx: 5em,
    dy: 9em
  )

  #absolute-place(
    figure(
      image("chapters/assets/altairspl.png", height: 10em),
    ), 
    dx: 24em,
    dy: 9em
  )
]

#pbr

#[
  == Hasil Simulasi: Denah Sederhana

  #absolute-place(
    figure(
      image("chapters/assets/s24.png", height:  100%),
      caption: [2.4G]
    ), 
    dx: 8em,
    dy: 7em
  )

  #absolute-place(
    figure(
      image("chapters/assets/s5.png", height: 100%),
      caption: [5G]
    ), 
    dx: 22em,
    dy: 7em
  )
]

#pbr

#[
  == Hasil Simulasi: Denah Nyata

  #absolute-place(
    figure(
      image("chapters/assets/realfray.png", height: 9em),
    ), 
    dx: 5em,
    dy: 9em
  )

  #absolute-place(
    figure(
      image("chapters/assets/altairreal.png", height: 9em),
    ), 
    dx: 22em,
    dy: 9em
  )
]

#pbr

#[
  == Hasil Simulasi: Denah Nyata

  #absolute-place(
    figure(
      image("chapters/assets/plreal24g.png", height:  100%),
      caption: [2.4G]
    ), 
    dx: 8em,
    dy: 7em
  )

  #absolute-place(
    figure(
      image("chapters/assets/plreal5g.png", height: 100%),
      caption: [5G]
    ), 
    dx: 22em,
    dy: 7em
  )
]

#pbr

#[
  == Hasil Simulasi: Pengukuran

  #absolute-place(
    figure(
      image("chapters/assets/test.png", height: 100%),
      caption: [Posisi pengukuran]
    ), 
    dx: 4em,
    dy: 7em
  )

  #absolute-place(
    figure(
      image("present/assets/res.png", width: 60%),
    ), 
    dx: 19em,
    dy: 7.3em
  )
]

#pbr

#[
  == Simpulan

  - Metode _ray-tracing_ didasarkan kepada GO/UTD dalam memodelkan propagasi gelombang sebagai sinar-sinar
  - _Shooting and bouncing rays_ digunakan dalam _ray tracing_ untuk memungkin-?kan integrasi transmisi dan difraksi
  - Program menggunakan bahasa pemrograman Rust dengan alur yang terpusah antara pemrosesan grafis di alur utama dan kalkulasi _ray-tracing_ di alur SBR.
  - Integrasi refleksi, transmisi, dan difraksi memberikan hasil simulasi yang cukup menggambarkan keadaan yang sebenarnya, meskipun aplikasi masih sangat terbuka untuk pengembangan lebih lanjut.
]

#pbr

#[
  #absolute-place(text("Terima Kasih", size: 32pt, fill: blue), dx: 5em, dy: 10em)
]