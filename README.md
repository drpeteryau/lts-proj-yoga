# 🧘 HealYoga

HealYoga is a Flutter-based mobile wellness application designed to encourage regular yoga practice through guided sessions, calming music, and progress tracking.  
The app focuses on accessibility and simplicity, making it suitable for beginners, working adults, and elderly users.

---

## ✨ Features

- 🧘 Guided yoga sessions (Beginner, Intermediate, Advanced)
- 🎵 Calming music and white-noise support
- 📊 Progress tracking (sessions completed, time practiced)
- 🔐 User authentication (Google / Email / Social login)
- 👤 Personal user profiles
- 🔔 Gentle reminders and notifications
- ♿ Accessibility-focused UI (readable fonts, simple navigation)

---

## 🛠 Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend:** Supabase (PostgreSQL, Auth, REST API)
- **Authentication:** Supabase Auth
- **State Management:** (add if used, e.g. Provider / Riverpod)
- **Platform:** Android (Web / iOS – if applicable)

---

## 🚀 Deployment Process

HealYoga is currently in the development and testing phase.

1. Developers clone the repository and run the app locally during development.
2. A release APK is generated using:
```bash
flutter build apk
```
3. The generated APK (app-release.apk) is used for internal testing,
demonstrations, and evaluation purposes.

4. The application has not been published to the Google Play Store yet.

## 🚀 Getting Started

### Prerequisites
Make sure you have the following installed:
- Flutter SDK
- Dart SDK
- Android Studio / VS Code
- Android Emulator or physical device or IOS device

Check setup:
```bash
flutter doctor
```

## 🚀 Installation & Run (For Code Testing)
1. Clone the repository:
```bash
git clone https://github.com/your-username/heal_yoga.git
```
2. Navigate into the project directory:
```bash
cd heal_yoga
```
3. Install dependencies:
```bash
flutter pub get
```
4. Run the application via emulator or web
```bash
flutter run
```

## Installation & Run (For Deployment)
1. Download the apk file from
https://drive.google.com/file/d/1kzjriKISg28ypxwUsrl8vBSdVKIaDSFv/view?usp=sharing
2. Install it via adb while having a emulator or physical phone with you
```bash
adb install {YOURPATH}/app-release.apk
```
(Ensure the terminal is opened in the same folder as the downloaded APK.)




