# Contributing to Face Recognition Attendance System

Terima kasih atas minat Anda untuk berkontribusi pada project ini! 

## 🚀 Cara Berkontribusi

### 1. Fork Repository
1. Klik tombol "Fork" di halaman repository ini
2. Clone repository yang sudah di-fork ke local machine Anda

### 2. Setup Development Environment
```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/face-recognition-app.git
cd face-recognition-app

# Install dependencies
npm install

# Start development server
npm start
```

### 3. Buat Branch untuk Feature
```bash
# Buat branch baru
git checkout -b feature/nama-feature-anda

# Atau untuk bug fix
git checkout -b fix/nama-bug-anda
```

### 4. Development Guidelines

#### Code Style
- Gunakan ESLint dan Prettier untuk formatting
- Ikuti React best practices
- Gunakan functional components dengan hooks
- Tambahkan PropTypes untuk type checking

#### Commit Messages
Gunakan format conventional commits:
```
feat: add new face detection algorithm
fix: resolve camera permission issue
docs: update README with new features
style: improve button hover effects
refactor: optimize face detection performance
test: add unit tests for attendance module
```

#### Testing
- Test semua fitur baru
- Pastikan responsive design berfungsi
- Test di berbagai browser
- Test camera functionality

### 5. Push dan Pull Request
```bash
# Add changes
git add .

# Commit dengan message yang jelas
git commit -m "feat: add new face recognition feature"

# Push ke repository Anda
git push origin feature/nama-feature-anda
```

Kemudian buat Pull Request dengan:
- Deskripsi yang jelas tentang perubahan
- Screenshot jika ada perubahan UI
- Test results
- Checklist yang sudah diselesaikan

## 📋 Template Pull Request

```markdown
## Description
Jelaskan perubahan yang Anda buat

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tested di Chrome
- [ ] Tested di Firefox
- [ ] Tested di Safari
- [ ] Tested di mobile browser
- [ ] Camera functionality tested
- [ ] Face recognition tested

## Screenshots
Tambahkan screenshot jika ada perubahan UI

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review of code
- [ ] Commented code, particularly in hard-to-understand areas
- [ ] Made corresponding changes to documentation
- [ ] No breaking changes
- [ ] Added tests for new functionality
```

## 🐛 Melaporkan Bug

### Template Bug Report
```markdown
**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Environment:**
 - OS: [e.g. Windows 10]
 - Browser: [e.g. Chrome 91]
 - Version: [e.g. 1.0.0]

**Additional context**
Add any other context about the problem here.
```

## 💡 Mengusulkan Fitur

### Template Feature Request
```markdown
**Is your feature request related to a problem? Please describe.**
A clear and concise description of what the problem is.

**Describe the solution you'd like**
A clear and concise description of what you want to happen.

**Describe alternatives you've considered**
A clear and concise description of any alternative solutions or features you've considered.

**Additional context**
Add any other context or screenshots about the feature request here.
```

## 🛠️ Development Setup

### Prerequisites
- Node.js 16+
- npm atau yarn
- Git
- Modern browser dengan WebRTC support

### Dependencies
```bash
# Core dependencies
npm install react react-dom
npm install face-api.js lucide-react

# Development dependencies
npm install -D tailwindcss postcss autoprefixer
npm install -D @testing-library/react @testing-library/jest-dom
```

### Scripts
```bash
# Development
npm start

# Build
npm run build

# Test
npm test

# Lint
npm run lint
```

## 📚 Resources

### Documentation
- [React Documentation](https://reactjs.org/docs/)
- [face-api.js Documentation](https://github.com/justadudewhohacks/face-api.js)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)

### Tools
- [ESLint](https://eslint.org/)
- [Prettier](https://prettier.io/)
- [React Developer Tools](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi)

## 🤝 Community

### Getting Help
- Buat issue di GitHub
- Join Discord community (jika ada)
- Check existing issues dan discussions

### Code of Conduct
- Hormati semua kontributor
- Berikan feedback yang konstruktif
- Jaga kerahasiaan informasi sensitif
- Fokus pada kualitas kode

## 📝 License

Dengan berkontribusi, Anda setuju bahwa kontribusi Anda akan dilisensikan di bawah MIT License.

## 🙏 Acknowledgments

Terima kasih kepada semua kontributor yang telah membantu mengembangkan aplikasi ini! 