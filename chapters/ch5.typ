= Kesimpulan dan Saran

== Kesimpulan

Dari penelitian yang telah dilakukan dalam menyusun suatu algoritma _ray tracing_ untuk memodelkan propagasi gelombang elektromagnetik pada ruang 2 dimensi dan kemudian mengintegrasikannya ke pada sebuah program grafis, didapatkan beberapa poin kesimpulan sebagai berikut:

+ _Ray tracing_ (RT) dapat dikembangkan sebagai metode dalam pemodelan propagasi gelombang elektromagnetik pada ruang dengan mendasarkan representasi sinar untuk radiasi energi kepada prinsip optika geometris (_geometric optics_/GO), dimana metode asimtotik berbasis ekspansi Luneberg-Kline digunakan untuk menyederhanakan sifat gelombang dengan frekuensi tinggi ke bentuk sinar-sinar yang arahnya ditentukan oleh fungsi eikonal dari persamaan gelombang. Representasi garis ini kemudian diperkuat dengan menunjukkan bahwa vektor Poynting yang menunjukkan arah pergerakan energi elektromagnetik memiliki arah yang ditentukan oleh fungsi eikonal tersebut. Karena GO hanya mampu menjelaskan refleksi dan transmisi, maka GTD ataupun UTD kemudian diintegrasikan kedalam RT untuk memodelkan difraksi.

+ Penerapan RT sebagai metode pemodelan propagasi gelombang dimulai dengan mengimplmentasikan algorima _shooting and bouncing rays_ (SBR) untuk memenuhi ruang dengan sinar-sinar yang berasal dari sumber. Setelah informasi sinar-sinar pada ruang terkumpul menggunakan SBR, maka tahap selanjutnya adalah melakukan kalkulasi untuk setiap titik interaksi untuk menentukan koefisien refleksi, transmisi, dan difraksi dari masing-masing sinar. Medan total pada titik pengukuran adalah superposisi dari setiap sinar yang mencapai titik tersebut.

+ Pemrograman menggunakan bahasa Rust memudahkan untuk menulis aplikasi dengan performa tinggi dan integrasi terhadap _library_ grafis. Dalam perihal integrasi antara algoritma yang telah disusun dan antarmuka, program melakukan pengukuran setiap waktu di latar belakang untuk melakukan kalkulasi terhadap input-input parameter dan denah yang diberikan oleh pengguna.

+ Setelah berhasil disusun dan diintegrasikan, dilakukan pengujian program dengan perbandingan program komersial Altair FEKO dan juga pengukuran nyata. Pada perbandingan pada denah sederhana, yang memberikan kesalahan rata-rata sekitar 13% pada frekuensi 2.4 GHz maupun 5 GHz, terjadi peningkatan kesalahan pada area LOS yang diindikasikan sebagai implikasi dari geometri denah sebagai poligin tertutup. Sementara itu, pada perbandingan menggunakan denah nyata, kesalahan rata-rata berada pada 10.3% pada 2.4 GHz dan 9.2% pada 5 GHz, sesuai dengan dasar _ray-tracing_ sebagai pendekatan asimtotik frekuensi tinggi dimana pemodelan akan lebih akurat pada frekuensi yang lebih tinggi. Sedangkan pada perbandingan dengan pengukuran, pada frekuensi 2.4 GHz, aplikasi kesulitan untuk mengkalkulasi rugi jalur di area yang sulit dicapai oleh sinar, dimana tingkat kesalahan mencapai 40%, meskipun hal yang serupa juga terjadi pada FEKO. Kedua aplikasi memberikan hasil yang cukup, yaitu tingkat kesalahan hingga 10%, pada frekuensi 5 GHz.

== Saran

Setelah dilakukan penelitian dan pengukian aplikasi program yang disusun, beberapa saran yang dapat diberikan untuk mengembangkan aplikasi lebih lanjut ialah:

+ Mendalami pemodelan interaksi dengan dielektrik, karena bahan dielektrik berinteraksi dengan cara yang berbeda dengan dibanding konduktor, integrasi pemodelan dielektrik yang lebih matang dan menggunakan beberapa fenomena gelombang pada dielektrik seperti absorbsi dan gelombang permukaan, akan membantu dalam meningkatkan akurasi program. Pilihan lainnya juga termasuk menggunakan basis _physical optics_ (PO) dari pada GO yang lebih merepresentasikan sifat gelombang dari propagasi.

+ Integrasi algoritma pembelajaran mesin yang dapat menentukan posisi titik akses agar memiliki cakupan terbaik akan menambah nilai guna dan kepraktisan dari program aplikasi yang disusun.

+ Kode program yang ditulis belum merupakan kode yang teroptimisasi sepenuhnya dan juga belum disesuaikan untuk paralelisasi, yang dapat meningkatkan performa program lebih jauh lagi jika program dapat dijalankan pada pemroses grafis (GPU), Hal ini dikarenakan kode-kode tersebut masih berupa implementasi secara langsung dari persamaan-persamaan dan algoritma.