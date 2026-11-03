<div align="center">

<img src="docs/logo.png" alt="MoveM logo" width="120" />

# MoveM

### Your life, in motion.

**Fitness, trips and tasks — together with your friends, in one app.**

Built by **Team ForRiel** for the **Youth Mobile App Competition**

<br />

![Flutter](https://img.shields.io/badge/Flutter-3.44-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![GetX](https://img.shields.io/badge/State-GetX-8A2BE2?style=for-the-badge)
![Firebase](https://img.shields.io/badge/Firebase-FCM%20%7C%20Storage-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Google Maps](https://img.shields.io/badge/Google%20Maps-Routes-4285F4?style=for-the-badge&logo=googlemaps&logoColor=white)
![ML Kit](https://img.shields.io/badge/ML%20Kit-Pose%20Detection-34A853?style=for-the-badge&logo=google&logoColor=white)

![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-lightgrey?style=flat-square)
![Languages](https://img.shields.io/badge/languages-English%20%7C%20ខ្មែរ-3C66C0?style=flat-square)
![Theme](https://img.shields.io/badge/theme-light%20%7C%20dark-111827?style=flat-square)

</div>

---

## ✨ What is MoveM?

MoveM is a social lifestyle app for young people. It brings three everyday things into one place — **staying active**, **travelling with friends**, and **getting things done** — and makes each of them social, so you can share progress, challenge friends and plan together.

<table>
<tr>
<td width="33%" valign="top">

### 🏃 Fitness
- GPS **running tracker** with live route on Google Maps
- **Push-up & squat counter** using the camera and ML Kit pose detection — no wearable needed
- Solo challenges, **clubs** and club challenges
- Goals, achievements, badges and workout history
- **Share workouts** to the feed

</td>
<td width="33%" valign="top">

### 🧳 Trips
- Create trips and **invite friends**
- Trip **route** planning on the map
- Shared **budget & expenses**
- **Split bills** between members
- Trip updates and invitations

</td>
<td width="33%" valign="top">

### ✅ Tasks
- Personal and **shared tasks**
- Add collaborators, comments and an activity feed
- Due dates, overdue handling and **reminders**
- Filter by status
- Task invitations

</td>
</tr>
</table>

### 🤝 Social & everything else

| | |
|---|---|
| 📰 **Home feed** | Friends' workouts with route maps, likes and comments |
| 👥 **Friends** | Search, add by **QR code**, public profiles |
| 🔔 **Notifications** | Push notifications (FCM) and local reminders |
| 🔐 **Secure sign-in** | Login with **OTP verification**, trusted devices, secure token storage |
| 🌗 **Light & dark mode** | Every screen follows the theme |
| 🇰🇭 **Khmer & English** | Full localization |
| ⚡ **Smooth loading** | Shimmer skeletons instead of spinners |

---

## 🛠 Tech stack

| Area | Tools |
|---|---|
| **Framework** | Flutter 3.44, Dart 3 |
| **State & routing** | GetX |
| **Networking** | Dio, REST API backend (OpenAPI / Swagger docs) |
| **Maps & location** | Google Maps, Geolocator, Geocoding |
| **Computer vision** | Google ML Kit Pose Detection, Camera |
| **Storage** | Isar (local DB), Shared Preferences, Flutter Secure Storage |
| **Cloud** | Firebase Cloud Messaging, Firebase Storage |
| **UI** | Google Fonts, fl_chart, Shimmer, Pinput, Cached Network Image |
| **Localization** | `flutter_localizations` + ARB files (English, Khmer) |

---

## 🧱 Architecture

MoveM uses a **feature-first clean architecture**. Each feature owns its data, domain and presentation layers.

```
lib/
├── core/                 # config, network (Dio, API results), routes, theme, storage
├── shared/               # base controller, shared widgets (skeletons, toolbars…)
├── l10n/                 # English & Khmer translations
└── features/
    ├── auth/             # login, register, OTP, reset password
    ├── home/             # feed and activity detail
    ├── fitness/          # running, push-up, squat, clubs, challenges, goals
    ├── trip/             # trips, routes, budget, split bills
    ├── task/             # tasks, collaborators, comments, reminders
    ├── friends/          # friends, QR code, public profiles
    ├── groups/
    ├── notifications/
    ├── settings/         # profile, theme, language, account
    └── main_nav/         # bottom navigation
        └── <feature>/
            ├── data/         # DTOs, services, repository implementations
            ├── domain/       # models and repository contracts
            └── presentation/ # screens, widgets, GetX controllers
```

---

## 🚀 Getting started

### Requirements
- Flutter **3.44** (stable)
- Android Studio or Xcode
- A Google Maps API key
- Firebase config files (`google-services.json`, `GoogleService-Info.plist`)

### Setup

```bash
git clone https://github.com/KanekaVong/MoveM.git
cd MoveM
flutter pub get
```

Add your Maps key to `android/local.properties` (this file is not committed):

```properties
MAPS_API_KEY=your_google_maps_key
```

### Run

```bash
# Development (app id: com.example.movem.dev, name "MoveM Dev")
flutter run --flavor dev -t lib/main_dev.dart

# Production
flutter run --flavor prod -t lib/main_release.dart
```

### Test

```bash
flutter analyze
flutter test
```

---

## 👩‍💻 Team ForRiel

<div align="center">

<table>
<tr>
<td align="center" width="20%">
<img src="docs/team/vong-kaneka.png" width="110" alt="Vong Kaneka" /><br />
<b>Vong Kaneka</b>
</td>
<td align="center" width="20%">
<img src="docs/team/eang-senghou.png" width="110" alt="Eang Senghou" /><br />
<b>Eang Senghou</b>
</td>
<td align="center" width="20%">
<img src="docs/team/treng-pichpanha.png" width="110" alt="Treng PichPanha" /><br />
<b>Treng PichPanha</b>
</td>
<td align="center" width="20%">
<img src="docs/team/john-youlong.png" width="110" alt="John Youlong" /><br />
<b>John Youlong</b>
</td>
<td align="center" width="20%">
<img src="docs/team/huot-sovan-channabot.png" width="110" alt="Huot Sovan Channabot" /><br />
<b>Huot Sovan Channabot</b>
</td>
</tr>
</table>

<br />

Made with 💙 in Cambodia

</div>
