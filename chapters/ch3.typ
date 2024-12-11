#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#codly(languages: codly-languages)

#set raw(block: true)
#show raw: set text(size: 8pt)

#let bup(v) = [$bold(upright(#v))$]

= Penulisan Program

== Alur Perancangan Program

#figure(
  image("assets/workflow.png"),
  placement: none, caption: [Diagram alur perancangan aplikasi]
)

Secara garis besar, perancangan aplikasi ini terdiri dari dua tahap, yaitu: 1). Penyusunan kerangka aplikasi dan kerangka algoritma, serta 2). Pemodelan materi, _ray tracing_, dan validasi. Pembagian ke dalam tahap-tahap tersebut didasarkan kepada tingkat kesulitan dalam implementasi dan perbedaan dalam topik pembahasan secara umum. Secara kronologis, perancangan aplikasi dimulai dari studi literatur, kemudian penulisan kerangka pemrograman, penulisan pemodelan material, dan diakhiri dengan validasi.

Studi literatur dilakukan pertama kali (dan berlanjut selama penulisan program) untuk hal terkait teori dasar yang mendasari propagasi gelombang, metode sinar sebagai pendekatan solusi propagasi gelombang, serta fenomena-fenomena gelombang yang dapat dimodelkan dengan metode sinar. Selain itu, studi literatur juga dilakukan dalam mempersiapkan _environment_ pemrograman diantaranya adalah pemrograman grafis, pemodelan geometri dalam pemrograman, dasar pemrograman itu sendiri, dan sebagainya.


Bagian utama dari tahap pertama adalah penulisan kerangka GUI program, geometri program, termasuk implementasi berbagai operasi matematika terutama operasi vektor, dan kemudian diakhiri dengan penulisan algoritma dasar SBR yaitu bagian algoritma yang bertanggung jawab dalam peluncuran sinar (_ray launcing_). Pemodelan refleksi dan refraksi dapat diintegrasikan pada tahap ini karena sifatnya yang linier (mengubah arah/magnitudo satu sinar).

Tahap kedua dalam penulisan program ini berfokus kepada integrasi GTD ke dalam program untuk memodelkan difraksi gelombang. Pada tahap ini, dilakukan perhitungan terhadap koefisien refleksi, refraksi, difraksi, dan atenuasi ruang. Tahap ini kemudian akan diuji dengan validasi terhadap aplikasi komersial Altair FEKO, dan dilakukan penyesuaian model agar mencapai tingkat validasi yang mencukupi. Perbandingan dilakukan dengan cara membandingkan hasil simulasi aplikasi yang dirancang dengan simulasi FEKO pada ukuran geometri dan parameter material dan gelombang yang sama.

=== _Environment_ Pemrograman

#figure(
    image("assets/benchmark.png"),
    caption: [Perbandingan performa algoritma SBR pada Rust, C, Python, dan PyPy]
) <benchies>

Pemilihan _environment_ pemrograman dilakukan untuk mempertimbangkan bagaimana aplikasi akan ditulis, seperti memutuskan jenis aplikasi, bahasa pemrograman, _framework_, dan sebagainya. Dalam hal ini, penulis memutuskan untuk menulis aplikasi _native_ (non web) untuk memaksimalkan performa dari aplikasi. Setelah mempertimbangkan beberapa bahasa pemrograman, penulis memutuskan untuk menggunakan bahasa Rust yang memiliki performa _native_ tanpa _garbage collector_ seperti C dan C++ tetapi memiliki keamanan memori seperti Java dan Python. Untuk _framework_ pembantu, penulis memutuskan hanya menggunakan _library_ grafis dan menulis bagian lainnya, termasuk model dan objek geometri dari nol.

@benchies menunjukkan perbandingan performa antara beberapa bahasa pemrograman untuk mengimplementasikan algoritma _shooting and bouncing rays_ sederhana dari @pseudosbr. Dapat dilihat bahwa Rust jauh lebih efisien dari Python dan bahkan memiliki rerata yang sedikit lebih baik dari C. Sisi performa dari Rust menjadi salah satu dari beberapa justifikasi untuk menulis program di bahasa tersebut, disamping _type safety_, _memory safety_, dan _developer experience_ yang akan sangat membantu dalam penyusunan program.

#figure(
    align(left)[
        #set math.equation(numbering: none)
        #pseudocode-list[
        + $bup(o)_0 = mat(0, 0)$
        + *for each* $i = 1,2,...,128$ *do*
            + $bup(d)_0 = mat(cos (i slash 127), sin (i slash 127))$
            + *for each* $j = 1,2,...,32$ *do*
                + *SBR*. $bup(o)$ origin, $bup(d)$ direction
                - $ {(bup(o)_j, bup(d)_j) |
                   (bup(s), bup(e)) in RR^2 times RR^2, \
                   bup(w) = bup(e) - bup(s),
                   bup(p)_1 = bup(s) - bup(o)_(j-1),
                   bup(p)_2 = -bup(d)_(j-1),
                   bup(p)_3 = "Rot"_(pi slash 2)(bup(w)), \
                   bup(o)_j = bup(s) + norm(bup(p)_2 times bup(p)_1)/(bup(p)_2 dot bup(p)_3) dot (bup(w)), \
                   bup(d)_j = "Refl"_(angle bup(w))(bup(d)_(j-1))} $
            + *end*
        + *end*
        ]
    ],
    supplement: [Algoritma],
    caption: [Algoritma perulangan SBR sederhana]
) <pseudosbr>

== Konfigurasi dan _Shooting and Bouncing Rays_

#figure(
  image("assets/prog.png"),
  caption: [Diagram alir algoritma program secara umum]
) <prog>

@prog merupakan diagram alir yang menunjukkan alur umum dari algoritma aplikasi. Program dapat dibagi atas alur utama (kiri) yang terdiri dari interaksi dengan pengguna dan perhitungan, sedangkan algoritma _shooting and bouncing rays_ (SBR) yang mengintegrasikan perhitungan refleksi, refraksi, dan difraksi oleh setiap sinar ke dalam alurnya sendiri, yang dipanggil untuk setiap segmen sinar. Karena menggunakan framework grafis egui yang bekerja pada mode _immediate_, maka alur di atas akan dipanggil untuk setiap frame yang akan ditampilkan.

=== Konfigurasi

Seperti yang telah dijelaskan sebelumnya, penulisan aplikasi hanya menggunakan library grafis, sementara berbagai macam komponen geometri dan algoritma ditulis dari nol. Kode Sumber 3.1 menunjukkan konfigurasi proyek dimana dependencies berisi library yang dibutuhkan. Terlihat bahwa library yang dibutuhkan hanya egui-macroquad untuk menggambar antarmuka dengan pengguna, image yang berguna untuk memproses gambar, dan macroquad sebagai library utama untuk menggambar berbagai objek dalam aplikasi. egui-macroquad sendiri sebenarnya adalah library yang membantu dalam mengintegrasikan egui sebagai penyedia antarmuka pengguna (seperti tombol dan teks), dengan macroquad, dengan pembagian seperti pada @apppart. Bagian profile.release sendiri mengatur optimasi compiler untuk mengompilasi kode dengan target performa tertinggi.

#figure(
    ```toml
    # Cargo.toml

    [package]
    name = "fray"
    version = "0.1.0"
    edition = "2021"

    [dependencies]
    egui-macroquad = "0.15.0"
    image = "0.24.7"
    macroquad = "0.3.26"

    [profile.release]
    opt-level = 3
    lto = true
    codegen-units = 1
    panic = 'abort'
    strip = true
    ```,
    caption: [Konfigurasi proyek Rust]
)

#figure(image("assets/pro1.png", width: 80%), caption: [Tampilan GUI aplikasi dengan pembagian egui (kotak merah terang) dengan macroquad (batas biru)]) <apppart>

=== Inisiasi Awal Aplikasi

#figure(
    ```rust
    #![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

    use std::f32::consts::PI;

    use egui_macroquad::{
        egui::{Align, Align2, Button, Layout, Slider, Window},
        ui,
    };
    use fps::{FrameTimeCounter, FrameTimeTank};
    use interaction::Hideable;
    use macroquad::prelude::*;
    use objects::{Drawable, Polygon, Segment, Vector};
    use receiver::generate_tx_array;
    use reception_sphere::{point_projection, project};

    mod fps;
    mod icon;
    mod interaction;
    mod objects;
    mod plot;
    mod receiver;
    mod reception_sphere;
    mod sbr;
    ```,
    caption: [Konfigurasi dan impor beberapa modul]
) <initmain>

\

Seperti yang terlihat pada @initmain, kode utama aplikasi ini (_file_ `main.rs`) diawali dengan konfigurasi yang mengatur bahwa aplikasi adalah aplikasi GUI, sehingga aplikasi tidak akan menampilkan console ketika aplikasi dijalankan. Setelah itu, konstanta pi di-import bersama beberapa objek UI dari egui-macroquad. Konstanta dan objek-objek UI tersebut di-import karena akan sering digunakan pada modul main ini. Setelah itu, modul-modul aplikasi serta objek-objek yang akan digunakan di dalamnya diimpor.

Setelah melakukan konfigurasi dan inisiasi modul, berikutnya adalah definisi fungsi ```rs main()``` yang menjadi fungsi utama yang dipanggil ketika aplikasi dijalankan. @mainvars menampilkan bahwa fungsi ini diawali dengan inisiasi variabel-variabel yang menampung nilai input dari pengguna, sehingga digunakan let mut agar dapat menampung nilai input yang berubah-ubah. Sementara itu, variabel `tx` dan `rx` adalah variabel yang masing-masing menyimpan posisi sumber dan penerima, yang kemudian diwrap dalam objek Hideable dari modul `interaction` agar dapat ditampilkan dan dihilangkan sesuai kebutuhan. Fungsi `set_camera` digunakan untuk mengatur tingkat _zoom_ dan rasio aspek dari GUI. Tahap inisiasi ini diakhiri dengan inisiasi objek `FrameTimeTank` dari modul `fps` yang berguna untuk menyimpan larik data FPS untuk diukur rata-ratanya.

#figure(
    ```rust
    #[macroquad::main(window_conf)]
    async fn main() {
        let mut offset = 10.0;
        let mut ray_number = 1;
        let mut iter = 3;
        let mut show_array = false;
        let mut ray_tank = Vec::with_capacity(MAX_RAYS as usize);
        #[allow(unused_mut)]
        let mut ray_select: i32 = -1;
        let mut refl_select: i32 = -1;
        let mut rec_rad: f32 = 0.0;
        let mut walls_selector = Walls::First;
        #[cfg(debug_assertions)]
        let mut projection = String::new();

        let tx = Vector::new(-0.0, 0.0);
        let rx = Vector::new(0.0, 0.0);

        #[cfg(debug_assertions)]
        let mut tx = Hideable::new(tx).debug();

        #[cfg(not(debug_assertions))]
        let mut tx = Hideable::new(tx);
        let mut rx = Hideable::new(rx);

        set_camera(&Camera2D {
            zoom: vec2(1., screen_width() / screen_height()),
            ..Default::default()
        });

        let mut timetank = FrameTimeTank::new();
        // ...
    ```,
    caption: [Inisiasi variabel-variabel aplikasi]
) <mainvars>

=== _Loop_ Utama Program

Seperti yang disinggung di atas bahwa aplikasi menggunakan GUI dengan mode _immediate_, maka setiap frame yang ditampilkan berasal dari pengulangan (_loop_) suatu urutan perintah tertentu. Pengulangan ini terdiri atas empat bagian yaitu
+ Inisiasi variabel perulangan
+ Pemanggilan fungsi update dari modul `interaction` yang menerima pembaharuan parameter-parameter dan meluncurkan SBR
+ Pengaturan ulang komponen-komponen GUI
+ Menggambar ulang objek-objek GUI
Kode Sumber 3.4 menunjukkan potongan kode bagian-bagian dari loop utama ini.

#figure(
    ```rs
    loop {
        let avg_fps = timetank.get_avg_fps();
        let _timecounter = FrameTimeCounter::new(&mut timetank);

        let walls = match walls_selector {
            Walls::First => &walls1,
            Walls::Second => &walls2,
            Walls::Third => &walls3,
        };

        // ...

        clear_background(BLACK);
        plot::draw_grid(0.05, DARKGRAY, 0.001, 5, 0.002);

        ui(|ctx| {
            ray_tank = interaction::update(
                &mut tx,
                &mut rx,
                walls,
                &offset,
                ctx.is_pointer_over_area(),
                ray_number,
                iter,
            );

            Window::new("Options");
            // ...
        });
        
        walls.draw(0.005, RED);
        tx.draw_hidable(0.01, YELLOW);
        rx.draw_hidable(0.01, BLUE);

        // ...

        egui_macroquad::draw();

        next_frame().await
    }
    ```,
    caption: [Potongan kode perulangan utama (_main loop_)]

)

\

Pada potongan kode di atas, `FrameTimeCounter` merupakan objek dari modul fps yang berguna dalam menghitung waktu eksekusi dari setiap perulangan, dengan memanfaatkan aturan _lifetime_ dari bahasa pemrograman Rust. walls adalah variabel yang menyimpan data reflektor dinding berdasarkan pilihan yang ada, sementara dua ekspresi berikutnya merupakan langkah untuk menggambar plot Kartesius. Fungsi ui merupakan fungsi yang menerima _closure_ yang berisi konfigurasi objek-objek UI seperti teks, tombol, dan _slider_. Tahap selanjutnya adalah menggambar komponen-komponen UI dan diakhiri dengan memanggil _frame_ selanjutnya.

=== Fungsi ```rs intersection::update``` Sebagai Inisiator _Ray Tracing_

Fungsi `update` dari modul `interaction` merupakan fungsi yang menjembatani antara mekanisme antarmuka GUI dengan algoritma ray tracing. Dapat dilihatd ari _signature_ fungsi tersebut bahwa fungsi ini menerima posisi tx, posisi rx, data poligon yang merepresentasikan reflektor dinding, sudut dari sinar-sinar yang akan dipancarkan, kondisi terkait apakah kursor berada di atas panel egui atau tidak, jumlah sinar yang akan diluncurkan dari sumber, serta batas jumlah iterasi pada SBR. Fungsi mengembalikan data berupa ```rs Vec<Vec<Segment>>``` yang menunjukkan bahwa fungsi ini mengembalikan hasil kalkulasi segmen melalui SBR untuk setiap sinar.

#figure(
    ```rs
    pub fn update(
        tx: &mut Hideable<Vector>,
        rx: &mut Hideable<Vector>,
        walls: &Polygon,
        offset: &f32,
        mouse_over_panel: bool,
        ray_number: u32,
        iter: u32,
    ) -> Vec<Vec<Segment>> {
        let mut ray_tank = Vec::with_capacity(ray_number as usize);

        if !mouse_over_panel {
            // ... 
        }

        if tx.visible {
            for a in (1..=ray_number).map(|n| n as f32 * 360.0 / ray_number as f32) {
                let offset = (offset * 360.0) / (ray_number as f32 * 100.0);
                let bouncing =
                    bouncing((tx.x, tx.y), walls, &((offset + a) % 360.), iter);
                ray_tank.push(bouncing);
            }
        }

        ray_tank
    }
    ```,
    caption: [Fungsi `update` dari modul `interaction`]
) <updatefunc>

\

Dari @updatefunc dapat dilihat bahwa fungsi update dimulai dengan menginisiasi sebuah kontainer yang menampung sinar-sinar hasil kalkulasi melalui SBR. Pengecekan terhadap kondisi kursor di atas panel kemudian dilakukan untuk menghindari pemosisian tx atau rx dari atas panel input. Kemudian, dilakukan iterasi untuk setiap nilai sudut yang diperoleh dari membagi lingkaran penuh terhadap jumlah sinar. Untuk setiap sudut, kemudian dilakukan operasi SBR dengan memanggil fungsi _bouncing_ dari modul `sbr`. Fungsi tersebut mengembalikan segmen-segmen sinar hasil SBR dengan input posisi sumber, informasi reflektor, sudut peluncuran sinyal, dan batas iterasi. Segmen-segmen sinar inilah yang dikumpulkan ke dalam kontainer di awal, dimana di akhir fungsi `update` ini, kontainer tersebut akan dikembalikan.

=== _Shooting Rays_

Inti dari algoritma _ray tracing_ pada aplikasi ini berada pada metode SBR yang digunakan untuk meluncurkan sinar dan mengalkulasi parameter pada setiap insiden. SBR, sebagaimana telah dijelaskan sebelumnya, merupakan metode _ray tracing_ dimana sinar yang diluncurkan dari sumber dibiarkan berinteraksi dengan lingkungan melalui fenomena seperti refleksi, refraksi, difraksi, atau pun fenomena lainnya yang dapat dimodelkan oleh program. SBR, terutama dalam kasus ini, penulis temukan dapat dibagi menjadi dua algoritma independen, yaitu:

+ *Shooting*: Yang berfungsi untuk meluncurkan sebuah sinar tunggal dengan parameter posisi sumber dan sudut peluncuran. Posisi sumber disini dapat berupa sumber tx ataupun sumber sinar dari refleksi, refraksi, maupun difraksi.
+ *Bouncing*: Karena satu segmen sinar pantulan dipengaruhi oleh hasil dari peluncuran sebelumnya, maka algoritma bouncing dapat berlaku sebagai akumulator dari hasil shooting sebelumnya. Oleh karena itu, bouncing dapat diimplementasikan sebagai sebuah algoritma rekursif.

#figure(
    image("assets/sbr.png"),
    caption: [Ilustrasi SBR dengan memisahkan _shooting_ dan _bouncing_.]
) <sbrtec>

@sbrtec membantu mengilustrasikan tahapan dari algoritma ini, shooting hanya akan bertanggung jawab dalam menentukan antara sinar dengan reflektor selanjutnya, dengan input sumber sinar saat ini dan sudut peluncuran sinar. Sementara itu, bouncing akan melakukan akumulasi, perhitungan sudut peluncuran, pemanggilan shooting untuk titik sumber dan sudut yang baru.

@sbrshoot merupakan kode dari algoritma _shooting_. Fungsi ini dimulai dengan menginisiasi sebuah sinar pada sudut yang telah diberikan. Kemudian, dilakukan iterasi untuk setiap reflektor (segmen dinding) yang ada untuk menemukan reflektor yang berpotongan dengan sinar. Karena proses tersebut dapat memberikan beberapa keluaran, maka diambil reflektor yang berpotongan terdekat dengan sumber sinar sebagai reflektor hasil. Keluaran fungsi berupa titik potong sinar dengan reflektor terdekat tersebut. Fungsi akan memberikan keluaran `None` jika sinar tidak memotong setidaknya satu reflektor (dalam kasus sinar menuju keluar dari area simulasi).

#figure(
    ```rs
    pub fn shooting(
        tx: (f32, f32),
        walls: &Polygon,
        offset: &f32
    ) -> Option<(f32, f32)> {
        let m = offset * PI / 180.0;
        let ray = Ray::new(tx.into()).set_dir_from_angle(m);

        walls
            .iterate_segments()
            .filter_map(|segment| ray.intersect(segment))
            .min_by(|&a, &b| a.dist(&tx.into()).partial_cmp(&b.dist(&tx.into())).unwrap())
            .map(|z| z.into())
    }
    ```,
    caption: [Fungsi `shooting` dari modul `sbr`]
) <sbrshoot>

#let bud(r) = [$dash(bup(#r))$]

_Method_ `intersect` dari struktur `objects::Ray` yang digunakan untuk menemukan titik perpotongan antara suatu sinar dan segmen reflektor bekerja menggunakan operasi vektor, secara umum berupa implementasi dari @pseudosbr. Misalkan sinar suatu sinar didefinisikan sebagai

$ bud(r)(t) = bup(o) + t bup(d), quad t>= 0 $

dimana $bup(o)$ vektor yang menunjukkan titik asal sinar dan $bup(d)$ vektor yang menunjukkan arah sinar. Sedangkan sebuah reflektor, berupa segmen garis didefinisikan sebagai

$ bud(w)(t) = (1-t)bup(s) + t bup(e), quad 0 <= t <= 1 $

dimana $bup(s)$ vektor yang menunjukkan titik awal segmen dan $bup(e)$ vektor yang menunjukkan titik akhir garis. @isect merupakan implementasi algoritma tersebut pada program.

#figure(
    ```rs
    pub fn intersect(&self, segment: &Segment) -> Option<Vector> {
        let v1 = self.start.add(&segment.start.neg());
        let v2 = segment.start.add(&segment.end.neg());
        let v3 = Vector::new(-self.direction.y, self.direction.x);

        let dot = v2.dot(&v3);
        if dot.abs() < 0.000001 {
            return None;
        }

        let t1 = v2.cross(&v1) / dot;
        let t2 = (v1.dot(&v3)) / dot; // ?

        if t1 >= 0.0 && (-1.0..=0.0).contains(&t2) {
            let res = Some(
                self.start
                    .add(&(t1 * self.direction.x, t1 * self.direction.y).into()),
            );
            return res;
        }

        None
    }
    ```,
    caption: [Fungsi `intersect` dari struktur `Ray` untuk menemukan perpotongan antara suatu sinar dan segmen]
) <isect>


=== _Bouncing Rays_

Bagian kedua dari implementasi SBR pada aplikasi ini adalah algoritma _bouncing_ yang bertindak sebagai akumulator dari algoritma _shooting_ pada jumlah iterasi yang berhingga. Secara garis besar, fungsi ini bekerja dengan cara sebagai berikut:
+ Misal bouncing dibatasi oleh jumlah iterasi $N$, maka operasi dilakukan atas nilai-nilai $n=0,1,2,…,N-1$.
+ Menggunakan fungsi `scan`, yaitu fungsi tingkat tinggi semacam `map` tetapi mengakumulasi data dari iterasi sebelumnya.
+ Setiap iterasi mengakumulasi posisi sumber sinar, sudut peluncuran, dan reflektor sinar. Informasi reflektor sinar dibutuhkan untuk menghindari perpotongan antara sinar dengan reflektor yang menjadi titik asal.
+ Dalam iterasi tersebut, dilakukan _shooting_ untuk menemukan titik sumber selanjutnya, reflektor yang dipotong untuk dieliminasi dari informasi reflektor selanjutnya, serta sudut sinar refleksi untuk _shooting_ selanjutnya.
+ Informasi sinar dari setiap iterasi tersebut kemudian diakumulasi untuk menjadi jalur sinar hasil.
+ Fungsi _bouncing_ mengembalikan objek tersebut.

Secara umum, algoritma ini merupakan implementasi konkrit dari @sbrtec. Potongan yang menunjukkan kerja fungsi ini secara umum dapat dilihat pada @bouncing.

#figure(
    ```rs
    pub fn bouncing(
        tx: (f32, f32),
        walls: &Polygon,
        offset: &f32, iter: u32
    ) -> Vec<Segment> {
        let res = (0..iter)
            .scan((tx, *offset, None), |state, _| {
                let state_tx = state.0;
                let state_offset = state.1;
                let state_filtered_wall_index = state.2;

                let curr_refl = // conditional shooting...

                let n_idx = // get next reflecting wall index...
                let rslope = // get next reflecting wall slope...
                let next_offset = // get next ray direction

                *state = (curr_refl, next_offset, Some(n_idx));

                Some(*state)
            })
            .map(|(p, _, _)| p)
            .collect::<Vec<_>>();

        let res = Polygon::new_open([vec![tx], res].concat());

        res.segments
    }
    ```,
    caption: [Potongan kode dari fungsi `bouncing` dari modul `sbr`]
) <bouncing>

== Tampilan Aplikasi

#figure(image("assets/Picture5.png", width: 80%), placement: none, caption: [Tampilan awal aplikasi])

#figure(image("assets/Picture6.png", width: 80%), placement: none, caption: [Tampilan aplikasi dengan sebuah konfigurasi])

#figure(image("assets/Picture7.png", width: 80%), placement: none, caption: [Tampilan dengan konfigurasi lainnya, dan titik penerima serta array penerima tampak])