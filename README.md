# Face Recognition Attendance System

Sistem absensi berbasis pengenalan wajah yang dibangun dengan React.js dan dapat di-deploy ke Vercel.

## Fitur

- ✅ Pengenalan wajah real-time menggunakan webcam
- ✅ Manajemen karyawan (tambah, edit, hapus)
- ✅ Pencatatan absensi otomatis
- ✅ Dashboard dengan statistik kehadiran
- ✅ Laporan absensi harian dan bulanan
- ✅ Responsive design untuk mobile dan desktop
- ✅ Data tersimpan di localStorage (untuk demo)

## Teknologi

- React.js 18
- Face-api.js untuk face recognition
- Tailwind CSS untuk styling
- Lucide React untuk icons
- HTML5 Canvas untuk image processing

## Instalasi

1. Clone repository:
```bash
git clone <repository-url>
cd face-attendance-system
```

2. Install dependencies:
```bash
npm install
```

3. Jalankan development server:
```bash
npm start
```

4. Buka http://localhost:3000 di browser

## Deploy ke Vercel

### Method 1: Via Vercel CLI

1. Install Vercel CLI:
```bash
npm i -g vercel
```

2. Login ke Vercel:
```bash
vercel login
```

3. Deploy:
```bash
vercel
```

### Method 2: Via GitHub

1. Push code ke GitHub repository
2. Connect repository ke Vercel dashboard
3. Deploy otomatis akan berjalan

## Cara Penggunaan

### 1. Tambah Karyawan
- Masuk ke tab "Employees"
- Isi form data karyawan (nama, ID, department)
- Upload foto karyawan
- Klik "Add Employee"

### 2. Absensi
- Masuk ke tab "Attendance"
- Klik "Start Camera" untuk mengaktifkan webcam
- Klik "Scan Face" untuk melakukan absensi
- Sistem akan mengenali wajah dan mencatat kehadiran

### 3. Lihat Laporan
- Masuk ke tab "Reports"
- Lihat data absensi harian dan bulanan
- Export data jika diperlukan

## Konfigurasi

### Environment Variables (Opsional)
Buat file `.env.local` untuk konfigurasi tambahan:

```
REACT_APP_API_URL=https://your-api-url.com
REACT_APP_FACE_API_MODELS_URL=/models
```

### Face-api.js Models
Models akan di-load dari CDN. Untuk performa lebih baik, download models dan simpan di folder `public/models/`.

## Pengembangan Lanjutan

### Integrasi Database Real
Ganti localStorage dengan database server:
- Backend: Node.js + Express + PostgreSQL
- API endpoints untuk CRUD operations
- Authentication & authorization

### Fitur Tambahan
- [ ] Multiple face detection
- [ ] Anti-spoofing detection
- [ ] Push notifications
- [ ] Export ke Excel/PDF
- [ ] Integration dengan sistem HR
- [ ] Geolocation tracking
- [ ] Shift management

### Optimisasi Performa
- Lazy loading components
- Image optimization
- Model caching
- Service worker untuk offline support

## Troubleshooting

### Camera tidak bisa diakses
- Pastikan browser memiliki permission untuk camera
- Gunakan HTTPS untuk production
- Check browser compatibility

### Face recognition tidak akurat
- Pastikan pencahayaan cukup
- Foto training harus berkualitas baik
- Adjust detection threshold

### Deploy gagal di Vercel
- Check build logs untuk error details
- Pastikan semua dependencies ter-install
- Verify vercel.json configuration

## Browser Support

- Chrome 60+
- Firefox 55+
- Safari 11+
- Edge 79+

## License

MIT License - bebas digunakan untuk project komersial dan non-komersial.

## Contributing

1. Fork repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## Support

Jika ada pertanyaan atau issue, silakan buat GitHub issue atau hubungi developer.