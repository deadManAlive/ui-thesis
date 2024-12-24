#import "@preview/cetz:0.3.1"

= Metode _Ray Tracing_

#let bup(x) = [$bold(upright(#x))$]

_Ray tracing_ merupakan kerangka kerja ilmiah yang hadir di berbagai bidang disiplin ilmu sebagai sebuah metode yang digunakan untuk memahami bagaimana gelombang berpropagasi dalam ruang, dan waktu. Meskipun memiliki konsep inti yang sama dalam aplikasinya di berbagai bidang, yaitu mengikuti ("_tracing_") sinar-sinar ("_rays_") untuk memodelkan interaksi dengan permukaan dan batasan, seperti simulasi cahaya pada grafika komputer, propagasi gelombang suara pada akustik, hingga propagasi gelombang seismik dalam seismologi dan dan cahaya dalam relativitas umum, prinsip-prinsip yang mendasari _ray tracing_ berbeda-beda secara signifikan satu sama lain pada bidang yang berbeda.
Dengan kata lain, agar suatu fenomena gelombang dapat dimodelkan melalui _ray tracing_, terdapat dua hal yang perlu diperhatikan, yaitu bahwa konsep sinar sebagai representasi propagasi gelombang valid pada ruang terkait serta terdapat mekanisme-mekanisme yang menjelaskan interaksi sinar tersebut dengan lingkungan.

Pemodelan propagasi gelombang elektromagnetik didasarkan kepada Optika Geometris (_Geometrical Optics_/GO) berupa pendekatan asimtotik terhadap persamaan Maxwell yang memperlakukan gelombang elektromagnetik sebagi sinar-sinar dan dapat menjadi mekanisme yang menjelaskan refleksi dan refraksi.
_Geometric theory of diffraction_ (GTD) dikembangkan untuk menjelaskan difraksi@keller_geometrical_1962 yang kemudian berkembang menjadi _uniform theory of diffraction_ (UTD) untuk menjawab beberapa permasalahan pada GTD@paknys_applied_2016.

Selain itu juga terdapat konsep _physical optics_ (PO) sebagai alternatif dari GO yang mempertimbangkan karakter gelombang dari propagasi dan dapat menjelaskan interferensi, difraksi, polarisasi, dan lainnya yang tidak dapat dijelaskan oleh GO@albani_uniform_2011, serta _physical theory of diffraction_ (PTD) sebagai ekuivalen dari GTD dengan basis PO yang memberikan koreksi pada difraksi di sekitar permukaan konduktif@balanis_balanis_2024. Tergantung kebutuhan, mekanisme lainnya seperti _Bidirectional Scattering Distribution Function_ (BSDF) untuk memodelkan hamburan permukaan, dan lainnya dapat diintegrasikan ke dalam sistem untuk memodelkan fenomena gelombang yang berbeda.

== Persamaan-Persamaan Maxwell

Persamaan-persamaan Maxwell merupakan sistem dari sejumlah persamaan-persamaan diferensial parsial yang menjelaskan bagaimana medan listrik $bup(E) : Gamma times RR_+ arrow RR^3$ dan medan induksi magnet $bup(B) : Gamma times RR_+ arrow RR^3$ sebagai fungsi vektor atas ruang $bup(r) = hat(bup(x))x + hat(bup(y))y + hat(bup(z))z in Gamma$, dengan $Gamma subset.eq RR^3$, dan waktu $t in RR_+$  berperilaku dan berinteraksi satu sama lain dalam ruang. Sistem persamaan ini terdiri atas 4 persamaan yang masing-masing merupakan formulasi hukum elektromagnetik yang menjelaskan bagaimana medan magnet dan medan listrik dihasilkan dan berinteraksi dengan muatan, arus, dan satu sama lainnya.

#[
  #set math.equation(numbering: none)
  #set par(justify: false, leading: 1em)
  #figure(
    table(
      columns: (30%, 50%),
      align: (left + horizon, center + horizon, center + horizon),
      table.header([*Hukum*], [*Formulasi* (Bentuk Diferensial)]),
      [Hukum Gauss], [$ nabla dot bup(E) = rho / epsilon_0 $],
      [Hukum Magnet Gauss], [$ nabla dot bup(B) = 0 $],
      [Hukum Induksi Faraday], [$ nabla times bup(E) = - (diff bup(B)) / (diff t) $],
      [Hukum Ampère], [$ nabla times bup(B) = mu_0(bup(J) + epsilon_0 (diff bup(E)) / (diff t)) $],
    ),
    caption: [Persamaan-persamaan Maxwell],
  )

  \

  Selain itu, medan listrik juga dapat direpresentasikan sebagai medan perpindahan listrik $bup(D)$, di mana pada ruang tanpa sumber medan listrik memiliki hubungan

  $ bup(D) = epsilon bup(E) $

  dan medan magnet juga dapat direpresentasikan melalui medan magnet $bup(H)$, yang pada ruang tanpa sumber medan magnet

  $ bup(H) = 1/mu bup(B) $
]

\

Persamaan-persamaan Maxwell ini dapat dijabarkan dalam bentuk integral maupun diferensial, di mana bentuk integral dari persamaan-persamaan ini dapat menjelaskan perilaku medan listrik dan magnet pada suatu area pada ruang sementara itu bentuk diferensialnya membantu dalam menjelaskan perilaku medan listrik dan medan magnet lokal pada suatu titik.

Pada bab ini, akan digunakan bentuk diferensial untuk memberikan dasar matematis dari beberapa konsep _ray tracing_ (RT).

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

@gaussmag mengilustrasikan implikasi dari hukum magnet Gauss, di mana fluks magnetik yang melewati suatu permukaan tertutup akan selalu bernilai nol. Pada permukaan $cal(S)_A$ hal ini terjadi karena jumlah garis fluks magnetik yang memasuki permukaan sama dengan jumlah garis fluks magnetik yang keluar dari permukaan, sedangkan pada permukaan $cal(S)_B$, semua garis medan dilingkupi oleh permukaan sehingga fluks yang melalui permukaan juga bernilai nol.

=== Hukum Induksi Faraday

Sementara persamaan pertama dan kedua dari persamaan-persamaan Maxwell menunjukkan perilaku medan magnet pada ruang, maka persamaan ketiga dan keempat menjelaskan hubungan antar kedua medan tersebut. Persamaan ketiga terkait dengan hukum induksi Faraday yang menunjukkan bahwa perubahan pada medan magnet dapat menghasilkan medan listrik. Bentuk integral dari persamaan ini menyatakan bahwa suatu tegangan akan terbentuk pada lingkaran tertutup (_loop_) ketika terjadi perubahan fluks magnetik yang melewati permukaan yang dilingkupi oleh lingkaran tertutup tersebut. Sementara itu, bentuk diferensial dari persamaan ini menunjukkan bahwa perubahan medan magnet pada suatu titik, akan menimbulkan medan listrik yang berputar di sekitar titik tersebut (_curl_).

#figure(
  image("assets/faradayinfimg.png", width: 80%),
  caption: [Induksi EMF (gaya gerak listrik) akibat pergerakan magnet di sekitar kumparan],
) <faradayimg>

@faradayimg menunjukkan salah satu implikasi nyata dari hukum induksi Faraday, di mana gaya gerak listrik dihasilkan ketika magnet digerakkan di sekitar kumparan. Hal ini terjadi karena ketika magnet digerakkan, maka terjadi perubahan garis medan magnet yang melewati permukaan yang dilingkupi oleh kumparan tersebut, yang menurut hukum induksi Faraday ini, akan menghasilkan gaya gerak listrik di sepanjang kumparan.

=== Hukum Ampère

Persamaan terakhir dari persamaan Maxwell berkorelasi dengan hukum Ampère yang menunjukkan bahwa perubahan medan listrik juga dapat menimbulkan medan magnet. Bentuk integral dari persamaan ini menunjukkan bahwa fluks magnet melingkar akar terbentuk pada suatu lingkaran tertutup (_loop_) ketika pada permukaan yang dilingkupi oleh lingkaran tertutup tersebut dilewati oleh muatan listrik dan/atau terjadi perubahan medan magnet.
Bentuk diferensial dari persamaan ini sementara itu menunjukkan bahwa ketika di suatu titik terdapat kerapatan arus dan/atau perubahan medan listrik, maka akan timbul medan magnet melingkar di titik tersebut (_curl_). @ampereimg menunjukkan efek dari hukum ini di mana ketika arus melewati sebuah kawat, maka akan terbentuk medan magnet melingkar di sekitarnya.

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

\

Salah satu identitas operator _curl_ adalah $nabla times (nabla times F) = nabla (nabla dot F)-nabla^2 F$, sedangkan pada ruang hampa tnapa sumber fluks listrik $nabla dot bup(E) = 0$, sehingga persamaan @cceinvacum menjadi:

$ nabla^2 bup(E) = mu_0 epsilon_0 diff^2/(diff t^2) bup(E) $

atau

$ diff^2/(diff t^2)bup(E)= c^2 nabla^2 bup(E) $ <ewaveequation>

yang merupakan persamaan gelombang, di mana kecepatan cahaya pada ruang hampa $c=1/sqrt(mu_0 epsilon_0)$. Persamaan @ewaveequation merupakan persamaan diferensial parsial yang menjelaskan propagasi gelombang listrik pada ruang hampa. Dengan penurunan yang sama, didapatkan persamaan gelombang magnet berupa:

$ diff^2/(diff t^2)bup(B) = c^2 nabla^2 bup(B) $

=== Persamaan Helmholtz

Persamaan-persamaan @gaussvacuum sampai @binvacuum juga dapat dijabarkan ke dalam domain frekuensi dengan bantuan transformasi Fourier $cal(F)[bup(F)(bup(r), t)] = tilde(bup(F))(bup(r), omega)$:

$ nabla dot tilde(bup(E)) = 0 $  <fourb>
$ nabla dot tilde(bup(B)) = 0 $
$ nabla times tilde(bup(E)) =  -j omega tilde(bup(B)) $ <fourfar>
$ nabla times tilde(bup(B)) =  (j omega)/c^2 tilde(bup(E)) $ <foure>

di mana $tilde(bup(E)) : Gamma times RR arrow RR^3$ dab $tilde(bup(B)) : Gamma times RR arrow RR^3$ masing-masing merupakan medan listrik dan medan magnet sebagai fungsi vektor pada domain frekuensi.

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

di mana persamaan @helmholtz adalah persamaan Helmholtz dengan $k=omega/c$ adalah angka gelombang.

=== Persamaan Eikonal

Indeks refraksi $n$ merupakan sebuah skalar yang berupa perbandingan antara cepat rambat gelombang elektromagnetik pada vakum $c$ dan kecepatan fasa pada material $v$

$ n = c/v  = sqrt(mu epsilon)/sqrt(mu_0 epsilon_0) = sqrt(mu_r epsilon_r) $

Jika gelombang elektromagnetik berpropagasi pada medium non-homogen di mana terdapat permitivitas $epsilon$ dan permeabilitas $mu$ berupa medan skalar pada ruang, maka kecepatan rambat gelombang menjadi fungsi ruang $v (bup(r))$ yang dapat disebut juga sebagai kecepatan fasa. Pada kondisi tersebut, indeks refraksi $n$ sebagai perbandingan antara cepat rambat gelombang pada ruang hampa dan medium juga berupa fungsi ruang:

$ n(bup(r)) = c/(v (bup(r))) $

\

Ketika persamaan @helmholtz diaplikasikan pada gelombang yang berpropagasi pada medium non-homogen ini, maka:

#[
  #set math.equation(number-align: bottom)

  $
    (nabla^2 + omega^2/(v^2(bup(r)))) tilde(bup(E)) &= 0 \
    (nabla^2 + n^2(bup(r)) omega^2/c^2) tilde(bup(E)) &= 0 \
    (nabla^2 + n^2(bup(r)) k^2) tilde(bup(E)) &= 0 \
  $ <nhhelmholtz>
]

\

Solusi tepat dari persamaan Maxwell secara umum sulit diperoleh secara langsung, sehingga pada praktiknya, perkiraan solusi dari sistem persamaan tersebut umumnya dilakukan dengan pendekatan, salah satunya adalah ekspansi asimtotik Luneberg-Kline@dominek_additional_1987:

$
  hat(bup(E))(bup(r), omega) = e^(-j k phi.alt(bup(r))) sum_(i in NN)(hat(bup(E))_i (bup(r))) / (j omega)^n
$ <lkexpansion>

di mana $phi.alt (bup(r))$ adalah fungsi fasa dan $tilde(bup(E))_i (bup(r))$ adalah vektor amplitudo untuk komponen orde ke-$i$ dari ekspansi asimtotik tersebut.

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

  Operator Laplace (Laplacian) $nabla^2$ memiliki identitas $nabla^2 (psi bup(F)) = bup(F) nabla^2 psi + 2 (nabla psi dot nabla) bup(F) + psi nabla^2 bup(F)$ dengan $psi$ medan skalar dan $bup(F)$ medan vektor, sehingga suku pertama dari persamaan @a1 dapat dikembangkan menjadi:

  $
    sn 1/jw [en nabla^2 ex  + 2 (nabla ex dot nabla) en + ex nabla^2 en] \
    + nr k^2 sn ex/jw en = 0
  $

  dengan

  $ nabla ex = -j k ex nabla phi.alt(bup(r)) $

  dan

  $ nabla^2 ex = -j k ex nabla^2 phi.alt(bup(r)) - k^2 ex (nabla phi.alt(bup(r)))^2 $

  maka

  $
    sn 1/jw [-j k ex en nabla^2 phi.alt(bup(r)) - k^2 ex en (nabla phi.alt(bup(r)))^2 \
    - 2 (j k ex nabla phi.alt(bup(r)) dot nabla) en + ex nabla^2 en \
    + nr k^2 ex en
    ] &= 0 \

    ex sn 1/jw [-j k en nabla^2 phi.alt(bup(r)) - k^2 en (nabla phi.alt(bup(r)))^2 \
    - 2 (j k nabla phi.alt(bup(r)) dot nabla) en + nabla^2 en \
    + nr k^2 en
    ] &= 0 \

    ex sn 1/jw [(nabla^2 en + nr k^2 en - k^2 en (nabla phi.alt(bup(r)))^2) \
    - j(k en nabla^2 phi.alt(bup(r)) + 2k (nabla phi.alt(bup(r)) dot nabla) en)] &= 0
  $ <lkexpanded>

\

  Agar persamaan @lkexpanded benar untuk $omega$ yang sangat besar, maka suku riil dan imajiner dari persamaan tersebut harus sama dengan 0.

  $
    nabla^2 en + nr k^2 en - k^2 en (nabla phi.alt(bup(r)))^2 &= 0 \
    k^2 en (nabla phi.alt(bup(r)))^2 &= nabla^2 en + nr k^2 en \
    (nabla phi.alt(bup(r)))^2 &= (nabla^2 en)/(k^2 en) + nr \
    norm(nabla phi.alt(bup(r))) &= n(bup(r))
  $ <eikonal>
]

\

Persamaan @eikonal merupakan persamaan eikonal dari gelombang di medan $bup(E)$. Gradien eikonal $nabla phi.alt(bup(r))$ juga disebut sebagai momentum optik $bup(p)(bup(r))$ pada optika Lagrangian dan berupa vektor di suatu titik $bup(P)$ pada sinar yang memiliki arah yang sama dengan sinar pada titik tersebut@chaves_introduction_2017. Sementara itu, eikonal $phi.alt(bup(r))$ juga disebut sebagai panjang jalur optik (_optical path length_/OPL) $sigma$.
Jika titik-titik pada sinar-sinar cahaya yang memiliki nilai $sigma$ yang sama disambungkan, akan didapatkan permukaan yang menggambarkan muka gelombang. Dengan kata lain, muka gelombang adalah permukaan ketinggian (_level surface_) dari dari fungsi gelombang. @wavefront mengilustrasikan garis hijau yang menyambungkan titik-titik pada sinar (_light rays_) yang memiliki nilai $sigma$ yang sama, yang membentuk muka gelombang (_wavefronts_).

#figure(
  image("assets/wavefront.png", width: 60%),
  caption: [Sinar (merah) dan muka gelombang (hijau) pada sinar 2 dimensi],
) <wavefront>

=== Vektor Poynting

Salah satu teorema dalam kalkulus vektor adalah bahwa vektor gradien tegak lurus dengan kurva atau permukaan ketinggian. Oleh karena itu, $bup(p)$ sebagai gradien dari permukaan ketinggian dari $S$ akan selalu tegak lurus dengan permukaan tersebut. Hal ini juga dapat dibuktikan dengan menjabarkan vektor Poynting $bup(S)$ rata-rata dari medan elektromagnetik yang berupa

$ angle.l bup(S) angle.r = 1/(2mu_0) cal(Re)[bup(E) times dash(bup(B))] $ <poynting0>

\

Pertama dengan melakukan pendekatan pada persamaan @lkexpansion untuk nilai $omega$ yang sangat besar sehingga deret hanya menyisakan suku ke-nol sebagai suku yang signifikan:

$
  lim_(omega arrow infinity) tilde(bup(E))(bup(r), omega) = tilde(bup(E))_0(bup(r)) e^(-j k phi.alt(bup(r)))
$ <limelexp>

yang juga berlaku untuk medan magnet

$
  lim_(omega arrow infinity) tilde(bup(B))(bup(r), omega) = tilde(bup(B))_0(bup(r)) e^(-j k phi.alt(bup(r)))
$

\

Memasukkan kedua nilai tersebut ke persamaan @fourb hingga @foure dengan menggunakan identitas kalkulus vektor $nabla dot (psi bup(F)) = psi nabla dot bup(F) + bup(F) dot nabla psi$ dan $nabla times (psi bup(F)) = psi (nabla times bup(F))+(nabla psi) times bup(F)$, didapatkan:

#[
  #set math.equation(number-align: bottom)
  #let ps = [$phi.alt(bup(r))$]
  #let ex = [$e^(-j k ps)$]
  #let eo(f) = [$tilde(bup(#f))_0(bup(r))$]

  $
    nabla dot tilde(bup(E)) &= 0 \
    nabla dot (eo(E) ex) &= 0 \
    ex nabla dot eo(E) + eo(E) dot nabla ex &= 0 \
    ex nabla dot eo(E) + eo(E) dot (-j k ex nabla ps) &= 0 \
    nabla dot eo(E) - j k nabla ps dot eo(E) &= 0 \
    nabla ps dot eo(E) &= 1/(j k) nabla dot eo(E)
  $

  $
    nabla dot tilde(bup(B)) &= 0 \
    nabla dot (eo(B) ex) &= 0 \
    nabla ps dot eo(B) &= 1/(j k) nabla dot eo(B)
  $

  $
    nabla times tilde(bup(E)) &=  -j omega tilde(bup(B)) \
    nabla times (eo(E) ex) &= -j omega eo(B) ex \
    ex (nabla times eo(E)) + (nabla ex) times eo(E) &= -j omega eo(B) ex \
    ex nabla times eo(E) - j k ex nabla ps times eo(E) &= -j omega eo(B) ex \
    nabla times eo(E) - j k nabla ps times eo(E) &= -j omega eo(B) \
    j k nabla ps times eo(E) &= j omega eo(B) + nabla times eo(E) \
    nabla ps times eo(E) &= c eo(B) + 1/(j k) nabla times eo(E)
  $

  $
    nabla times tilde(bup(B)) &= (j omega)/c^2 tilde(bup(E)) \
    nabla times (eo(B) ex) &= (j omega)/c^2 eo(E) ex \
    j k nabla ps times eo(B) &= -(j omega)/c^2 eo(E) + nabla times eo(B) \
    nabla ps times eo(B) &= 1/c eo(E) + 1/(j k) nabla times eo(B)
  $

  \

  Karena $omega arrow infinity$ dan $k = omega / c$, maka $k arrow infinity$, sehingga

  $
    nabla ps dot eo(E) = 0
  $

  $
    nabla ps dot eo(B) = 0
  $ <pseoiszero>

  $
    nabla ps times eo(E) = c eo(B)
  $

  $
    nabla ps times eo(B) = - 1/c eo(E)
  $

  \

  Menggunakan perkalian silang tiga vektor $bup(A) times (bup(B) times bup(C)) = (bup(A) dot bup(C))bup(B) - (bup(A) dot bup(B))bup(C)$, maka

  $
    angle.l bup(S) angle.r &= 1/(2 mu_0) cal(Re)[bup(E) times dash(bup(B))] \
    &= 1/(2mu_0)cal(Re)[eo(E) times 1/c (nabla ps times dash(eo(E)))] \
    &= 1/(2 c mu_0)cal(Re)[(eo(E) dot dash(eo(E)))nabla ps-(eo(E) dot nabla ps)dash(eo(E))] \
  $ <poynting1>

  Persamaan @pseoiszero membuat suku kedua dari @poynting1 bernilai nol, sedangkan $nabla ps$ adalah riil, selain itu

  $ angle.l w_e angle.r = 1/4 cal(Re)[epsilon_0 bup(E) dot dash(bup(E))] $ <elintencity>

  adalah kerapatan energi listrik rata-rata, sehingga

  $
    angle.l bup(S) angle.r &= 2/(c mu_0 epsilon_0) angle.l w_e angle.r nabla ps \
    &= 2c angle.l w_e angle.r nabla ps
  $ <finalpoynting>
]

\

Persamaan @finalpoynting menunjukkan bahwa vektor Poynting $bup(S)$, sebagai vektor yang menunjukkan arah energi dari gelombang elektromagnetik, memiliki arah yang sama dengan momentum optik $nabla phi.alt (bup(r))$. Implikasi dari hal ini adalah bahwa propagasi gelombang sebagai aliran energi dapat direpresentasikan sebagai garis-garis sinar. Hal inilah yang mendasari GO sebagai analisis propagasi gelombang elektromagnetik dalam bentuk representasi sinar-sinar.

== Atenuasi Ruang

=== Daya dan Intensitas Gelombang Elektromagnetik

Jika suatu vektor unit $hat(bup(s)) $ dapat didefinisikan sebagai $(nabla phi.alt(bup(r)))/(norm(nabla phi.alt(bup(r)))) = (nabla phi.alt(bup(r)))/n$, maka persamaan @finalpoynting dapat ditulis sebagai

$ angle.l bup(S) angle.r = 2 c angle.l w_e angle.r hat(bup(s)) $

sehingga intensitas gelombang elektromagnetik $I$ dapat didefinisikan sebagai nilai mutlak dari vektor Poynting rata-rata@born_principles_1999 dan dapat ditulis sebagai

$ I = abs(angle.l bup(S) angle.r) = 2 c angle.l w_e angle.r $ <poyntintent>

\

Sementara itu, daya total $P$ yang dipancarkan oleh suatu sumber dapat didefinisikan sebagai

$ P = integral bup(I)(bup(r)) dot d bup(A) $ <power>

di mana $bup(I)(bup(r))$ adalah fungsi vektor yang menjelaskan arah dan besaran intensitas dan $bup(A)$ suatu permukaan tertutup yang mencakup suatu sumber. Pada gelombang planar, persamaan ini tidak relevan karena sumber gelombang berupa bidang tak hingga sehingga P hanya berlaku pada suatu permukaan $cal(A) in bup(A)$. Tetapi, pada suatu sumber non-planar seperti sumber titik, gelombang yang dihasilkan adalah gelombang bulat (_spherical_). Pada bentuk gelombang ini, persamaan @power menjadi

#[
  #set math.equation(number-align: bottom)
  $
    P &= I dot 4 pi r^2 \
    I &= P/(4 pi r^2)
  $ <sphintent>
]

#figure(
  image("assets/invsqr.png", width: 60%),
  caption: [Ilustrasi hukum kuadrat terbalik]
) <invsqr>

di mana $I$ dan $r$ memiliki hubungan kuadrat terbalik, seperti yang diilustrasikan oleh @invsqr di mana pada jumlah fluks yang tetap akan melewati permukaan dengan rasio $n^2$ untuk setiap perubahan jarak $n$ menjauhi sumber radiasi.

Kemudian, karena $c dash(c) = abs(c)^2$ dengan $c in CC$, maka persaamaan @elintencity juga dapat ditulis sebagai

$
  angle.l w_e angle.r = 1/4 epsilon abs(bup(E))^2
$

sehingga dari persamaan tersebut, persamaan @finalpoynting, persaamaan @poyntintent, dan persamaan @sphintent dapat dilihat bahwa

$
  abs(bup(E)) prop 1/r
$ <epropir>

\

#figure(
  image("assets/spherical.jpg", width: 60%),
  caption: [Muka gelombang dan sinar pada gelombang lingkaran],
) <spherical>

@spherical menunjukkan muka gelombang sebuah gelombang lingkaran (irisan 2 dimensi dari gelombang bulat), di mana muka gelombang $sigma_0$ pada waktu $t$ memiliki jari-jari $rho_0$ dan kemudian $rho_0 + Delta rho$ setelah $Delta t$. Karena $P$ konstan, maka

$ (abs(bup(E)(rho_0)))/(abs(bup(E)(rho_0 + Delta rho))) = (rho_0+Delta rho)/rho_0 $ <intencratio>

dan jika perhitungan dimulai dari sumber ($rho_0 = 0$) dan permukaan yang berjarak $r$ dari sumber, maka

$ abs(bup(E)(rho_0 + Delta rho)) = 1/r abs(bup(E)(rho_0)) $

sehingga $1/r$ adalah koefisien atenuasi ruang $A(r)$ pada jarak $r$ dari sumber, sesuai dengan persamaan @epropir.

=== Atenuasi Ruang Secara Umum

Suku imajiner dari persamaan @lkexpanded akan memberikan

#[
  #set math.equation(number-align: bottom)
  #let en = [$tilde(bup(E))_i (bup(r))$]
  #let pr = [$phi.alt(bup(r))$]

  $
    en nabla^2 pr &= -2 (nabla pr dot nabla) en
  $
  
]

#figure(
  image("assets/gc.jpg", width: 80%),
  caption: [Dua permukaan gelombang sebagai lengkungan Gauss],
) <gausscurv>

== Refleksi dan Transmisi

=== Kondisi Antarmuka Pada Persamaan-Persamaan Maxwell

#figure(
  [
    #set math.equation(numbering: none)
    #cetz.canvas({
      import cetz.draw: *
        line((-3, -1), (3, -1), mark: (start: "stealth", end: "stealth"))
        content((), $ z $, anchor: "west")
        line((0, -3), (0, 3), mark: (start: "stealth", end: "stealth"))
        content((), $ x $, anchor: "south")

        circle((0,-1), radius: 0.15)
        circle((0,-1), radius: 0.05, fill: black)
        content((0.25, -1.25), $ y $)

        line((-0.5,2),(0.5,2))
        line((-0.5,0),(0.5,0))
        line((-0.5,2),(-0.5,0))
        line((0.5,2),(0.5,0))

        mark((-0.5,1), (-0.5,-2), symbol: "triangle", fill: black)
        mark((0.5,1), (0.5, 2), symbol: "triangle", fill: black)
        content((0.25, 2.25), $ delta $)
        content((0.75, 1), $ cal(l) $)

        content((-2, -2), $ n_1 $)
        content((2, -2), $ n_2 $)
    })
  ],
  caption: [Ilustrasi sebuah segmen pada perbatasan medium]
) <interface>

Misakan $Sigma$ adalah sebuah persegi dalam sebuah _loop_ disepanjang batas medium (bidang $x y$) dengan panjang sejajar batas $cal(l)$ dan lebar $delta$ seperti pada @interface, persamaan Faraday @faradarorig menjelaskan hubungan medan magnet dan listrik yang berada di dalam _loop_ tersebut.

$ integral.cont_(diff Sigma) bup(E) dot d bup(cal(l)) = - upright(d) / (upright(d) t) integral.double_Sigma bup(B) dot d bup(S) $ <faradarorig>

\

Jika $delta$ mendekati 0, maka luas $S$ juga mendekati 0 sehingga sisi kanan persamaan tersebut menjadi 0:

#[
  #set math.equation(number-align: bottom)
  $
    lim_(delta arrow 0) integral.cont_(diff Sigma) bup(E) dot d bup(cal(l)) &= lim_(delta arrow 0) - upright(d) / (upright(d) t) integral.double_Sigma bup(B) dot d bup(S) \
    integral.cont_(diff Sigma) bup(E) dot d bup(cal(l)) &= 0
  $
]

dan karena segmen membagi ruang pada medium 1 dan medium 2 serta medan listrik yang terdapat di masing-masing potongan, maka

$ integral_(n_1) bup(E) dot d bup(cal(l)) + integral_(n_2) bup(E) dot d bup(cal(l)) = 0 $

Karena $cal(l)$ dimasing-masing sisi medium memiliki arah yang berbeda yang cukup kecil sehingga $bup(E)$ konstan, maka

$ (bup(E)_2 - bup(E)_1) dot bup(t) = 0 $

dengan $bup(t)$ vektor tangensial dari medium, yang berada pada bidang antarmuka. Karena vektor $bup(t)$ dapat  berupa vektor mana saja pada bidang antarmuka, maka persamaan tersebut juga dapat ditulis sebagai

$ bup(n) times (bup(E)_2 - bup(E)_1) = 0 $ <intcond>

dengan $bup(n)$ vektor normal dari bidang antarmuka.

=== Koefisien Refleksi dan Transmisi

#[
  #let un(z) = [$hat(bup(#z))$]

  #figure(
    image("assets/reftran.jpg", width: 60%),
    caption: [Refleksi dan transmisi gelombang elektromagnetik $(bup(E)_i, bup(H)_i)$ pada sebuah perbatasan medium pada bidang $x z$]
  ) <reftrans>

  Medan listrik dari sebuah gelombang elektromagnetik datang ke sebuah perbatasan medium yang bergerak pada bidang $x z$ seperti pada @reftrans dapat diformulasikan sebagai

  $
    bup(E)_i = un(y)E_0 e^(-j bup(k)_i dot bup(r))
  $ <harm2>

  di mana $E_0 e^(-j bup(k)_i dot r) : RR^3 arrow RR$ sedangkan medan akibat refleksi $bup(E)_r$ dan transmisi $bup(E)_t$ pada perbatasan medium adalah

  $
    bup(E)_r = un(y) Gamma e^(-j bup(k)_r dot bup(r))
  $ <refl1>

  $
    bup(E)_r = un(y) T e^(-j bup(k)_t dot bup(r))
  $ <trans1>

  di mana $Gamma$ dan $T$ adalah koefisien refleksi dan transmisi.

  Dengan $un(z)$ sebagai normal dari antarmuka medium, maka dari persamaan @intcond, didapatkan

  #[
    #set math.equation(number-align: bottom)
    $
      un(z) times (bup(E)_i + bup(E)_r) &= un(z) times bup(E)_t |_(z=0) \
      un(z) times (un(y)E_0 e^(-j bup(k)_i dot r) + un(y) R e^(-j bup(k)_r dot bup(r))) &= un(z) times un(y) T e^(-j bup(k)_t dot bup(r)) |_(z=0) \
    $ <continuity>
  ]

  \

  Selain itu, kontinuitas juga mengharuskan gelombang memiliki fasa yang sama pada titik refleksi, sehingga

  $
    bup(k)_i dot bup(r) = bup(k)_r dot bup(r) = bup(k)_t dot bup(r) |_(z=0)
  $ <continuity1>

  \

  Karena $bup(k) = abs(bup(k))hat(bup(k))$, sedangkan $abs(bup(k))$ adalah intrinsik untuk setiap medium, sehingga @continuity1 menjadi

  $ k_1 sin theta_i = k_1 sin theta_r = k_2 sin theta_t $

  yang menunjukkan hukum refleksi

  $ sin theta_i = sin theta_r $

  dan hukum Snellius

  $ n_1 sin theta_i = n_2 sin theta_t $

  di mana $k_n = n k_0$, $k_0$ angka gelombang pada vakum.

  \

  Selain itu, persamaan @continuity1 menunjukkan bahwa persamaan @continuity dapat disederhanakan menjadi

  $ 1 + Gamma = T $ <refltrans>

  yang menunjukkan hubungan koefisien refleksi dan transmisi.

  === Persamaan Fresnel

  Jika kembali diperhatikan persamaan gelombang listrik harmonik dengan sembarang arah osilasi

  $ bup(E) = E_0 e^(-j bup(k) dot bup(r)) $

  dan kemudian diaplikasikan ke persamaan @fourfar, akan didapatkan

  #[
    #set math.equation(number-align: bottom)
    $
       -j omega bup(B) &= nabla times bup(E) \
       &= nabla times E_0 e^(-j bup(k) dot bup(r)) \
       &= -j bup(k) times E_0 e^(-j bup(k) dot bup(r)) \
       &= -j bup(k) times bup(E) \
       bup(B) &= (bup(k) times bup(E)) / omega
    $

    karena $bup(k) = abs(bup(k)) hat(bup(k)) = omega/v bup(hat(k)) = omega sqrt(mu epsilon) hat(bup(k))$, maka

    $
      bup(B) &=(omega sqrt(mu epsilon) hat(bup(k)) times bup(E))/omega \
      &= sqrt(mu epsilon) hat(bup(k)) times bup(E)
    $

    atau juga dapat ditulis dalam medan magnet $bup(H) = bup(B) slash mu$:

    $ bup(H) = (hat(bup(k)) times bup(E)) / eta $

    di mana $eta = sqrt(mu/epsilon)$ impedansi medium.

    Mengaplikasikan persamaan tersebut ke persamaan @harm2 hingga @trans1 memberikan

    $ bup(H)_i = E_0/eta_1 bup(k)_i times e^(-j bup(k)_i dot bup(r))  $ <magr1>
    $ bup(H)_i = (Gamma E_0)/eta_1 bup(k)_r times e^(-j bup(k)_r dot bup(r))  $
    $ bup(H)_i = (T E_0)/eta_1 bup(k)_t times e^(-j bup(k)_t dot bup(r))  $ <magr3>
    
    \

    Lalu seperti halnya medan listrik, kontinuitas medan magnet dapat ditentukan dengan

    $ un(z) times (bup(H)_i + bup(H)_r) &= un(z) times bup(H)_t |_(z=0) $

    dan dari @reftrans dapat diuraikan masing-masing vektor gelombang menjadi komponen-komponen unitnya

    $ un(k)_i &= un(x) sin theta_i + un(z) cos theta_i $
    $ un(k)_r &= un(x) sin theta_r - un(z) cos theta_r $
    $ un(k)_t &= un(x) sin theta_t + un(z) cos theta_t $

    sehingga persamaan @magr1 hingga @magr3 menjadi

    $ 1/eta_1 (-cos theta_i e^(-j bup(k)_i dot bup(r))+Gamma cos theta_r e^(-j bup(k)_r dot bup(r)))=T/eta_2(-cos theta_t e^(-j bup(k)_t dot bup(r))) $

    \

    Karena $theta_i = theta_r$ dan pada $z=0$, fasa tiap suku adalah sama, maka

    $ 1/eta_1 (Gamma - 1) cos theta_i = - T/theta_2 cos theta_t $

    \

    Dengan persamaan @refltrans, maka didapatkan koefisien refleksi dan transmisi dengan medan listrik tegak lurus bidang refleksi sebagai persamaan Fresnel berupa

    $
      Gamma_perp = (eta_2 cos theta_i - eta_1 cos theta_t)/(eta_2 cos theta_i + eta_1 cos theta_t)
    $ <gammafin>

    dan

    $
      T_perp = (2 eta_2 cos theta_i)/(eta_2 cos theta_i + eta_1 cos theta_t)
    $ <tfin>

    \

    Dengan cara yang sama, tetapi dengan memutar polarisasi $bup(E)$ dan $bup(H)$ sehingga $bup(E)$ pada bidang refleksi dan $bup(B)$ tegak lurus, didapatkan

    $
      Gamma_parallel = (eta_2 cos theta_t - eta_1 cos theta_i)/(eta_2 cos theta_t + eta_1 cos theta_i)
    $

    dan

    $
      T_parallel = (2 eta_2 cos theta_i)/(eta_2 cos theta_t + eta_1 cos theta_i)
    $
  ]
]

== Difraksi

Difraksi merupakan fenomena gelombang berupa terjadinya penyebaran atau pembelokan muka gelombang di sekitar suatu penghalang. Dalam fisika klasik, hal ini dapat dijelaskan sebagai implikasi dari prinsip Huygens-Fresnel, dimana setiap titik pada muka gelombang merupakan sumber gelombang bulat sekunder yang kemudian berinterferensi satu sama lainnya membentuk muka gelombang sebenarnya, seperti yang diilustrasikan pada @huygenswf. Oleh karena itu, difraksi mengakibatkan adanya medan propagasi pada ruang bayangan yang ditimbulkan pada ruang NLOS oleh suatu benda yang berada di jalur propagasi gelombang.

$
  #box
$

#figure(
  image("assets/huygens.png", width: 60%),
  caption: [Pembentukan muka gelombang berdasarkan prinsip Huygens-Fresnel]
) <huygenswf>

Dapat dicermati bahwa difraksi sebagai fenomena gelombang menjadi batasan dari metode GO yang mengabaikan sifat gelombang dan menggambarkannya sebagai sinar-sinar diskrit sebagai jalur propagasi muka gelombang. @shadow mengilustrasikan adanya batas bayangan (_shadow boundary_) ketika sinar mengenai suatu objek penghalang pada titik difraksi. Batas bayangan sendiri berupa diskontinuitas antara ruang LOS dan ruang bayangan yang mana pada GO, tidak terdapat sinar yang berpropagasi ke ruang tersebut. Hal ini terjadi karena formulasi GO tidak memberikan mekanisme yang menjelaskan perilaku gelombang dari sinar di sekitar titik-titik difraksi tersebut.

#figure(
  image("assets/shadow.jpg", width: 80%),
  caption: [Difraksi oleh beberapa bentuk penghalang]
) <shadow>

_Geometric theory of diffraction_ (GTD) kemudian dikembangkan oleh J. B. Keller yang mengintegrasikan difraksi kedalam GO. GTD menambahkan jenis sinar baru pada GO disamping sinar refleksi dan transmisi, yaitu sinar difraksi yang berupa solusi atas masalah batas dan sinar-sinar tersebut haruslah memenuni prinsip Fermat@keller_geometrical_1962. Implikasi dari teori tersebut adalah bahwa difraksi dapat dimodelkan seperti refleksi dan transmisi, yaitu dapat dimodelkan dengan sinar dan berupa fenomena lokal yang hanya bergantung pada geometri penghalang dan parameter-parameter gelombang dari sinar datang@balanis_balanis_2024.

== Lintasan Propagasi

$ E_R = E_0 [product_i A_i R_i product_j A_j T_j product_k A_k D_k] (e^(-j k s))/s $

$ E_"total" = sum_i E_R[i] $

== Komputasi Elektromagnetik

=== _Ray Tracing_

=== _Shooting and Bouncing Rays_


$ "RSSI" = 10 log_(10) abs(bup(E)_"total")^2/(1 "mW") space "dBm"  $

#page(flipped: true)[
  #set par(leading: 1em)
  #show figure: set block(breakable: true)
  == Tabel Perbandingan Beberapa Konsep Pemodelan Propagasi Berbasis Sinar

  #figure(
    table(
      columns: (auto, auto, auto, auto, auto, auto),
      align: left,
      table.header([Aspek], [*Ray Tracing*], [*Geometrical Optics*], [*Physical Optics*], [*Geometric Theory \ of Diffraction*], [*Uniform Theory \ of Diffraction*]),

      [Definisi],
      [Istilah umum yang merujuk kepada metode perhitungan jalur gelombang atau pun partikel pada suatu sistem dengan mempertimbangkan berbagai interaksi antara sinar sebagai representasi jalur dengan sistem.],
      [Pemodelan propagasi gelombang elektromagnetik ke dalam bentuk sinar-sinar yang bergerak lurus pada medium homogen. Pemodelan ini dapat menjelaskan refleksi dan refraksi.],
      [Metode pemodelan gelombang elektromagnetik yang juga berbasis kepada representasi sinar dari gelombang elektromagnetik, tetapi juga mempertimbangkan sifat-sifat gelombang dari propagasi elektromagnetik. Dapat memodelkan interferensi, difraksi, dan polarisasi.],
      [Ekstensi dari _Geometrical Optics_ yang menyertakan pemodelan difraksi. GTD memodelkan difraksi dengan mengasumsikan suatu sumber sekunder dari gelombang elektromagnetik pada titik difraksi sudut.],
      [Penyempurnaan terhadap GTD yang gagal mengkalkulasi beberapa sudut pada difraksi. UTD menyertakan prinsip-prinsip PO untuk memodelkan difraksi secara lebih akurat.],

      [Dasar Teori],
      [Tergantung bidang aplikasinya, RT dapat didasarkan kepada _geometrical optics_, _geometrical acoustics_, seismologi, relativitas umum, dan sebagainya],
      [Persamaan eikonal dari persamaan gelombang elektromagnetik dan ekspansi Luneberg-Kline.],
      [Persamaan-persamaan Maxwell, persamaan Gelombang, prinsip Huygens, dsb.],
      [_Geometrical optics_, dengan pemodelan difraksi.],
      [Dengan memasukkan prinsip _physical optics_ ke GTD, maka diskontinuitas pada pemodelan GTD dapat diatasi.]
    ),
    caption: [Perbandingan RT, GO, PO, GTD, UTD],
  )
]
