# UnityAid 🤝

> A comprehensive Flutter application connecting donors with NGOs and charitable causes

[![Flutter Version](https://img.shields.io/badge/Flutter-3.0%2B-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-orange.svg)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

UnityAid is a mobile application designed to bridge the gap between donors and Non-Governmental Organizations (NGOs). The platform facilitates transparent donations, real-time communication, and community engagement for social causes.

---

## 📋 Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Quick Start](#-quick-start)
- [Credentials Setup](#-credentials-setup-important)
- [Firebase Configuration](#-firebase-configuration)
- [Running the Project](#-running-the-project)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

---

## ✨ Features

### For Donors
- 🔍 **Browse Donation Cases**: Discover verified charitable causes and donation campaigns
- 💳 **Secure Donations**: Make safe and transparent contributions to causes you care about
- 📰 **News Feed**: Stay updated with latest activities and impact stories
- 💬 **AI-Powered Chat**: Get assistance and answers to your queries
- 🔔 **Real-time Updates**: Track the impact of your donations

### For NGOs
- 📝 **Create Campaigns**: Post donation cases and fundraising campaigns
- 📊 **Dashboard Analytics**: Monitor donations and campaign performance
- ✅ **Verification System**: Get verified through DigiLocker integration
- 👥 **Community Engagement**: Connect with donors and share impact stories
- 📈 **Profile Management**: Showcase your organization's mission and achievements

### General Features
- 🔐 **Unified Authentication**: Seamless Email/Password and Google Sign-In for both Users and NGOs
- 🔍 **Advanced Search**: Find NGOs by category, location, and cause
- 📱 **Responsive Design**: Beautiful and intuitive user interface
- 🌙 **Theme Support**: Customizable app appearance
- 📸 **Media Sharing**: Upload and share images for campaigns and updates

---

## 📸 Screenshots

### Authentication Screens
| User Dashboard | Login | Sign Up |
|:------------:|:-----:|:-------:|
| ![User Dashboard](screenshots/user_dashboard.jpg) | ![Login](screenshots/login.jpg) | ![Sign Up](screenshots/signup.jpg) |

### User Interface
| Home Feed | Donation Cases | NGO Profile |
|:---------:|:--------------:|:-----------:|
| ![Home](screenshots/home.jpg) | ![Donate](screenshots/donate.jpg) | ![NGO Profile](screenshots/ngo_profile.jpg) |

### Features
| NGO Dashboard | Search | AI Chat |
|:-------------:|:------:|:-------:|
| ![Dashboard](screenshots/ngo_dashboard.jpg) | ![Search](screenshots/search.jpg) | ![Chat](screenshots/ai_chat.jpg) |

### Create Post & Settings
| News | Settings | Verification |
|:----------:|:--------:|:------------:|
| ![News](screenshots/news.jpg) | ![Settings](screenshots/settings.jpg) | ![Verification](screenshots/verification.jpg) |

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | Flutter (SDK 3.0+), Dart, Provider |
| **Backend** | Firebase Cloud Functions (TypeScript) |
| **Database** | Cloud Firestore |
| **Auth** | Firebase Authentication (Email/Password + Google) |
| **Storage** | Firebase Storage |
| **Messaging** | Firebase Cloud Messaging (FCM) |
| **Payments** | Razorpay |
| **Data API** | Firebase DataConnect (GraphQL) |

---

## 📦 Prerequisites

Ensure you have the following installed before starting:

| Tool | Version | Check Command |
|------|---------|---------------|
| **Flutter SDK** | 3.0+ | `flutter --version` |
| **Dart SDK** | (included with Flutter) | `dart --version` |
| **Node.js** | 18+ | `node -v` |
| **npm** | 9+ | `npm -v` |
| **Java JDK** | **21+** | `java -version` |
| **Firebase CLI** | Latest | `firebase --version` |
| **Git** | Any | `git --version` |

> ⚠️ **Java 21+ is required** for Firebase Emulators. Download from [Adoptium](https://adoptium.net/).

### Install Firebase CLI (if not installed)
```bash
npm install -g firebase-tools
firebase login
```

---

## 🚀 Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/Unity_Aid.git
cd Unity_Aid

# 2. Set up credentials (see Credentials Setup section below)

# 3. Install backend dependencies
cd backend/functions
npm install

# 4. Build backend TypeScript
npm run build

# 5. Install frontend dependencies
cd ../../frontend
flutter pub get

# 6. Start Firebase Emulators (Terminal 1)
cd ../backend
firebase emulators:start

# 7. Run Flutter app (Terminal 2)
cd ../frontend
flutter run
```

---

## 🔐 Credentials Setup (IMPORTANT)

The following files contain **secrets and API keys** and are **NOT included** in the repository. You must create them locally.

### Files You Must Create

| File | Location | How to Obtain |
|------|----------|---------------|
| `google-services.json` | `frontend/android/app/` | Firebase Console → Project Settings → Android app → Download |
| `GoogleService-Info.plist` | `frontend/ios/Runner/` | Firebase Console → Project Settings → iOS app → Download |
| `firebase_options.dart` | `frontend/lib/` | Run `flutterfire configure` in the `frontend/` directory |
| `.firebaserc` | `backend/` | Run `firebase use --add` and select your project |
| `serviceAccountKey.json` | `backend/` | Firebase Console → Project Settings → Service Accounts → Generate Key |
| `.env` | `backend/` and `frontend/` | Copy from `.env.example` and fill in values |

### Step-by-Step

#### 1. Create a Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **Add Project** → Name it (e.g., `unity-aid`)
3. Enable **Google Analytics** (optional)

#### 2. Register Android App
1. Firebase Console → **Project Settings** → **Add App** → Android
2. Package name: `com.example.unityaid`
3. Download `google-services.json`
4. Place it at: `frontend/android/app/google-services.json`

#### 3. Register iOS App (macOS only)
1. Firebase Console → **Add App** → iOS
2. Bundle ID: `com.example.unityaid`
3. Download `GoogleService-Info.plist`
4. Place it at: `frontend/ios/Runner/GoogleService-Info.plist`

#### 4. Generate `firebase_options.dart`
```bash
cd frontend
dart pub global activate flutterfire_cli
flutterfire configure
```

#### 5. Enable Firebase Services
In Firebase Console, enable:
- **Authentication** → Sign-in methods: Email/Password, Google
- **Cloud Firestore** → Create database (start in test mode)
- **Storage** → Create bucket
- **Cloud Messaging** → (auto-enabled)

#### 6. Set Up Backend
```bash
cd backend
firebase login
firebase use --add    # Select your Firebase project
cp .env.example .env  # Edit with your actual values
```

#### 7. Set Up Environment Variables
```bash
# Backend
cp backend/.env.example backend/.env
# Edit backend/.env with your Firebase project details

# Frontend
cp frontend/.env.example frontend/.env
# Edit frontend/.env with your Firebase API keys
```

---

## 🔥 Firebase Configuration

### `backend/.firebaserc` (create this file)
```json
{
  "projects": {
    "default": "your-firebase-project-id"
  }
}
```

### Firebase Emulator Ports (pre-configured in `firebase.json`)

| Service | Port |
|---------|------|
| Auth Emulator | `localhost:9099` |
| Firestore Emulator | `localhost:8080` |
| Functions Emulator | `localhost:5001` |
| Storage Emulator | `localhost:9199` |
| Pub/Sub Emulator | `localhost:8085` |
| Emulator UI | `localhost:4000` |

### Deploy to Firebase (Production)
```bash
cd backend

# Deploy everything
firebase deploy

# Deploy specific services
firebase deploy --only functions
firebase deploy --only firestore:rules
firebase deploy --only storage
firebase deploy --only dataconnect
```

---

## ▶️ Running the Project

You need **two separate terminals** running simultaneously:

### Terminal 1 — Backend (Firebase Emulators)
```bash
cd backend/functions
npm run build          # Compile TypeScript → JavaScript
cd ..
firebase emulators:start
```
> Emulator UI available at: http://localhost:4000

### Terminal 2 — Frontend (Flutter App)
```bash
cd frontend
flutter pub get        # Install dependencies (first time)
flutter run            # Run on connected device/emulator
```

### Useful Commands

| Command | Description | Run From |
|---------|-------------|----------|
| `npm run build` | Compile TypeScript functions | `backend/functions/` |
| `npm run build:watch` | Auto-compile on changes | `backend/functions/` |
| `firebase emulators:start` | Start all emulators | `backend/` |
| `flutter pub get` | Install Flutter dependencies | `frontend/` |
| `flutter run` | Run app in debug mode | `frontend/` |
| `flutter run -d chrome` | Run as web app | `frontend/` |
| `flutter build apk --release` | Build Android APK | `frontend/` |
| `firebase functions:log` | View function logs | `backend/` |

---

## 📁 Project Structure

```text
Unity_Aid/
├── backend/                    # Firebase Backend
│   ├── dataconnect/            # Firebase DataConnect (GraphQL API)
│   │   ├── schema/             # GraphQL schemas
│   │   ├── example/            # Sample queries/mutations
│   │   └── dataconnect.yaml    # DataConnect configuration
│   ├── functions/              # Firebase Cloud Functions (TypeScript)
│   │   ├── src/
│   │   │   ├── index.ts        # Entry point — exports all functions
│   │   │   ├── config.ts       # Firebase Admin SDK initialization
│   │   │   ├── types/          # Shared TypeScript interfaces
│   │   │   ├── utils/          # Helpers (FCM notifications, etc.)
│   │   │   └── triggers/       # Cloud Function triggers
│   │   │       ├── onPostCreated.ts
│   │   │       ├── onCaseVerified.ts
│   │   │       └── dailyCasesAlert.ts
│   │   ├── package.json
│   │   └── tsconfig.json
│   ├── firebase.json           # Firebase project configuration
│   ├── firestore.rules         # Firestore security rules
│   ├── firestore.indexes.json  # Firestore index definitions
│   └── storage.rules           # Storage security rules
│
├── frontend/                   # Flutter Mobile App
│   ├── android/                # Android native project
│   ├── ios/                    # iOS native project
│   ├── lib/
│   │   ├── main.dart           # Application entry point
│   │   ├── firebase_options.dart # Firebase config (auto-generated)
│   │   ├── login_page.dart     # Authentication screen
│   │   ├── models/             # Data models
│   │   ├── screens/            # UI screens
│   │   ├── services/           # Backend communication layer
│   │   │   ├── auth_service.dart
│   │   │   ├── user_service.dart
│   │   │   ├── upload_service.dart
│   │   │   ├── notification_service.dart
│   │   │   └── razorpay_payment_service.dart
│   │   └── widgets/            # Reusable UI components
│   ├── assets/                 # Images and static assets
│   └── pubspec.yaml            # Flutter dependencies
│
├── screenshots/                # App screenshots for README
├── LICENSE
└── README.md
```

---

## 🤝 Contributing

We welcome contributions to UnityAid! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. **Commit your changes**
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/AmazingFeature
   ```
5. **Open a Pull Request**

### Guidelines
- Follow the existing code style
- Write meaningful commit messages
- Test your changes thoroughly
- Update documentation as needed

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📞 Contact

**Project Team**
- Project Name: UnityAid
- Course: Theory of App Development

**Links**
- Project Repository: [GitHub](https://github.com/yourusername/Unity_Aid)
- Additional Docs:
  - [NGO Dashboard Guide](frontend/NGO_DASHBOARD_README.md)
  - [Donation Cases Guide](frontend/DONATION_CASES_README.md)
  - [Migration Guide](frontend/MIGRATION_GUIDE.md)
  - [Backend Setup Guide](backend/SETUP.md)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for the backend infrastructure
- All contributors and supporters
- NGOs and charitable organizations using UnityAid
- Open source community

---

## 📈 Roadmap

- [ ] Implement real-time notifications
- [ ] Add multiple payment gateway options
- [ ] Enhanced analytics and reporting
- [ ] Multi-language support
- [ ] Dark mode theming
- [ ] Social media integration
- [ ] Export donation receipts
- [ ] Advanced search filters

---

<div align="center">
  <p>Made with ❤️ for social good</p>
  <p>⭐ Star this repository if you find it helpful!</p>
</div>
