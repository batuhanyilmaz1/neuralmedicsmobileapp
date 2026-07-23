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

## Screenshots

| Home | AI Scan |
|:---:|:---:|
| ![Home](docs/screenshots/home.png) | ![AI Scan](docs/screenshots/ai-scan.png) |

| Health Articles | Profile |
|:---:|:---:|
| ![Articles](docs/screenshots/articles.png) | ![Profile](docs/screenshots/profile.png) |

---

## Quick start

When opening the project for the first time or after a long break:

```powershell
cd neuralmedicsmobileapp
flutter pub get
flutter run
```

Full rebuild if the model file was added or changed:

```powershell
flutter clean
flutter pub get
flutter run
```

List devices:

```powershell
flutter devices
flutter run -d <device_id>
```

---

## Requirements

| Tool | Note |
|------|-----|
| [Flutter SDK](https://docs.flutter.dev/get-started/install) | Dart `^3.12` (compatible with pubspec) |
| Android Studio / Xcode | Android or iOS emulator/device |
| Firebase CLI (optional) | For Auth / Firestore deploy |

Check:

```powershell
flutter doctor
flutter --version
```

---

## Features

- **Authentication:** Email/password, Google Sign-In, password reset
- **Health profile:** Age, gender, height, weight, blood type (Firestore `users/{uid}`)
- **AI scan:** Upload an MRI image → 4-class prediction with TFLite
- **Scan history:** Local SQLite (`sqflite`)
- **Articles & FAQ:** In-app health content

Bottom navigation: **Home · History · Articles · Profile**

---

## AI model

| File | Size | Description |
|-------|-------|----------|
| `assets/ai/brain_tumor.tflite` | ~157 MB | On-device model |
| `ai_figma/Unet-BrainTumor.h5` | ~473 MB | Source Keras model (trained with TF 2.14) |

**Input:** `[1, 256, 256, 3]` float32, RGB 0–1  
**Output:** `[1, 4]` softmax — order: Glioma, Meningioma, No Tumor, Pituitary  
**Service:** `lib/features/ai_tumor/tumor_detection_service.dart`

Model files are tracked in the repo with **Git LFS** (`.gitattributes`). Run `git lfs pull` after cloning.

If the model is missing, the app produces mock predictions in **DEMO** mode.

### H5 → TFLite reconversion

```powershell
python -m venv .venv-convert
.\.venv-convert\Scripts\pip install -r scripts\requirements-convert.txt
.\.venv-convert\Scripts\python.exe scripts\convert_h5_to_tflite.py
```

Details: `assets/ai/README.md` · Script: `scripts/convert_h5_to_tflite.py`

---

## Firebase configuration

Config files already included in the project:

| Platform | File |
|----------|-------|
| Android | `android/app/google-services.json` |
| iOS | `ios/Runner/GoogleService-Info.plist` |
| Flutter | `lib/firebase_options.dart` |

Google Sign-In web client ID: `lib/core/config/google_sign_in_config.dart`

### Auth & Firestore deploy (optional)

```powershell
npx -y firebase-tools@latest login
npx -y firebase-tools@latest use neuralmedicsmobileapp
npx -y firebase-tools@latest deploy --only auth,firestore:rules
```

**Note:** For Android Google Sign-In, SHA-1 / SHA-256 fingerprints must be registered in the Firebase Console.

To get the debug keystore SHA:

```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

---

## Git & Git LFS (push)

Large model files can't be pushed with plain git (GitHub's 100 MB limit). Git LFS is configured in the project:

| File | Size | LFS |
|-------|-------|-----|
| `assets/ai/brain_tumor.tflite` | ~157 MB | Yes |
| `ai_figma/Unet-BrainTumor.h5` | ~473 MB | Yes |

### First push

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

When creating the repo on GitHub, make sure **Git LFS** is enabled (on by default).

### Clone (on another machine)

```powershell
git clone https://github.com/batuhanyilmaz1/neuralmedicsmobileapp.git
cd neuralmedicsmobileapp
git lfs pull
flutter pub get
flutter run
```

To verify LFS files are tracked:

```powershell
git lfs ls-files
```

---

## Test & analysis

```powershell
flutter analyze
flutter test
```

Release build (Android):

```powershell
flutter build apk --release
```

---

## Project structure

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

---

## Common issues

| Issue | Fix |
|-------|--------|
| `CONFIGURATION_NOT_FOUND` (sign-up) | Check that Email/Password is enabled in Firebase Auth; add SHA fingerprints |
| Google sign-in not working | Verify `google-services.json` + SHA-1/256 + `serverClientId` |
| Model not loading / DEMO mode | Check `assets/ai/brain_tumor.tflite` exists; `flutter clean && flutter run` |
| Large model APK size | Expected (~157 MB); can be quantized later |
| Redirect after profile save | `/profile-setup` opens if the health profile isn't completed |

---

## License

This project is licensed under the MIT License.
