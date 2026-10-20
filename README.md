# RuangKelasku

Clone Google Classroom untuk UTS mata kuliah Pemrograman Aplikasi Bergerak.

| Nama                   | NIM         |
| ---------------------- | ----------- |
| Rafi Ramadhana Bukaryo | 24051214180 |
| Danella Andritya Putri | 24051214205 |
| Haikal Ahmad El Salman | 24051214207 |
| Revo Novandra          | 24051214211 |

## Google Classroom → RuangKelasku

Tata letak, navigasi, dan label mengikuti Google Classroom versi Indonesia. Nama, logo, warna, dan maskot
(Ruki) milik RuangKelasku.

| Google Classroom                         | RuangKelasku                                                       |
| ---------------------------------------- | ------------------------------------------------------------------ |
| Kelas, kode kelas, tema header           | Sama; 8 tema header dengan pola geometris buatan sendiri           |
| Forum, Tugas Kelas, Anggota, Nilai       | Sama, dengan urutan tab yang sama                                  |
| Tugas, Materi, Tugas kuis (Google Forms) | Tugas, Materi, dan kuis pilihan ganda bawaan yang dinilai otomatis |
| Lampiran Google Drive                    | Storage Laravel sendiri (maks. 10 MB per file)                     |
| Daftar tugas dan Perlu diperiksa         | Sama, lintas kelas                                                 |
| Notifikasi push dan email                | Notifikasi di dalam aplikasi (polling)                             |
| Login akun Google                        | Email dan password (Laravel Sanctum)                               |

## Struktur

| Folder     | Isi                                                     |
| ---------- | ------------------------------------------------------- |
| `backend/` | Laravel REST API + MySQL (Laragon)                      |
| `mobile/`  | Flutter untuk Android dan Chrome                        |
| `docs/`    | Product brief, ERD, spesifikasi API, arsitektur, desain |

## Menjalankan

Prasyarat: Laragon (PHP 8.3+, MySQL), Composer, Flutter stabil.

### Backend

```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
# Buat database `ruangkelasku` di MySQL Laragon
php artisan migrate --seed
php artisan storage:link
php artisan serve --host=0.0.0.0 --port=8000
php artisan schedule:work   # terminal terpisah, untuk posting terjadwal
```

### Akun demo

Dibuat oleh `php artisan migrate --seed`; semua memakai password `password`.

| Peran | Email                                                                                                                             |
| ----- | --------------------------------------------------------------------------------------------------------------------------------- |
| Guru  | `rina@ruangkelasku.test`                                                                                                          |
| Siswa | `dimas@ruangkelasku.test`, `sari@ruangkelasku.test`, `budi@ruangkelasku.test`, `ayu@ruangkelasku.test`, `rizky@ruangkelasku.test` |

### Mobile

```bash
cd mobile
flutter pub get
dart run build_runner build -d
flutter run -d chrome          # API di localhost:8000
flutter run -d emulator-5554   # API di 10.0.2.2:8000
```
