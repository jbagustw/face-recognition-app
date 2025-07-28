# 🚀 Panduan Deployment Face Recognition Attendance System

## 📋 Checklist Persiapan

- [ ] Node.js 16+ terinstall
- [ ] npm atau yarn terinstall  
- [ ] Git terinstall
- [ ] Akun Vercel (gratis)
- [ ] Browser modern untuk testing

## 🔧 Setup Project

### 1. Create Project Folder
```bash
mkdir face-attendance-system
cd face-attendance-system
```

### 2. Copy Files
Buat struktur folder dan copy semua file sesuai artifacts:

```
face-attendance-system/
├── public/
│   ├── index.html
│   └── manifest.json
├── src/
│   ├── App.js
│   ├── index.js
│   └── index.css
├── package.json
├── vercel.json
├── tailwind.config.js
├── .gitignore
└── README.md
```

### 3. Install Dependencies
```bash
npm install
```

### 4. Install Tailwind CSS
```bash
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
```

## 🧪 Test Local

### 1. Development Server
```bash
npm start
```
Buka http://localhost:3000

### 2. Test Build
```bash
npm run build
npx serve -s build
```

### 3. Test Features
- [ ] Camera access berfungsi
- [ ] Add employee berfungsi  
- [ ] Face scan simulation berfungsi
- [ ] Data tersimpan di localStorage
- [ ] Responsive di mobile

## 🌐 Deploy ke Vercel

### Method 1: Vercel CLI (Recommended)

1. **Install Vercel CLI**
```bash
npm i -g vercel
```

2. **Login ke Vercel**
```bash
vercel login
```

3. **Deploy**
```bash
# First deployment
vercel

# Production deployment
vercel --prod
```

4. **Follow prompts:**
```
? Set up and deploy "~/face-attendance-system"? [Y/n] y
? Which scope do you want to deploy to? [Your Account]
? Link to existing project? [y/N] n
? What's your project's name? face-attendance-system
? In which directory is your code located? ./
```

### Method 2: GitHub Integration

1. **Initialize Git**
```bash
git init
git add .
git commit -m "Initial commit"
```

2. **Push to GitHub**
```bash
git branch -M main
git remote add origin https://github.com/username/face-attendance-system.git
git push -u origin main
```

3. **Connect ke Vercel**
- Buka https://vercel.com/dashboard
- Klik "New Project"
- Import dari GitHub repository
- Configure settings (auto-detect React)
- Deploy

### Method 3: Manual Upload

1. **Build Project**
```bash
npm run build
```

2. **Upload via Vercel Dashboard**
- Buka https://vercel.com/dashboard
- Drag & drop folder `build`
- Wait for deployment

## ⚙️ Konfigurasi Advanced

### Environment Variables
Set di Vercel dashboard atau via CLI:

```bash
# Via CLI
vercel env add REACT_APP_API_URL
vercel env add REACT_APP_FACE_API_MODELS_URL

# Via Dashboard
# Go to Project Settings > Environment Variables
```

### Custom Domain
```bash
# Add domain
vercel domains add yourdomain.com

# Verify domain
vercel domains verify yourdomain.com
```

### Build Settings
Modifikasi `vercel.json` jika diperlukan:

```json
{
  "version": 2,
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/static-build",
      "config": {
        "buildCommand": "npm run build",
        "outputDirectory": "build"
      }
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/index.html"
    }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        }
      ]
    }
  ]
}
```

## 🔍 Troubleshooting

### Build Errors

**Error: Module not found**
```bash
rm -rf node_modules package-lock.json
npm install
```

**Error: Tailwind not working**
```bash
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
```

**Error: Out of memory**
```bash
# Add to package.json scripts
"build": "react-scripts --max_old_space_size=4096 build"
```

### Camera Issues

**Camera not accessible**
- Pastikan deploy dengan HTTPS (Vercel otomatis provide)
- Check browser permissions
- Test di browser yang support WebRTC

**Permission denied**
```javascript
// Add error handling di startCamera function
try {
  const stream = await navigator.mediaDevices.getUserMedia({ video: true });
  // ...
} catch (error) {
  if (error.name === 'NotAllowedError') {
    alert('Please allow camera access and refresh the page');
  }
}
```

### Performance Issues

**Slow loading**
```bash
# Analyze bundle
npm install -g serve
npm run build
npx serve -s build
```

**Large bundle size**
- Use code splitting
- Lazy load components
- Optimize images

## 📊 Monitoring

### Analytics
Tambahkan Google Analytics di `public/index.html`:

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_TRACKING_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_TRACKING_ID');
</script>
```

### Error Tracking
Integrasikan Sentry untuk error monitoring:

```bash
npm install @sentry/react @sentry/tracing
```

## 🔒 Security

### HTTPS
Vercel provide HTTPS otomatis, tapi pastikan:
- Gunakan secure headers
- Validate input data
- Sanitize user uploads

### Content Security Policy
Tambahkan di `vercel.json`:

```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "Content-Security-Policy",
          "value": "default-src 'self'; img-src 'self' data: blob:; media-src 'self' blob:; script-src 'self' 'unsafe-inline';"
        }
      ]
    }
  ]
}
```

## 📈 Scaling

### Database Integration
Untuk production scale:

1. **Backend API**
```bash
# Deploy backend terpisah
# Options: Railway, Render, Heroku, Vercel Functions
```

2. **Database Options**
- Supabase (PostgreSQL + Auth)
- PlanetScale (MySQL)  
- MongoDB Atlas
- Firebase Firestore

3. **File Storage**
- Cloudinary (images)
- AWS S3
- Vercel Blob

### Example API Integration
```javascript
// Ganti localStorage dengan API calls
const saveEmployee = async (employee) => {
  const response = await fetch('/api/employees', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(employee)
  });
  return response.json();
};
```

## 🔄 CI/CD Pipeline

Buat `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Vercel
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    - run: npm ci
    - run: npm run build
    - uses: amondnet/vercel-action@v25
      with:
        vercel-token: ${{ secrets.VERCEL_TOKEN }}
        vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
        vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
```

## 📞 Support

Jika ada masalah deployment:

1. **Check Deployment Logs**
   - Buka Vercel dashboard
   - Lihat deployment logs untuk error details

2. **Test Local Build**
```bash
npm run build
npx serve -s build
# Test di http://localhost:3000
```

3. **Common Issues**
   - Camera permission: Perlu HTTPS
   - Build errors: Clear cache dan reinstall
   - Performance: Optimize bundle size

4. **Get Help**
   - Vercel Discord community
   - GitHub issues
   - Stack Overflow

## ✅ Post-Deployment Checklist

- [ ] App accessible via deployed URL
- [ ] Camera access working
- [ ] All features functional
- [ ] Mobile responsive
- [ ] Performance acceptable
- [ ] Error tracking setup
- [ ] Analytics configured
- [ ] Domain configured (optional)
- [ ] SSL certificate active
- [ ] SEO optimized

**Congratulations! 🎉 Your Face Recognition Attendance System is now live!**