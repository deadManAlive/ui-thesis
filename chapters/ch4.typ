= Hasil dan Analisis Simulasi

Untuk memverifikasi algoritma program dalam memodelkan propagasi gelombang elektromagnetik, maka dilakukan serangkaian simulasi dan perbandingan, yaitu:
+ Simulasi pada denah dengan geometri sederhana.
+ Simulasi pada denah ruang nyata.
+ Perbandingan dengan simulasi aplikasi komersial (Altair FEKO) dan pengukuran.

Konfigurasi Altair FEKO ProMan sebagai pembanding menggunakan pemodelan _Standard Ray Tracing_ (SRT), ketinggian panel dinding 3 meter dan tinggi titik akses 2.5 meter, dan pada kedua simulasi, digunakan sumber 2.4G dan 5G dengan daya 0.1W, dan materi objek kayu dengan parameter pada @woodpar, dengan $a = 1.99$, $b = 0$, $c = 0.0047$, dan $d =1.07128$ (ITU-R P.2040-3). Altair FEKO yang digunakan adalah versi 2022.3 _Student Edition_.

#figure(
  table(
    columns: 4,
    align: center + horizon,
    table.header([*Frekuensi*], [$ sigma = c f_"GHz"^d ("S/m") $], [$ epsilon_r^'= a f_"GHz"^b $], [$ epsilon_r^'' = sigma / (epsilon_0 omega) $]),
    [2.4 GHz], [0.0120], [1.99], [0.0899],
    [5 GHz], [0.0264], [1.99], [0.0949]
  ),
  caption: [Parameter atenuasi materi kayu (sumber: ITU-R P.2040-3)],
  placement: none,
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

@s24 dan @s5 menunjukkan hasil pengukuran rugi jalur pada ruangan dengan denah sederhana di atas untuk frekuensi 2.4 dan 5 GHz. Titik-titik pengukuran dipilih dengan mengambil satu posisi pada ruang dan, memvariasikan posisi pada satu sumbu. Garis hijau menunjukkan rentang dari titik-titik yang dipilih, dari bawah ke atas.

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

Perbandingan dapat dilihat pada @res. Data menampilkan posisi dari beberapa titik diruangan yang telah ditentukan, kemudian untuk masing-masing frekuensi dilakukan pengecekan terhadap FEKO dan terhadap program yang disusun. Titik akses diasumsikan menggunakan daya 0.1W. Dapat dilihat bahwa pada frekuensi 2.4 GHz, aplikasi kesulitan untuk melakukan kalkulasi pada titik C, yaitu titik yang cukup jauh dengan sumber secara jarak dan geometri yang menghalanginya, meskipun hal yang sama juga terjadi pada FEKO pada tingkat yang lebih rendah. Sementara itu, pada pengukuran di 5 GHz, kedua aplikasi memberikan bacaan yang cukup konsisten.

Oleh karena itu, dari verifikasi ini, dapat dikatakan bahwa aplikasi yang disusun cukup berguna untuk mengetahui cakupan titik akses secara umum, meskipun masih dapat dikembangkan lagi dalam perihal antarmuka dan algoritma.

#figure(
  image("assets/res.jpg"),
  placement: none,
  kind: table,
  caption: [Perbandingan hasil pengukuran, FEKO, dan program aplikasi yang disusun]
) <res>

== Analisis Hasil Simulasi

Dari beberapa perbandingan kinerja aplikasi yang disusun dan Altair FEKO, terdapat beberapa poin yang dapat dicermati:

+ Pada perbandingan denah ruang sederhana, terdapat peningkatan tingkat kesalahan pada posisi LOS, meskipun hal yang serupa tidak ditemukan pada simulasi ruang nyata. Dengan implementasi program yang hanya memodelkan refleksi, transmisi, dan difraksi, dan perbedaan utama antara denah sederhana dan denah nyata adalah bahwa denah ruang sederhana berupa poligin tertutup, seperti yang dapat dilihat pada @simplex, maka rugi jalur yang lebih kecil di area tersebut dapat dijelaskan sebagai efek dari aplifikasi sinar yang bergerak pada arah horizontal pada ruang tertutup. Hal ini kontras dengan denah ruang nyata yang memberikan celah pada pintu utama denah, yang berada pada sumbu horizontal yang sama dengan titik sumber. Salah satu solusi yang dapat diberikan adalah pengimplementasian absorbsi dan batas atau _threshold_ sinar dengan nilai koefisien-koefisien tertentu.

+ Secara umum, tiga fenomena gelombang yang diimplementasikan dalam pemodelan, berhasil memberikan gambaran secara umum atas penyebaran medan elektromagnetik pada ruang, meskipun kesalahan masih berada di kisaran 2 - 20%, dengan rata-rata 10-11%, baik pada frekuensi 2.4 GHz maupun 5 GHz. Tingkat kesalahan pada percobaan ruang nyata juga menunjukkan kesesuaian terhadap sifat pendekatan asimtotik frekuensi tinggi yang seharusnya memberikan akurasi yang lebih tinggi pada frekuensi yang lebih tinggi. Tingkat kesalahan tidak terlalu berubah pada pengujian denah sederhana antara aplikasi yang disusun dan FEKO, sebagai implikasi dari perihal ruang sebagai poligon tertutup di atas.

+ #par(
  [
    Semantara itu, pada perbandingan dengan hasil pengukuran, terdapat beberapa faktor yang mempengaruhi perbandingan, dimana salah satu poin utama adalah tingginya tingkat kesalahan pada posisi C dan D dari denah @measure pada @res, terlebih pada frekuensi 2.4 GHz, meskipun hal yang sama tidak ditemukan pada perbandingan di frekuensi 5 GHz. Melihat pada frekuensi 2.5 GHz FEKO juga mengalami hal yang serupa, meskipun sedikit lebih ringan, maka dapat disimpulkan bahwa ketidakakurasian yang tinggi pada pengukuran di titik C adalah terkait geometri dan bahan ruang sendiri yang menyulitkan dalam hal simulasi, terlebih kedua simulasi hanya memodelkan dinding sebagai material homogen tanpa mempertimbangkan material dan objek lainnya pada ruang. Dapat dilihat juga meskipun titik C dan D memberikan tingkat kesalahan yang tinggi, titik C dengan jarak lurus terjauh dan jumlah segmen objek yang lebih banyak yang berada pada jalur lurusnya dengan sumber memberikan tingkat kesalahan yang lebih tinggi.

    Dokumentasi FEKO sendiri tidak menjabarkan secara mendetail cara kerja dari metode RT dan SBR yang digunakan pada aplikasi, selain menunjukkan bahwa pemodelan menggunakan refleksi dan transmisi, serta difraksi dan/atau hamburan@altair_altair_2023. Secara teori persis dengan yang diimplementasikan pada program, terlebih perbandingan menggunakan konfigurasi RT pada FEKO menggunakan persamaan Fresnel. Perbedaan utama dari simulasi dengan program yang disusun dan FEKO adalah bahwa simulasi pada FEKO berbasis ruang 3 dimensi, selain fakta bahwa kerapatan sinar yang dipancarkan sumber pada FEKO juga tidak dijelaskan. Kedua program memodelkan sumber sebagai antena isotropik yang mengeluarkan daya 0.1 W. Oleh karena itu, tingkat kesalahan aplikasi pada situasi ini dapat diatribusikan kepada keterbatasan pemodelan 2 dimensi.
  ]
)

\

Secara umum, meskipun aplikasi yang disusun belum dapat memberikan nilai numerik yang akurat, aplikasi dapat digunakan untuk memberikan gambaran umum dan secara cepat terkait persebaran sinyal elektromagnetik atau cakupan sinyal yang dipancarkan oleh suatu sumber Wi-Fi pada ruangan berupa denah 2 dimensi.