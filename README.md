# track_absence_sample_by_geolocator

Getting Started :

- flutter pub get

Aplikasi ini memiliki alur kerja sebagai berikut :

1. Pengguna masuk aplikasi
2. Pengguna diminta untuk mengizinkan permintaan akses lokasi device
3. Pengguna dapat melihat pin lokasi kantor
4. Aplikasi melacak lokasi GPS pengguna dan menampilkannya di peta
5. Pengguna mengkonfirmasi absensi
6. Jika jarak <= 50 meter, absensi di terima dan pesan di tampilkan
7. Jika jarak > 50, absensi ditolak dan pesan di tampilkan

Package yang digunakan:

- geolocator (Untuk melacak lokasi GPS dan menghitung jarak (meter) antara dua geocoordinates )
- google_maps_flutter (untuk menampilkan maps)
- get (untuk menampilkan snackbar)
