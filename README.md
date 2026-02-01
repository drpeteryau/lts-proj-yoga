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

## 1. 🚀 Getting Started

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

## 2. 🚀 Installation & Run (For Code Testing)
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

## 3. Installation & Run (For Deployment)
1. Download the apk file from
https://drive.google.com/file/d/1kzjriKISg28ypxwUsrl8vBSdVKIaDSFv/view?usp=sharing
2. Install it via adb while having a emulator or physical phone with you
```bash
adb install {YOURPATH}/app-release.apk
```
(Ensure the terminal is opened in the same folder as the downloaded APK.)


## 4. 📱 Screenshots

| Login | Register |
|-------|----------|
| ![Login Screen](screenshots/login.png) | ![Register Screen](screenshots/register1.png) |

**Login Screen**  
Users can sign in to HealYoga using multiple authentication methods, including
Google Sign-In or email and password. This allows returning users to securely
access their personalized yoga sessions, progress records, and profile data.

**Register Screen**  
New users can register for an account using their email address and password.
Once registered, users can log in to the application and begin using all core
features of HealYoga.

---

| Home Screen | Start Workout |
|-------------|----------------|
| ![Home Screen](screenshots/home.png) | ![Start Workout](screenshots/startworkout.png) |

**Home Screen**  
The home screen provides quick access to daily yoga challenges and recommended
sessions, allowing users to quickly start a workout with minimal effort.

**Start Workout**  
This screen allows users to preview the selected yoga session and begin the
guided workout, showing session duration and exercise details.


| Sessions | Workout Progress |
|----------|------------------|
| ![Sessions](screenshots/sessions.png) | ![Workout Progress](screenshots/workoutprogress.png) |

**Sessions Screen**  
Displays available yoga exercises categorized by difficulty level, enabling
users to explore and choose suitable sessions.

**Workout Progress**  
Shows real-time progress during a yoga session, guiding users through exercises
with timers and completion indicators.

| Calming Sounds | Progress Tracking |
|----------------|------------------|
| ![Calming Sounds](screenshots/sound1.png) | ![Progress Tracking](screenshots/progress1.png)<br>![Progress2](screenshots/progress2.png) |

**Calming Sounds**  
Provides a collection of white noise and relaxing ambient sounds that users
can play independently or alongside yoga sessions to enhance relaxation.

**Progress Tracking**  
Displays users’ completed yoga sessions and overall practice progress, helping
them monitor consistency and stay motivated.

| Profile | Edit Profile |
|---------|--------------|
| ![Profile Screen](screenshots/profile.png) | ![Edit Profile](screenshots/editprofile1.png) |

**Profile Screen**  
Allows users to view their personal information, preferences, and account
details within the application.

**Edit Profile**  
Enables users to update their profile information and preferences to personalize
their experience within HealYoga.



