# GYM Project Workspace

Welcome to the **GYM** project workspace. This repository houses the entire Gym & Fitness Management ecosystem, organized into modular components.

## Workspace Structure

```
GYM/
├── gym_app/             # Flutter mobile application (iOS & Android)
├── gym_admin_pannel/     # Admin control panel folder
└── gym_backend/         # Backend API folder
```

---

## 📱 Gym App (`/gym_app`)

A premium, responsive Flutter-based mobile application designed to provide users with a complete fitness management experience.

### Key Features
*   **Authentication & Onboarding**: Premium welcome, onboarding sliders, login, registration, and social sign-in integration.
*   **Dashboard**: A visually striking home screen featuring body metrics overview and progress line charts.
*   **Redesigned Membership Plans**: Clean, modern membership screens featuring:
    *   Dynamic monthly/yearly plan toggles.
    *   Detailed list of plan features and pricing.
*   **Profile & Settings Screens**: Completely integrated sub-screens within the user profile:
    *   **Personal Information**: Edit user details.
    *   **Goals**: Set and track fitness achievements.
    *   **Notifications Settings**: Manage alerts and schedules.
    *   **Payment History**: View billing logs.
    *   **Help & Support**: FAQs and contact channels.
*   **Diet & Workout Trackers**:
    *   Custom meal card lists.
    *   Interactive exercise and workout programs.

### Design System & Typography
*   **Typography**: Styled using the premium **Oswald** (for headlines) and **Montserrat** (for body/subtitles) font families.
*   **Responsiveness**: Optimized layouts to prevent overflow issues (`RenderFlex` errors) across different screen sizes, including various iOS and Android devices.

### Getting Started (Mobile App)
1.  Navigate to `gym_app/`:
    ```bash
    cd gym_app
    ```
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Run the application:
    ```bash
    flutter run
    ```

---

## 💻 Admin Panel (`/gym_admin_pannel`)
*(Under Development / Coming Soon)*

An administrative dashboard to manage members, check subscriptions, analyze payments, and manage diet/workout plans.

---

## ⚙️ Backend (`/gym_backend`)
*(Under Development / Coming Soon)*

A robust server application to handle authentication, database storage, subscription verification, and API endpoints for both the mobile app and the admin panel.
