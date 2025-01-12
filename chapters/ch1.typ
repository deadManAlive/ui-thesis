= Pendahuluan <intro>

== Latar Belakang

Dikutip dari laporan survei tahunan Asosiasi Penyelenggara Jasa Internet Indonesia (APJII), penetrasi Internet di Indonesia mengalami peningkatan setiap tahunnya, melewati angka 70% pada periode 2019-2020 dan mendekati 80% pada 2023@asosiasi_penyelenggara_jasa_internet_indonesia_laporan_nodate @asosiasi_penyelenggara_jasa_internet_indonesia_profil_2022 @asosiasi_penyelenggara_jasa_internet_indonesia_survei_nodate.
Sumber yang sama juga menunjukkan bahwa meskipun akses internet masih didominasi oleh akses via jaringan seluler (di atas 70%), proporsi pengguna yang menggunakan akses Wi-Fi dan berlangganan internet tetap juga meningkat setiap tahunnya.
Hal ini belum memperhitungkan penggunaan internet jenis tersebut di dunia UMKM dan korporasi di mana pada 2023, lebih dari 70%-nya berlangganan@asosiasi_penyelenggara_jasa_internet_indonesia_survei_nodate-1.

Peningkatan pengguna internet tetap tersebut tentunya akan diiringi dengan peningkatan kebutuhan atas struktur dan infrastruktur pendukung seperti titik akses (_access point_/AP) sebagai bagian dari sistem untuk penyediaan sambungan internet pada jaringan lokal nirkabel (WLAN).
Pada penggunaan perumahan kecil serta UMKM dengan harapan _coverage_ jaringan internet cukup sederhana serta fungsi internet yang non-kritis, penempatan AP merupakan masalah trivial.
Hal sebaliknya terjadi ketika koneksi nirkabel dibutuhkan pada situs yang kompleks atau dengan fungsi internet kritis yang membuat dibutuhkannya perencanaan penempatan AP yang matang agar infrastruktur bekerja optimal dan mampu menyediakan koneksi tanpa kesulitan yang berarti, sebagai contoh pada penggunaan korporasi kantoran, institusi pemerintahan, dan akademik.

Dalam kondisi-kondisi tersebut, adanya ruang tanpa jangkauan di wilayah yang tidak diinginkan atau sekedar kekuatan sinyal yang tidak mencukupi dapat membuat pemanfaatan jaringan pada bangunan menjadi suboptimal, terutama jika terjadi di lingkungan komersial. Oleh karena itu, dibutuhkan penempatan titik akses yang terencana bahkan hal tersebut dapat menjadi salah satu acuan dalam tahap desain konstruksi bangunan.

Terdapat berbagai macam cara yang dapat dilakukan untuk perencanaan tersebut, contoh yang sederhana adalah menggunakan model empiris, seperti dalam kondisi _indoor_ di antaranya ITU-R P.1238-9 (pemodelan propagasi dalam ruangan) dan model _log-distance path loss_. Kedua model tersebut memperkirakan _path loss_ sebagai fungsi dari jarak, frekuensi, dan sebagainya. Meskipun dapat memberikan estimasi awal kinerja suatu channel dengan cukup akurat dan kalkulasi yang sederhana, model empiris memiliki keterbatasan dalam hal suatu model hanya valid untuk lingkungan yang spesifik serta mengabaikan berbagai faktor eksternal yang dapat mempengaruhi propagasi gelombang@yun_ray_2015@faruk_study_2013.

Metode yang umum digunakan untuk memodelkan propagasi gelombang radio adalah melakukan komputasi numerik  terhadap persamaan Maxwell untuk mengalkulasi medan listrik $bold(upright(E))$ dan medan magnet $bold(upright(B))$, melalui penyelesaian numerik dari bentuk integral persamaan Maxwell seperti _Method of Moments_ (MoM) dan _Fast Multi-pole Method_ (FMM) ataupun dari bentuk diferensial seperti _Finite-Difference Time-Domain_ (FDTD) dan _Finite Element Method_ (FEM).
Karena bekerja secara langsung terhadap persamaan Maxwell yang menjelaskan perilaku medan listrik dan magnet, metode-metode _computational electromagnetic_ (CEM) ini memiliki kelebihan dalam perihal akurasi dan domain permasalahan yang lebih beragam dari pemodelan empiris.

Karena bergantung pada diskritisasi, yaitu pemecahan sistem kontinu menjadi elemen-elemen diskrit untuk dapat direpresentasikan secara numerik oleh komputer di mana ukuran elemen diskrit umumnya berbanding lurus dengan panjang gelombang@bouche_asymptotic_1997, metode-metode di atas memberikan tantangan dalam waktu dan memori komputasi, yang meningkat drastis dengan meningkatnya frekuensi dan kompleksitas geometri.
_Ray tracing_ (RT) sebagai pendekatan asimtotik untuk solusi persamaan Maxwell berdasarkan kepada representasi gelombang dalam bentuk sinar.
RT belakangan menjadi metode pemodelan propagasi elektromagnetik yang populer karena algoritma yang lebih sederhana serta perkembangan teknologi _general purpose graphical processing unit_ (GPGPU) yang dapat mendukung komputasi paralel@sarestoniemi_overview_2017.

Pada laporan skripsi ini, akan dirancang sebuah aplikasi, dari algoritma di baliknya hingga antarmuka GUI, untuk memodelkan propagasi gelombang untuk lingkungan _indoor_ pada _floorplan_ dua dimensi, terutama untuk  radio Wi-Fi 2.4 GHz dan 5 GHz dan digunakan metode _shooting and bouncing rays_ (SBR) untuk menemukan jalur yang valid, di mana interaksi sinar dan lingkungan dimodelkan oleh _geometrical optics_ dan _geometric theory of diffraction_. Kemudian dilakukan pengujian dari aplikasi yang telah dibuat terhadap hasil simulasi aplikasi komersial dan juga hasil pengukuran di lapangan.

== Rumusan Masalah

Beberapa perihal yang mendasari penelitian ini adalah:

+ Bagaimana metode _ray tracing_ dapat digunakan untuk memodelkan propagasi gelombang elektromagnetik pada ruang?

+ Bagaimana menerapkan metode _ray tracing_ ke dalam bentuk algoritma program untuk melakukan perhitungan daya yang diterima dan rugi jalur dari suatu sumber pada ruang 2 dimensi?

+ Bagaimana menyusun suatu antarmuka grafis (GUI) terhadap algoritma program yang telah disusun?

+ Bagaimana pengaruh pemodelan interaksi gelombang dengan lingkungan mempengaruhi hasil simulasi?

== Tujuan Penulisan

Tujuan dari penulisan skripsi ini adalah:

+ Mengimplementasikan metode _ray tracing_ dalam bentuk algoritma program untuk memodelkan propagasi gelombang elektromagnetik pada ruang dua dimensi.

+ Menyusun sebuah aplikasi berbasis GUI untuk pemodelan propagasi gelombang berdasarkan algoritma yang dikembangkan.

+ Menganalisis dan memverifikasi hasil simulasi dari aplikasi yang telah dibuat terhadap aplikasi komersial serupa dan pengukuran lapangan.

+ Mendemonstrasikan penulisan program komputasi elektromagnetik dalam bahasa pemrograman Rust.

== Batasan Masalah

Pengembangan dan pengujian aplikasi ini dibatasi oleh beberapa batasan masalah:

+ Lingkungan yang disimulasikan adalah lingkungan dalam ruangan dengan input denah dua dimensi.
+ Frekuensi kerja pemancar yang disimulasikan adalah standar IEEE 802.11 dengan frekuensi 2.4 GHz dan 5 GHz dengan asumsi pola radiasi omnidireksional.
+ Simulasi dilakukan untuk menentukan daya dan rugi jalur antara pemancar dan penerima.
+ Fenomena gelombang elektromagnetik yang disimulasikan pada aplikasi adalah refleksi, transmisi, dan difraksi.

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
  #set par(leading: 1em, first-line-indent: 0em)

  #grid(
    columns: (1fr, 2fr),
    gutter: 5pt,
    inset: (y: 0.4em),
    [*BAB I*], [
      *PENDAHULUAN*

      Bagian ini berisi penjelasan umum seperti latar belakang, tujuan penulisan, batasan masalah, metodologi penulisan, serta sistematika penulisan ini sendiri.
    ],
    [*BAB II*], [
      *METODE _RAY TRACING_*

      Bagian ini berisi penjelasan tentang dasar bagaimana metode _ray tracing_ dapat memodelkan propagasi gelombang, prinsip-prinsip dasar _ray tracing_, metode _shooting and bouncing rays_, hingga prinsip _graphical optics_ dan _universal theory of diffraction_ yang mendasari kerja aplikasi yang dikembangkan dalam penelitian ini.
    ],
    [*BAB III*], [
      *METODE DAN PENULISAN PROGRAM*

      Bagian ini berisi penjelasan algoritma-algoritma yang digunakan pada program sebagai implementasi pemodelan _ray tracing_.
    ],
    [*BAB IV*], [
      *HASIL DAN ANALISIS SIMULASI*

      Bagian ini berisi tentang analisis hasil simulasi yang didapatkan oleh program dengan membandingkannya dengan simulasi perangkat lunak komersial dan kemudian dengan hasil pengukuran.
    ],
    [*BAB V*], [
      *KESIMPULAN DAN SARAN*

      Bagian ini berisi penutup dan kesimpulan terhadap simulasi yang telah dilakukan oleh aplikasi yang dibuat.
    ]
  )
]
