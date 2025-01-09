= Hasil dan Analisis Simulasi

#show figure.where(kind: table): set figure(placement: auto) 

Untuk memverifikasi algoritma program dalam memodelkan propagasi gelombang elektromagnetik, maka dilakukan serangkaian simulasi dan perbandingan, yaitu:
+ Simulasi pada denah dengan geometri sederhana.
+ Simulasi pada denah ruang nyata.
+ Perbandingan dengan simulasi aplikasi komersial (Altair FEKO) dan pengukuran.

Konfigurasi Altair FEKO ProMan sebagai pembanding menggunakan pemodelan _Standard Ray Tracing_ (SRT), ketinggian panel dinding 3 meter dan tinggi titik akses 2.5 meter, dan pada kedua simulasi, digunakan sumber 2.4G dan 5G dengan daya 0.1W, dan materi objek kayu dengan parameter pada @woodpar, dengan $a = 1.99$, $b = 0$, $c = 0.0047$, dan $d =1.07128$ (ITU-R P.2040-3).

#figure(
  table(
    columns: 4,
    align: center + horizon,
    table.header([*Frekuensi*], [$ sigma = c f_"GHz"^d ("S/m") $], [$ epsilon_r^'= a f_"GHz"^b $], [$ epsilon_r^'' = sigma / (epsilon_0 omega) $]),
    [2.4 GHz], [0.0120], [1.99], [0.0899],
    [5 GHz], [0.0264], [1.99], [0.0949]
  ),
  caption: [Parameter atenuasi materi kayu (sumber: ITU-R P.2040-3)]
) <woodpar>

Perbandingan dilakukan dengan cara mengukur beberapa titik uji pada ruang dan membandingkan hasil kalkulasi program dengan FEKO.

== Uji Simulasi Pada Denah Ruang Dengan Geometri Sederhana

#figure(
  image("assets/simple.jpg", width: 50%),
  caption: [Denah ruang uji dengan geometri sederhana],
) <simplex>

#figure(
  image("assets/simplefray.png", width: 80%),
  caption: [Simulasi program pada denah sederhana]
) <simplefray>

#figure(
  image("assets/altairspl.png", width: 70%),
  caption: [Simulasi denah sederhana pada Altair FEKO (_path loss_, 2.4G)]
) <simplefeko>

Pada pengujian pertama dilakukan simulasi terhadap suatu ruang dengan geometri sederhana, dalam hal ini adalah sebuah ruangan yang terbentuk dari dua persegi. @simplex merupakan denah dari ruang tersebut, dengan posisi pemancar sebagai `Site 1`, @simplefray merupakan simulasi denah pada program, dan @simplefeko merupakan hasil simulasi dari Altair FEKO untuk _path loss_ di 2.4G.

#figure(
  image("assets/s24.png", width: 60%),
  kind: table,
  caption: [Pengukuran menggunakan FEKO dan program untuk denah sederhana pada 2.4 GHz]
) <s24>

#figure(
  image("assets/s5.png", width: 60%),
  kind: table,
  caption: [Pengukuran menggunakan FEKO dan program untuk denah sederhana pada 5 GHz]
) <s5>

@s24 dan @s5 menunjukkan hasil pengukuran rugi jalur pada ruangan dengan denah sederhana di atas untuk frekuensi 2.4 dan 5 Ghz. Titik-titik pengukuran dipilih dengan mengambil satu posisi pada ruang dan, memvariasikan posisi pada satu sumbu. Garis hijau menunjukkan rentang dari titik-titik yang dipilih, dari bawah ke atas.

Dapat dilihat dari pengukuran bahwa kalkulasi program mengalami galat yang relatif lebih besar ketika titik penerima berada pada LOS. Meskipun demikian, kesalahan secara umum masih di bawah 20%.

== Simulasi Pada Denah Ruang Nyata

#figure(
  image("assets/real.jpg", width: 100%),
  caption: [Denah gedung 1 lantai 2 DTE FTUI]
) <realmap>

#figure(
  image("assets/realfray.png", width: 80%),
  caption: [Simulasi denah nyata pada program aplikasi]
) <realfray>

#figure(
  image("assets/altairreal.png", width: 80%),
  caption: [Simulasi pada denah nyata dengan FEKO untuk _path loss_ pada 2.4 GHz]
) <realfeko>

Denah ruang nyata menggunakan denah gedung 1 lantai 2 Departemen Teknik Elektro Faktultas Teknik Universitas Indonesia (@realmap). Seperti pada pengujian denah sederhana, pengujian dilakukan untuk suatu sumber terhadap titik-titik tertentu dalam ruangan. @realfray dan @realfeko menunjukkan tampilan masing-masing aplikasi ketika mensimulasikan kondisi ruangan tersebut.

Tabel @r24 dan @r5 masing-masing menunjukkan hasil pengukuran dan perbandingan antara beberapa titik-titik pada denah di kedua program. Dan seperti pada pengujian sebelumnya, titik-titik uji dipilih dengan cara mengambil suatu titik pada ruang, dan memvariasikan salah satu sumbunya. Garis hijau pada @realmap menunjukkan rentang dari garis-garis yang dipilih tersebut, dari bawah ke atas.

Dapat dilihat bahwa program berhasil memprediksi dengan kesalahan cukup di bawah 12%, yang menekankan tingkat akurasi program dari pengujian sebelumnya. Hal yang dapat diperhatikan adalah bahwa tidak terjadi meningkatan kesalahan pada wilayah LOS seperti pada pengujian sebelumnya. Hal yang membedakan dari kedua denah adalah dimensi dari ruang, yang mengimplikasikan bahwa terdapat bagian dari pemodelan yang sensitif terhadap dimensi ruang.

#figure(
  image("assets/plreal24g.png", width: 60%),
  kind: table,
  caption: [Pengukuran menggunakan FEKO dan program untuk denah nyata pada 2.4 GHz]
) <r24>

#figure(
  image("assets/plreal5g.png", width: 60%),
  kind: table,
  caption: [Pengukuran menggunakan FEKO dan program untuk denah nyata pada 5 GHz]
) <r5>

== Perbandingan Dengan Hasil Pengukuran

#show link: underline

#figure(
  image("assets/test.png", width: 80%),
  caption: [Titik-titik pengukuran pada denah nyata]
) <measure>

Untuk pengukuran, dilakukan pengambilan data terhadap titik akses di gedung 1 lantai 2 DTE FTUI, terhadap titik akses "DTE-FTUI" pada beberapa titik yang ditunjukkan oleh lingkaran hijau pada @measure. Pengkuran dilakukan menggunakan bantuan aplikasi Wi-Fi _analyzer_ #link("https://www.fing.com/")[Fing] pada telefon genggam POCO X3 NFC.

Perbandingan dapat dilihat pada @res. Data menampilkan posisi dari beberapa titik diruangan yang telah ditentukan, kemudian untuk masing-masing frekuensi dilakukan pengecekan terhadap FEKO dan terhadap program yang disusun. Titik akses diasumsikan menggunakan daya 0.1W. Dapat dilihat bahwa pada frekuensi 2.4 Ghz, aplikasi kesulitan untuk melakukan kalkulasi pada titik C, yaitu titik yang cukup jauh dengan sumber secara jarak dan geometri yang menghalanginya, meskipun hal yang sama juga terjadi pada FEKO pada tingkat yang lebih rendah. Sementara itu, pada pengukuran di 5 Ghz, kedua aplikasi memberikan bacaan yang cukup konsisten.

Oleh karena itu, dari verifikasi ini, dapat dikatakan bahwa aplikasi yang disusun cukup berguna untuk mengetahui cakupan titik akses secara umum, meskipun masih dapat dikembangkan lagi dalam perihal antarmuka dan algoritma.

#figure(
  image("assets/res.jpg"),
  placement: none,
  kind: table,
  caption: [Perbandingan hasil pengukuran, FEKO, dan program aplikasi yang disusun]
) <res>
