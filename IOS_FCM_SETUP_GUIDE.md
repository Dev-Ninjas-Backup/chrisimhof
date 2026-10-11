# iOS Firebase Cloud Messaging (FCM) & APNs Setup Guide

This guide documents the one-time Apple Developer Portal, Xcode, and Firebase Console configuration required for delivering push notifications to physical iOS devices and TestFlight / App Store builds.

---

## 1. Code & Project Configuration (Already Completed ✅)

The following codebase configuration has already been implemented:
1. **Dependency**: `firebase_messaging: ^16.7.0` installed in `pubspec.yaml` and linked via iOS Swift Package Manager / CocoaPods.
2. **`Info.plist`**: Added `UIBackgroundModes` with `fetch` and `remote-notification` in `ios/Runner/Info.plist`.
3. **`GoogleService-Info.plist`**: Placed in `ios/Runner/GoogleService-Info.plist` linked to project `ryvenza-1d3f0` and bundle ID `com.ryvenza.app`.
4. **`AppDelegate.swift`**: Uses `FlutterAppDelegate` which handles UNUserNotificationCenter delegate and APNs swizzling.
5. **`FcmService` (`lib/core/service/fcm_service.dart`)**:
   - Requests user permission (`alert`, `badge`, `sound`).
   - Configures `setForegroundNotificationPresentationOptions`.
   - Inspects `getAPNSToken()` and automatically syncs the FCM token to `PATCH /api/v1/users/:userId/fcm-token`.
   - Routes notification taps to the Notification Center.

---

## 2. Xcode Capabilities (One-Time Setup in Xcode)

When preparing to run on a physical iPhone or building for release/TestFlight:

1. Open the iOS project in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
2. Select the **Runner** project in the left project navigator.
3. Select the **Runner** target in the targets list.
4. Go to the **Signing & Capabilities** tab.
5. Ensure your Apple Developer Team is selected under **Signing**.
6. Click **+ Capability** (top left of the tab) and add:
   - **Push Notifications**
7. Click **+ Capability** again and add:
   - **Background Modes**
   - Check the box for: **Remote notifications**
   - Check the box for: **Background fetch**

---

## 3. Apple Developer Portal (Generate APNs Auth Key)

Firebase needs permission to send push notifications to Apple's Push Notification service (APNs) on your app's behalf.

1. Go to [Apple Developer Portal - Certificates, Identifiers & Profiles](https://developer.apple.com/account/resources).
2. Go to **Keys** in the left sidebar.
3. Click the **+** button to create a new key.
4. Set Key Name (e.g. `RYVENZA APNs Key`).
5. Check the box for **Apple Push Notifications service (APNs)**.
6. Click **Continue**, then click **Register**.
7. **Download the `.p8` file** (e.g. `AuthKey_XXXXXXXXXX.p8`).
   > ⚠️ **Important**: Apple only allows you to download this file ONCE. Store it securely.
8. Note down:
   - **Key ID**: The 10-character ID shown next to the key (e.g. `AB12CD34EF`).
   - **Team ID**: Your 10-character Apple Developer Team ID (visible in top right corner of the Developer portal).

---

## 4. Firebase Console Configuration

Link the `.p8` key with Firebase so the backend can dispatch push notifications through FCM to iOS devices:

1. Open [Firebase Console](https://console.firebase.google.com/).
2. Select the **ryvenza-1d3f0** project.
3. Click the gear icon ⚙️ next to **Project Overview** -> **Project settings**.
4. Go to the **Cloud Messaging** tab.
5. Scroll down to **Apple app configuration**.
6. In the **APNs Authentication Key** section, click **Upload**:
   - Upload your downloaded `.p8` file.
   - Enter the **Key ID** (10 characters).
   - Enter your **Team ID** (10 characters).
7. Click **Upload**.

---

## 5. Testing & Verification

1. **Physical Device Required**:
   - While iOS 16+ simulators on macOS 13+ support test push notifications, physical iPhones are the gold standard for APNs testing.
2. **App Launch**:
   - Run the app on an iPhone.
   - The app will present the native iOS notification permission dialog.
   - Tap **Allow**.
3. **Log Verification**:
   - In Xcode console / Flutter logs, look for:
     ```
     [FCM] Permission status: AuthorizationStatus.authorized
     [FCM] iOS APNs token: <apns_token>
     [FCM] Token sync response [200]: {"success":true,"message":"FCM token updated","data":null}
     ```
4. **Send a Test Notification**:
   - In Firebase Console -> **Messaging** -> **Create campaign** -> **Firebase Notification messages**.
   - Enter title and body, select the iOS app `com.ryvenza.app`, and click **Send test message** using the FCM token logged in your console.
