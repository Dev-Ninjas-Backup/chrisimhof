# Ryvenza API — Mobile & Frontend Integration Guide
**Target Audience: Mobile (Flutter / iOS / Android) & Web Frontend Engineers**  
*Last Updated: 2026-10-28 (Post-25-Oct Review Updates)*

---

## Table of Contents
1. [Executive Summary & Recent Changes](#1-executive-summary--recent-changes)
2. [Shift Lookahead on Days Off (`isDayOffToday` & Next Shift Fields)](#2-shift-lookahead-on-days-off)
3. [Shift Transition Protocol & Max Continuous Awake Time](#3-shift-transition-protocol--max-continuous-awake-time)
4. [Dedicated Endpoints: Optimal Bedtime & Sleep Screen](#4-dedicated-endpoints-optimal-bedtime--sleep-screen)
5. [Work Settings & Timezone Synchronization (`PUT` on App Resume)](#5-work-settings--timezone-synchronization)
6. [Morning Shift 90-Minute Pre-Shift Buffer & Adaptive Sleep Reminders](#6-morning-shift-90-minute-pre-shift-buffer--adaptive-sleep-reminders)
7. [Weekly Sport Objective & Multi-Session Workouts](#7-weekly-sport-objective--multi-session-workouts)
8. [Automatic 30-Hour Session Expiration & Morning Rollover Protocol](#8-automatic-30-hour-session-expiration--morning-rollover-protocol)
9. [Frontend Developer Integration Checklist (Flutter / Dart Examples)](#9-frontend-developer-integration-checklist)

---

## 1. Executive Summary & Recent Changes

Following Christian Imhof's review (25-Oct-2026) and the 29-Oct session rollover update, the backend has been updated to resolve several critical circadian calculation behaviors and API contracts:

1. **Shift Lookahead on Days Off (Point 02)**: On a Day Off, the backend queries the user's actual work rotation up to 14 days ahead. If the next shift is an Evening or Night shift, the sleep window reflects that upcoming shift (with circadian phase delay or chronotype baseline) instead of defaulting to an assumed `06:00` morning shift.
2. **Shift Transitions & Awake Duration Cap (Point 03)**: Continuous wakefulness is strictly capped at **16.5 hours** ($\le 17\text{h}$) from the recorded wake time. Day-Off $\rightarrow$ Night-Shift transitions now recommend intermediate sleep tonight with phase delay (e.g. `00:30`), eliminating the bug that recommended sleeping after tomorrow's shift (`06:30` next morning = 22.5h awake).
3. **Dedicated Endpoints for Flutter Sleep Flow**: Added `GET /api/v1/calculator/optimal-bedtime` and `GET /api/v1/calculator/session/:sessionId/sleep`.
4. **`PUT /api/v1/calculator/work-settings` (Point 07)**: Added `PUT` route support (in addition to `PATCH`) for the Flutter mobile lifecycle resume sync. When timezone changes, it synchronizes across Profile, User, WorkRotation, active session, and invalidates Redis cache.
5. **Morning Pre-Shift Buffer (90m)**: Wake times for morning shifts ($\le 13:59$) are automatically backed out as $\text{Shift Start} - 90\text{ minutes}$.
6. **Multi-Session Sport Tracking**: Completed workouts count individual sessions toward weekly targets rather than distinct calendar days.
7. **Automatic 30-Hour Inactive Session Rollover**: If an active session is older than 30 hours (e.g. user leaves app untouched for 48 hours), `GET /api/v1/calculator/session` and `GET /api/v1/dashboard` automatically finalize the expired day and return a fresh `PENDING_WAKE` session (`waitingForMainWake: true`) with a new `sessionId`. In addition, an hourly background cron sweeps and finalizes dormant sessions in PostgreSQL.

---

## 2. Shift Lookahead on Days Off

### What Changed
Previously, when a user was on a Day Off, the backend fell back to an assumed 06:00 morning shift, scheduling bedtime around 20:45–21:00.  
Now, the backend automatically queries the user's rotation calendar up to 14 days ahead and returns explicit next-shift metadata.

### API Contract: New Response Fields
Returned at the root level and inside `workInfo` in:
- `GET /api/v1/calculator/session`
- `GET /api/v1/dashboard`
- `GET /api/v1/calculator/optimal-bedtime`
- `GET /api/v1/calculator/session/:sessionId/sleep`

| Field | Type | Description |
| :--- | :--- | :--- |
| `isDayOffToday` | `boolean` | `true` if today's circadian session or calendar date is a Day Off (`'off'`). |
| `nextShiftStart` | `string \| null` | `HH:MM` start time of the next working shift (e.g. `"22:00"` or `"06:00"`). |
| `nextShiftType` | `string \| null` | Shift code of the next working shift (`"day"`, `"evening"`, `"night"`). |
| `nextShiftDate` | `string \| null` | Calendar date `YYYY-MM-DD` of the next working shift (e.g. `"2026-10-26"`). |

#### Example Response (`GET /api/v1/dashboard` or `GET /api/v1/calculator/session`)
```json
{
  "success": true,
  "statusCode": 200,
  "data": {
    "isDayOffToday": true,
    "nextShiftStart": "22:00",
    "nextShiftType": "night",
    "nextShiftDate": "2026-10-26",
    "workInfo": {
      "label": "Off",
      "shiftType": "off",
      "shiftStart": null,
      "shiftEnd": null,
      "derivedTiming": "off",
      "isDayOffToday": true,
      "nextShiftStart": "22:00",
      "nextShiftType": "night",
      "nextShiftDate": "2026-10-26"
    },
    "nextSleepWindow": {
      "sleepStart": "00:30",
      "wakeTime": "08:15",
      "sleepAt": "2026-10-26T00:30:00.000Z",
      "note": null
    }
  }
}
```

### Frontend Action
- **Work Card on Dashboard**:
  - If `isDayOffToday == true`:
    - Display "Day Off" badge/status.
    - If `nextShiftDate` & `nextShiftStart` are provided, display a subline: `"Next shift: Night at 22:00 (Mon, 26 Oct)"`.
  - If `isDayOffToday == false`:
    - Display current shift times as usual.

---

## 3. Shift Transition Protocol & Max Continuous Awake Time

### What Changed
- **Cap on Continuous Awake Time**: The server enforces a maximum continuous awake limit of **16.5 hours** ($\text{Wake Time} + 16.5\text{h}$, cap threshold 17 hours) from the user's recorded wake-up timestamp.
- **Day Off to Night Shift Transition**: When moving from a Day Off into a Night Shift (e.g. Sunday Day Off, Monday Night shift starting at 22:00), the app schedules **intermediate transition sleep tonight** with circadian phase delay (e.g. bedtime around `00:30`, waking around `08:15–08:30`).
- The user is **never** told to stay awake 22.5 hours until after the next night shift.

### Frontend Action
- The recommended bedtime displayed on the home screen banner (`optimalBedtime.time`) will naturally show `00:30` (or similar evening hour) rather than `06:30`.
- If `optimalBedtime.reasons` contains `"max wakefulness limit (16.5h)"`, the frontend may optionally display a small circadian safety pill/hint: `"Bedtime capped for safe wakefulness"`.

---

## 4. Dedicated Endpoints: Optimal Bedtime & Sleep Screen

To keep Flutter screens clean and avoid running calculation side effects, two dedicated endpoints are available:

### 4.1 `GET /api/v1/calculator/optimal-bedtime`
Used by the Dashboard / Bedtime widget.
- **URL**: `/api/v1/calculator/optimal-bedtime?locale=EN`
- **Method**: `GET`
- **Auth**: Bearer Token (`@Auth()`)
- **Response**:
```json
{
  "success": true,
  "statusCode": 200,
  "data": {
    "time": "00:30",
    "reasons": [],
    "sleepAsap": false,
    "sleepWindowPassed": false,
    "hoursUntilBed": 11.2,
    "isDayOffToday": true,
    "nextShiftStart": "22:00",
    "nextShiftType": "night",
    "nextShiftDate": "2026-10-26"
  }
}
```

### 4.2 `GET /api/v1/calculator/session/:sessionId/sleep`
Used when navigating to the Sleep Screen (`SleepLogScreen` / `SleepDetailsScreen`) to load initial state.
- **URL**: `/api/v1/calculator/session/:sessionId/sleep` (or alias `/api/v1/calculator/sessions/:sessionId/sleep`)
- **Method**: `GET`
- **Auth**: Bearer Token (`@Auth()`)
- **Response**:
```json
{
  "success": true,
  "statusCode": 200,
  "data": {
    "sessionId": "a1b2c3d4-...",
    "sleepStartTime": "23:15",
    "wakeTime": "07:30",
    "sleepDurationDisplay": "8h 15m",
    "optimalBedtime": {
      "time": "00:30",
      "reasons": [],
      "sleepAsap": false,
      "hoursUntilBed": 11.2
    },
    "nextSleepWindow": {
      "sleepStart": "00:30",
      "wakeTime": "08:15",
      "sleepAt": "2026-10-26T00:30:00.000Z"
    },
    "isDayOffToday": true,
    "nextShiftStart": "22:00",
    "nextShiftType": "night",
    "nextShiftDate": "2026-10-26",
    "tabSleep": {
      "sleepDebt7d": 45,
      "targetMinutes": 465
    }
  }
}
```

---

## 5. Work Settings & Timezone Synchronization

### What Changed
Flutter app sends `PUT /api/v1/calculator/work-settings` on application lifecycle resume (e.g. `didChangeAppLifecycleState` with `AppLifecycleState.resumed`).
- Previously returned `404 Not Found` because only `PATCH` was registered.
- Now both `PUT` and `PATCH` are fully supported.
- When `timezone` is passed, the backend automatically:
  1. Updates `Profile.timezone`
  2. Updates `User.timezone`
  3. Updates `WorkRotation.timezone`
  4. Updates active `DailySession.timezoneAtStart`
  5. Invalidates Redis baseline cache (`cache:baseline:${userId}`) and rotation cache

### Endpoint Details
- **URL**: `/api/v1/calculator/work-settings`
- **Method**: `PUT` or `PATCH`
- **Headers**: `Authorization: Bearer <TOKEN>`, `Content-Type: application/json`
- **Request Body**:
```json
{
  "timezone": "Europe/Zurich"
}
```
*(Also accepts `defaultRotation`, `shiftReminderEnabled`, and `shiftReminderMinutes`).*
- **Response**: Returns 200 OK with the full updated `WorkSettings` object.

### Frontend Action
In your Flutter app lifecycle listener, you can safely continue sending `PUT /api/v1/calculator/work-settings`:
```dart
Future<void> syncTimezoneOnResume() async {
  final currentTimezone = await FlutterTimezone.getLocalTimezone();
  await apiClient.put('/calculator/work-settings', data: {
    'timezone': currentTimezone,
  });
}
```

---

## 6. Morning Shift 90-Minute Pre-Shift Buffer & Adaptive Sleep Reminders

### 6.1 Pre-Shift Wake Buffer
- For morning shifts starting between `04:00` and `13:59`, the backend automatically backs out the wake time:
  $$\text{Planned Wake} = \text{Shift Start} - 90\text{ minutes}$$
- Recommended bedtime is backed out as $\text{Planned Wake} - \text{Sleep Target}$.
- **Frontend Action**: Do **not** calculate wake times or subtract buffers in Flutter code. Bind directly to `nextSleepWindow.wakeTime` and `nextSleepWindow.sleepStart`.

### 6.2 Adaptive Sleep-Logging Reminders (FCM)
- Push notifications are delivered adaptively at:
  $$\text{Reminder Time} = \text{Planned Wake} + 20\text{ minutes}$$
- Morning shift example: For a `06:00` shift $\rightarrow$ wake up `04:30` $\rightarrow$ push notification at `04:50`.
- Android FCM channel: `high_importance_channel` with high priority.
- iOS APNS: `sound: default`, `badge: 1`.
- **Frontend Action**:
  - In your Flutter `MainActivity.kt` / notification initialization:
    ```kotlin
    val channel = NotificationChannel(
        "high_importance_channel",
        "High Importance Notifications",
        NotificationManager.IMPORTANCE_HIGH
    )
    ```
  - In iOS, request standard alert and sound authorization.

---

## 7. Weekly Sport Objective & Multi-Session Workouts

### What Changed
The weekly sport objective counts **individual completed workout sessions**, not distinct calendar days.
- If a user logs 2 workouts in a single day (e.g. morning cardio + evening gym), both count toward the goal.
- `weeklySportStats.workoutsCompletedThisWeek` reflects the total session count.
- In `GET /api/v1/calculator/tabs/sport`, each day in `thisWeek` has a `sessions: []` array that can contain multiple workouts.

### Frontend Action
- Bind the progress label (e.g. `"3 / 5 completed"`) directly to `weeklySportStats.workoutsCompletedThisWeek` and `weeklySportStats.weeklyGoal`.
- Render the `sessions` list for each day in the weekly calendar grid (`ListView.builder` or `Column`).

---

## 8. Automatic 30-Hour Session Expiration & Morning Rollover Protocol

### What Changed
Previously, active circadian sessions stayed in status `ACTIVE` indefinitely if the user did not manually tap "End My Day" or submit a new wake. If a user left the app untouched for 48 hours, returning to the app served the 2-day-old active session with stale water, caffeine, and sport logs.

Now, both **lazy evaluation on request** and an **hourly background cron worker** enforce session expiration:
1. **30-Hour Inactive Expiration**: If an active session is older than 30 hours ($\text{now} \ge \text{expiresAt}$ or $\text{now} - \text{startedAt} \ge 30\text{h}$):
   - The backend automatically finalizes the expired day (`status: 'FINALIZED'`, `closedBy: 'MANUAL'`, saves `Calculation` history, and emits `session_ended`).
   - `GET /api/v1/calculator/session` immediately creates and returns a clean **`PENDING_WAKE`** session (`waitingForMainWake: true`) with a brand new `sessionId`.
   - `GET /api/v1/dashboard` detects the expiration, auto-finalizes the session, and returns `hasActiveSession: false`, `sessionId: null`, and `dataSource: 'last_calculation'`.
2. **Scheduled Sweeper**: A BullMQ/NestJS cron (`@Cron('0 * * * *')`) runs every hour to sweep and finalize dormant active sessions in PostgreSQL.

---

### Frontend Mobile Action (Flutter / Dart)

To ensure local SharedPreferences and UI controllers stay 100% in sync with the backend rollover:

#### 1. Session ID Invalidation & Tracking Reset
In `DashboardController.fetchDashboardData()` and `SessionService.fetchAndStoreSessionId()`:
```dart
final String? newSessionId = dataMap['sessionId'] as String?;
final String? storedSessionId = await SharedPreferencesHelper.getSessionId();

// When session changes (e.g. 30h rollover or manual end), clear stale tracking caches
if (newSessionId != null && newSessionId.isNotEmpty) {
  if (storedSessionId != null && storedSessionId != newSessionId) {
    debugPrint('[Session] Session ID changed from $storedSessionId to $newSessionId. Resetting local tracking data.');
    await resetTrackingData(newSessionId: newSessionId);
  } else {
    await SharedPreferencesHelper.saveSessionId(newSessionId);
  }
}
```

#### 2. Handle `waitingForMainWake == true` / `status == 'PENDING_WAKE'`
When the user opens the app after 30+ hours of inactivity:
- `dataMap['status'] == 'PENDING_WAKE'` and `dataMap['waitingForMainWake'] == true`.
- Clear local water, caffeine, meal, and workout logs:
  ```dart
  if (dataMap['waitingForMainWake'] == true || dataMap['status'] == 'PENDING_WAKE') {
    await resetTrackingData(newSessionId: newSessionId);
    // Display Morning Wake Prompt ("Good morning! What time did you wake up today?")
  }
  ```

#### 3. Client-Side Resume 30-Hour Guard
In `WidgetsBindingObserver.didChangeAppLifecycleState`:
```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.resumed) {
    final DateTime? sessionStartedAt = SharedPreferencesHelper.getSessionStartedAt();
    if (sessionStartedAt != null && DateTime.now().difference(sessionStartedAt).inHours >= 30) {
      debugPrint('[Lifecycle] Active session exceeded 30h on app resume. Refreshing session...');
      fetchDashboardData();
    }
  }
}
```

---

## 9. Frontend Developer Integration Checklist

Use this checklist to verify your Flutter / Mobile client integration:

- [ ] **Home / Dashboard Work Row**:
  - Bind to `isDayOffToday` from `/calculator/session` or `/dashboard`.
  - When `isDayOffToday == true`, show Day Off badge and display upcoming shift preview using `nextShiftStart`, `nextShiftType`, and `nextShiftDate`.
- [ ] **Bedtime Banner**:
  - Bind bedtime directly to `optimalBedtime.time`.
  - Do not override or reject bedtimes between `00:00` and `02:00` on Day-Off $\rightarrow$ Night-Shift transition nights (this is valid circadian phase delay).
- [ ] **App Lifecycle Resume Timezone Sync**:
  - Ensure `PUT /api/v1/calculator/work-settings` sends `{ "timezone": "<iana_tz>" }`.
- [ ] **Sleep Screen Loading**:
  - Call `GET /api/v1/calculator/session/{sessionId}/sleep` to load existing sleep logs and bedtime recommendations.
- [ ] **Morning Shift Buffers**:
  - Verify that wake time displayed for early shifts comes directly from `nextSleepWindow.wakeTime` (no client-side buffer math needed).
- [ ] **FCM Channel Configuration**:
  - Ensure Android `high_importance_channel` is registered so early wake notifications alert the user properly.