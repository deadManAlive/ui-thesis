#let abstract_id = (
  abstract: [
    Pada penelitian ini, telah dikembangkan aplikasi grafis untuk memodelkan propagasi gelombang radio pada frekuensi umum Wi-Fi 2.4 GHz dan 5 GHz. Algoritma yang dikembangkan memodelkan propagasi gelombang radio pada denah ruang dua dimensi melalui pendekatan _Ray Tracing_ (RT) dengan metode _Shooting and Bouncing Rays_ (SBR) dengan pemodelan refleksi dan transmisi yang berbasis kepada prinsip _Geometrical Optics_ (GO) bersama pemodelan difraksi berbasis yang berbasis kepada _Geometric Theory of Diffraction_ (GTD) untuk melakukan prediksi terhadap daya yang diterima dan rugi jalur.

    Aplikasi diimplementasikan dalam bentuk program yang ditulis dengan bahasa pemrograman modern Rust dan berbasis pada suatu objek segmen garis dua dimensi yang merepresentasikan jalur sinar antara dua titik serta interaksi-interaksinya terhadap objek penghalang pada ruang, yang direpresentasikan dalam segmen-segmen garis dinding. Program yang diimplementasikan berhasil memprediksi rugi jalur pada denah dengan geometri sederhana dan denah gedung dengan tingkat kesalahan rata-rata dibawah 20%, baik untuk pengujian pada frekuensi 2.4 GHz maupun 5 GHz, terhadap aplikasi komersial FEKO. Pada pengujian terhadap pengukuran lapangan, program bekerja cukup baik pada frekuensi 5 GHz, meskipun pada 2.4 GHz program komersial juga menampakkan nilai kesalahan yang relatif cukup besar.
  ],
  keywords: (
    "_access point_",
    "pemodelan propagasi",
    "aplikasi GUI",
    "_ray tracing_",
    "_shooting and bouncing rays_",
    "RSSI")
)

#let abstract_en = (
  abstract: [
    In this study, a graphical software has been developed to model radio frequency propagation, especially in common Wi-Fi frequencies of 2.4 GHz and 5 GHz. The developed algorithm models radio frequency propagation for a 2-dimensional floorplan environment by ray tracing approach with shooting and bouncing rays (SBR) method, reflection and transmission modelling based on Geometrical Optics (GO) principle, and diffraction modelling based on Geometric Theory of Diffraction (UTD) with goal to predict the perceived power and path loss at some points in the modelled room.

    The application implemented as a computer program written in bleeding edge Rust language and based on a line segment object in 2D space representing ray path between two points and its interactions with obstacles in the space, represented as wall line segments. The implemented program is able to predict the path loss of a floorplan with simple geometric arrangement and so real floorplan with error rate under 20% from several point in the room, for both 2.4 and 5 GHz frequencies, against comercial FEKO. In measurement test, the program works sufficiently in 5 GHz, while the comercial software also struggle at some point in 2.4 GHz.
  ],
  keywords: (
    "access point",
    "propagation modelling",
    "GUI application",
    "ray tracing",
    "shooting and bouncing rays",
    "RSSI"
  )
)