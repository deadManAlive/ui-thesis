= Pendahuluan <intro>

== Latar Belakang

Dikutip dari laporan survei tahunan Asosiasi Penyelenggara Jasa Internet Indonesia (APJII), penetrasi Internet di Indonesia mengalami peningkatan setiap tahunnya, melewati angka 70% pada periode 2019-2020 dan mendekati 80% pada 2023 @asosiasi_penyelenggara_jasa_internet_indonesia_laporan_nodate @asosiasi_penyelenggara_jasa_internet_indonesia_profil_2022 @asosiasi_penyelenggara_jasa_internet_indonesia_survei_nodate.
Sumber yang sama juga menunjukkan bahwa meskipun akses internet masih didominasi oleh akses via jaringan seluler (di atas 70%), proporsi pengguna yang menggunakan akses Wi-Fi dan berlangganan internet _fixed_ juga meningkat setiap tahunnya.
Hal ini belum memperhitungkan penggunaan internet _fixed_ du dunia UMKM dan korporasi dimana pada 2023, lebih dari 70%-nya berlangganan @asosiasi_penyelenggara_jasa_internet_indonesia_survei_nodate-1.

Peningkatan pengguna internet _fixed_ tersebut tentunya akan diiringi dengan peningkatan kebutuhan atas struktur dan infrastruktur pendukung seperti _router_/_access point_ (AP) sebagai bagian dari sistem untuk penyediaan sambungan internet pada jaringan lokal nirkabel (WLAN).
Pada penggunaan perumahan kecil serta UMKM dengan harapan _coverage_ jaringan internet cukup sederhana serta fungsi internet yang non-kritis, penempatan AP merupakan masalah trivial.
Hal sebaliknya terjadi ketika koneksi nirkabel dibutuhkan pada situs yang kompleks atau dengan fungsi internet kritis yang membuat dibutuhkannya perencanaan penempatan AP yang matang agar infrastruktur bekerja optimal dan mampu menyediakan koneksi tanpa kesulitan yang berarti, sebagai contoh pada penggunaan korporasi kantoran, institusi pemerintahan, dan akademik.

Dalam kondisi-kondisi tersebut, adanya _dead zone_ di area yang tidak diinginkan atau sekedar nilai kekuatan sinyal yang tidak mencukupi dapat membuat pemanfaatan jaringan pada bangunan menjadi sub optimal, yang tentunya tidak diinginkan terjadi di lingkungan komersial. Oleh karena itu, dibutuhkan penempatan AP yang terencana bahkan hal tersebut dapat menjadi salah satu acuan dalam tahap desain konstruksi bangunan.

Terdapat berbagai macam cara yang dapat dilakukan untuk perencanaan tersebut, contoh yang sederhana adalah menggunakan model empiris, seperti dalam kondisi _indoor_ diantaranya dapat digunakan ITU-R P.1238-9 (pemodelan propagasi dalam ruangan) dan model rugi jalur log-jarak. Kedua model tersebut mengestimasi rugi jalur sebagai fungsi dari jarak, frekuensi, dan sebagainya.
Persamaan @plosm1 merupakan pemodelan ITU-R P.1238-9 dimana rugi jalur $L$ merupakan fungsi dari rugi jalur pada jarak referensi $L_0$, koefisien rugi daya $N$, jarak $d$, jarak referensi $d_0$, dan faktor rugi penetrasi untuk $n$ lantai pada frekuensi tertentu $L_f (n)$.
Sementara itu, pada pemodelan rugi jalur log-jarak pada persamaan @plosm2, $gamma$ adalah eksponen rugi jalur dan $chi$ adalah variabel acak normal (Gaussian) yang menggambarkan atenuasi akibat _fading_.

$ L = L_0 + N log_10 d/d_0 + L_f (n) $ <plosm1>
$ L = L_0 + 10 gamma log_10 d/d_0 + chi $ <plosm2>

Meskipun dapat memberikan estimasi awal kinerja suatu channel berupa perkiraan path loss, model empiris memiliki keterbatasan dalam hal akurasi karena beberapa hal seperti sifatnya yang spesifik sehingga hanya valid untuk lingkungan yang serupa dengan yang awalnya dimodelkan serta mengabaikan berbagai data yang dapat menyebabkan ketidakakuratan @yun_ray_2015.
Sebagai contoh pada model-model indoor, model log-jarak mengabaikan frekuensi dan semua model memberikan estimasi kasar terhadap geometri bangunan @schwengler_radio_2019. Untuk itu, dibutuhkan metode yang lebih baik dan mencakup berbagai faktor dalam pemodelannya secara umum jika dibutuhkan hasil yang lebih akurat.

Metode yang umum digunakan untuk memodelkan propagasi gelombang radio adalah melakukan komputasi numerik  terhadap persamaan Maxwell untuk mengalkulasi medan listrik E dan medan magnet B, melalui penyelesaian numerik dari bentuk integral persamaan Maxwell seperti _Method of Moments_ (MoM) dan _Fast Multipole Method_ (FMM) ataupun dari bentuk diferensial seperti _Finite-Difference Time-Domain_ (FDTD) dan _Finite Element Method_ (FEM).
Karena bekerja secara langsung terhadap persamaan Maxwell yang menjelaskan perilaku medan listrik dan magnet, metode-metode _computational electromagnetics_ (CEM) ini memiliki kelebihan dalam perihal akurasi dan domain permasalahan yang lebih beragam dari pemodelan empiris.

Karena bergantung pada diskritisasi, yaitu pemecahan sistem kontinu menjadi elemen-elemen diskrit untuk dapat direpresentasikan secara numerik oleh komputer dimana ukuran elemen diskrit umumnya berbanding lurus dengan panjang gelombang @bouche_asymptotic_1997, metode-metode di atas memberikan tantangan dalam waktu dan memori komputasi, yang meningkat drastis dengan meningkatnya frekuensi.
Terdapat metode CEM alternatif _ray tracing_ (RT) yang tidak bekerja secara langsung untuk mengalkulasi solusi numerik persamaan Maxwell melainkan pendekatan terhadap solusinya melalui pemodelan optik _geometrical optic_ (GO) bersama pemodelan difraksi _Uniform Theory of Diffraction_ (UTD). RT belakangan menjadi metode pemodelan propagasi elektromagnetik yang populer karena algoritma yang lebih sederhana dan tidak memerlukan kalkulasi sinar kembali untuk frekuensi yang berbeda serta perkembangan teknologi _graphical processing unit_ (GPU) yang dapat membantu kecepatan komputasi paralel secara signifikan @sarestoniemi_overview_2017 @andreas_rogne_raytracing_2022.

Pada laporan skripsi ini, akan dirancang sebuah aplikasi, dari algoritma dibaliknya hingga antarmuka GUI, untuk memodelkan propagasi gelombang untuk lingkungan _indoor_ pada _floorplan_ dua dimensi, terutama untuk frekuensi Wi-Fi 2.4 GHz dan 5 GHz dan digunakan metode _shooting and bouncing rays_ (SBR) untuk menemukan path yang valid. Kemudian dilakukan pengujian dari aplikasi yang telah dibuat terhadap hasil simulasi aplikasi komersial dan juga hasil pengukuran di lapangan.

== Tujuan Penulisan

Tujuan dari penulisan skripsi ini adalah:

+ Mengimplementasikan metode _ray tracing_/_shooting and bouncing rays_ menggunakan _geometric optics_ dan _universal theory of diffraction_ dalam bentuk algoritma untuk menyusun sebuah aplikasi berbasis GUI untuk pemodelan propagasi gelombang.

+ Menganalisis dan memverifikasi hasil simulasi dari aplikasi yang telah dibuat terhadap aplikasi komersial serupa dan pengukuran lapangan.

== Batasan Masalah

Pengembangan dan pengujian aplikasi ini dibatasi oleh beberapa batasan masalah:

+ Lingkungan yang disimulasikan adalah lingkungan _indoor_ dengan input _floorplan_ dua dimensi.
+ Frekuensi kerja _transmitter_ yang disimulasikan adalah frekuensi IEEE 802.11 2.4 GHz dan 5 GHz ddengan asumsi pola radiasi omnidireksional.
+ Simulasi dilakukan untuk menentukan RSSI dan _path loss_ antara _transmitter_ dan _receiver_.
+ Fenomena gelombang elektromagnetik yang disimulasikan pada aplikasi adalah refleksi, refraksi, dan difraksi.
+ Aplikasi ditulis dengan bahasa pemrograman Rust untuk memaksimalkan performa dengan tetap memperhatikan keamanan memori.

== Metodologi Penelitian

Metode-metode penelitian yang digunakan dalam penyusunan laporan skripsi ini adalah:

+ Studi literatur \
  Pada tahap ini, penulis membaca jurnal, buku, ataupun karya ilmiah lainnya untuk lebih memahami perihal propagasi gelombang elektromagnetik dan metode-metode pemodelannya, terutama _ray tracing_.

+ Penulisan program \
  Dari teori yang telah dipahami dan disesuaikan dengan batasan masalah, penulis menerapkan teori menjadi algoritma dan kemudian mengintegrasikannya dalam suatu antarmuka GUI.

+ Pengujian program \
  Aplikasi yang telah ditulis kemudian diuji dengan cara membandingkannya dengan hasil simulasi software komersial dan juga terhadap hasil pengukuran.

== Sistematika Penulisan

#[
  #set par(leading: 1em)
  #set block(spacing: 1em)

  #table(
    columns: (1fr, 2fr),
    stroke: none,
    [#strong[BAB I: Pendahuluan]], [
      Bagian ini berisi penjelasan umum seperti latar belakang, tujuan penulisan, batasan masalah, metodologi penulisan, serta sistematika penulisan ini sendiri.
    ],
    [#strong[BAB II: Dasar Teori]], [
      Bagian ini berisi penjelasan tentang dasar bagaimana metode _ray tracing_ dapat memodelkan propagasi gelombang, prinsip-prinsip dasar _ray tracing_, metode _shooting and bouncing rays_, hingga prisip _graphical optics_ dan _universal theory of diffraction_ yang mendasari kerja aplikasi yang dikembangkan dalam penelitian ini.
    ],
    [#strong[BAB III: Penulisan Program]], [
      Bagian ini berisi penjelasan algoritma-algoritma yang digunakan pada program sebagai implementasi pemodelan _ray tracing_.
    ],
    [#strong[BAB IV: Simulasi dan Analisis Hasil]], [
      Bagian ini berisi tentang analisis hasil simulasi yang didapatkan oleh program dengan membandingkannya dengan simulasi _software_ komersial dan kemudian dengan hasil pengukuran.
    ],
    [#strong[BAB V: Penutup]], [
      Bagian ini berisi penutup dan kesimpulan terhadap simulasi yang telah dilakukan oleh aplikasi yang dibuat.
    ]
  )
]
