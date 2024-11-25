= Dasar Teori

#let bup(x) = [$bold(upright(#x))$]

_Ray tracing_ merupakan kerangka kerja ilmiah yang hadir di berbagai bidang disiplin ilmu sebagai sebuah metode yang digunakan untuk memahami bagaimana gelombang berpropagasi dalam ruang, dan waktu. Meskipun memiliki konsep inti yang sama dalam aplikasinya di berbagai bidang, yaitu mengikuti ("_tracing_") sinar-sinar ("_rays_") untuk memodelkan interaksi dengan permukaan dan batasan, seperti simulasi cahaya pada grafika komputer, propagasi gelombang suara pada akustik, hingga propagasi gelombang seismik dalam seismologi dan dan cahaya dalam relativitas umum, prinsip-prinsip yang mendasari _ray tracing_ berbeda-beda secara signifikan satu sama lain pada bidang yang berbeda. Dengan kata lain, agar suatu fenomena gelombang dapat dimodelkan melalui _ray tracing_, terdapat dua hal yang perlu diperhatikan, yaitu bahwa konsep sinar sebagai representasi propagasi gelombang valid pada ruang terkait serta terdapat mekanisme-mekanisme yang menjelaskan interaksi sinar tersebut dengan lingkungan.

Pemodelan propagasi gelombang elektromagnetik didasarkan kepada Optika Geometris (_Geometrical Optics_/GO) berupa pendekatan asimtotik terhadap persamaan Maxwell yang memperlakukan gelombang elektromagnetik sebagi sinar-sinar dan dapat menjadi mekanisme yang menjelaskan refleksi dan refraksi. _Geometric theory of diffraction_ (GTD) dikembangkan untuk menjelaskan difraksi@keller_geometrical_1962, dan kemudian _uniform theory of diffraction_ (UTD), yang bekerja menggunakan prinsip Optika Fisik (_Physical Optics_/PO) berupa perkembangan selanjutnya dari GO dengan mempertimbangkan sifat gelombang dari sinar dan dapat menjelaskan interferensi, difraksi, polarisasi, dan lainnya yang tidak dapat dijelaskan oleh GO@albani_uniform_2011. Tergantung kebutuhan, mekanisme lainnya seperti BSDF untuk memodelkan hamburan permukaan, dan lainnya dapat diintegrasikan ke dalam sistem untuk memodelkan fenomena gelombang yang berbeda.

== Persamaan-Persamaan Maxwell

Persamaan-persamaan Maxwell merupakan sistem dari sejumlah persamaan-persamaan diferensial parsial yang menjelaskan bagaimana medan listrik $bup(E) : Gamma times RR_+ arrow RR^3$ dan medan magnet $bup(B) : Gamma times RR_+ arrow RR^3$ sebagai fungsi vektor atas ruang $bup(r) in Gamma$, dengan $Gamma subset RR^3$, dan waktu $t in RR_+$  berperilaku dan berinteraksi satu sama lain dalam ruang. Sistem persamaan ini terdiri atas 4 persamaan yang masing-masing merupakan formulasi hukum elektromagnetik yang menjelaskan bagaimana medan magnet dan medan listrik dihasilkan dan berinteraksi dengan muatan, arus, dan satu sama lainnya. 

#[
  #set math.equation(numbering: none)
  #set par(justify: false, leading: 1em)
  #figure(
    table(
      columns: (80pt, auto, auto),
      align: (left + horizon, center + horizon, center + horizon),
      table.header([*Hukum*], [*Bentuk Diferensial*], [*Bentuk Integral*]),
      [Hukum Gauss], [$ nabla dot bup(E) = rho / epsilon_0 $], [$ integral.surf_(diff Omega) bup(E) dot d bup(S) = Q/epsilon_0 $],
      [Hukum Magnet Gauss], [$ nabla dot bup(B) = 0 $], [$ integral.surf_(diff Omega) bup(B) dot d bup(S) = 0 $],
      [Hukum Induksi Faraday], [$ nabla times bup(E) = - (diff bup(B)) / (diff t) $], [$ integral.cont_(diff Sigma) bup(E) dot d bup(cal(l)) = - upright(d) / (upright(d) t) bup(Phi)_B  $],
      [Hukum Ampère], [$ nabla times bup(B) = mu_0(bup(J) + epsilon_0 (diff bup(E)) / (diff t)) $], [$ integral.cont_(diff Sigma) bup(B) dot d bup(cal(l)) = mu_0 (I + epsilon_0 upright(d)/(upright(d) t) bup(Phi)_E) $]
    ),
    caption: [Persamaan-persamaan Maxwell],
  )

  \

  $
    Q = integral.triple_Omega rho space d V
  $

  adalah total muatan listrik yang dilingkupi oleh suatu volume tertutup $Omega$,

  $
    bup(Phi)_B = integral.double_Sigma bup(B) dot d bup(S)
  $

  adalah fluks magnetik berupa medan magnet $bup(B)$ yang melalui suatu permukaan tertutup $Sigma$,

  $
    bup(Phi)_E = integral.double_Sigma bup(E) dot d bup(S)
  $

  adalah fluks listrik berupa medan listrik $bup(E)$ yang melalui $Sigma$, dan

  $
    I = integral.double_Sigma bup(J) dot d bup(S)
  $

  adalah arus listrik berupa kerapatan arus listrik $bup(J)$ yang melalui $Sigma$.
]

Persamaan-persamaan Maxwell dapat dijabarkan dalam bentuk integral maupun diferensial, dimana bentuk integral dari persamaan-persamaan ini dapat menjelaskan perilaku medan listrik dan magnet pada suatu area pada ruang sementara itu bentuk diferensialnya membantu dalam menjelaskan perilaku medan listrik dan medan magnet lokal pada suatu titik.

=== Hukum Gauss

Persamaan pertama dari persamaan Maxwell menggambarkan hukum Gauss terkait perilaku medan listrik di sekitar muatan listrik. Bentuk integral persamaan ini menyatakan bahwa fluks listrik yang melewati suatu permukaan tertutup sebanding dengan muatan yang dilingkupi oleh permukaan tersebut. Sementara itu, bentuk diferensial dari persamaan ini menunjukkan adanya monopol-monopol muatan (positif dan negatif) yang besarnya sebanding dengan kerapatan muatan pada titik-titik monopol tersebut.

@gaussimg mengilustrasikan muatan yang menghasilkan fluks listrik pada kondisi terlingkupi (kiri) dan tidak terlingkupi (kanan). Menurut hukum Gauss, fluks listrik total pada kondisi pertama sebanding dengan muatan, sedangkan fluks listrik total pada permukaan kedua adalah nol karena total fluks yang keluar dan masuk pada permukaan adalah sama.

#figure(
  image("assets/gaussian.png", width: 60%),
  caption: [Muatan dan fluks listrik yang dihasilkannya melalui suatu permukaan],
) <gaussimg>

=== Hukum Magnet Gauss

Persamaan kedua dari persamaan Maxwell merupakan formulasi dari hukum magnet Gauss terkait medan magnet pada suatu area. Dalam bentuk integralnya, persamaan ini menyatakan bahwa fluks magnet total yang melewati suatu permukaan akan selalu bernilai nol, atau dengan kata lain fluks magnetik yang keluar dan masuk dari suatu permukaan akan selalu sama. Bentuk diferensial dari persamaan ini mengimplikasikan tidak adanya monopol magnet.

#figure(
  image("assets/gaussmag.png", width: 40%),
  caption: [Fluks magnetik yang melewati permukaan tertutup],
) <gaussmag>

@gaussmag mengilustrasikan implikasi dari hukum magnet Gauss, dimana fluks magnetik yang melewati suatu permukaan tertutup akan selalu bernilai nol. Pada permukaan $cal(S)_A$ hal ini terjadi karena jumlah garis fluks magnetik yang memasuki permukaan sama dengan jumlah garis fluks magnetik yang keluar dari permuakaan, sedangkan pada permukaan $cal(S)_B$, semua garis medan dilingkupi oleh permukaan sehingga fluks yang melalui permukaan juga bernilai nol.

=== Hukum Induksi Faraday

Sementara persamaan pertama dan kedua dari persamaan-persamaan Maxwell menunjukkan perilaku medan magnet pada ruang, maka persamaan ketiga dan keempat menjelaskan hubungan antar kedua medan tersebut. Persamaan ketiga terkait dengan hukum induksi Faraday yang menunjukkan bahwa perubahan pada medan magnet dapat menghasilkan medan listrik. Bentuk integral dari persamaan ini menyatakan bahwa suatu tegangan akan terbentuk pada lingkaran tertutup (_loop_) ketika terjadi perubahan fluks magnetik yang melewati permukaan yang dilingkupi oleh lingkaran tertutup tersebut. Sementara itu, bentuk diferensial dari persamaan ini menunjukkan bahwa perubahan medan magnet pada suatu titik, akan menimbulkan medan listrik yang berputar di sekitar titik tersebut (_curl_).

#figure(
  image("assets/faradayinfimg.png", width: 80%),
  caption: [Induksi EMF (gaya gerak listrik) akibat pergerakan magnet di sekitar kumparan],
) <faradayimg>

@faradayimg menunjukkan salah satu implikasi nyata dari hukum induksi Faraday, dimana gaya gerak listrik dihasilkan ketika magnet digerakkan disekitar kumparan. Hal ini terjadi karena ketika magnet digerakkan, maka terjadi perubahan garis medan magnet yang melewati permukaan yang dilingkupi oleh kumparan tersebut, yang menurut hukum induksi Faraday ini, akan menghasilkan gaya gerak listrik di sepanjang kumparan.

=== Hukum Ampère

Persamaan terakhir dari persamaan Maxwell berkorelasi dengan hukum Ampère yang menunjukkan bahwa perubahan medan listrik juga dapat menimbulkan medan magnet. Bentuk integral dari persamaan ini menunjukkan bahwa fluks magnet melingkar akar terbentuk pada suatu lingkaran tertutup (_loop_) ketika pada permukaan yang dilingkupi oleh lingkaran tertutup tersebut dilewati oleh muatan listrik dan/atau terjadi perubahan medan magnet. Bentuk diferensial dari persamaan ini sementara itu menunjukkan bahwa ketika di suatu titik terdapat kerapatan arus dan/atau perubahan medan listrik, maka akan timbul medan magnet melingkar di titik tersebut (_curl_). @ampereimg menunjukkan efek dari hukum ini dimana ketika arus melewati sebuah kawat, maka akan terbentuk medan magnet melingkar di sekitarnya.

#figure(
  image("assets/ampereimg.png", width: 80%),
  caption: [Pola pada serbuk besi di sekitar kawat yang dialiri arus listrik],
) <ampereimg>

== Gelombang Elektromagnetik dan Optika Geometris

=== Persamaan Gelombang Elektromagnetik

Pada ruang hampa, yaitu ruang yang bebas dari pengaruh sumber medan listrik dan medan magnet, persamaan-persamaan Maxwell menjadi:

$ nabla dot bup(E) = 0 $ <gaussvacuum>
$ nabla dot bup(B) = 0 $
$ nabla times bup(E) = - (diff bup(B)) / (diff t) $ <einvacuum>
$ nabla times bup(B) = mu_0 epsilon_0 (diff bup(E)) / (diff t) $ <binvacuum>

\

Dengan melakukan operasi _curl_ kembali pada persamaan @einvacuum, maka didapatkan:

$ nabla times nabla times bup(E) = - diff / (diff t) nabla times bup(B) $ <ceinvacuum>

\

Lalu dengan melakukan substitusi persamaan @binvacuum ke persamaan @ceinvacuum didapatkan:

$ nabla times nabla times bup(E) = -mu_0 epsilon_0 diff^2/(diff t^2) bup(E) $ <cceinvacum>

Salah satu identitas operator _curl_ adalah $nabla times (nabla times F) = nabla(nabla dot F)-nabla^2 F$, sedangkan pada ruang hampa tnapa sumber fluks listrik $nabla dot bup(E) = 0$, sehingga persamaan @cceinvacum menjadi:

$ nabla^2 bup(E) = mu_0 epsilon_0 diff^2/(diff t^2) bup(E) $

atau

$ diff^2/(diff t^2)bup(E)= c^2 nabla^2 bup(E) $ <ewaveequation>

yang merupakan persamaan gelombang, dimana kecepatan cahaya pada ruang hampa $c=1/sqrt(mu_0 epsilon_0)$. Persamaan @ewaveequation merupakan persamaan diferensial parsial yang menjelaskan propagasi gelombang listrik pada ruang hampa. Dengan penuruanan yang sama, didapatkan persamaan gelombang magnet berupa:

$ diff^2/(diff t^2)bup(B) = c^2 nabla^2 bup(B) $

=== Persamaan Helmholtz

Persamaan-persamaan @gaussvacuum sampai @binvacuum juga dapat dijabarkan ke dalam domain frekuensi dengan bantuan transformasi Fourier $cal(F)[bup(F)(bup(r), t)] = tilde(bup(F))(bup(r), omega)$:

$ nabla dot tilde(bup(E)) = 0 $  <fourb>
$ nabla dot tilde(bup(B)) = 0 $
$ nabla times tilde(bup(E)) =  -j omega tilde(bup(B)) $
$ nabla times tilde(bup(B)) =  (j omega)/c^2 tilde(bup(E)) $ <foure>

dimana $tilde(bup(E)) : Gamma times RR arrow RR^3$ dab $tilde(bup(B)) : Gamma times RR arrow RR^3$ masing-masing merupakan medan listrik dan medan magnet sebagai fungsi vektor pada domain frekuensi.

Jika dilakukan transformasi Fourier pada persamaan @ewaveequation, akan didapatkan:

#[
  #set math.equation(number-align: bottom)

  $
    diff^2/(diff t^2)bup(E) &= c^2 nabla^2 bup(E) \
    cal(F)[diff^2/(diff t^2)bup(E)] &= cal(F)[c^2 nabla^2 bup(E)] \
    -omega^2 tilde(bup(E)) &= c^2 nabla^2 tilde(bup(E)) \
    (nabla^2 + k^2) tilde(bup(E)) &= 0
  $ <helmholtz>
]

dimana persamaan @helmholtz adalah persamaan Helmholtz dengan $k=omega/c$ adalah angka gelombang.

=== Persamaan Eikonal

Jika gelombang elektromagnetik berpropagasi pada medium nonhomogen dimana terdapat permitivias $epsilon$ dan permeabilitas $mu$ berupa medan skalar pada ruang, maka kecepatan rambat gelombang menjadi fungsi ruang $v_p (bup(r))$ yang dapat disebut juga sebagai kecepatan fasa. Pada kondisi tersebut, indeks refraksi $n$ sebagai perbandingan antara cepat rambat gelombang pada ruang hampa dan medium juga berupa fungsi ruang:

$ n(bup(r)) = c/(v_p (bup(r))) $

\

Ketika persamaan @helmholtz diaplikasikan pada gelombang yang berpropagasi pada medium nonhomogen ini, maka:

#[
  #set math.equation(number-align: bottom)

  $
    (nabla^2 + omega^2/(v_p^2(bup(r)))) tilde(bup(E)) &= 0 \
    (nabla^2 + n^2(bup(r)) omega^2/c^2) tilde(bup(E)) &= 0 \
    (nabla^2 + n^2(bup(r)) k^2) tilde(bup(E)) &= 0 \
  $ <nhhelmholtz>
]

\

Solusi tepat dari persamaan Maxwell secara umum sulit diperoleh secara langsung, sehingga pada prakteknya, perkiraan solusi dari sistem persamaan tersebut umumnya dilakukan dengan pendekatan, salah satunya adalah ekspansi asimtotik Luneberg-Kline@dominek_additional_1987:

$
  hat(bup(E))(bup(r), omega) = e^(-j k phi.alt(bup(r))) sum_(i in NN)(hat(bup(E))_i (bup(r))) / (j omega)^n
$ <lkexpansion>

dimana $phi.alt (bup(r))$ adalah fungsi fasa dan $tilde(bup(E))_i (bup(r))$ adalah vektor amplitudo untuk komponen orda ke-$i$ dari ekspansi asimtotik tersebut.

Jika persamaan @lkexpansion disubstitusikan ke persamaan @nhhelmholtz, maka:

#[
  #set math.equation(number-align: bottom)
  #let en = [$tilde(bup(E))_i (bup(r))$]
  #let ex = [$e^(-j k phi.alt(bup(r)))$]
  #let sn = [$sum_(i in NN)$]
  #let jw = [$(j omega)^i$]
  #let nr = [$n^2(bup(r))$]

  $
    (nabla^2 + n^2 k^2) tilde(bup(E)) &= 0 \
    nabla^2 tilde(bup(E)) + nr k^2 tilde(bup(E)) &= 0\
    nabla^2 sn ex/jw en + nr k^2 sn ex/jw en &= 0 \
    sn nabla^2 ex/jw en + nr k^2 sn ex/jw en &= 0 \
  $ <a1>

  \

  Operator Laplace (Laplacian) $nabla^2$ memiliki identitas $nabla^2 (psi dot bup(F)) = bup(F) nabla^2 psi + 2 nabla psi dot nabla bup(F) + psi nabla^2 bup(F)$ dengan $psi$ medan skalar dan $bup(F)$ medan vektor, sehingga suku pertama dari persamaan @a1 dapat dikembangkan menjadi:
  
  $
    sn 1/jw [en nabla^2 ex  + 2 nabla ex dot nabla en + ex nabla^2 en] \
    + nr k^2 sn ex/jw en = 0
  $

  dengan

  $ nabla ex = -j k ex nabla phi.alt(bup(r)) $

  dan

  $ nabla^2 ex = -j k ex nabla^2 phi.alt(bup(r)) - k^2 ex (nabla phi.alt(bup(r)))^2 $

  maka

  $
    sn 1/jw [-j k ex en nabla^2 phi.alt(bup(r)) - k^2 ex en (nabla phi.alt(bup(r)))^2 \
    - 2 j k ex nabla phi.alt(bup(r)) dot nabla en + ex nabla^2 en \
    + nr k^2 ex en 
    ] &= 0 \

    ex sn 1/jw [-j k en nabla^2 phi.alt(bup(r)) - k^2 en (nabla phi.alt(bup(r)))^2 \
    - 2 j k nabla phi.alt(bup(r)) dot nabla en + nabla^2 en \
    + nr k^2 en 
    ] &= 0 \

    ex sn 1/jw [(nabla^2 en + nr k^2 en - k^2 en (nabla phi.alt(bup(r)))^2) \
    - j(k en nabla^2 phi.alt(bup(r))) + 2k nabla phi.alt(bup(r)) dot nabla en)] &= 0
  $ <lkexpanded>
  
\

  Agar persamaan @lkexpanded benar, maka suku riil dan imajiner dari persamaan tersebut harus sama dengan 0.

  $
    nabla^2 en + nr k^2 en - k^2 en (nabla phi.alt(bup(r)))^2 &= 0 \
    k^2 en (nabla phi.alt(bup(r)))^2 &= nabla^2 en + nr k^2 en \
    (nabla phi.alt(bup(r)))^2 &= (nabla^2 en)/(k^2 en) + nr \
    ||nabla phi.alt(bup(r))|| &= n(bup(r))
  $ <eikonal>
]

\

Persamaan @eikonal merupakan persamaan eikonal dari gelombang di medan $bup(E)$. Eikonal $nabla phi.alt(bup(r))$ juga disebut sebagai momentum optik $bup(p)(bup(r))$ pada optika Lagrangian dan berupa vektor di suatu titik $bup(P)$ pada sinar yang memiliki arah yang sama dengan sinar pada titik tersebut@chaves_introduction_2017. Sementara itu, eikonal $phi.alt(bup(r))$ juga disebut sebagai panjang jalur optik (_optical path length_/OPL) $S$. Jika titik-titik pada sinar-sinar cahaya yang memiliki nilai $S$ yang sama disambungkan, akan didapatkan permukaan yang menggambarkan muka gelombang. Dengan kata lain, muka gelombang adalah permukaan ketinggian (_level surface_) dari dari fungsi gelombang. @wavefront mengilustrasikan garis hijau yang menyambungkan titik-titik pada sinar (_light rays_) yang memiliki nilai $S$ yang sama, yang membentuk muka gelombang (_wavefronts_).

#figure(
  image("assets/wavefront.png", width: 60%),
  caption: [Sinar (merah) dan muka gelombang (hijau) pada sinar 2 dimensi],
) <wavefront>

=== Vektor Poynting

Salah satu teorema dalam kalkulus vektor adalah bahwa vektor gradien tegak lurus dengan kurva atau permukaan ketinggian. Oleh karena itu, $bup(p)$ sebagai gradien dari permukaan ketinggian dari $S$ akan selalu tegak lurus dengan permukaan tersebut. Hal ini juga dapat dibuktikan dengan menjabarkan vektor Poynting $bup(S)$ rata-rata dari medan elektromagnetik yang berupa@orfanidis_electromagnetic_2016

#[
  #set math.equation(number-align: bottom)
  $
    angle.l bup(S) angle.r &= 1/2 cal(Re)[bup(E) times dash(bup(H))] \
    &= 1/(2mu) cal(Re)[bup(E) times dash(bup(B))]
  $
]

Pertama dengan melakukan pendekatan pada persamaan @lkexpansion untuk nilai $omega$ yang sangat besar sehingga deret hanya menyisakan suku ke-nol:

$
  lim_(omega arrow infinity) tilde(bup(E))(bup(r), omega) = tilde(bup(E))_0(bup(r)) e^(-j k phi.alt(bup(r)))
$

yang juga berlaku untuk medan magnet

$
  lim_(omega arrow infinity) tilde(bup(B))(bup(r), omega) = tilde(bup(B))_0(bup(r)) e^(-j k phi.alt(bup(r)))
$

\

Memasukkan kedua nilai tersebut kepersamaan @fourb hingga @foure dengan menggunakan identitas kalkulus vektor $nabla dot (psi bup(F)) = psi nabla dot bup(F) + bup(F) dot nabla psi$ dan $nabla times (psi bup(F)) = psi (nabla times bup(F))+(nabla psi) times bup(F)$, didapatkan:

#[
  #set math.equation(number-align: bottom)
  #let ex = [$e^(-j k phi.alt(bup(r)))$]
  #let eo(f) = [$tilde(bup(#f))_0(bup(r))$]
  #let ps = [$phi.alt(bup(r))$]

  $ 
    nabla ps dot eo(E) = 0
  $

  $
    nabla ps dot eo(B) = 0
  $ <pseoiszero>
  
  $
    nabla ps times eo(E) = j c eo(B) 
  $

  $
    nabla ps times eo(B) = -j/c eo(E)
  $
  
  \

  Menggunakan perkalian silang tiga vektor $bup(A) times (bup(B) times bup(C)) = (bup(A) dot bup(C))bup(B) - (bup(A) dot bup(B))bup(C)$, maka

  $
    angle.l bup(S) angle.r &= 1/(2 mu_0) cal(Re)[bup(E) times dash(bup(B))] \
    &= 1/(2mu)cal(Re)[eo(E) times (nabla ps times dash(eo(E)))] \
    &= 1/(2mu)cal(Re)[(eo(E) dot dash(eo(E)))nabla ps-(eo(E) dot nabla ps)dash(eo(E))] \
  $ <poynting1>

  Persamaan @pseoiszero membuat suku kedua dari @poynting1 bernilai nol, sedangkan $nabla ps$ adalah riil, selain itu $1/4 cal(Re)[epsilon bup(E) dot dash(bup(E))]$ adalah kerapatan energi listrik rata-rata $angle.l w_e angle.r$@orfanidis_electromagnetic_2016, sehingga

  $
    angle.l bup(S) angle.r &= 2/(mu epsilon) angle.l w_e angle.r nabla ps
  $ <finalpoynting>
]

\

Persamaan @finalpoynting menunjukkan bahwa vektor Poynting sebagai vektor yang menunjukkan arah energi dari gelombang elektromagnetik, searah dengan eikonal. Implikasi dari hal ini adalah bahwa propagasi gelombang sebagai aliran energi dapat direpresentasikan sebagai garis-garis sinar. Hal inilah yang mendasari optika geometris sebagai analisis propagasi gelombang elektromagnetik dalam bentuk representasi sinar-sinar.