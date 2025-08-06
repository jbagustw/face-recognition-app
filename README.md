# Face Recognition Attendance System

Aplikasi sistem kehadiran berbasis pengenalan wajah yang dibangun dengan React dan face-api.js.

## Fitur Utama

- **Deteksi Wajah Real-time**: Mendeteksi wajah secara real-time menggunakan kamera
- **Registrasi Wajah**: Mendaftarkan wajah baru ke dalam sistem
- **Sistem Kehadiran**: Mencatat kehadiran otomatis ketika wajah terdaftar terdeteksi
- **Database Persisten**: Data wajah tersimpan permanen di database PostgreSQL
- **API Backend**: RESTful API untuk manajemen data wajah dan kehadiran
- **Mode Offline**: Tetap berfungsi jika database tidak tersedia
- **UI Modern**: Interface yang responsif dan mudah digunakan

## Teknologi yang Digunakan

### Frontend
- React 18
- face-api.js untuk pengenalan wajah
- Tailwind CSS untuk styling
- Lucide React untuk icons

### Backend
- Node.js dengan Express.js
- PostgreSQL untuk database
- CORS untuk cross-origin requests

### Deployment
- Vercel untuk hosting full-stack
- Vercel Postgres untuk database

## Cara Menjalankan Aplikasi

### Prerequisites
- Node.js (versi 14 atau lebih baru)
- npm atau yarn

### Instalasi

1. Clone repository ini
```bash
git clone <repository-url>
cd face-recognition-app
```

2. Install dependencies
```bash
npm install
```

3. Setup database (opsional untuk development)
```bash
# Untuk development lokal, bisa skip step ini
# Data akan disimpan sementara di memori browser
```

4. Setup environment variables (untuk production)
```bash
cp env.example .env.local
# Edit .env.local dan isi DATABASE_URL jika menggunakan database
```

5. Jalankan aplikasi
```bash
npm start
```

6. Buka browser dan akses `http://localhost:3000`

## Cara Menggunakan

### 1. Deteksi Wajah
- Klik "Nyalakan Kamera" untuk memulai kamera
- Sistem akan mendeteksi wajah secara real-time
- Wajah yang terdaftar akan ditampilkan dengan nama

### 2. Registrasi Wajah Baru
- Pilih menu "Registrasi Wajah"
- Masukkan nama orang yang akan didaftarkan
- Pastikan wajah terlihat jelas di kamera
- Klik "Daftarkan Wajah" untuk menyimpan

### 3. Sistem Kehadiran
- Pilih menu "Kehadiran"
- Sistem akan otomatis mencatat kehadiran ketika wajah terdaftar terdeteksi
- Log kehadiran akan ditampilkan dengan tanggal dan waktu

### 4. Database Wajah
- Pilih menu "Database" untuk melihat semua wajah terdaftar
- Dapat menghapus wajah yang tidak diperlukan

## Pengaturan

### Confidence Threshold
- Atur tingkat kepercayaan deteksi wajah (0.1 - 1.0)
- Nilai lebih tinggi = lebih akurat tapi lebih ketat
- Nilai lebih rendah = lebih fleksibel tapi mungkin kurang akurat

## Troubleshooting

### Kamera Tidak Bisa Diakses
- Pastikan browser memiliki izin untuk mengakses kamera
- Coba refresh halaman dan berikan izin lagi
- Pastikan tidak ada aplikasi lain yang menggunakan kamera

### Model Tidak Ter-load
- Pastikan koneksi internet stabil
- Model akan diunduh dari CDN saat pertama kali
- Coba refresh halaman jika model gagal dimuat

### Deteksi Tidak Akurat
- Pastikan pencahayaan cukup
- Wajah harus menghadap kamera dengan jelas
- Atur confidence threshold sesuai kebutuhan

## Database Setup

### Untuk Production (Vercel)
1. Buat database PostgreSQL di Vercel:
   - Masuk ke dashboard Vercel
   - Pilih project Anda
   - Go to Storage → Create Database → Postgres
   - Copy connection string

2. Set environment variables di Vercel:
   - `DATABASE_URL`: Connection string dari database
   - `NODE_ENV`: `production`

3. Database akan otomatis membuat tabel yang diperlukan

### Untuk Development Lokal
Aplikasi akan bekerja tanpa database (mode offline) untuk development.
Data akan tersimpan sementara di browser.

Lihat [DATABASE_SETUP.md](DATABASE_SETUP.md) untuk panduan lengkap.

## Deployment

### Build untuk Production
```bash
npm run build
```

### Deploy ke Vercel
1. Install Vercel CLI
```bash
npm i -g vercel
```

2. Setup database terlebih dahulu (lihat Database Setup di atas)

3. Deploy
```bash
vercel --prod
```

4. Set environment variables di Vercel dashboard jika belum

## Struktur File

```
face-recognition-app/
├── api/
│   └── index.js        # Express.js backend API
├── public/
│   ├── index.html
│   └── manifest.json
├── src/
│   ├── services/
│   │   └── api.js      # API service untuk frontend
│   ├── App.js          # Komponen utama aplikasi
│   ├── index.js        # Entry point
│   └── index.css       # Global styles
├── package.json
├── vercel.json         # Konfigurasi deployment Vercel
├── env.example         # Template environment variables
├── DATABASE_SETUP.md   # Panduan setup database
├── tailwind.config.js
└── README.md
```

## Kontribusi

1. Fork repository
2. Buat feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

- Email: [your-email@example.com]
- Project Link: [https://github.com/your-username/face-recognition-app]