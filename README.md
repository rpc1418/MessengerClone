# MessengerClone

A concise Swift/Xcode project that demonstrates a modern messaging experience for Apple platforms.

## Overview

This repository contains an Xcode project built with Swift. It follows a modular, SwiftUI-first approach and integrates Firebase for authentication and realtime data.

- Platform(s): iOS
- Language: Swift
- UI: SwiftUI
- Minimum OS: iOS 17+ (update if your target differs)
- Build system: Xcode 26+
- Services: Firebase (Auth, Firestore)



## Requirements

- Xcode 26.0 or later
- Swift 6.x
- iOS 17+ (adjust as needed)
- A configured Firebase project (GoogleService-Info.plist) for Auth/Firestore
## Highlights

- Phone and Email authentication flows using Firebase Auth
- SwiftUI navigation with an `AppRouter` and custom top bar
- Contacts sync and registration detection
- Profile & Settings with theme selection and modular settings rows
- Modern UI components with gradients and glass effects

## Architecture

- SwiftUI-first with MVVM
  - Views: `LoginView`, `EmailRegistrationView`, `ProfileView`, `HomeTopBarView`, etc.
  - ViewModels: `ContactsViewModel`, `AuthViewModel`, etc (ObservableObject) manages state, async tasks, and filtering.
  - Routing: `AppRouter` with a typed `Route` enum and a `NavigationPath` for navigation stack management.
- Concurrency
  - Uses Swift Concurrency (async/await) for Firebase calls, contact syncing, and Core Data operations on the main actor when needed.
  - Streams for real-time updates via `AsyncThrowingStream` (e.g., messages and chat lists).
- Persistence
  - Core Data via `PersistenceController` with an `NSPersistentContainer` named `RegisteredContactContainer` for caching registered contacts and local selections.
  - Helper methods for CRUD: `createRegCon`, `fetchContactsDetails`, `fetUserById`, `deleteContact`, and mapping object IDs to user IDs.
- Theming
  - `ThemeManager` uses `@AppStorage("selectedTheme")` to persist the user’s theme preference and exposes an optional `ColorScheme` for system/light/dark.

## Services

- Authentication (`AuthService`)
  - Phone number OTP flow using `PhoneAuthProvider` with simulator test mode support.
  - Email sign-in/sign-up and password reset via Firebase Auth.
  - Explicit credential handling and cleanup of phone auth state to avoid corruption between modes.
- Firestore (`FirestoreService`)
  - User profile lifecycle: `saveUserProfile`, `createUserIfNotExists`, and `fetchUserData` keyed by normalized phone numbers.
  - Data decoding to `AppUser` with safe defaults and presence checks.
- Chats (`ChatService`)
  - Chat creation (`createChat`) for 1:1 and groups, with `lastMessage`, `lastUpdated`, and per-user `lastRead` fields.
  - Sending messages (`sendMessage`) with concurrent updates to message and chat metadata.
  - Real-time listeners using `AsyncThrowingStream` for user chat lists and per-chat messages.
  - Utilities for uploads (image/document stubs) and read receipts (`markMessageAsRead`).
- Contacts & Sync (`ContactsViewModel` + Core Data)
  - Requests Contacts permission, fetches distinct device numbers, normalizes to a canonical format, and mirrors changes locally.
  - Resolves contacts against Firestore: creates registered/unregistered entries and prunes deleted device contacts.

## Setup

1. Open the project in Xcode 26+.
2. Add your Firebase `GoogleService-Info.plist` to the iOS app target.
3. Ensure signing & capabilities are configured for your bundle identifier.
4. Build and run on iOS 17+.

## Screenshots 

## Home Tab Bar Section

| View Name | Light Mode | Dark Mode |
|----------|-----------|-----------|
| Chats | <img src="Snapshots/Light/Chats.png" width="200" alt="Chats"> | <img src="Snapshots/Dark/Chats.png" width="200" alt="Chats"> |
| Reg People | <img src="Snapshots/Light/RegPeople.png" width="200" alt="Reg People"> | <img src="Snapshots/Dark/RegPeople.png" width="200" alt="Reg People"> |
| People | <img src="Snapshots/Light/People.png" width="200" alt="People"> | <img src="Snapshots/Dark/People.png" width="200" alt="People"> |
| People Content View | <img src="Snapshots/Light/PeopleContentView.png" width="200" alt="People Content View"> | <img src="Snapshots/Dark/PeopleContentView.png" width="200" alt="People Content View"> |
| People Swipe Action | <img src="Snapshots/Light/PeopleSwipeAction.png" width="200" alt="People Swipe Action"> | <img src="Snapshots/Dark/PeopleSwipeAction.png" width="200" alt="People Swipe Action"> |
| Discover | <img src="Snapshots/Light/Discover.png" width="200" alt="Discover"> | <img src="Snapshots/Dark/Discover.png" width="200" alt="Discover"> |
| Profile & Settings | <img src="Snapshots/Light/ProfileAndSettings.png" width="200" alt="Profile & Settings"> | <img src="Snapshots/Dark/ProfileAndSettings.png" width="200" alt="Profile & Settings"> |
| Profile & Settings Logout and Liquid Glass | <img src="Snapshots/Light/psLiqGlass.png" width="200" alt="Profile & Settings Logout and Liquid Glass"> | <img src="Snapshots/Dark/psLiqGlass.png" width="200" alt="Profile & Settings Logout and Liquid Glass"> |
| Profile & Settings - Phone Verification | <img src="Snapshots/Light/psPhnoVerify.png" width="200" alt="Profile & Settings - Phone Verification"> | <img src="Snapshots/Dark/psPhnoVerify.png" width="200" alt="Profile & Settings - Phone Verification"> |

## Chat Section

| View Name | Light Mode | Dark Mode |
|----------|-----------|-----------|
| Chat | <img src="Snapshots/Light/Chat.png" width="200" alt="Chat"> | <img src="Snapshots/Dark/Chat.png" width="200" alt="Chat"> |
| Chat while typing | <img src="Snapshots/Light/ChatWTyping.png" width="200" alt="Chat while typing"> | <img src="Snapshots/Dark/ChatWTyping.png" width="200" alt="Chat while typing"> |
| Error | <img src="Snapshots/Light/Alert.png" width="200" alt="Error"> | <img src="Snapshots/Dark/Alert.png" width="200" alt="Error"> |

## Auth Section

| View Name | Light Mode | Dark Mode |
|----------|-----------|-----------|
| Auth Home | <img src="Snapshots/Light/AuthHome.png" width="200" alt="Auth Home"> | <img src="Snapshots/Dark/AuthHome.png" width="200" alt="Auth Home"> |
| Email Registration | <img src="Snapshots/Light/CreateAccount.png" width="200" alt="Email Registration"> | <img src="Snapshots/Dark/CreateAccount.png" width="200" alt="Email Registration"> |
| Email Login | <img src="Snapshots/Light/EmailLogin.png" width="200" alt="Email Login"> | <img src="Snapshots/Dark/EmailLogin.png" width="200" alt="Email Login"> |
| Password | <img src="Snapshots/Light/Password.png" width="200" alt="Password"> | <img src="Snapshots/Dark/Password.png" width="200" alt="Password"> |
| ForgotPassword | <img src="Snapshots/Light/ForgotPassword.png" width="200" alt="ForgotPassword"> | <img src="Snapshots/Dark/ForgotPassword.png" width="200" alt="ForgotPassword"> |
| Phone Login | <img src="Snapshots/Light/PhnoLogin.png" width="200" alt="Phone Login"> | <img src="Snapshots/Dark/PhnoLogin.png" width="200" alt="Phone Login"> |
| Verify OTP | <img src="Snapshots/Light/VerifyOtp.png" width="200" alt="Verify OTP"> | <img src="Snapshots/Dark/VerifyOtp.png" width="200" alt="Verify OTP"> |
