= Kesimpulan dan Saran

== Kesimpulan

Dari penelitian yang telah dilakukan dalam menyusun suatu algoritma _ray tracing_ untuk memodelkan propagasi gelombang elektromagnetik pada ruang 2 dimensi dan kemudian mengintegrasikannya ke pada sebuah program grafis, didapatkan beberapa poin kesimpulan sebagai berikut:

+ _Ray tracing_ (RT) dapat dikembangkan sebagai metode dalam pemodelan propagasi gelombang elektromagnetik pada ruang dengan mendasarkan representasi sinar untuk radiasi energi kepada prinsip optika geometris (_geometric optics_/GO), dimana metode asimtotik berbasis ekspansi Luneberg-Kline digunakan untuk menyederhanakan sifat gelombang dengan frekuensi tinggi ke bentuk sinar-sinar yang arahnya ditentukan oleh fungsi eikonal dari persamaan gelombang. Representasi garis ini kemudian diperkuat dengan menunjukkan bahwa vektor Poynting yang menunjukkan arah pergerakan energi elektromagnetik memiliki arah yang ditentukan oleh fungsi eikonal tersebut. Karena GO hanya mampu menjelaskan refleksi dan transmisi, maka GTD ataupun UTD kemudian diintegrasikan kedalam RT untuk memodelkan difraksi.

+ Penerapan RT sebagai metode pemodelan propagasi gelombang dimulai dengan mengimplmentasikan algorima _shooting and bouncing rays_ (SBR) untuk memenuhi ruang dengan sinar-sinar yang berasal dari sumber. Setelah informasi sinar-sinar pada ruang terkumpul menggunakan SBR, maka tahap selanjutnya adalah melakukan kalkulasi untuk setiap titik interaksi untuk menentukan koefisien refleksi, transmisi, dan difraksi dari masing-masing sinar. Medan total pada titik pengukuran adalah superposisi dari setiap sinar yang mencapai titik tersebut.

+ Pemrograman menggunakan bahasa Rust memudahkan untuk menulis aplikasi dengan performa tinggi dan integrasi terhadap _library_ grafis. Dalam perihal integrasi antara algoritma yang telah disusun dan antarmuka, program melakukan pengukuran setiap waktu di latar belakang untuk melakukan kalkulasi terhadap input-input parameter dan denah yang diberikan oleh pengguna.

+ Setelah berhasil disusun dan diintegrasikan, dilakukan pengujian program dengan perbandingan program komersial Altair FEKO dan juga pengukuran nyata. Pada pengujian denah sederhana, program berhasil mencapai tingkat akurasi di bawah 20%, meskipun program terlihat mengalami kesulitan dalam memprediksi LOS. Karena pada pengujian berikutnya program juga berhasil memodelkan dengan kesalahan rata-rata dibawah 20%, tetapi tanpa peningkatan kesalahan pada wilayah LOS, dapat diimplikasikan bahwa masih terdapat situasi dimana simulasi sensitif terhadap frekuensi karena objek pada denah sederhana lebih kecil dari pemodelan denah nyata (lanatai 1 gedung 2 DTE FTUI).

== Saran

Setelah dilakukan penelitian dan pengukian aplikasi program yang disusun, beberapa saran yang dapat diberikan untuk mengembangkan aplikasi lebih lanjut ialah:

+ Mendalami pemodelan interaksi dengan dielektrik, karena bahan dielektrik berinteraksi dengan cara yang berbeda dengan dibanding konduktor, integrasi pemodelan dielektrik yang lebih matang akan membantu dalam meningkatkan akurasi program.

+ Integrasi algoritma pembelajaran mesin yang dapat menentukan posisi titik akses agar memiliki cakupan terbaik akan menambah nilai guna dan kepraktisan dari program aplikasi yang disusun.

+ Karena berupa implementasi secara langsung dari persamaan-persamaan dan algoritma, kode program yang ditulis belum merupakan kode yang teroptimisasi sepenuhnya dan juga belum disesuaikan untuk paralelisasi, yang dapat meningkatkan performa program lebih jauh lagi jika program dapat dijalankan pada pemroses grafis (GPU).