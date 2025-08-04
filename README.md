# Face Recognition Attendance System

Aplikasi sistem kehadiran berbasis pengenalan wajah yang dibangun dengan React dan face-api.js.

## Fitur Utama

- **Deteksi Wajah Real-time**: Mendeteksi wajah secara real-time menggunakan kamera
- **Registrasi Wajah**: Mendaftarkan wajah baru ke dalam sistem
- **Sistem Kehadiran**: Mencatat kehadiran otomatis ketika wajah terdaftar terdeteksi
- **Database Wajah**: Mengelola database wajah yang telah terdaftar
- **UI Modern**: Interface yang responsif dan mudah digunakan

## Teknologi yang Digunakan

- React 18
- face-api.js untuk pengenalan wajah
- Tailwind CSS untuk styling
- Lucide React untuk icons

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

3. Jalankan aplikasi
```bash
npm start
```

4. Buka browser dan akses `http://localhost:3000`

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

2. Deploy
```bash
vercel
```

## Struktur File

```
face-recognition-app/
├── public/
│   ├── index.html
│   └── manifest.json
├── src/
│   ├── App.js          # Komponen utama aplikasi
│   ├── index.js        # Entry point
│   └── index.css       # Global styles
├── package.json
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