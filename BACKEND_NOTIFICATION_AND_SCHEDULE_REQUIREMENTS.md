# RYVENZA Backend Specification: Adaptive Sleep-Logging Reminders & Schedule Calculations

**Date**: October 25, 2026  
**Target Audience**: Backend Development Team  
**Reference Document**: `RYVENZA_Corrections_Application_22-10-2026-1.pdf` (Page 7 & Page 8) + Client Testing Feedback  
**Status**: High Priority / Pending Implementation  

---

## 1. Context & Problem Statement

### 1.1 The Client's Direct Feedback
During testing of the live app with push notifications, the client noted:
> *"Could you also run another check of the notifications, especially their delivery and timing? I've detailed the requested changes for the sleep-logging reminder, but I have the impression that one or two reminders may not be arriving or triggering correctly. I'm not certain yet, so it would be great if you could take a closer look."*

### 1.2 Root Cause Analysis
1. **Static Morning Delivery**: Currently, the notification cron triggers sleep-logging reminders at a fixed morning hour (e.g., `08:00` local time).
2. **Shift Worker Incompatibility**: Shift workers operate on irregular schedules:
   * **Night Shifts**: Workers sleep during the day and wake up in the afternoon/evening (e.g., `14:00` or `18:00`). Sending a reminder at `08:00` wakes the user up in the middle of their deep sleep, violating core circadian health principles.
   * **Early Morning Shifts**: Workers wake up at `04:00` for a `05:30` shift. An `08:00` reminder arrives 4 hours too late, long after they have already started working.
3. **Missing Suppression & Recalculation**:
   * Notifications are dispatched even if the user has already recorded their sleep for that cycle.
   * When a user changes their shift rotation or calendar date override in the app, pending notifications are not rescheduled.

---

## 2. Requirement 1: Adaptive Sleep-Logging Reminder (Page 8)

The sleep-logging push notification reminder must adapt dynamically to each user's configured shift schedule and planned wake time.

### 2.1 Trigger Time Formula
$$\text{Notification Trigger Time} = \text{Planned Wake Time} + 20 \text{ minutes}$$

All calculations must be evaluated in the user's local timezone (`profile.timezone` / device timezone).

### 2.2 Shift Type Matrix

| Schedule Scenario | How Wake Time is Determined | Reminder Delivery Time |
| :--- | :--- | :--- |
| **Morning Shift** (e.g. shift `05:00` – `13:00`) | Planned wake time: `04:00` (calculated as `shift start - 1h30` or user-defined) | **`04:20`** local time |
| **Afternoon / Evening Shift** (e.g. shift `14:00` – `22:00`) | Planned wake time: `11:30` | **`11:50`** local time |
| **Night Shift** (e.g. shift `22:00` – `06:00`) | Planned wake time: `15:00` (sleep during the morning/afternoon) | **`15:20`** local time |
| **Rest Day (Known Planned Wake Time)** | User configured a planned wake time (e.g. `09:30`) | **`09:50`** (`wake time + 20m`) |
| **Rest Day (Unknown Wake Time)** | No planned wake time set | **`08:00`** local time (fallback) |
| **Work Day (Unknown Wake Time)** | Derived from active work rotation pattern | `(Rotation Shift Start - 1h30) + 20m` |

---

### 2.3 Strict Suppression & Cancellation Rules

1. **Already Recorded Sleep**:
   * Before dispatching the push notification, check if a sleep record exists for the current session/cycle:
   ```typescript
   const existingSleep = await db.sleepLogs.findOne({
     userId,
     occurredAt: { $gte: cycleStartUtc, $lte: cycleEndUtc }
   });
   if (existingSleep) {
     // Suppress notification — do not send!
     return;
   }
   ```
   * If a user logs sleep before the reminder fires, cancel the pending reminder job immediately.

2. **Planned Sleep Window Protection**:
   * **Under no circumstance** may a notification be sent while the user is inside their planned sleep window (`optimalBedtime` to `plannedWakeTime`).
   * This restriction also applies to the `08:00` rest day fallback. If the user's planned sleep window covers `08:00` (e.g., night shift recovery sleep from `07:00` to `15:00`), the `08:00` fallback **must not fire**.

3. **Schedule Changes / Dynamic Recalculation**:
   * Whenever an endpoint modifies the user's schedule:
     * `POST /api/v1/schedule/rotation/save`
     * `PATCH /api/v1/calculator/work-rotation/override`
     * `PATCH /api/v1/profile/baseline`
   * The backend must:
     1. Invalidate/cancel any pending sleep-reminder job scheduled for that user.
     2. Recalculate the next planned wake time from the updated calendar.
     3. Schedule a new job for `Planned Wake Time + 20 min`.

4. **Zero Manual Setup Required**:
   * The user must never be forced to set a manual reminder alarm. The system must schedule this automatically in the background.

---

### 2.4 Payload Specification (FCM Push Notification)

When dispatching the notification via Firebase Cloud Messaging (`FCM`), use the following structure:

```json
{
  "token": "<user_fcm_token>",
  "notification": {
    "title": "Enregistrez votre dernier sommeil",
    "body": "Prenez un instant pour noter votre dernier sommeil et maintenir vos recommandations à jour."
  },
  "data": {
    "type": "SLEEP_REMINDER",
    "channel": "high_importance_channel",
    "click_action": "FLUTTER_NOTIFICATION_CLICK",
    "route": "/sleepScreen"
  },
  "android": {
    "priority": "high",
    "notification": {
      "channel_id": "high_importance_channel",
      "sound": "default"
    }
  },
  "apns": {
    "payload": {
      "aps": {
        "sound": "default",
        "badge": 1
      }
    }
  }
}
```

*Note: Titles and bodies must respect the user's interface language (`user.language == 'FR'` vs `'EN'`).*

* **English**:
  * Title: `"Log your last sleep"`
  * Body: `"Take a moment to record your last sleep to keep your rhythm and recommendations accurate."`
* **French**:
  * Title: `"Enregistrez votre dernier sommeil"`
  * Body: `"Prenez un instant pour noter votre dernier sommeil et maintenir vos recommandations à jour."`

---

## 3. Requirement 2: Morning-Shift 90-Minute Buffer Rule (Page 7)

On Page 7 of the specification, the client requested a modification to the bedtime and wake calculation rule for morning shifts.

### 3.1 The 90-Minute Product Rule
* **Previous/Screenshot Interval**: 2-hour interval before shift start.
* **New Requested Rule**: Use a **90-minute default buffer** (`1h 30m`) for morning shifts.

$$\text{Wake Time} = \text{Next Shift Start} - 1 \text{ hour } 30 \text{ minutes}$$
$$\text{Bedtime} = \text{Wake Time} - \text{Personalized Sleep Duration Target}$$

### 3.2 Shift Differentiation
* **Morning Shifts**: Apply the 90-minute buffer rule automatically.
* **Afternoon and Night Shifts**: Do **not** apply the 90-minute morning buffer. Continue existing adaptation based on circadian rhythm and the shift schedule cycle.

### 3.3 Example Calculation
* User has a morning shift starting at **`05:00`**.
* User's baseline target sleep duration: **`7h 45m`** (`sleepTargetMinutes = 465`).
* **Wake Time**: `05:00 - 1h30` = **`03:30`**.
* **Bedtime**: `03:30 - 7h45m` = **`19:45`** (previous evening).
* **Sleep Reminder**: `03:30 + 20m` = **`03:50`**.

---

## 4. Implementation Architecture Recommendation

### Option A: Distributed Queue with Delayed Jobs (Recommended)
If using **BullMQ / Redis** or **Agenda / Mongo**:
1. When generating or updating the user's active rotation, enqueue a job `SEND_SLEEP_LOG_REMINDER` with a delay timestamp equal to `(plannedWakeUtc + 20 minutes)`.
2. Assign a deterministic job ID (e.g., `sleep-reminder-${userId}-${sessionDate}`).
3. If the user logs sleep or changes schedule, call `queue.remove(jobId)` and re-enqueue if necessary.

### Option B: High-Frequency Scheduler (Tick Every 5–10 Minutes)
If using a cron runner (e.g. `node-cron`):
1. Every 5 minutes, query users where:
   * Current UTC time $\in [\text{targetReminderUtc} - 2\text{m}, \text{targetReminderUtc} + 2\text{m}]$
   * No sleep log exists for the current cycle.
   * User has `notificationPreferences.bedtimeAlerts == true`.
2. Dispatch FCM push and mark `reminderSentAt = new Date()`.

---

## 5. Verification Checklist for Backend Team

- [ ] **1. Scheduler**: Replaced static 08:00 cron with dynamic `plannedWakeTime + 20m`.
- [ ] **2. Shift-Aware**: Afternoon (`14:00+`) and night shift wake times trigger in the afternoon/evening.
- [ ] **3. Rest Day Fallback**: Rest days with known wake time use `wake + 20m`; fallback to 08:00 only when wake time is unknown.
- [ ] **4. Sleep Interval Protection**: Notifications never trigger during planned sleep intervals.
- [ ] **5. Suppression**: No reminder is sent if sleep is already logged for the session.
- [ ] **6. Invalidation Hook**: Pending jobs are canceled and rescheduled when rotation/override changes.
- [ ] **7. Morning Shift Buffer**: `calculator.service.ts` uses `shiftStart - 1h30m` for morning shift wake time calculations.
- [ ] **8. Multilingual FCM**: Push messages use French when `user.language == 'FR'` and English when `user.language == 'EN'`.
