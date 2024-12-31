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
  #figure(
    table(
      columns: (1fr, 2fr),
      align: (left + horizon, center + horizon, center + horizon),
      table.header([*Hukum*], [*Formulasi* (Bentuk Diferensial)]),
      [Hukum Gauss], [$ nabla dot bup(E) = rho / epsilon_0 $],
      [Hukum Magnet Gauss], [$ nabla dot bup(B) = 0 $],
      [Hukum Induksi Faraday], [$ nabla times bup(E) = - (diff bup(B)) / (diff t) $],
      [Hukum Ampère], [$ nabla times bup(B) = mu_0(bup(J) + epsilon_0 (diff bup(E)) / (diff t)) $],
    ),
    caption: [Persamaan-persamaan Maxwell],
  )
]

Dimana $rho$ adalah kerapatan muatan listrik, $epsilon_0$ permitivitas vakum, $mu_0$ permeabilitas vakum, dan $bup(J)$ kerapatan arus. Selain itu, medan listrik juga dapat direpresentasikan sebagai medan perpindahan listrik $bup(D)$, di mana pada ruang tanpa sumber medan listrik memiliki hubungan

$ bup(D) = epsilon bup(E) $

dan medan magnet juga dapat direpresentasikan melalui medan magnet $bup(H)$, yang pada ruang tanpa sumber medan magnet

$ bup(H) = 1/mu bup(B) $

\

Persamaan-persamaan Maxwell ini dapat dijabarkan dalam bentuk integral maupun diferensial, di mana bentuk integral dari persamaan-persamaan ini dapat menjelaskan perilaku medan listrik dan magnet pada suatu area pada ruang sementara itu bentuk diferensialnya membantu dalam menjelaskan perilaku medan listrik dan medan magnet lokal pada suatu titik.

Pada bab ini, bentuk diferensial dari persamaan-persamaan Maxwell menjadi dasar dari beberapa konsep _ray tracing_ (RT) yang akan dikembangkan.

=== Hukum Gauss

Persamaan pertama dari persamaan Maxwell menggambarkan hukum Gauss terkait perilaku medan listrik di sekitar muatan listrik. Bentuk integral persamaan ini menyatakan bahwa fluks listrik yang melewati suatu permukaan tertutup sebanding dengan muatan yang dilingkupi oleh permukaan tersebut. Sementara itu, bentuk diferensial dari persamaan ini menunjukkan adanya monopol-monopol muatan (positif dan negatif) yang besarnya sebanding dengan kerapatan muatan pada titik-titik monopol tersebut.

#figure(
  image("assets/gaussian.png", width: 60%),
  caption: [Muatan dan fluks listrik yang dihasilkannya melalui suatu permukaan],
) <gaussimg>

@gaussimg mengilustrasikan muatan yang menghasilkan fluks listrik pada kondisi terlingkupi (kiri) dan tidak terlingkupi (kanan). Menurut hukum Gauss, fluks listrik total pada kondisi pertama sebanding dengan muatan, sedangkan fluks listrik total pada permukaan kedua adalah nol karena total fluks yang keluar dan masuk pada permukaan adalah sama.


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

#figure(
  image("assets/ampereimg.png", width: 80%),
  caption: [Pola pada serbuk besi di sekitar kawat yang dialiri arus listrik],
) <ampereimg>

Persamaan terakhir dari persamaan Maxwell berkorelasi dengan hukum Ampère yang menunjukkan bahwa perubahan medan listrik juga dapat menimbulkan medan magnet. Bentuk integral dari persamaan ini menunjukkan bahwa fluks magnet melingkar akar terbentuk pada suatu lingkaran tertutup (_loop_) ketika pada permukaan yang dilingkupi oleh lingkaran tertutup tersebut dilewati oleh muatan listrik dan/atau terjadi perubahan medan magnet.
Bentuk diferensial dari persamaan ini sementara itu menunjukkan bahwa ketika di suatu titik terdapat kerapatan arus dan/atau perubahan medan listrik, maka akan timbul medan magnet melingkar di titik tersebut. @ampereimg menunjukkan efek dari hukum ini di mana ketika arus melewati sebuah kawat, maka akan terbentuk medan magnet melingkar di sekitarnya.


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

Persamaan-persamaan @gaussvacuum sampai @binvacuum juga dapat dijabarkan ke dalam domain frekuensi dengan bantuan transformasi Fourier temporal $cal(F)[bup(F)(bup(r), t)] = tilde(bup(F))(bup(r), omega)$:

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
  $ 

  \

  Untuk $omega$ yang sangat besar, maka hanya orda $i = 0$ yang signifikan sehingga persamaan tersebut menjadi

  #let e0 = [$tilde(bup(E))_0 (bup(r))$]

  $
    ex [(nabla^2 e0 + nr k^2 e0 - k^2 e0 (nabla phi.alt(bup(r)))^2) \
    - j(k e0 nabla^2 phi.alt(bup(r)) + 2k (nabla phi.alt(bup(r)) dot nabla) e0)] &= 0
  $ <lkexpanded>

  \

  Agar persamaan @lkexpanded benar, maka suku riil dan imajiner dari persamaan tersebut harus bernilai 0. Mengevaluasi bagian riil didapatkan

  $
    nabla^2 e0 + nr k^2 e0 - k^2 e0 (nabla phi.alt(bup(r)))^2 &= 0 \
    k^2 e0 (nabla phi.alt(bup(r)))^2 &= nabla^2 e0 + nr k^2 e0 \
    (nabla phi.alt(bup(r)))^2 &= (nabla^2 e0)/(k^2 e0) + nr \
  $

  atau dapat disederhanakan menjadi

  $
    norm(nabla phi.alt(bup(r))) = n(bup(r))
  $ <eikonal>

  karena pada frekuensi yang sangat besar, $n^2(bup(r)) >> abs((nabla^2 e0)/(k^2 e0))$.
]

\

#figure(
  image("assets/wavefront.png", width: 60%),
  caption: [Sinar (merah) dan muka gelombang (hijau) pada sinar 2 dimensi],
) <wavefront>

Persamaan @eikonal merupakan persamaan eikonal dari gelombang di medan $bup(E)$. Gradien eikonal $nabla phi.alt(bup(r))$ juga disebut sebagai momentum optik $bup(p)(bup(r))$ pada optika Lagrangian dan berupa vektor di suatu titik $bup(P)$ pada sinar yang memiliki arah yang sama dengan sinar pada titik tersebut@chaves_introduction_2017. Sementara itu, eikonal $phi.alt(bup(r))$ juga disebut sebagai panjang jalur optik (_optical path length_/OPL) $sigma$.
Jika titik-titik pada sinar-sinar cahaya yang memiliki nilai $sigma$ yang sama disambungkan, akan didapatkan permukaan yang menggambarkan muka gelombang. Dengan kata lain, muka gelombang adalah permukaan ketinggian (_level surface_) dari dari fungsi gelombang. @wavefront mengilustrasikan garis hijau yang menyambungkan titik-titik pada sinar (_light rays_) yang memiliki nilai $sigma$ yang sama, yang membentuk muka gelombang (_wavefronts_).


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
  $ <pseoiszero>

  $
    nabla ps dot eo(B) = 0
  $ 

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

Persamaan @finalpoynting menunjukkan bahwa vektor Poynting $bup(S)$, sebagai vektor yang menunjukkan arah energi dari gelombang elektromagnetik, memiliki arah yang sama dengan eikonal $nabla phi.alt (bup(r))$. Implikasi dari hal ini adalah bahwa propagasi gelombang sebagai aliran energi dapat direpresentasikan sebagai garis-garis sinar. Hal inilah yang mendasari GO sebagai analisis propagasi gelombang elektromagnetik dalam bentuk representasi sinar-sinar.

== Atenuasi Ruang

=== Daya dan Intensitas Gelombang Elektromagnetik <sphint>

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

$ abs(bup(E)(rho_0 + Delta rho)) = 1/r abs(bup(E)(rho_0)) $ <atten>

sehingga $1/r$ adalah koefisien atenuasi ruang $A(r)$ pada jarak $r$ dari sumber, sesuai dengan persamaan @epropir.

=== Atenuasi Ruang Secara Umum

Suku imajiner dari persamaan @lkexpanded akan memberikan

#[
  #set math.equation(number-align: bottom)
  #let e0 = [$tilde(bup(E))_0 (bup(r))$]
  #let er(r) = [$tilde(bup(E))_0 (#r)$]
  #let pr = [$phi.alt(bup(r))$]

  #figure(
    image("assets/gc.jpg", width: 80%),
    caption: [Dua permukaan gelombang sebagai lengkungan Gauss],
  ) <gausscurv>

  $
    e0 nabla^2 pr = -2 (nabla pr dot nabla) e0
  $
  
  \

  $(nabla pr dot nabla)e0$ merupakan aplikasi suatu operator diferensial (turunan direksional) yang menunjukkan turunan $e0$ pada arah $nabla pr$. Karena arah propagasi $e0$ adalah $nabla pr$ itu sendiri, maka operasi tersebut dapat juga ditulis sebagai $norm(nabla pr)d/(d s) e0$ dengan $s$ jalur propagasi, sehingga didapatkan

  $
    e0 nabla^2 pr &= -2 norm(pr) d / (d s) e0 \
    (d e0) / e0 &= - (nabla^2 pr) / (2 norm(pr))d s
  $

  dan jika persamaan tersebut diintegrasikan diantara dua posisi berbeda pada ruang, $rho_0$ dan $rho_0 + Delta$, maka

  $
    integral^er(rho_0 + Delta rho)_er(rho_0) (d e0) / e0 &= - integral^(rho_0 + Delta rho)_(rho_0) (nabla^2 pr) / (2 norm(pr)) d s \
    ln er(rho_0 + Delta rho) - ln er(rho_0) &= - integral^(rho_0 + Delta rho)_(rho_0) (nabla^2 pr) / (2 norm(pr)) d s \
    ln er(rho_0 + Delta rho) / er(rho_0) &= - integral^(rho_0 + Delta rho)_(rho_0) (nabla^2 pr) / (2 norm(pr)) d s \
    er(rho_0 + Delta rho) / er(rho_0) &= exp(- integral^(rho_0 + Delta rho)_(rho_0) (nabla^2 pr) / (2 norm(pr)) d s) \
    er(rho_0 + Delta rho) &= er(rho_0) exp(- integral^(rho_0 + Delta rho)_(rho_0) (nabla^2 pr) / (2 norm(pr)) d s) \
  $ <direxpand>

  atau juga dapat ditulis

  $
    tilde(bup(E))_0^2 (rho_0 + Delta rho) = tilde(bup(E))_0^2 (rho_0) exp(- integral^(rho_0 + Delta rho)_(rho_0) (nabla^2 pr) / (norm(pr)) d s)
  $ <direxp>

  \

  Muka gelombang dapat diinterpretasikan sebagai lengkungan Gauss, yaitu sebuah permukaan yang terbentuk dari dua lengkungan utama. @gausscurv mengilustrasikan dua muka gelombang $cal(A)$ dan proyeksinya $cal(B)$ pada jarak $s$, masing-masing memiliki kelengkungan
  
  
  $  K_cal(A) = 1/(rho_1 rho_2) $
  $  K_cal(B) &= 1/((rho_1 + s)(rho_2 + 2)) $

  \

  Misalkan unit vektor $hat(bup(t)) = (nabla pr) / norm(nabla pr) = (nabla pr) / n(bup(r))$ merupakan vektor unit yang menunjukkan arah propagasi pada suatu titik di muka gelombang, serta vektor $bup(u)$ dan $bup(v)$ yang menunjukkan pergerakan di sepanjang masing-masing kelengkungan muka gelombang, maka divergensi dari $hat(bup(t))$ dapat dijabarkan sebagai penjumlahan dari turunan direksional setiap basis sebarang non-ortonormal yang menyusunnya, dalam hal ini, digunakan $(bup(t), bup(u), bup(v))$, sehingga

  $
    nabla dot hat(bup(t)) = nabla_bup(t) dot hat(bup(t)) + nabla_bup(u) dot hat(bup(t)) + nabla_bup(v) dot hat(bup(t)) space "dimana" space nabla_bup(g) dot bup(F) = hat(bup(g)) dot (partial bup(F))/(partial bup(g))
  $

  \

  Turunan direksional vektor unit terhadap arahnya sendiri adalah $0$ $(hat(bup(t)) dot hat(bup(t)) = 1 arrow.double.l.r partial_bup(t)(hat(bup(t)) dot hat(bup(t))) = 0 arrow.double.l.r 2hat(bup(t)) dot partial_bup(t) hat(bup(t)) = 0 arrow.double.l.r hat(bup(t)) dot partial_bup(t) hat(bup(t)) = 0)$. Selain itu, turunan direksional terhadap $bup(u)$ dan $bup(v)$ terkait dengan perubahan kelengkungan permukaan Gauss terhadap masing-masing kelengkungan utama dan $sigma$ perubahan terhadap $s$, sehingga 

  $
    nabla dot hat(bup(t)) = 1/(rho_1 + sigma) + 1/(rho_2 + sigma)
  $

  atau karena $hat(bup(t)) = (nabla pr) / norm(nabla pr)$, juga dapat ditulis

  $
    nabla dot (nabla pr) / norm(nabla pr) = (nabla^2 pr)/norm(nabla pr) &= 1/(rho_1 + sigma) + 1/(rho_2 + sigma) \
  $
  
  yang mana sisi kiri dari persamaan dapat dibuat sama dengan suku eksponensial dari persamaan @direxp dengan melakukan integrasi, negasi, dan eksponensiasi:

  $
    (nabla^2 pr)/norm(nabla pr) &= 1/(rho_1 + sigma) + 1/(rho_2 + sigma) \
    integral^s_0 (nabla^2 pr)/norm(nabla pr) d sigma &=  integral ^s_0 (d sigma)/(rho_1 + sigma) + integral^s_0 (d sigma)/(rho_2 + sigma) \
    -integral^s_0 (nabla^2 pr)/norm(nabla pr) d sigma &=  -integral^s_0 (d sigma)/(rho_1 + sigma) - integral^s_0 (d sigma)/(rho_2 + sigma) \
    exp(-integral^s_0 (nabla^2 pr)/norm(nabla pr) d sigma) &=  exp(-integral ^s_0 (d sigma)/(rho_1 + sigma)) exp(- integral^s_0 (d sigma)/(rho_2 + sigma)) \
  $

  dengan asumsi muka gelombang $cal(A)$ berada pada $s = 0$. Kemudian, dengan melakukan integrasi pada sisi kanan persamaan, didapatkan

  $
    exp(-integral^s_0 (nabla^2 pr)/norm(nabla pr) d s) &=  exp(-integral ^s_0 (d sigma)/(rho_1 + s)) exp(- integral^s_0 (d sigma)/(rho_2 + sigma)) \
    &= exp(- ln (rho_1 + sigma) bar^s_0) exp(- ln(rho_2 + sigma) |^s_0) \
    &= (rho_1/(rho_1 + s))(rho_2/(rho_2 + s)) \
    &= (rho_1 rho_2)/((rho_1 + s)(rho_2 + s)) \
  $

  sehingga persaamaan @direxp dapat ditulis menjadi

  $
    tilde(bup(E))_0^2 (s) &= tilde(bup(E))_0^2 (0) (rho_1 rho_2)/((rho_1 + s)(rho_2 + s)) \
    tilde(bup(E))_0 (s) &= tilde(bup(E))_0 (0) sqrt( (rho_1 rho_2)/((rho_1 + s)(rho_2 + s))) \
  $

  yang menunjukkan atenuasi ruang pada jarak $s$ dari sumber. Pada sumber gelombang bulat, maka $rho_1 = rho_2 = r$, sehingga

  $ 
    A(s) &= sqrt( (r^2)/((r + s)^2)) \
    &= r/(r + s) \
    &= 1/s quad (r << s)
  $

  yang senada dengan persamaan @atten dari penurunan atenuasi ruang via vektor Poynting pada subsubbab @sphint di atas.
]

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

#[
  #let pa = [$phi.alt$]

  #figure(
    image("assets/huygens.png", width: 60%),
    caption: [Pembentukan muka gelombang berdasarkan prinsip Huygens-Fresnel]
  ) <huygenswf>

  Difraksi merupakan fenomena gelombang berupa terjadinya penyebaran atau pembelokan muka gelombang di sekitar suatu penghalang. Dalam fisika klasik, hal ini dapat dijelaskan sebagai implikasi dari prinsip Huygens-Fresnel, dimana setiap titik pada muka gelombang merupakan sumber gelombang bulat sekunder yang kemudian berinterferensi satu sama lainnya membentuk muka gelombang sebenarnya, seperti yang diilustrasikan pada @huygenswf. Oleh karena itu, difraksi mengakibatkan adanya medan propagasi pada ruang bayangan yang ditimbulkan pada ruang NLOS oleh suatu benda yang berada di jalur propagasi gelombang.


  #figure(
    image("assets/shadow.jpg", width: 80%),
    caption: [Difraksi oleh beberapa bentuk penghalang]
  ) <shadow>

  Dapat dicermati bahwa difraksi sebagai fenomena gelombang menjadi batasan dari metode GO yang mengabaikan sifat gelombang dan menggambarkannya sebagai sinar-sinar diskrit sebagai jalur propagasi muka gelombang. @shadow mengilustrasikan adanya batas bayangan (_shadow boundary_) ketika sinar mengenai suatu objek penghalang pada titik difraksi. Batas bayangan sendiri berupa diskontinuitas antara ruang LOS dan ruang bayangan yang mana pada GO, tidak terdapat sinar yang berpropagasi ke ruang tersebut. Hal ini terjadi karena formulasi GO tidak memberikan mekanisme yang menjelaskan perilaku gelombang dari sinar di sekitar titik-titik difraksi tersebut.


  === _Geometric Theory of Diffraction_

  _Geometric theory of diffraction_ (GTD) kemudian dikembangkan oleh J. B. Keller yang mengintegrasikan difraksi kedalam GO. GTD menambahkan jenis sinar baru pada GO disamping sinar refleksi dan transmisi, yaitu sinar difraksi yang berupa solusi atas masalah batas dan sinar-sinar tersebut haruslah memenuni prinsip Fermat@keller_geometrical_1962. Implikasi dari teori tersebut adalah bahwa difraksi dapat dimodelkan seperti refleksi dan transmisi, yaitu fenomena yang dapat dimodelkan dengan sinar dan berupa fenomena lokal yang hanya bergantung pada geometri penghalang dan parameter-parameter gelombang dari sinar datang@balanis_balanis_2024.

  GTD didasarkan kepada usaha mengatasi keberadaan diskontinuitas yang terjadi ketika sebuah sinar mengenai sebuah penghalang yang seharusnya tidak terjadi karena gelombang, yang direpresentasikan oleh sinar itu sendiri, tidak menghasilkan diskontinuitas ketika berpropagasi melewati suatu objek penghalang.

  #figure(
    image("assets/diffr.jpg", width: 60%),
    caption: []
  ) <difbound>

  @difbound mengilustrasikan tiga wilayah yang terbentuk akibat diskontinuitas oleh adanya penghalang berbentuk sudut. Dengan menggunakan GO saja, maka wilayah I berada pada LOS dari sumber $bup(S)$ sehingga dapat menerima sinar langsung dan refleksi, wilayah II yang masih terdapat pada LOS sumber hanya memungkinkan sinar langsung, dan tidak terdapat sinar pada wilayah III.

  Tidak adanya suatu jenis sinar pada wilayah yang berbatasan memberikan diskontinuitas, yang pertama berupa batas bayangan pantul (_reflection shadow bounday_/RSB) antara wilayah I dan II, serta batas bayangan datang (_incident shadow boundary_/ISB) antara wilayah II dan III. Memperkenalkan sinar difraksi untuk mengeliminasi diskontinuitas tersebut karena sinar difraksi menyebar ke segala arah dari titik difraksi, memberikan suatu komponen medan kontinyu pada medan total. Misal $bup(E)_"total"$ adalah medan listrik yang berasal dari sumber, maka


  $ 
    bup(E)_"total" = cases(
      bup(E)_r + bup(E)_i + bup(E)_d quad &0 < pa < pi - pa' &"(I)",
      bup(E)_i + bup(E)_d &pi - pa' < pa < pi + pa' quad &"(II)",
      bup(E)_d &pi + pa' < pa < n pi &"(III)"
    )
  $ <diftot>

  dimana $bup(E)_r$ adalah medan listrik refraksi, $bup(E)_i$ medan listrik LOS, dan $bup(E)_d$ medan listrik difraksi.

  Seperti halnya sinar refleksi dan transmisi, kekuatan medan yang direpresentasikan oleh suatu sinar difraksi juga dijelaskan oleh suatu koefisien, yaitu koefisien refraksi $D$. Penelitian Keller terhadap GTD memberikan

  $ 
    D_(s,h)(pa,pa') &= (e^(-j pi / 4))/(n sqrt(2 pi k)) sin(pi/n) \ 
    &times [1/(cos(pi/n)-cos((pa - pa')/n)) minus.plus 1/(cos(pi/n)+cos((pa - pa')/n))]
  $ <kellerd>

  dimana terdapat dua jenis difraksi, yaitu $s$ yang terjadi ketika gelombang yang datang memiliki polarisasi TM, dan $h$ sebaliknya.

  === _Uniform (Geometric) Theory of Diffraction_

  Meskipun GTD mampu mengintegrasikan difraksi pada GO dengan memperkenalkan sinar-sinar difraksi yang bersumber dari titik difraksi dan membuat medan-medan pada ketiga wilayah difraksi kontinyu, dari persaamaan koefisien difraksi @kellerd dapat dilihat adanya singularitas ketika $pa + pa' = pi$ dan $pa - pa' = pi$ dimana $D$ akan bernilai tak hingga. Dapat dilihat bahwa masing-masing kondisi tersebut terjadi pada ISB dan RSB, sehingga meskipun GTD terlihat dapat mengatasi diskontinuitas pada medan-medan disekitar objek, masih terdapat diskontinuitas pada perbatasan wilayah.

  Untuk itu, R. G. Kouyoumjian dan P. H. Pathak mengembangkan GTD menjadi _uniform (geometric) theory of diffraction_ (UTD) dengan melihat wilayah-wilayah bayangan disekitar objek sebagai wilayah transisi medan antara ISB dan ISR@balanis_balanis_2024, yang dilakukan dengan cara memperkenalkan suatu fungsi transisi $F$ pada GTD@paknys_applied_2016, dan didapatkan koefisien difraksi

  $
    D_(s,h) &= (-e^(-j pi / 4))/(2n sqrt(2 pi k)) \
    &times [cot((pi + (pa - pa'))/2n) F(k L a^+(pa - pa')) \
    &+ cot((pi - (pa - pa'))/2n) F(k L a^-(pa - pa')) \
    &minus.plus {cot((pi + (pa + pa'))/2n) F(k L a^+(pa + pa')) \
    &+ cot((pi - (pa + pa'))/2n)F(k L a^-(pa + pa'))}]
  $

  dimana parameter jarak $L$ adalah

  $
    L = cases(
      rho &"gelombang planar",
      (rho rho')/(rho + rho') &"gelombang silindris"
    )
  $

  kemudian

  $
    a^plus.minus(theta) = 2 cos((2 n pi N^plus.minus - theta)/2)
  $

  dengan $N^plus.minus$ adalah bilangan bulat yang memenuhi

  $ 2 pi n N^+ - theta = pi "dan" 2 pi n N^- - theta = - pi $

  dan fungsi transisi $F$ merupakan fungsi transisi Fresnel berupa

  $
    F(x) = 2 j sqrt(x) e^(j x) integral^infinity_sqrt(x) e^(j t^2) d t
  $

  === Difraksi Oleh Objek Dielektrik

  Satu hal yang perlu diperhatikan dari GTD dan UTD adalah bahwa digunakan asumsi bahwa materi dari objek penghalang adalah PEC sehingga menyederhanakan banyak parameter dalam interaksi antara medan dan materi, terutama dalam hal lokalitas dimana pada frekuensi tinggi dan objek PEC, refleksi, transmisi, dan bahkan difraksi adalah fenomena lokal. 
  
  Pada objek dielektrik, interaksi gelombang dengan materi lebih rumit pada batas medium sehingga asumsi lokalitas pada GTD dan UTD tidak berlaku. Pada kondisi demikian, umumnya metode _physical optics_ (PO) dan _physical theory of diffraction_ (PTD) lebih tepat digunakan karena mempertimbangkan distribusi medan disepanjang permukaan objek, atau metode _full-wave_ lainnya.

  #figure(
    image("assets/dieslab.jpg", width: 60%),
    caption: [Difraksi oleh lempeng dielektrik tipis.]
  ) <dieslab>

  Meskipun demikian, UTD masih dapat dikembangkan, dengan berbagai asumsi, untuk memberikan perkiraan terhadap berbagai situasi difraksi. Sebagai contoh, suatu sinar baru yaitu sinar gelombang permukaan bisa diperkenalkan pada situasi objek memiliki impedansi permukaan@rojas_electromagnetic_1988. Contoh lainnya adalah pada kondisi objek penghalang berupa lapisan dielektrik seperti pada @dieslab, sehingga komponen medan transmisi perlu ditambahkan pada persaamaan @diftot sehingga persamaan tersebut menjadi

  $ 
    bup(E)_"total" = cases(
      bup(E)_r + bup(E)_i + bup(E)_d quad &0 < pa < pi - pa' &"(I)",
      bup(E)_i + bup(E)_d &pi - pa' < pa < pi + pa' quad &"(II)",
      bup(E)_d + bup(E)_t &pi + pa' < pa < n pi &"(III)"
    )
  $

  dengan $bup(E)_t$ medan transmisi. Pada kondisi tersebut, koefisien difraksi $D$ dapat diestimasikan sebagai@burnside_high_1983

  $
    D_(s,h)(pa, pa') = [(1-T)D(pa - pa') + Gamma D(pa + pa')]
  $

  dengan koefisien refleksi total $R$

  $
    R = R_(perp, parallel) = (R_(1(perp,parallel))(1-P_d^2 P_a))/(1-R^2_(1,(perp,parallel))P_d^2 P_a)
  $

  koefisien transmisi total $T$

  $
    T = T_(perp, parallel) = ((1 - R_(1(perp,parallel)))P_d^2 P_t)/(1-R^2_(1,(perp,parallel))P_d^2 P_a)
  $

  dan

  $
    D(pa minus.plus pa') = (-e^(-j pi / 4))/(2 sqrt(2 pi k)) (F[k L a(pa minus.plus pa')])/cos((pa minus.plus pa')/2)
  $

  dimana

  $
    P_d = exp(-j k' d/(cos theta_t))
  $
  $
    P_a = exp(j k 2 d/(cos(theta_r)) sin(theta_t) sin(theta_i))
  $
  $
    P_t = exp(j k d/(cos(theta_t)) cos(theta_i - theta_t))
  $

  dengan $k$ konstanta propagasi pada ruang bebas, $k'$ konstanta propagasi pada dielektrik, dan $d$ ketebalan dielektrik.
]

== Komputasi Elektromagnetik

#figure(
  image("assets/compem.png", width: 80%),
  caption: [Pembagian komputasi elektromagnetik]
) <cemdiag>

Komputasi elektromagnetik (_computational electromagnetics_) atau CEM dapat didefinisikan sebagai cabang dari elektromagnetika yang memanfaatkan komputer digital terotomasi untuk memperoleh suatu nilai-nilai angka@miller_selective_1988, meskipun pada hakikatnya komputasi sendiri (dari Latin _computo_, menghitung) tidak terbatas pada pemanfaatan komputer dan termasuk kepada perhitungan dengan tangan solusi secara analitik maupun numerik terhadap persamaan-persamaan Maxwell, atau hukum-hukum fisika lainnya secara umum pada komputasi fisika (_computational physics_).

Salah satu aplikasi utama dari CEM adalah pemodelan propagasi yang memprediksi perilaku gelombang elektromagnetik di situasi lingkungan yang beragam, yang sebagai contoh sangat berguna dalam perencanaan infrastruktur jaringan.
Secara konsep, CEM dapat dibagi menjadi dua: pemodelan empiris dan pemodelan deterministik. Pemodelan empiris bergantung kepada pengamatan dan hasil pengukuran dan memberikan persaamaan berupa fungsi aljabar sederhana atas frekuensi, jarak, gain, dan sebagainya untuk mengestimasi perilaku gelombang dalam kondisi-kondisi spesifik.

Berbeda dengan metode-metode empirik, metode deterministik mensimulasikan propagasi gelombang elektromagnetik berdasarkan hukum-hukum fisika dan formulasi matematika terkait untuk memprediksi kuat sinyal pada suatu titik@abhayawardhana_comparison_2005. Pemodelan deterministik dapat bekerja secara _full-wave_, dimana metode numerik digunakan untuk mengaproksimasi solusi dari persamaan-persamaan Maxwell.
Berdasarkan bentuk persamaan Maxwell yang digunakan, metode _full-wave_ terbagi atas metode-metode berbasis persamaan diferensial dan metode-metode berbasis persamaan integral. Selain itu, metode _full-wave_ juga dapat dilakukan pada domain waktu maupun frekuensi.

Metode asimtotik atau metode frekuensi tinggi, yang berdasarkan kepada asumsi-asumsi atau ekspansi asimtotik tertentu terhadap solusi persamaan-persamaan Maxwell tersebut. Metode ini berguna sebagai alternatif dari metode _full-wave_ karena pada frekuensi tinggi, metode tersebut memberikan sistem persamaan linear yang sangat besar dan akan sangat membebani dalam perihal komputasi@stutzman_antenna_2013.
Metode asimtotik sederhananya memberikan aproksimasi atas solusi dari persaamaan-persamaan Maxwell dengan asumsi/hipotesis yang berlaku ketika panjang gelombang cukup kecil dibanding dengan ukuran geometri objek@pelosi_brief_2021. Secara garis besar, metode asimtotik ini terbagi atas _geometric optics_ (GO) dan _physical optics_ (PO).


=== Pemodelan Empiris Rugi Jalur

Rugi jalur (_path loss_) merupakan karakteristik gelombang dimana gelombang akan mengalami atenuasi atau pengurangan daya selama propagasinya dari satu titik ke titik lain. Rugi jalur dapat terjadi karena berbagai macam hal seperti akibat sifat alami gelombang yang menyebar, hamburan akibat difraksi, penyerapan dan distorsi oleh medium, refleksi oleh suatu objek, _fading_, dan lain sebagainya. Oleh karena itu, akan cukup sulit untuk memprediksi rugi jalur secara tepat tanpa memperhitungkan semua faktor lingkungan tersebut.

#figure(
  [
    #set math.equation(numbering: none)
    #table(
      columns: (auto,1fr,auto),
      table.header([*Model*],[*Formulasi*],[*Keterangan*]),
      align: (left, center + horizon, left),

      [Rugi Jalur Ruang Bebas \ (FSPL)],
      [$ P_r/P_t = D_t D_r (lambda/(4 pi d))^2 $],
      [
        - $P_(r,t)$ daya
        - $D_(r,t)$ direktivitas
        - $lambda$ panjang \ gelombang
        - $d$ jarak antena
      ],

      [Model Medan Egli],
      [$ P_r/P_t = G_B G_M ((h_B h_M)/d^2)^2 (40/f)^2 $],
      [
        - $G_(B,M)$ gain \ _base_/_mobile_
        - $h_(B,M)$ ketinggian \ _base_/_mobile_
        - $f$ frekuensi
      ],

      [Model Hata-Okumura \ untuk wilayah perkotaan],
      [$
        L &= 69.55 + 26.16 log_10 f \
        &- 13.82 h_B - alpha(h_m) \
        &+(44.9 - 6.55 log_10 h_B) log d
      $],
      [
        - $alpha$ fungsi faktor \ koreksi \ ketinggian
      ],

      [Model dalam ruang \ ITU],
      [$ L_"dB" = 20 log_10 f + N log_10 d \ + P_f (n) - 28 $],
      [
        - $N$ koefisien rugi \ jarak
        - $n$ jumlah lantai \ antar terminal
        - $P_f$ fungsi faktor \ penetrasi
      ]
    )
  ],
  caption: [Beberapa contoh model empirik rugi jalur untuk kondisi-kondisi yang berbeda],
  placement: auto,
) <empire>

Masalahnya adalah bahwa prediksi rugi jalur merupakan salah satu hal yang penting untuk diperhitungkan dalam penyusunan _link budget_, yang menentukan konfigurasi struktur pendukung dalam suatu sistem telekomunikasi. Oleh karena itu, muncullah model-model empiris yang dapat digunakan untuk memprediksi rugi jalur dengan cara mengintegrasikan parameter lingkungan hasil pengukuran dan pengamatan@abhayawardhana_comparison_2005. @empire menunjukkan beberapa contoh model empirik untuk situasi-situasi yang berbeda.


Dapat dilihat bahwa model empiris, meskipun dapat memprediksi kinerja suatu kanal secara umum dengan cepat dan dengan hasil yang cukup meyakinkan dalam merepresentasikan keadaan yang sebenarnya, memiliki keterbatasan dalam perihal akurasi, karena suatu model hanya valid untuk lingkungan yang spesifik dan juga abai terhadap fenomena dan kondisi, termasuk geometri, spesifik dari lingkungan pengukuran. Ketika akurasi dan informasi yang lebih spesifik dibutuhkan, model deterministik akan lebih tepat untuk digunakan.

=== _Ray Tracing_

_Ray tracing_ (RT) merupakan salah satu dari CEM sebagai metode numerik yang digunakan untuk memperkirakan solusi dari persaamaan Maxwell pada frekuensi tinggi. RT dapat memberikan beberapa prediksi dalam perihal rugi jalur, sudut kedatangan, dan waktu tunda@yun_ray_2015. RT secara umum didasarkan kepada representasi aliran radiasi energi dalam bentuk sinar-sinar@robinson_basic_2017 sehingga tidak terbatas pada pemodelan gelombang elektromagnetik saja.

Dalam elektromagnetika atau CEM sendiri, RT berbasis pada GO yang memberikan landasan representasi sinar untuk menjelaskan propagasi gelombang dan interaksinya dengan objek-objek dalam ruangan. Oleh karena itu, RT termasuk ke dalam metode deterministik asimtotik (frekuensi tinggi) dalam CEM, seperi yang dapat dilihat pada @cemdiag.

Dalam implementasinya, pemodelan propagasi dengan RT terdiri atas 2 tahap:
+ Penentuan sinar jalur, dalam hal ini digunakan untuk menentukan jalur-jalur yang menghubungkan sumber dengan penerima atau suatu titik ukur pada ruang. Terdapat dua metode utama yang dapat digunakan:
  - Metode bayangan (_image_), dimana pencerminan bayangan dilakukan untuk setiap bidang refleksi untuk menentukan jalur-jalur tepat antara pemancar dan penerima. Kelebihan metode ini adalah akurasi terhadap jalur yang didapatkan. Karena transformasi dilakukan pada setiap $N$ reflektor untuk setiap $m$ refleksi, algoritma ini memiliki kompleksitas kuadrat $cal(O)(N^m)$ yang tidak efisien dan memberikan beban komputasi yang besar dengan semakin rumitnya geometri ruangan. Kekurangan lainnya adalah bahwa setiap transformasi oleh reflektor hanya memungkinkan satu bayangan sehingga pemodelan transmisi dan tentu saja difraksi tidak dapat dilakukan dengan metode ini.
    #figure(
      image("assets/image.jpg", width: 80%),
      caption: [Metode bayangan]
    )

  - Metode _shooting and bouncing rays_ (SBR), dimana sinar-sinar diluncurkan dari sumber ke segala arah dan setiap sinar dibiarkan berinteraksi dengan objek-objek di lingkungan. Kemudian, sinar-sinar yang valid (mengenai penerima) didapatkan dengan melakukan seleksi dengan kriteria tertentu dari sinar-sinar yang telah diluncurkan. Meskipun metode ini memperkenalkan penyimpangan fasa karena jalur yang tidak tepat seperti metode bayangan, algoritma memiliki kompleksitas $cal(O)(m N)$ sehingga akan jauh lebih efisien seiring geometri ruangan yang semakin rumit, disamping SBR juga memungkinkan pemodelan transmisi dan difraksi. Tidak terdapat aturan spesifik terkair kriteria sinar valid meskipun beberapa sumber memberikan jari-jari lingkaran penerima (_reception sphere_) $r$, dimana sinar akan valid jika beririsan dengan ruang tersebut, sebagai fungsi dari sudut antara sinar yang dipancarkan $alpha$ dan panjang total sinar dari sumber $s$
  $ r = (alpha s)/sqrt(3) $
    #figure(
      image("assets/sbr.jpg", width: 80%),
      caption: [Metode SBR]
    )
+ #par[
    Pengukuran, dimana dalam propagasinya, masing-masing sinar mengalami atenuasi akibat refleksi, transmisi, dan difraksi berupa koefisien Fresnel dan GTD/UTD, sehingga medan hasil dari tiap sinar berupa

    $ E_R = E_0 [product_i A_i Gamma_i product_j A_j T_j product_k A_k D_k] (e^(-j k s))/s $

    dimana $E_R$ merupakan medan pada penerima yang dihasilkan oleh suatu sinar, $E_0$ adalah magnitudo awal medan, $A$ adalah faktor persebaran atau atenuasi ruang pada setiap interaksi sinar, $Gamma$ adalah koefisien refleksi, $T$ adalah koefisien transmisi, dan $D$ adalah koefisien difraksi, sementara $s$ adalah jarak total yang telah ditempuh sinar. Selain itu, karena sifat linear dari persamaan Maxwell, medan total pada titik penerima merupakan superposisi dari masing-masing sinar@kasdorf_advancing_2021, sehingga medan total $E_"total"$ adalah

    $ E_"total" = sum_i E_R[i] $

    dan rugi jalur

    $ L = -20 log_10 (E_"total"/E_0) $

  ]

#page(flipped: true)[
  #set par(leading: 1em)
  #show figure: set block(breakable: true)
  == Perbandingan Beberapa Konsep Pemodelan Propagasi Berbasis Sinar

  #figure(
    table(
      columns: (auto, auto, auto, auto, auto, auto),
      align: left,
      table.header(
        [Aspek],
        [*_Ray Tracing_*],
        [*_Geometric Optics_*],
        [*_Geometrical Theory \ of Diffraction_*],
        [*_Uniform Theory \ of Diffraction_*],
        [*_Shooting and \ Bouncing \ Rays_*]),

      [Definisi],
      [Istilah umum yang merujuk kepada metode perhitungan jalur gelombang atau pun partikel pada suatu sistem dengan mempertimbangkan berbagai interaksi antara sinar sebagai representasi jalur dengan sistem.],
      [Pemodelan propagasi gelombang elektromagnetik ke dalam bentuk sinar-sinar yang bergerak lurus pada medium homogen. Pemodelan ini dapat menjelaskan refleksi dan refraksi.],
      [Ekstensi dari _Geometrical Optics_ yang menyertakan pemodelan difraksi. GTD memodelkan difraksi dengan mengasumsikan suatu sumber sekunder dari gelombang elektromagnetik pada titik difraksi sudut.],
      [Penyempurnaan terhadap GTD yang mampu menjelaskan singularitas pada ISB dan RSB.],
      [],

      [Dasar Teori],
      [Tergantung bidang aplikasinya, RT dapat didasarkan kepada _geometrical optics_, _geometrical acoustics_@krautkramer_geometrical_1990, teori sinar seismik@cerveny_seismic_2001, bahkan dalam relativitas umum@macpherson_cosmological_2022, dan lain sebagainya yang memungkinkan representasi sinar terhadap suatu fenomena fisika.],
      [Persamaan eikonal dari persamaan gelombang elektromagnetik dan ekspansi Luneberg-Kline. Juga dapat dilihat sebagai aplikasi dari prinsip Fermat.],
      [_Geometrical optics_, dengan pemodelan difraksi, dimana titik difraksi diasumsikan sebagai sumber sinar sekunder.],
      [UTD memperkenalkan fungsi transisi Fresnel $F$ kepada GTD, yang membuat wilayah-wilayah difraksi sebagai wilayah transisi dari batas-batas bayangan yang sebelumnya memunculkan singularitas pada GTD.],
      [],
    ),
    caption: [Perbandingan RT, GO, GTD, UTD, dan SBR],
  )

  #figure(
    image("assets/venn.png", width: 80%),
    caption: [Hubungan beberapa topik dalam _ray tracing_]
  )
]
