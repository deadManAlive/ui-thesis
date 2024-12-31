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
            #text(size: 6pt, tracking: 2pt)[DEPARTEMEN] \
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
          #text(size: 6pt, tracking: 2pt)[DEPARTEMEN] \
          #text(size: 12pt)[*TEKNIK ELEKTRO*]
        ]
      )
    )
    ], footer: move(dx: 0pt, dy: 50%, rect(fill: blue, width: 150%, height: 100%))
  )

  #set align(center + horizon)
  #show heading.where(level: 1): set text(size: 32pt) 
  = #cfg.title

  \

  #cfg.name (#cfg.npm)
]

#pagebreak(weak: true)

// slide 2
#[
  == Latar Belakang

  + Kebutuhan akan konektivitas internet tetap dan/atau dalam ruang yang semakin meningkat.
  + Tantangan dalam mendesain ruangan yang mengoptimasi penggunaan titik akses dalam menyediakan akses Wi-Fi.
  + Solusi yang ada selain berupa piranti lunak berbayar yang mahal (Altair, Remcom, MATLAB) ataupun membutuhkan keahlian dalam penggunaannya (Meeps, OpenEMS, FEniCS).
]

#pagebreak(weak: true)

// slide 3
#[
  == Rumusan Masalah

  + Bagaimana _ray-tracing_ memodelkan propagasi gelombang radio?
  + Bagaimana menerapkan _ray-tracing_ ke dalam bentuk algoritma yang dapat melakukan perhitungan daya yang diterima dan rugi jalur dari satu sumber pada ruang 2 dimensi?
  + Bagaimana menyusun antarmuka grafis untuk algoritma program yang telah disusun?
  + Bagaimana pengaruh pemodelan interaksi-interaksi gelombang dengan lingkungan mempengaruhi hasil pemodelan?
]

#pagebreak(weak: true)

// slide 4
#[
  == Dasar Teori: Dari Persamaan Maxwell Ke Geometric Optics

  #set align(center)
  #set text(size: 13pt)

  #import "@local/fletcher:0.5.3" as fletcher: diagram, node, edge, shapes

  #diagram(
    node-stroke: black,
    node((-2,0), [
      $
        nabla dot bup(E) &= 0 \
        nabla dot bup(B) &= 0 \
        nabla times bup(E) &= - (partial bup(B))/(partial t) \
        nabla times bup(B) &= mu_0(bup(J) + epsilon_0 (partial bup(E))/(partial t))
      $
    ], shape: rect),
    edge("-|>", [$ (nabla times nabla times bup(E)) $]),
    node((0,0), [$ partial^2 / (partial t^2) bup(E)  = c^2 nabla^2 bup(E) $]),
    edge("-|>", [$ cal(F) $]),
    node((2,0), [$ (nabla^2 + k^2) hat(bup(E)) = 0 $]),
    edge("-|>", [$ hat(bup(E)) = e^(-j k phi.alt(bup(r)))  sum_n hat(bup(E))_i/(j omega)^n = 0 $], label-side: right),
    node((2,2), [$ norm( nabla phi.alt(bup(r))) = n $]),
    edge("-|>", [$ angle.l bup(S) angle.r = 1/(2 mu_0) Re[bup(E) times dash(bup(B))] $], label-side: right),
    node((-2,2), [$ angle.l bup(S) angle.r = 2 c angle.l w_c angle.r nabla phi.alt(bup(r)) $])
  ) 
]

// slide 5
#[
  == Dasar Teori: _Ray Tracing_

  - Pemodelan propagasi energi dalam bentuk sinar-sinar jalur.
  - Dalam elektromagnetika, didasarkan kepada Geometric Optics.
  - Terdapat dua metode utama: _shooting and bouncing rays_ (SBR) dan _image_.
  - Total medan adalah super posisi dari setiap sinar.

  #figure(
    image("present/assets/sbr.png", width: 35%)
  )
]