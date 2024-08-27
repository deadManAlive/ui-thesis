= Pendahuluan <intro>

== Latar Belakang

Dikutip Dikutip dari laporan survei tahunan Asosiasi Penyelenggara Jasa Internet Indonesia (APJII), penetrasi internet di Indonesia mengalami peningkatan setiap tahunnya, melewati angka 70% pada 2019-2020 dan mendekati 80% pada 2023. Sumber yang sama juga menunjukkan bahwa meskipun akses internet masih didominasi oleh akses internet via jaringan seluler (di atas 70%), proporsi pengguna yang menggunakan akses Wi-Fi dan berlangganan internet _fixed_ juga meningkat setiap tahunnya. Hal ini belum memperhitungkan penggunaan internet _fixed_ di dunia UMKM dan korporasi dimana lebih dari 70%-nya berlangganan (2023).

Peningkatan pengguna internet _fixed_ tersebut tentunya akan diiringi dengan peningkatan kebutuhan atas struktur/infrastruktur pendukung, salah satunya adalah _access point_ (AP), sebagai perangkat yang menyediakan sambungan internet melalui jaringan lokal nirkabel (WLAN). Pada penggunaan perumahan kecil serta UMKM dengan harapan _coverage_ jaringan internet cukup sederhana serta fungsi internet yang non-kritis, penempatan AP merupakan masalah trivial. Hal sebaliknya terjadi ketika koneksi nirkabel dibutuhkan pada situs yang kompleks atau dengan fungsi internet kritis yang membuat dibutuhkannya perencanaan penempatan AP yang matang agar infrastruktur bekerja optimal dan mampu menyediakan koneksi tanpa kesulitan yang berarti, sebagai contoh pada penggunaan korporasi kantoran, institusi pemerintahan, dan akademik.

Dalam kondisi-kondisi tersebut, adanya _dead zone_ di area yang tidak diinginkan atau sekedar nilai kekuatan sinyal yang tidak mencukupi dapat membuat pemanfaatan jaringan pada bangunan menjadi sub optimal, yang tentunya tidak diinginkan terjadi di lingkungan komersial. Oleh karena itu, dibutuhkan penempatan AP yang terencana bahkan hal tersebut dapat menjadi salah satu acuan dalam tahap desain konstruksi bangunan.

Terdapat berbagai macam cara yang dapat dilakukan untuk perencanaan tersebut, contoh yang sederhana adalah menggunakan model empiris, seperti dalam kondisi _indoor_ diantaranya dapat digunakan ITU-R P.1238-9 (pemodelan propagasi dalam ruangan) dan model _path loss_ log-jarak. Kedua model tersebut mengestimasi _path loss_ sebagai fungsi dari jarak, frekuensi, dan sebagainya. @hello merupakan pemodelan ITU-R P.1238-9 dimana _path loss_ $L$ merupakan fungsi dari _path loss_ pada jarak referensi $L_0$, koefisien _power loss_ $N$, jarak $d$, jarak referensi $d_0$, dan faktor _penetration loss_ untuk $n$ lantai pada frekuensi tertentu $L_f (n)$. Sementara itu, pada pemodelan _path loss_ log-jarak pada persamaan 1.2, $gamma$ adalah eksponen _path loss_ dan $chi$ adalah variabel acak normal (Gaussian) yang menggambarkan atenuasi akibat _fading_.

#figure(
  $
    L=L_0 + N log_10 d/d_0 + L_f (n)
  $,
  caption: [Apa ni],
  kind: "Equation",
  supplement: [Persamaan],
  gap: 1.5em
) <hello>

$
  L=L_0 + 10 gamma log_10 d/d_0 + chi
$