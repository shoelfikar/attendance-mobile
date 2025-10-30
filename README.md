# Attendance Mobile App

Aplikasi mobile untuk sistem absensi berbasis GPS, dibangun dengan Flutter untuk platform Android.

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider / Riverpod / Bloc
- **HTTP Client**: Dio
- **GPS**: geolocator
- **Storage**: shared_preferences / hive
- **Maps**: google_maps_flutter / flutter_map

## 📁 Project Structure

```
attendance_mobile/
├── lib/
│   ├── core/
│   │   ├── constants/         # App constants
│   │   ├── theme/             # App theme
│   │   └── utils/             # Utility functions
│   ├── data/
│   │   ├── models/            # Data models
│   │   ├── repositories/      # Repository implementations
│   │   └── datasources/       # API & local data sources
│   ├── domain/
│   │   ├── entities/          # Business entities
│   │   ├── repositories/      # Repository interfaces
│   │   └── usecases/          # Business logic use cases
│   ├── presentation/
│   │   ├── pages/             # App screens
│   │   ├── widgets/           # Reusable widgets
│   │   └── providers/         # State management
│   └── main.dart              # App entry point
├── assets/                    # Images, fonts, etc.
├── android/                   # Android configuration
├── ios/                       # iOS configuration (future)
├── test/                      # Unit & widget tests
└── pubspec.yaml               # Dependencies
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.x or higher
- Android Studio / VS Code
- Android device / emulator
- Backend API running

### Installation

1. Navigate to mobile directory:
```bash
cd attendance_mobile
```

2. Get dependencies:
```bash
flutter pub get
```

3. Configure API endpoint in `lib/core/constants/api_constants.dart`

4. Run the app:
```bash
# Check available devices
flutter devices

# Run on connected device/emulator
flutter run

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release
```

## 📋 Features

### Authentication
- Login screen
- Register screen (optional)
- JWT token storage
- Auto-login
- Logout

### Home Screen
- User profile summary
- Today's attendance status
- Quick check-in/check-out button
- Recent attendance history
- Notifications

### Check-In/Check-Out Flow
1. User taps "Absen" button
2. Request GPS permission (if not granted)
3. Get current GPS location
4. Validate location with backend
5. Show confirmation dialog
6. Optional: Take selfie photo
7. Submit attendance
8. Show success/error message

### Attendance History
- List of past attendances
- Filter by date range
- View attendance details
- Check-in/check-out times
- Location information
- Work duration

### Profile
- View user information
- Edit profile
- Change password
- Notification settings
- App version

## 📍 GPS Permissions

### Android Configuration

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.CAMERA" />

    <application>
        ...
    </application>
</manifest>
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

## 📦 Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split APKs by architecture
flutter build apk --split-per-abi

# APK location
# build/app/outputs/flutter-apk/app-release.apk
```

## 🔐 Security

- Secure token storage
- API key obfuscation
- Certificate pinning (production)
- Root/jailbreak detection
- Code obfuscation

## 🎯 Development Roadmap

- [x] Project initialization
- [ ] Setup Clean Architecture
- [ ] Authentication screens
- [ ] GPS service implementation
- [ ] Home screen & dashboard
- [ ] Check-in/check-out flow
- [ ] Camera integration
- [ ] Attendance history
- [ ] Offline mode
- [ ] Push notifications
- [ ] Profile management
- [ ] Testing

## 📝 License

Proprietary

---

**Version:** 1.0.0
**Status:** In Development
**Platform:** Android (iOS coming soon)
