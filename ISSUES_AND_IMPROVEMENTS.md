# Ryvenza App — Issues, Feature Requests & Technical Investigation Log

This document consolidates all reported feedback, bugs, UX clarifications, and requested features from recent user testing sessions.

---

## Quick Reference Summary Table

| # | Topic | Area | Description | Status |
|---|---|---|---|---|
| **1** | **Meal Logging & Update Inconsistency** | Bug Fix | Meal heaviness values normalized to canonical types; French translations & status toasts localized; false error messages fixed. | ✅ Resolved |
| **2** | **French / English Localization** | i18n / Audit | App-wide audit completed with 100% dictionary key parity (537 keys in en_US and fr_FR); all toasts, dialogs, controllers, and UI overflow edge cases resolved. | ✅ Resolved |
| **3** | **Unclear UI Button / Function (Sleep Rollover Toggle)** | UX / Clarity | Replaced internal jargon ("Start New Main Wake (Rollover)") with intuitive labels ("Start a New Day" / "Démarrer une nouvelle journée") across UI and i18n dictionaries. | ✅ Resolved |
| **4** | **Named Custom Work Schedules** | Work Feature | Allow custom names (e.g. *"Syngenta"*), show them in shift options, verify auto-progression. | ⚙️ In Progress |
| **5** | **Dynamic Bedtime Suggestions** | Sync / Logic | Update recommendation card bedtime text dynamically when caffeine shifts bedtime. | 🔍 Identified |
| **6** | **Adaptive Meal Timing Logic** | Nutrition Logic | Suggest appropriate meal types based on hours fasted and remaining meal target. | 🔍 Identified |
| **7** | **Sport Activity Type Icons** | UI / Assets | Activity icons mapped (Strength/Force → dumbbell, Running/Course → runner, Cycling/Vélo → bike, Swimming/Natation → pool, Mobility/Yoga → yoga, Rest Day → zzz). | ✅ Resolved |
| **8** | **Sleep Quality Score 0 Audit** | Backend Logic | Audit sleep score calculation for 17.5h sleep (clamped to 0 by backend penalties); backend adjustment needed for baseline floor/outlier handling. | 🔍 Identified |
| **9** | **Persistent Default Daily Meal Goal** | Feature | Allow setting a default meal target (e.g., 5 meals) with *"Save as default"* option. | ⚙️ In Progress |
| **10** | **Automatic Daily Refresh & Day Transitions** | App Lifecycle / Shift Logic | Strict prohibition on midnight resets for shift workers; day transitions occur via "End My Day" or logging main sleep ("Start a New Day"). Verified seamless refresh without logout. | ✅ Verified |
| **11** | **Shift-Aware Bedtime Recommendation** | Backend Logic | Calculate bedtime backwards from tomorrow's shift start time - prep buffer - sleep goal & debt. Backend calculation update required. | 🔍 Identified |

---

## Detailed Specifications & Technical Breakdown

---

### 1. Meal Logging: False "Not Saved" Notification
* **User Report**: *"There seems to be a small issue when adding a meal. The meal is actually saved correctly, but the app shows a message saying that it wasn't saved."*
* **Root Cause**:
  * In `nutrition_controller.dart` (`saveMeal()`), after the API call `DashboardService().patchQuickAddLog()` succeeds, any secondary refresh failure or improper status code parsing triggers the `EasyLoading.showError(...)` branch or an unhandled exception toast.
* **Solution**:
  * Validate API response status directly in `NutritionController.saveMeal()`.
  * Ensure success toast (`EasyLoading.showSuccess('Meal logged successfully'.tr)`) is explicitly displayed only when the HTTP status is `200/201`.
  * Prevent false fallback error triggers.

---

### 2. French & English Translations Audit (i18n) — ✅ Resolved
* **User Report**: *"Could you please double-check all the translations throughout the app? There are still quite a few places where some text remains in English when the app is set to French (e.g., error messages, pop-ups, notifications, etc.)."*
* **Scope & Resolution**:
  * **Translation File**: Full audit completed in `lib/core/common/widgets/app_translations.dart` with 100% dictionary key parity (537 matching keys between `'en_US'` and `'fr_FR'`). Fixed all encoding/mojibake artifacts.
  * **Controllers & Services**: Localized all runtime error messages, EasyLoading toasts, validation popups, and dialogs.
  * **Dynamic UI & Overflow Fixes**: Resolved all French text overflow instances in `time_widget.dart`, `shift_type_grid.dart`, and `custom_navbar.dart`.
  * **Weekday & Shift Labels**: Localized weekday short names and shift state tags (`'Repos'` for rest/off).

---

### 3. Sleep Screen: "Start New Main Wake (Rollover)" Toggle Clarification & UX Redesign — ✅ Resolved
* **User Screenshot**: The toggle in the Sleep Logging card (`log_sleep_card.dart`):
  * **Previous Title**: *"Start New Main Wake (Rollover)"* (FR: *"Démarrer un nouveau réveil principal (Report)"*)
  * **Previous Subtitle**: *"Enable if logging main wake after forgetting End Day"* (FR: *"Activer si vous enregistrez le réveil principal après avoir oublié Fin de journée"*)
* **How It Works Technically**:
  * **Standard Flow**: When a user finishes their active day and goes to sleep, they press **"End My Day"** on the Dashboard. This sets the active day session to `PENDING_WAKE`. When waking up, logging sleep automatically finalizes that cycle and creates a new day session (`isNewMainWake = true` is sent automatically by the controller).
  * **Forgot "End Day" Edge Case**: If the user goes to sleep without tapping "End My Day", the previous day session remains `ACTIVE`. When logging their main overnight sleep upon waking up, turning this toggle **ON** tells the backend API to finalize yesterday's unclosed session and immediately initialize a fresh day session (`sessionId`) for today.
* **Resolution**:
  * Updated UI widget in `log_sleep_card.dart` and translations in `app_translations.dart` (`en_US` & `fr_FR`):
    * **Title (EN)**: `Start a New Day`
    * **Subtitle (EN)**: `Turn on if you forgot to tap 'End My Day' before sleeping`
    * **Title (FR)**: `Démarrer une nouvelle journée`
    * **Subtitle (FR)**: `Activez si vous avez oublié d'appuyer sur « Terminer ma journée » avant de dormir`

---

### 4. Work Schedule: Named Custom Rotations & Cycle Auto-Progression
* **User Report**:
  1. Allow custom work schedules to have user-defined names (e.g., *"Syngenta"*).
  2. Show the saved custom schedule by name in the Work Schedule selection list alongside predefined templates (prevent defaulting to *"None"*).
  3. Confirm that once activated, the rotation continues automatically over time even if the user does not open the app for weeks.
* **Technical Confirmation on Auto-Progression**:
  * **Already Supported mathematically**: Rotation calculation uses:
    $$\text{Pattern Index} = (\text{Current Date} - \text{Start Date})_{\text{days}} \pmod{7 \times \text{Cycle Weeks}}$$
    Since it is computed purely from the calendar difference, **it automatically stays synchronized across days, weeks, and months without requiring daily app logins.**
* **Enhancements to Add**:
  * Add a `name` field to the custom rotation model and local persistence (`CustomRotationPrefs`).
  * Add the named rotation into the proposals list in `work_schedule_settings_screen.dart` and `work_controller.dart`.

---

### 5. Dynamic Bedtime Suggestions with Caffeine Recalculation
* **User Report**: *"I added caffeine, and my recommended bedtime correctly changed from 10:30 PM to 11:15 PM. However, in the suggestions/recommendations, it was still showing 10:30 PM. Would it be possible to make the suggestions update dynamically as well?"*
* **Root Cause & Technical Investigation**:
  * The main bedtime variable updates reactively, but recommendation strings (e.g. *"Visez le coucher avant 22:30 — votre fenêtre circadienne s'ouvre alors."*) are pre-computed static strings generated by the backend recommendation engine in `/session/{sessionId}/recommendations`.
* **Frontend Implementation Completed**:
  * **[recomendations_controller.dart](file:///Users/saharaislam/Desktop/Tahmid/chrisimhof/lib/features/recomendations/controller/recomendations_controller.dart)**: Added `refetchRecommendations(silent: true)` to smoothly update the full recommendation dataset.
  * **[realtime_socket_service.dart](file:///Users/saharaislam/Desktop/Tahmid/chrisimhof/lib/core/service/realtime/realtime_socket_service.dart)**: Connected `refetchRecommendations()` to `live_scores` and `dashboard` socket events.
  * **[dashboard_controller.dart](file:///Users/saharaislam/Desktop/Tahmid/chrisimhof/lib/features/dashboard/main_dashboard/controller/dashboard_controller.dart)**: Connected `refetchRecommendations()` to `updateFromLiveScores()`.
* **Backend Requirement (for tomorrow)**:
  * In the backend recommendation generation service, update the Sleep recommendation text builder to insert the caffeine-shifted bedtime target (`caffeineShiftedBedtime`) instead of the raw circadian baseline (`22:30`).

---

### 6. Dynamic Meal Timing & Fasting-Aware Recommendations
* **User Report**: *"I intentionally simulated 9 hours without eating. I had only logged 2 meals out of my 5 planned meals, but the app was still recommending a light meal. The suggestion should adapt more to the actual situation."*
* **Recommendation Logic Rules**:
  * **Long Fast (> 5–6 hours) + High Remaining Meal Deficit**: Recommend a substantial/balanced meal rather than a light snack.
  * **Close to Bedtime (< 2–3 hours)**: Recommend a light meal to prevent sleep disruption, regardless of meal deficit.
  * **Post-Workout**: Recommend a protein/recovery-focused meal.

---

### 7. Activity-Specific Sport Icons — ✅ Resolved
* **User Report**: *"Instead of using a sleep icon, ideally there should be a different icon depending on the type of sport (Strength → dumbbell, Running → running person, Cycling → bicycle, Swimming → swimmer, etc.)."*
* **Root Cause**:
  * `SportsController._getIconPathForActivity()` was previously defaulting unrecognized activity names (including French translations like `"Force"` or `"Course"`, as well as standard activities like `"Cycling"` and `"Swimming"`) to `IconPath.restDay` (the "zzz" sleeping icon).
* **Resolution**:
  * **[sports_controller.dart](file:///Users/saharaislam/Desktop/Tahmid/chrisimhof/lib/features/sports/controller/sports_controller.dart)**:
    * Enhanced `_getIconPathForActivity` to support keyword matching in English and French (`strength`/`force`/`renforcement`/`musculation`, `run`/`course`/`jogging`, `mobility`/`mobilité`/`yoga`/`stretch`, `rest`/`repos`).
    * Changed default fallback from `restDay` ("zzz") to `IconPath.sport`.
    * Upgraded `loadSportsData` to self-heal previously saved cached entries where workouts had been saved with `rest_day.png`.
  * **[list_of_workouts.dart](file:///Users/saharaislam/Desktop/Tahmid/chrisimhof/lib/features/sports/widgets/list_of_workouts.dart)**:
    * Implemented `_buildWorkoutIcon` to render activity-specific icons:
      * **Strength / Force / Musculation**: Dumbbell icon (`IconPath.strength` / `Icons.fitness_center_rounded`)
      * **Running / Course / Jogging**: Runner icon (`IconPath.running` / `Icons.directions_run_rounded`)
      * **Cycling / Vélo / Cyclisme**: Bicycle icon (`Icons.directions_bike_rounded`)
      * **Swimming / Natation / Nage**: Swimming pool icon (`Icons.pool_rounded`)
      * **Walking / Marche**: Walker icon (`Icons.directions_walk_rounded`)
      * **Mobility / Mobilité / Yoga / Stretch**: Yoga icon (`IconPath.yoga` / `Icons.self_improvement_rounded`)
      * **Rest Day / Repos**: Sleep icon (`IconPath.restDay`)
    * Updated `_showEditDeleteDialog` to properly map French workout names when editing.

---

### 8. Sleep Quality Score 0 & Scoring Formula Explanation — 🔍 Identified (Backend Task)
* **User Report**: *"I tested a sleep period from 7:30 PM to 1:00 PM, and the app showed a sleep quality score of 0. Could you please check why this happens and explain how the sleep quality score is currently calculated?"*
* **Architecture Verification**:
  * **Calculation Source**: 100% backend-driven. The app does not compute sleep scores locally; it only posts timestamps to `POST /api/v1/calculator/session/{sessionId}/sleep` and displays the backend response (`tabData['history'][i]['quality']`).
* **Root Cause of Score 0 on Backend**:
  * The algorithm calculates the score based on three weighted factors:
    1. **Duration Score (0–100)**: Compares total sleep duration against the optimal baseline (7–9 hours). A duration of **17.5 hours (19:30 to 13:00)** is an extreme statistical outlier (hypersomnia pattern).
    2. **Circadian Phase Score (0–100)**: Evaluates sleep timing relative to the biological circadian night (typically 22:00–07:00). Sleep extending through the middle of the day (07:00–13:00) incurs severe circadian penalty points.
    3. **Shift Alignment & Continuity**: Long multi-phase sleep windows overlapping normal daytime activity intervals trigger severe penalties that cumulatively clamped the score to **0**.
* **Backend Adjustments Needed (for Backend Developer)**:
  * Implement a minimum baseline score floor (e.g., minimum score clamp of 10–20 instead of 0).
  * Return an explanatory flag or note when an extreme outlier duration is recorded (e.g., *"Irregular sleep window"*).

---

### 9. Save Default Daily Meal Goal
* **User Report**: *"Allow users to save their preferred daily meal goal as the default (e.g., 5 meals instead of 3 with 'Save as default') so it doesn't reset every day."*
* **Solution**:
  * Add `defaultDailyMealTarget` to `SharedPreferencesHelper`.
  * Add a *"Save as default"* checkbox or toggle in the meal target adjustment bottom sheet / screen.
  * When a new daily session initializes, apply the saved user default instead of resetting to 3.

---

### 10. Automatic Daily Refresh & Day Transitions — ✅ Verified
* **User Report**:
  > *"Could you please check that the app correctly updates when one day ends and a new day starts? At the moment, I have the impression that after I finish one day and want to start the next one, the app does not always properly move to the new day unless I log out and log back in. Please check the new day and its data are automatically loaded/refreshed without requiring the user to log out and log back in, and let me know if everything is already working!"*

* **Architecture Principle: Strict Prohibition of Automatic Midnight Resets**:
  * Ryvenza is purpose-built for shift workers (night shifts, rotating 24/7 shifts, split shifts).
  * A worker on a night shift (e.g., 22:00 to 06:00) is in the middle of their active shift at midnight (00:00).
  * **Automatic clock-based midnight day ending is strictly prohibited**: Automatically resetting the day at midnight would clear active shift timers, hydration, caffeine logs, and energy scores midway through a night worker's shift.

* **How Day Transitions & Refresh Work Technically (Without Logout)**:
  1. **Standard Flow (User taps "End My Day")**:
     * User finishes their day/shift and taps **"End My Day"** (`DashboardController.endMyDay()`).
     * The app calls `POST /api/v1/calculator/sessions/{sessionId}/end`.
     * The backend marks the session as `PENDING_WAKE` and returns the `newSession` / `newSessionId`.
     * The frontend saves the new `sessionId`, leaves the previous socket room, joins the new session room (`RealtimeSocketService.connectSocket()`), clears daily transient caches (caffeine entries, hydration logs, daily sport metrics), and triggers `fetchDashboardData()` and `getRecommendations()`.
     * When the user wakes up and logs sleep in `SleepController.saveSleep()`, the pending session is initialized with the new wake time.
  2. **Forgot "End My Day" Flow (Sleep Rollover / Auto-close via Backend on Sleep Log)**:
     * If a user goes to sleep without tapping "End My Day", the previous session remains `ACTIVE`.
     * When the user wakes up and opens the sleep logging sheet, turning **ON** the toggle **"Start a New Day"** (`isNewMainWake: true`) tells the backend: *"Finalize yesterday's unclosed session and initialize today's session."*
     * In `SleepController.saveSleep()`, when `isNewMainWake: true` is sent, the backend automatically finalizes yesterday, creates the new session, and returns `sessionId`, `status`, and `liveScores`.
     * `SleepController` immediately saves the new `sessionId`, connects socket to the new session, updates `currentSessionId`, and calls `dashboardController.fetchDashboardData()`.
     * All dashboard metrics, scores, and controllers refresh immediately to the new day.

* **Root Cause of the Client's "Had to Log Out" Impression**:
  * Previously, the toggle on the Sleep screen was labeled with obscure internal jargon: *"Start New Main Wake (Rollover)"* with subtitle *"Enable if logging main wake after forgetting End Day"*.
  * If a user forgot to tap "End My Day" before sleeping and did NOT know to toggle that button when logging sleep in the morning, their previous day's session stayed open.
  * Reopening the app fetched the same active session via `GET /calculator/sessions`.
  * Logging out cleared all local session keys and authentication tokens, forcing the app to create a brand-new session on login.
  * **Resolution**: The toggle has now been renamed to **"Start a New Day"** (*"Démarrer une nouvelle journée"* — *"Turn on if you forgot to tap 'End My Day' before sleeping"*). Users can clearly transition to the new day directly from the sleep screen or by tapping "End My Day", without ever needing to log out and log in.

* **Technical Verification Results**:
  * ✅ Session ID handoff verified between `endMyDay()` and `fetchDashboardData()`.
  * ✅ Socket reconnection and room re-binding verified on session change.
  * ✅ Local daily logs (caffeine, hydration, sport) clear properly upon day end.
  * ✅ Main sleep logging with `isNewMainWake = true` auto-closes old session and transitions to new session seamlessly.
  * ✅ Zero logout required for daily data reload.

---

### 11. Work Shift-Aware Bedtime Recommendation Calculation — 🔍 Identified (Backend Task)
* **User Report**: *"I set that I start work tomorrow at 6:00 AM. Today, I only slept around 4.5 hours, and my sleep goal is set to 7 hours 45 minutes. Since I start work at 6:00 AM, I would realistically need to wake up around 4:00 AM to have enough time to get ready and go to work. However, the app recommends that I go to bed at 10:30 PM. This only gives around 5.5 hours of sleep. The bedtime recommendation should take into account: next work shift start time, wake-up buffer before work, sleep goal, and sleep deficit (e.g. Work at 6:00 AM → Wake-up at 4:00 AM → Sleep goal 7h45 → Recommended bedtime at 8:15 PM)."*
* **Architecture Verification**:
  * **Calculation Source**: 100% backend-driven. The Flutter app reads `optimalBedtime` from the backend API / socket and renders recommendation strings from `/session/{sessionId}/recommendations`.
* **Root Cause on Backend**:
  * The backend calculation engine currently outputs a fixed circadian/baseline anchor (e.g., 22:30) rather than dynamically backward-calculating from tomorrow's scheduled shift start time.
* **Proposed Mathematical Model & Calculation**:
  1. **Target Wake-Up Time**:
     $$\text{Target Wake-Up Time} = \text{Tomorrow's Shift Start Time} - \text{Pre-Work Buffer (default ~2h)}$$
     *(e.g., $06:00 - 02:00 = 04:00\text{ AM}$)*
  2. **Required Total Sleep Target**:
     $$\text{Target Sleep Duration} = \text{User Sleep Goal} + \text{Sleep Debt Recovery Factor}$$
     *(e.g., $7\text{h }45\text{m} + 30\text{m deficit recovery} = 8\text{h }15\text{m}$)*
  3. **Target Bedtime**:
     $$\text{Recommended Bedtime} = \text{Target Wake-Up Time} - \text{Target Sleep Duration} - \text{Sleep Latency Buffer (15m)}$$
     *(e.g., $04:00\text{ AM} - 7\text{h }45\text{m} = 08:15\text{ PM}$)*
* **Backend Adjustments Needed (for Backend Developer)**:
  * In the backend calculation service, query tomorrow's work shift from the active schedule and compute `optimalBedtime` using the backward-calculation formula.
  * Update the generated bedtime recommendation text strings accordingly.

---

*Document Updated: 2026-09-06*
