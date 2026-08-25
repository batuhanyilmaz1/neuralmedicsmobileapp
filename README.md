<div align="center">
  <img src="icon.png" alt="NeuralMedics" width="200" height="200">
</div>

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-v3.22-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-v3.4-0175C2?style=flat&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-v13.0-FFCA28?style=flat&logo=firebase&logoColor=black)](https://firebase.google.com)
[![TensorFlow Lite](https://img.shields.io/badge/TensorFlow%20Lite-v2.16-FF6F00?style=flat&logo=tensorflow&logoColor=white)](https://www.tensorflow.org/lite)
[![SQLite](https://img.shields.io/badge/SQLite-v3.45-003B57?style=flat&logo=sqlite&logoColor=white)](https://www.sqlite.org)
[![Google Sign-In](https://img.shields.io/badge/Google%20Sign--In-v20.7-4285F4?style=flat&logo=google&logoColor=white)](https://developers.google.com/identity)
</div>

<div align="center">

# NeuralMedics

An AI-powered brain MRI tumor classification app built with Flutter.
Uses Firebase Auth + Firestore, a local SQLite history, and on-device TFLite inference.

**Firebase project:** `neuralmedicsmobileapp`
**Language:** English UI
</div>

---

## Problem

Brain tumor diagnosis from MRI scans traditionally requires a radiologist to manually review each image, which can be slow, subjective, and hard to access outside of major hospitals. Patients often have no way to get a quick, preliminary read on their scan or to track results over time.

NeuralMedics addresses this by putting an on-device AI model directly into a mobile app: users can upload a brain MRI image and receive an instant 4-class prediction (Glioma, Meningioma, No Tumor, Pituitary), while also keeping a personal health profile, scan history, and access to educational health content — all without the raw image ever leaving the device.

---

## Teknolojiler

| Teknoloji | Kullanım Amacı |
|-----------|-----------------|
| **Flutter / Dart** | Cross-platform mobil uygulama (Android & iOS) |
| **Firebase Auth** | E-posta/şifre ve Google ile kimlik doğrulama |
| **Cloud Firestore** | Kullanıcı sağlık profili verileri (`users/{uid}`) |
| **TensorFlow Lite** | Cihaz üzerinde (on-device) MRI görüntü sınıflandırma |
| **SQLite (sqflite)** | Yerel tarama (scan) geçmişi kaydı |
| **Google Sign-In** | Google hesabıyla tek tıkla giriş |
| **go_router** | Sayfa yönlendirme ve auth guard |
| **image_picker / image** | MRI görüntüsü seçme ve ön işleme |

---

## Kurulum

### Gereksinimler

| Araç | Not |
|------|-----|
| [Flutter SDK](https://docs.flutter.dev/get-started/install) | Dart `^3.12` (pubspec ile uyumlu) |
| Android Studio / Xcode | Android veya iOS emulator/cihaz |
| Firebase CLI (opsiyonel) | Auth / Firestore deploy için |

Kontrol:

```powershell
flutter doctor
flutter --version
```

### Hızlı başlangıç

Projeyi ilk kez açarken veya uzun bir aradan sonra:

```powershell
cd neuralmedicsmobileapp
flutter pub get
flutter run
```

Model dosyası eklendiyse/değiştiyse tam yeniden derleme:

```powershell
flutter clean
flutter pub get
flutter run
```

Cihazları listele:

```powershell
flutter devices
flutter run -d <device_id>
```

### AI modeli

| Dosya | Boyut | Açıklama |
|-------|-------|----------|
| `assets/ai/brain_tumor.tflite` | ~157 MB | Cihaz üzerinde çalışan model |
| `ai_figma/Unet-BrainTumor.h5` | ~473 MB | Kaynak Keras modeli (TF 2.14 ile eğitildi) |

**Girdi:** `[1, 256, 256, 3]` float32, RGB 0–1
**Çıktı:** `[1, 4]` softmax — sıra: Glioma, Meningioma, No Tumor, Pituitary
**Servis:** `lib/features/ai_tumor/tumor_detection_service.dart`

Model dosyaları repoda **Git LFS** ile takip edilir (`.gitattributes`). Klonladıktan sonra `git lfs pull` çalıştırın.

Model bulunamazsa uygulama **DEMO** modunda örnek (mock) tahminler üretir.

#### H5 → TFLite yeniden dönüştürme

```powershell
python -m venv .venv-convert
.\.venv-convert\Scripts\pip install -r scripts\requirements-convert.txt
.\.venv-convert\Scripts\python.exe scripts\convert_h5_to_tflite.py
```

Detaylar: `assets/ai/README.md` · Script: `scripts/convert_h5_to_tflite.py`

### Firebase yapılandırması

Yapılandırma dosyaları projede zaten mevcut:

| Platform | Dosya |
|----------|-------|
| Android | `android/app/google-services.json` |
| iOS | `ios/Runner/GoogleService-Info.plist` |
| Flutter | `lib/firebase_options.dart` |

Google Sign-In web client ID: `lib/core/config/google_sign_in_config.dart`

#### Auth & Firestore deploy (opsiyonel)

```powershell
npx -y firebase-tools@latest login
npx -y firebase-tools@latest use neuralmedicsmobileapp
npx -y firebase-tools@latest deploy --only auth,firestore:rules
```

**Not:** Android Google Sign-In için SHA-1 / SHA-256 parmak izlerinin Firebase Console'a kaydedilmesi gerekir.

Debug keystore SHA'sını almak için:

```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

### Git & Git LFS (push)

Büyük model dosyaları düz git ile push edilemez (GitHub'ın 100 MB sınırı). Projede Git LFS yapılandırılmıştır:

| Dosya | Boyut | LFS |
|-------|-------|-----|
| `assets/ai/brain_tumor.tflite` | ~157 MB | Evet |
| `ai_figma/Unet-BrainTumor.h5` | ~473 MB | Evet |

#### İlk push

```powershell
cd neuralmedicsmobileapp
git init
git lfs install
git add .gitattributes
git add .
git commit -m "NeuralMedics: Flutter AI brain tumor app"
git branch -M main
git remote add origin https://github.com/<username>/<repo>.git
git push -u origin main
```

GitHub'da repo oluştururken **Git LFS**'in etkin olduğundan emin olun (varsayılan olarak açıktır).

#### Klonlama (başka bir makinede)

```powershell
git clone https://github.com/batuhanyilmaz1/neuralmedicsmobileapp.git
cd neuralmedicsmobileapp
git lfs pull
flutter pub get
flutter run
```

LFS dosyalarının takip edildiğini doğrulamak için:

```powershell
git lfs ls-files
```

### Test & analiz

```powershell
flutter analyze
flutter test
```

Release build (Android):

```powershell
flutter build apk --release
```

---

## Özellikler

- **Kimlik doğrulama:** E-posta/şifre, Google ile giriş, şifre sıfırlama
- **Sağlık profili:** Yaş, cinsiyet, boy, kilo, kan grubu (Firestore `users/{uid}`)
- **AI tarama:** MRI görüntüsü yükle → TFLite ile 4 sınıflı tahmin
- **Tarama geçmişi:** Yerel SQLite (`sqflite`)
- **Makaleler & SSS:** Uygulama içi sağlık içeriği

Alt navigasyon: **Home · History · Articles · Profile**

### Proje yapısı

```
lib/
├── main.dart                 # Firebase, Google Sign-In, router setup
├── firebase_options.dart
├── core/
│   ├── router/               # go_router + auth guard
│   ├── services/             # Auth, Firestore, prediction repo
│   ├── database/             # SQLite scan history
│   ├── models/               # UserProfile, PredictionRecord
│   └── theme/
└── features/
    ├── auth/                 # Login, register, password reset
    ├── ai_tumor/             # MRI scan + TFLite
    ├── profile/              # Profile & health form
    ├── home/                 # Home screen
    ├── history/              # Scan history
    ├── articles/             # Health articles
    └── faq/                  # FAQ

assets/
├── ai/                       # brain_tumor.tflite
├── images/
└── icons/
```

### Bilinen sorunlar

| Sorun | Çözüm |
|-------|--------|
| `CONFIGURATION_NOT_FOUND` (kayıt) | Firebase Auth'ta Email/Password'ün etkin olduğunu kontrol edin; SHA parmak izlerini ekleyin |
| Google ile giriş çalışmıyor | `google-services.json` + SHA-1/256 + `serverClientId` doğrulayın |
| Model yüklenmiyor / DEMO modu | `assets/ai/brain_tumor.tflite` dosyasının var olduğunu kontrol edin; `flutter clean && flutter run` |
| Büyük model APK boyutu | Beklenen (~157 MB); ileride quantize edilebilir |
| Profil kaydından sonra yönlendirme | Sağlık profili tamamlanmadıysa `/profile-setup` açılır |

---

## Ekran görüntüsü

| Home | AI Scan |
|:---:|:---:|
| ![Home](docs/screenshots/home.png) | ![AI Scan](docs/screenshots/ai-scan.png) |

| Health Articles | Profile |
|:---:|:---:|
| ![Articles](docs/screenshots/articles.png) | ![Profile](docs/screenshots/profile.png) |

---

## License

This project is licensed under the MIT License.
