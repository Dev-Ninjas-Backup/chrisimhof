# Ryvenza API — Mobile & Frontend Integration Guide
**Authoritative Reference for App Developers & Integration Engineers**
*Last Updated: 2026-09-21*

---

## 📋 Overview

This living document details all endpoint payloads, contracts, breaking changes, and integration behaviors for mobile (iOS/Android Flutter) and web engineers interacting with the Ryvenza backend API.

---

## 🚀 Future Scope Phase 1 Integrations

---

### 1. `PUT /api/v1/calculator/work-rotation` — Custom Rotation Naming (`name`)

Work rotation creation now supports a user-defined custom `name` field (e.g., *"Syngenta"*, *"Novartis 3x8"*).

- **Endpoint**: `PUT /api/v1/calculator/work-rotation`
- **Auth Required**: `Bearer <token>`
- **Content-Type**: `application/json`

#### Request Payload
```json
{
  "name": "Syngenta",
  "cycleWeeks": 4,
  "startDate": "2026-07-06",
  "shiftTimesJson": {
    "day": { "startTime": "06:00", "endTime": "14:00" },
    "evening": { "startTime": "14:00", "endTime": "22:00" },
    "night": { "startTime": "22:00", "endTime": "06:00" }
  },
  "patternJson": [
    { "weekIndex": 0, "dayIndex": 0, "shiftCode": "day" },
    { "weekIndex": 0, "dayIndex": 1, "shiftCode": "day" },
    { "weekIndex": 0, "dayIndex": 2, "shiftCode": "day" },
    { "weekIndex": 0, "dayIndex": 3, "shiftCode": "day" },
    { "weekIndex": 0, "dayIndex": 4, "shiftCode": "day" },
    { "weekIndex": 0, "dayIndex": 5, "shiftCode": "off" },
    { "weekIndex": 0, "dayIndex": 6, "shiftCode": "off" }
  ],
  "sourceTemplateKey": "custom-syngenta"
}
```

#### Response (`200 OK`)
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Work rotation saved successfully",
  "data": {
    "id": "cm...123",
    "name": "Syngenta",
    "cycleWeeks": 4,
    "startDate": "2026-07-06",
    "timezone": "Europe/Zurich",
    "sourceTemplateKey": "custom-syngenta",
    "shiftTimesJson": { ... },
    "patternJson": [ ... ],
    "overridesJson": { ... },
    "createdAt": "2026-07-06T08:00:00.000Z",
    "updatedAt": "2026-07-06T08:00:00.000Z"
  }
}
```

#### Mobile App Integration Checklist
- [ ] In the Work Schedule creation/edit screen, provide an optional "Rotation Name" text input field.
- [ ] Pass `name` in `PUT /api/v1/calculator/work-rotation`. Optional `saveAsTemplate: true` (defaults to true) auto-saves this custom rotation to the user's template library.
- [ ] In the shift selection and rotation summary screens, display `data.name` if present (falling back to preset label or "Custom Rotation").

---

### 1b. `GET /api/v1/calculator/work-rotation/presets` — Rotation Presets & Saved Custom Proposals

Returns all available rotation presets, merging the system built-in presets (`3-2-2 Night`, `2-2-3 (Panama)`, `DuPont`) with the authenticated user's saved custom rotation templates (e.g. `Syngenta`), along with the currently active selection.

- **Endpoint**: `GET /api/v1/calculator/work-rotation/presets`
- **Auth Required**: `Bearer <token>`

#### Response (`200 OK`)
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Success",
  "data": {
    "presets": [
      {
        "key": "three-two-two-night",
        "label": "3-2-2 Night",
        "description": "3 nights on, 2 days off, 2 evenings on — repeats weekly",
        "cycleWeeks": 1,
        "isCustom": false,
        "shiftTimesJson": { ... },
        "patternJson": [ ... ]
      },
      {
        "key": "two-two-three-panama",
        "label": "2-2-3 (Panama)",
        "description": "2 on, 2 off, 3 on, 2 off, 3 on, 2 off — 14-day cycle, alternating weekends off",
        "cycleWeeks": 2,
        "isCustom": false,
        "shiftTimesJson": { ... },
        "patternJson": [ ... ]
      },
      {
        "key": "four-on-four-off-dupont",
        "label": "DuPont (4-on/4-off)",
        "description": "4-week rotation of 12h day/night blocks with a 7-day break every cycle",
        "cycleWeeks": 4,
        "isCustom": false,
        "shiftTimesJson": { ... },
        "patternJson": [ ... ]
      },
      {
        "id": "cm...",
        "key": "custom-cm...",
        "label": "Syngenta",
        "description": "Custom rotation pattern",
        "cycleWeeks": 4,
        "isCustom": true,
        "shiftTimesJson": {
          "day": { "startTime": "06:00", "endTime": "14:00" },
          "evening": { "startTime": "14:00", "endTime": "22:00" },
          "night": { "startTime": "22:00", "endTime": "06:00" }
        },
        "patternJson": [ ... ]
      }
    ],
    "activeRotationKey": "custom-cm...",
    "activeRotationName": "Syngenta"
  }
}
```

#### Saved Templates Management Endpoints
- `GET /api/v1/calculator/work-rotation/templates` — List all user custom rotation templates.
- `POST /api/v1/calculator/work-rotation/templates` — Save or update a reusable template (`name`, `description?`, `cycleWeeks`, `shiftTimesJson`, `patternJson`).
- `DELETE /api/v1/calculator/work-rotation/templates/:id` — Delete a custom template.

#### 🚀 Quick-Apply Shortcuts (Set Preset/Template as Active)
Instead of re-sending full pattern and shift timings, the mobile app can activate any preset or saved template with just a `startDate`:

1. **Apply any Preset or Custom Template by Key**:
   - **Endpoint**: `POST /api/v1/calculator/work-rotation/presets/:key/apply`
   - **Path Param**: `key` (e.g., `three-two-two-night`, `two-two-three-panama`, or `custom-cm123abc`)
   - **Payload**:
     ```json
     {
       "startDate": "2026-07-06",
       "name": "Optional Custom Name"
     }
     ```

2. **Apply a Saved Template by ID**:
   - **Endpoint**: `POST /api/v1/calculator/work-rotation/templates/:id/apply`
   - **Path Param**: `id` (e.g., template ID `cm123abc`)
   - **Payload**:
     ```json
     {
       "startDate": "2026-07-06",
       "name": "Optional Override Name"
     }
     ```

#### Mobile App Integration Checklist
- [ ] In the Work Schedule preset picker modal/screen, bind the list directly to `data.presets`.
- [ ] Use `isCustom: true` to optionally show a "Custom" badge or an option to edit/delete the template.
- [ ] To immediately activate a preset upon selection, simply call `POST /api/v1/calculator/work-rotation/presets/:key/apply` with `{ startDate: "YYYY-MM-DD" }`.
- [ ] In the Work Planning screen header, display `data.activeRotationName` (or `settings.defaultRotation`) — eliminating "None".

---

### 2. `POST /api/v1/calculator/work-rotation/overrides/batch` — Batch Shift Overrides

Allows setting shift overrides across a continuous date range (e.g. vacation, sick leave, block shifts) in a single atomic network request.

- **Endpoint**: `POST /api/v1/calculator/work-rotation/overrides/batch`
- **Auth Required**: `Bearer <token>`
- **Content-Type**: `application/json`

#### Request Payload
```json
{
  "startDate": "2026-07-10",
  "endDate": "2026-07-17",
  "shiftType": "off"
}
```
*Note: For work shifts, optional `"shiftStartTime": "08:00"` and `"shiftEndTime": "16:00"` can also be passed.*

#### Response (`200 OK`)
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Batch day overrides saved",
  "data": {
    "id": "cm...123",
    "name": "Syngenta",
    "cycleWeeks": 4,
    "startDate": "2026-07-06",
    "timezone": "Europe/Zurich",
    "overridesJson": {
      "2026-07-10": { "shiftCode": "off", "source": "manual", "updatedAt": "2026-07-06T08:00:00.000Z" },
      "2026-07-11": { "shiftCode": "off", "source": "manual", "updatedAt": "2026-07-06T08:00:00.000Z" },
      ...
    }
  }
}
```

---

### 3. `DELETE /api/v1/calculator/work-rotation/overrides/batch` — Batch Clear Overrides

Mass-reverts shift overrides across a date range back to the underlying rotation pattern.

- **Endpoint**: `DELETE /api/v1/calculator/work-rotation/overrides/batch`
- **Auth Required**: `Bearer <token>`
- **Content-Type**: `application/json`

#### Request Payload
```json
{
  "startDate": "2026-07-10",
  "endDate": "2026-07-17"
}
```

#### Response (`200 OK`)
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Batch day overrides cleared",
  "data": { ... }
}
```

#### Mobile App Integration Checklist
- [ ] In the calendar override interface, provide a multi-day range selector (e.g. *"Select start and end date for Vacation/Leave"*).
- [ ] Call `POST /api/v1/calculator/work-rotation/overrides/batch` with `{ startDate, endDate, shiftType: "off" }`.
- [ ] To remove a leave block, call `DELETE /api/v1/calculator/work-rotation/overrides/batch`.

---

### 4. `PATCH /api/v1/profile/baseline` & `GET /api/v1/profile/baseline` — Persistent Default Daily Meal Target (`defaultDailyMealTarget`)

Allows the user to configure their standard daily meal count preference (1–8 meals, default: 3). Each new circadian day session automatically initializes with this meal count.

- **Endpoints**:
  - `GET /api/v1/profile/baseline`
  - `PATCH /api/v1/profile/baseline`
- **Auth Required**: `Bearer <token>`
- **Content-Type**: `application/json`

#### Baseline Get Response (`GET /api/v1/profile/baseline`)
```json
{
  "success": true,
  "statusCode": 200,
  "data": {
    "sleepTargetMinutes": 465,
    "chronotype": "evening",
    "caffeineSensitivity": "medium",
    "sportProfile": "mixed",
    "defaultDailyMealTarget": 4,
    "sleepTargetDisplay": "7h 45m",
    "chronotypeDisplay": "Evening leaning",
    "caffeineSensitivityDisplay": "Medium",
    "sportProfileDisplay": "Strength + Cardio"
  }
}
```

#### Update Baseline Request (`PATCH /api/v1/profile/baseline`)
```json
{
  "defaultDailyMealTarget": 4
}
```

#### Mobile App Integration Checklist
- [ ] In Settings > Baseline Profile, display the "Default Daily Meal Target" picker / stepper (range: 1–8).
- [ ] Save changes by calling `PATCH /api/v1/profile/baseline` with `{ "defaultDailyMealTarget": number }`.
- [ ] All subsequent daily calculator sessions will automatically default to this target.

---

### 5. `POST /api/v1/users/account-deletion/request-otp` & `DELETE /api/v1/users/:id` — Account Deactivation with Email OTP

To prevent accidental account deletion, deactivating an account requires requesting and verifying a single-use 6-digit OTP code sent to the user's registered email.

#### Step 1: Request Deactivation OTP
- **Endpoint**: `POST /api/v1/users/account-deletion/request-otp`
- **Auth Required**: `Bearer <token>`
- **Request Body**: `{}` (Empty)

##### Response (`200 OK`)
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Account deactivation OTP code has been sent to your registered email address.",
  "data": null
}
```

#### Step 2: Confirm Account Deactivation
- **Endpoint**: `DELETE /api/v1/users/:id`
- **Auth Required**: `Bearer <token>`
- **Content-Type**: `application/json`

##### Request Payload
```json
{
  "otp": "123456"
}
```

##### Response (`200 OK`)
```json
{
  "success": true,
  "statusCode": 200,
  "message": "User account deactivated successfully",
  "data": null
}
```

#### Mobile App Integration Checklist
- [ ] When the user taps "Delete Account" in Settings / Account management:
  1. Trigger `POST /api/v1/users/account-deletion/request-otp`.
  2. Open the OTP modal dialog ("Enter the 6-digit code sent to your email to confirm deletion").
  3. When user inputs code and confirms, submit `DELETE /api/v1/users/:id` with `{ "otp": "123456" }`.
  4. On success (`200 OK`), wipe local tokens/state and navigate user to the Welcome / Login screen.

---

### 6. `PATCH /api/v1/profile/baseline` & `PATCH /api/v1/profile` — 12-Hour (AM/PM) vs. 24-Hour Time Format Preference (`timeFormat`)

Users can customize whether time recommendations and clock windows are rendered in 12-hour AM/PM format (e.g., `9:00 PM`) or 24-hour format (e.g., `21:00`).

- **Endpoints**:
  - `PATCH /api/v1/profile/baseline`
  - `PATCH /api/v1/profile`
- **Supported Values**: `"12h"` | `"24h"` (Default: `"24h"`)

#### Update Request Payload
```json
{
  "timeFormat": "12h"
}
```

#### Recommendation Rendering Behavior
- When `timeFormat: "12h"`, recommendation text bodies automatically render with 12h formatting:
  - `"Aim for bed by 9:30 PM — your circadian window opens then."`
  - `"Last coffee before 2:00 PM — this could support tonight's sleep window."`
  - `"A light snack around 1:00 AM may keep energy steady through the shift."`
- The returned structured `bodyParams` retains the raw 24-hour time strings (e.g. `{ "bedtime": "21:30" }`) so mobile apps can still perform programmatic date arithmetic.

#### Mobile App Integration Checklist
- [ ] In Settings > Preferences, display a "Time Format" selector (Options: `12-Hour (AM/PM)` vs `24-Hour`).
- [ ] Send `PATCH /api/v1/profile/baseline` with `{ "timeFormat": "12h" }` or `{ "timeFormat": "24h" }`.
- [ ] The dashboard, for-you preview, and daily calculation screens will immediately deliver localized advice strings matching the user's preferred time notation.

---

## ⚡ Future Scope Phase 2 Integrations

---

### 7. Dynamic Caffeine Metabolic Clearance & Optimal Bedtime Shift

The caffeine engine now calculates true exponential clearance curves personalized to the user's metabolic sensitivity and dynamically adjusts scheduled bedtime in real-time when circulating caffeine at bedtime exceeds safe limits.

#### Metabolic Sensitivity Half-Lives ($t_{\text{half}}$)
Configured via `caffeineSensitivity` in Profile / Baseline:
- `"low"` $\to$ **4.5 hours**
- `"medium"` (or omitted/default) $\to$ **5.5 hours**
- `"high"` $\to$ **7.0 hours**

#### Circulating Caffeine Modeling
When caffeine entries are logged via Quick Add (`POST /api/v1/calculator/sessions/:sessionId/quick-add`), updated, or deleted, the server recalculates circulating active caffeine at scheduled sleep time:
$$\text{activeAtBedtime} = \sum_{i} \text{mg}_i \times 0.5^{\frac{\Delta t_{\text{bedtime}, i}}{t_{\text{half}}}}$$

If $\text{activeAtBedtime} > 50\text{mg}$ (the clinical disruption threshold), the engine calculates an extra bedtime delay buffer (capped at 90 minutes for circadian safety):
$$\Delta t_{\text{extra}} = \min\left(90, \text{round}\left(t_{\text{half}} \times \log_2\left(\frac{\text{activeAtBedtime}}{50}\right) \times 60\right)\right)$$

#### Calculation Response Updates
In `GET /api/v1/calculator/sessions/:sessionId` (or `tabs/overview` / `quick-add` responses):

```json
{
  "caffeine": {
    "score": 78,
    "totalCaffeineMg": 400,
    "activeCaffeineMg": 280.5,
    "activeCaffeineAtBedtimeMg": 213.2,
    "caffeineCutoffTime": "14:00",
    "isPastCutoff": false,
    "dailyLimitMg": 400,
    "timeline": [ ... ],
    "logs": [
      {
        "id": "log-1",
        "time": "18:00",
        "amountMg": 400,
        "name": "Pre-Workout Energy",
        "halfLifeHours": 5.5,
        "projectedZeroTime": "09:30",
        "activeAtBedtimeMg": 213.2
      }
    ]
  },
  "sleep": {
    "optimalBedtime": "23:30",
    "targetBedtime": "22:00",
    "circadianBedtime": "22:00",
    "bedtimeBufferMinutes": 90
  }
}
```

#### Mobile App Integration Checklist
- [ ] Ensure `caffeineSensitivity` (`"low"` | `"medium"` | `"high"`) is selectable in Onboarding and Settings > Baseline Profile.
- [ ] On the Sleep & Bedtime UI, observe `data.sleep.optimalBedtime` — this time automatically incorporates dynamic caffeine delay buffers without manual client calculation.
- [ ] In the Caffeine Details / Timeline view, mobile apps can use `activeCaffeineAtBedtimeMg` to display warnings (e.g. *"213 mg active at bedtime — your recommended sleep time has been delayed by 90 minutes to allow clearance"*).
- [ ] Send `drinkLabel` (e.g. `"Monster"`, `"Red Bull"`, or custom roasts) alongside `drinkType` in caffeine logs. The API persists and returns `drinkLabel` in session tabs and daily timeline.

#### Custom Caffeine Drink Labels (`drinkLabel`)
When logging caffeine drinks via Quick Add (`PATCH /api/v1/calculator/session/:sessionId/log` or resource CRUD `/caffeine/:entryId`), clients can supply a custom drink name:

```json
{
  "newCaffeineLogs": [
    {
      "occurredAt": "2026-10-09T08:30:00.000Z",
      "caffeineMg": 160,
      "drinkType": "energy",
      "drinkLabel": "Monster"
    }
  ]
}
```
- **Response**: The API preserves `drinkLabel` in `session.caffeineLogsJson`, `tabs.caffeine.logs`, and `GET /api/v1/history/timeline` (caffeine track).

---

### 8. `PATCH /api/v1/profile/baseline` — Weekly Sport Goal & Adaptive Rest Recommendations (`weeklySportGoal`)

Users can configure their weekly workout target (1 to 7 workouts per week, default: 3). The engine automatically computes weekly progress across each ISO calendar week (Monday to Sunday) anchored to the user's timezone, intelligently managing adaptive rest and catch-up pacing.

#### Baseline Profile Payload Update
- **Endpoint**: `PATCH /api/v1/profile/baseline`
- **Request Body**:
```json
{
  "weeklySportGoal": 4
}
```

#### Weekly Sport Stats in Session Responses
In `GET /api/v1/calculator/sessions/:sessionId` (or `tabs/overview` / `quick-add`):

```json
{
  "sport": {
    "sportScore": 85,
    "sportReadiness": "medium",
    "recoveryScore": 62,
    "totalDurationMinutes": 0,
    "isRestDay": true,
    "weeklySportStats": {
      "weeklyGoal": 4,
      "workoutsCompletedThisWeek": 3,
      "daysRemainingInWeek": 2,
      "isGoalMet": false,
      "isOnPace": true
    },
    "adaptiveRestRecommended": true,
    "adaptiveRestReason": "onTrackRest"
  }
}
```

#### Adaptive Rest & Weekly Goal Recommendation Cards
The recommendation engine automatically emits actionable cards based on weekly pace and biometric fatigue:

1. **Adaptive Rest On Track** (`titleKey: "sport.adaptiveRestTitle"`, `bodyKey: "sport.adaptiveRestOnTrack"`):
   - Triggered when user is comfortably on pace or has met their weekly goal but has accumulated fatigue (`sleepDebt7dMin > 60` or `recoveryScore < 65`).
   - English: `"You're on track with 3/4 workouts this week — taking a rest day today will support your recovery and performance."`
   - French: `"Vous êtes sur la bonne voie avec 3/4 séances cette semaine — un jour de repos aujourd'hui soutiendra votre récupération."`

2. **Weekly Goal Met** (`titleKey: "sport.weeklyGoalTitle"`, `bodyKey: "sport.weeklyGoalMet"`):
   - Triggered when `workoutsCompletedThisWeek >= weeklyGoal`.
   - English: `"Weekly workout goal reached (4/4)! Any additional activity today can focus on light recovery or mobility."`
   - French: `"Objectif hebdomadaire atteint (4/4) ! Toute activité supplémentaire aujourd'hui peut se concentrer sur la mobilité ou la récupération."`

3. **Catch-up Pacing Nudge** (`titleKey: "sport.trainingTitle"`, `bodyKey: "sport.catchUpNudge"`):
   - Triggered when days remaining in the week $\le$ workouts needed and the user is well-rested.
   - English: `"You have 3 days left to complete 2 workouts toward your weekly goal — conditions look great for a session today."`
   - French: `"Il vous reste 3 jours pour compléter 2 séances — les conditions sont idéales pour s'entraîner aujourd'hui."`

#### Mobile App Integration Checklist
- [ ] In Onboarding and Settings > Baseline Profile, provide a "Weekly Workout Goal" stepper/slider (1–7 workouts/week).
- [ ] In the Sport Card on Dashboard / Today tab, render weekly progress (e.g. `"3/4 workouts this week"`).
- [ ] When `adaptiveRestRecommended: true`, display an "Adaptive Rest" status badge highlighting that taking a rest day supports circadian recovery.

---

### 9. Active Profile Baseline Integration (`chronotype`, `sportProfile`, `sleepTargetMinutes`)

Onboarding and profile baseline settings actively govern mathematical recommendations and thresholds across all domain engines:

#### 1. Chronotype (`"morning"` | `"intermediate"` | `"evening"`)
- **Peak Alertness & Suggested Training Time**:
  - **Morning (*Lark*)**: Peak alertness occurs **2.0–3.0h post-wake** (base offset = 2.5h; shifted to 4.0h if poorly rested with `sleepScore < 55`).
  - **Evening (*Owl*)**: Peak alertness occurs **5.0–6.5h post-wake** (base offset = 5.5h; shifted to 7.0h if poorly rested).
  - **Intermediate / Standard**: Peak alertness occurs **3.5–4.0h post-wake** (base offset = 3.5h; shifted to 5.0h if poorly rested).
- **Circadian Sleep Timing**:
  - Morning chronotypes receive earlier sleep window recommendations (-30 min).
  - Evening chronotypes receive later sleep window recommendations (+30 min).

#### 2. Sport Profile (`"endurance"` | `"cardio"` | `"strength"` | `"mixed"` | `"sedentary"` | `"light"`)
- **Dynamic Hydration Baseline Target**:
  - `endurance`: Base hydration target is increased by **+20%** ($3000\,\text{ml}$ vs $2500\,\text{ml}$ baseline).
  - `cardio`: Base hydration target is increased by **+10%** ($2750\,\text{ml}$).
  - `sedentary`: Base hydration target adjusted to $2300\,\text{ml}$.
  - `light`: Base hydration target adjusted to $2400\,\text{ml}$.
  - `strength` / `mixed` / default: Standard $2500\,\text{ml}$ baseline.
  - *Note*: Sweat volume from logged workouts (+300 to +700 ml/h), caffeine offsets, and night shift boosts stack dynamically on top of this profile base target.
- **Post-Workout Sleep Wind-Down Buffer**:
  - `strength` and `mixed`: Maximum bedtime buffer cap is expanded to **60 minutes** (vs 45 minutes for cardio/endurance) for late high-intensity sessions to account for sustained sympathetic nervous system activation, delayed muscle thermogenesis, and cortisol clearance.

#### 3. Personalized Sleep Target (`sleepTargetMinutes`)
- Configurable from 240 min (4h) to 660 min (11h).
- Strictly determines sleep quality scoring ratios, 7-day sleep debt accumulation, and upcoming circadian sleep window durations without static hardcoded 8-hour overrides.

#### 4. Daily Meal Target Synchronization & Flexible Meal Logging (`defaultDailyMealTarget`)
- Configurable in Baseline Profile (`PATCH /api/v1/profile/baseline`, 1 to 10 meals/day, default: 3).
- **Session Synchronization**:
  - Every new daily session automatically initializes `quickAddSummary.meals.dailyTarget` directly from `profile.defaultDailyMealTarget`.
  - When the user updates `defaultDailyMealTarget` in profile settings, all unfinalized circadian day sessions (`ACTIVE` and `PENDING_WAKE`) immediately update their `dailyMealTarget`.
  - When opening the app via `GET /api/v1/calculator/session`, any pending or active session dynamically verifies and synchronizes its `dailyMealTarget` against the user's latest baseline profile settings so the quick-add counter never shows stale defaults (e.g. `0/3` when the profile target is 5).
- **Flexible Quick Meal Logging**:
  - Direct endpoint: `POST /api/v1/calculator/session/:sessionId/meals` (or plural `POST /sessions/:sessionId/meals`).
  - Bulk Quick-Add: `PATCH /api/v1/calculator/session/:sessionId/log` (`newMealLogs`).
  - Payload parameters are fully flexible:
    - `occurredAt`: Optional ISO-8601 UTC timestamp (defaults to current instant `now`).
    - `heaviness`: Optional (`'light'`, `'medium'`, `'heavy'`, defaults to `'medium'`).
    - `order`: Optional sequence integer (automatically calculated as `existingCount + 1`).
  - Logged meals dynamically increment `quickAddSummary.meals.count` and are accurately reflected in `display: "${count}/${dailyTarget}"` (e.g. `"1/5"`).

---

### 10. First-Class Nap Management & Zero-Day-Reset Safety

Allows users to log daytime, power, and pre-shift naps without interfering with main anchor sleep or risking premature session termination. Logged nap durations are automatically credited against acute 7-day sleep debt.

#### 1. Bulk Quick-Add with Naps (`PATCH /api/v1/calculator/session/:sessionId/log`)
- **Endpoint**: `PATCH /api/v1/calculator/session/:sessionId/log`
- **Auth Required**: `Bearer <token>`
- **Request Body**:
```json
{
  "newNaps": [
    {
      "occurredAt": "2026-07-28T14:00:00.000Z",
      "durationMinutes": 30,
      "quality": "refreshing",
      "notes": "Afternoon power nap"
    }
  ]
}
```
- **Response**: Returns `entries.naps` and updated `quickAddSummary.naps`:
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Quick log updated successfully",
  "data": {
    "sessionId": "cm123456789",
    "entries": {
      "naps": [
        {
          "id": "nap-uuid-1",
          "occurredAt": "2026-07-28T14:00:00.000Z",
          "timestamp": "14:00",
          "durationMinutes": 30,
          "quality": "refreshing",
          "notes": "Afternoon power nap",
          "createdAt": "2026-07-28T14:35:00.000Z",
          "updatedAt": "2026-07-28T14:35:00.000Z"
        }
      ]
    },
    "quickAddSummary": {
      "naps": {
        "count": 1,
        "totalMinutes": 30,
        "display": "30m"
      }
    }
  }
}
```

#### 2. Update a Nap Entry (`PATCH /api/v1/calculator/sessions/:sessionId/naps/:entryId`)
- **Endpoint**: `PATCH /api/v1/calculator/sessions/:sessionId/naps/:entryId`
- **Auth Required**: `Bearer <token>`
- **Request Body**:
```json
{
  "durationMinutes": 45,
  "quality": "grogginess",
  "notes": "Extended nap before night shift"
}
```

#### 3. Delete a Nap Entry (`DELETE /api/v1/calculator/sessions/:sessionId/naps/:entryId`)
- **Endpoint**: `DELETE /api/v1/calculator/sessions/:sessionId/naps/:entryId`
- **Auth Required**: `Bearer <token>`
- **Response (`200 OK`)**: Deletes the specified nap entry, updates `napsJson`, and rolls back the sleep debt credit.

#### 4. Delete Individual Sleep Record (`DELETE /api/v1/calculator/sessions/:sessionId/sleep/:entryId` & `DELETE /api/v1/history/sleep/:entryId`)
Users can delete mistaken or unwanted sleep records without deleting their entire day or resetting other logged entries:
- **Active Session Endpoint**: `DELETE /api/v1/calculator/sessions/:sessionId/sleep/:entryId` (alias: `DELETE /api/v1/calculator/session/:sessionId/sleep/:entryId`)
- **History Endpoint**: `DELETE /api/v1/history/sleep/:entryId`
- **Auth Required**: `Bearer <token>`

##### Deletion Routing & Behavior:
1. **Nap Record**: If `:entryId` matches a logged nap ID in `napsJson`, it safely removes that nap, updates quick-add counters, and rolls back the nap sleep debt credit.
2. **Main Sleep (Active Session)**: If `:entryId` is `'main'`, `:sessionId`, or matching calculation ID, the backend:
   - Clears main sleep timestamps (`sleepStartTime`, `wakeTime`, `sleepStartedAt`, `wakeRecordedAt`).
   - Reverts session status to `PENDING_WAKE`.
   - Clears live scores until a new main wake is logged.
   - **Crucially retains** all other logged data (meals, hydration, caffeine, workouts, and other naps).
3. **Historical Sleep (`DELETE /api/v1/history/sleep/:entryId`)**:
   - Deletes the historical `Calculation` record.
   - Cleans up linked `DailySession` references (`calculationId`, `rhythmScore`, `sleepScore`, etc.) without deleting the session or workouts.

##### Response (`200 OK`)
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Sleep entry deleted successfully",
  "data": {
    "sessionId": "cm123456789",
    "status": "PENDING_WAKE",
    "liveScores": null
  }
}
```

#### Mobile App Integration Checklist
- [ ] In the Sleep Tab or Sleep History list, add swipe-to-delete or a delete button on individual sleep cards.
- [ ] For active sessions, call `DELETE /api/v1/calculator/sessions/:sessionId/sleep/:entryId`. If main sleep is deleted, prompt the user with a wake logging CTA while keeping their daily logs intact.
- [ ] For historical days, call `DELETE /api/v1/history/sleep/:calculationId`.
- [ ] In the Quick-Add bottom sheet, add a "Nap" logging option (preset buttons: `20m`, `30m`, `45m`, `90m`, or custom minutes).
- [ ] In the Sleep Tab, display today's logged naps list and total nap minutes (`data.sleep.naps` and `data.sleep.totalNapMinutes`).
- [ ] Observe the 7-day Sleep Debt bar chart — taking a nap immediately reduces today's active sleep debt by the logged nap duration.

---

## 11. Proactive Nap Recommendations & Sleep Pressure Guidance

The engine automatically generates shift-aware nap recommendation cards and dynamic sleep pressure guidance in the `recommendations` array (`FOR YOU` section).

### 1. Recommendation Scenarios & Card Keys

| Scenario | Trigger Condition | Title Key | Body Key | Sample English Output | Sample French Output |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Pre-Shift Anchor Nap** | Night shift today (`derivedWorkTiming === 'night'`), total naps $< 60\text{m}$ | `sleep.anchorNapTitle` | `sleep.preShiftAnchorNap` | *"A 90-min anchor nap between 14:30 and 16:00 completes a full sleep cycle to boost nocturnal alertness."* | *"Une sieste d'ancrage de 90 min entre 14:30 et 16:00 complète un cycle complet pour soutenir la vigilance nocturne."* |
| **Circadian Dip Power Nap** | 7-day sleep debt $> 90\text{m}$, non-night shift, total naps $< 20\text{m}$ | `sleep.powerNapTitle` | `sleep.circadianDipPowerNap` | *"Sleep debt is elevated (2h 15m). A 20-min power nap (13:30–13:50) during your afternoon dip can restore alertness."* | *"Dette de sommeil élevée (2h 15m). Une sieste éclair de 20 min (13:30–13:50) pendant votre creux d'après-midi restaure la vigilance."* |
| **Power Nap Restored** | Logged nap $\le 30\text{m}$ | `sleep.napPressureTitle` | `sleep.powerNapRestored` | *"20-min power nap logged — alertness restored with zero interference to tonight's sleep window."* | *"Sieste éclair de 20 min enregistrée — vigilance restaurée sans impacter votre fenêtre de sommeil de ce soir."* |
| **Restorative Nap Pressure** | Logged nap $> 30\text{m}$ | `sleep.napPressureTitle` | `sleep.napSleepPressureNote` | *"Logged 60m nap today — homeostatic sleep pressure is reduced. Maintain your 22:30 bedtime to preserve circadian stability."* | *"Sieste de 60 min enregistrée aujourd'hui — pression de sommeil réduite. Maintenez votre coucher à 22:30 pour préserver votre stabilité circadienne."* |

### 2. Sample Recommendation Payload

```json
{
  "category": "sleep",
  "priority": 1,
  "isPremium": false,
  "title": "Night shift anchor nap",
  "body": "A 90-min anchor nap between 14:30 and 16:00 completes a full sleep cycle to boost nocturnal alertness.",
  "titleKey": "sleep.anchorNapTitle",
  "bodyKey": "sleep.preShiftAnchorNap",
  "bodyParams": {
    "napStart": "14:30",
    "napEnd": "16:00",
    "durationMin": 90
  }
}
```

### 3. 12-Hour vs. 24-Hour Time Format Formatting
- When user `Profile.timeFormat` is `'12h'`, rendered `body` strings automatically format times as `2:30 PM–4:00 PM`.
- `bodyParams` retains raw 24-hour time strings (`"14:30"`, `"16:00"`) for programmatic client scheduling and notifications.

---

## 12. Progressive Multi-Day Shift Transitions (Circadian Phasing)

The engine monitors upcoming work rotations across a 3-day lookahead window ($T+1, T+2, T+3$) to proactively phase sleep-wake cycles and prevent acute circadian misalignment.

### 1. Phasing Logic & Recommendations

| Shift Transition | Lookahead Window | Strategy / Card Key | Phase Delay ($\Delta t$) | Description & Guidance |
| :--- | :--- | :--- | :--- | :--- |
| **Day / Off $\to$ Night** | 3 days away ($T+3$) | `sleep.circadianPhasingTitle` / `sleep.circadianPhaseDelay` | **+60 min** | Shifting bedtime 60 minutes later tonight to begin progressive nocturnal adaptation. |
| **Day / Off $\to$ Night** | 2 days away ($T+2$) | `sleep.circadianPhasingTitle` / `sleep.circadianPhaseDelay` | **+90 min** | Phasing bedtime 90 minutes later tonight as night shift approaches. |
| **Day / Off $\to$ Night** | Tomorrow ($T+1$) | `sleep.circadianPhasingTitle` / `sleep.circadianPhaseDelay` | **+120 min** | Applying a 2-hour phase delay tonight to optimize nocturnal stamina for tomorrow's shift. |
| **Night $\to$ Day / Off** | Post-Night ($T+1$) | `sleep.splitSleepTitle` / `sleep.splitSleepStrategy` | **0 min** (Split Sleep) | Prescribes a **4-hour morning recovery anchor sleep** ($\text{shiftEnd} + 1\text{h}$ to $+4\text{h}$) followed by an early evening bedtime (`22:00`) to reset diurnal rhythm without 24h sleep deprivation. |

### 2. Sample Payloads

#### Phase Delay Recommendation Card (`sleep.circadianPhaseDelay`):
```json
{
  "category": "sleep",
  "priority": 1,
  "isPremium": false,
  "title": "Circadian shift prep",
  "body": "Transitioning to a night shift in 3 days. Bedtime is phased 60m later tonight (23:00) to ease circadian adjustment.",
  "titleKey": "sleep.circadianPhasingTitle",
  "bodyKey": "sleep.circadianPhaseDelay",
  "bodyParams": {
    "daysUntilNight": 3,
    "phaseDelayMin": 60,
    "bedtime": "23:00"
  }
}
```

#### Split-Sleep Recovery Recommendation Card (`sleep.splitSleepStrategy`):
```json
{
  "category": "sleep",
  "priority": 1,
  "isPremium": false,
  "title": "Post-night recovery",
  "body": "Post-night transition: prioritize a 4h morning recovery sleep (08:00–12:00), followed by an early evening bedtime (22:00) to reset your diurnal rhythm.",
  "titleKey": "sleep.splitSleepTitle",
  "bodyKey": "sleep.splitSleepStrategy",
  "bodyParams": {
    "morningSleepStart": "08:00",
    "morningSleepEnd": "12:00",
    "eveningBedtime": "22:00"
  }
}
```

---

## 13. Comprehensive Notification Infrastructure & Preference Management

Users can customize notification channels and timing offsets in Profile Settings. The backend automatically filters server-side push notifications according to user preferences and provides structured timing data for mobile client local offline notifications.

### 1. Endpoints

#### Get Notification Preferences (`GET /api/v1/profile/notifications`)
- **Headers**: `Authorization: Bearer <accessToken>`
- **Response (`200 OK`)**:
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Notification preferences retrieved successfully",
  "data": {
    "shiftReminders": true,
    "shiftReminderMinutes": 30,
    "bedtimeAlerts": true,
    "bedtimeReminderMinutes": 60,
    "caffeineCutoff": true,
    "caffeineReminderMinutes": 30,
    "hydrationReminders": true,
    "circadianTransitions": true,
    "weeklySportReport": true
  }
}
```

#### Update Notification Preferences (`PATCH /api/v1/profile/notifications`)
- **Headers**: `Authorization: Bearer <accessToken>`
- **Request Body** (all fields optional):
```json
{
  "shiftReminders": true,
  "shiftReminderMinutes": 45,
  "bedtimeAlerts": true,
  "bedtimeReminderMinutes": 45,
  "caffeineCutoff": false,
  "hydrationReminders": true,
  "circadianTransitions": true,
  "weeklySportReport": true
}
```
- **Response (`200 OK`)**:
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Notification preferences updated successfully",
  "data": {
    "shiftReminders": true,
    "shiftReminderMinutes": 45,
    "bedtimeAlerts": true,
    "bedtimeReminderMinutes": 45,
    "caffeineCutoff": false,
    "caffeineReminderMinutes": 30,
    "hydrationReminders": true,
    "circadianTransitions": true,
    "weeklySportReport": true
  }
}
```

### 2. Notification Channels & Preference Filtering Matrix

| Notification Channel | Trigger / Description | Profile Setting Key | Default |
| :--- | :--- | :--- | :--- |
| `shift_reminder` | Upcoming shift alert | `shiftReminders` / `shiftReminderMinutes` | `true` (30 min) |
| `bedtime_alert` | Circadian bedtime wind-down alert | `bedtimeAlerts` / `bedtimeReminderMinutes` | `true` (60 min) |
| `caffeine_cutoff` | Caffeine clearance cutoff reminder | `caffeineCutoff` / `caffeineReminderMinutes` | `true` (30 min) |
| `hydration_reminder` | Daily hydration pacing reminders | `hydrationReminders` | `true` |
| `circadian_transition`| Multi-day phase delays & split-sleep | `circadianTransitions` | `true` |
| `weekly_sport` | Weekly workout progress & adaptive rest | `weeklySportReport` | `true` |
| `payment_transaction` | Invoices, receipts, subscription alerts | *Mandatory* (Bypasses preference check) | `true` |
| `system_alert` | Security alerts, password changes | *Mandatory* (Bypasses preference check) | `true` |

### 3. Mobile Client Local Offline Notification Guide

For resilient offline operation when users have airplane mode or spotty connectivity (e.g., flight crews, underground nurses):
1. **Fetch Daily Calculation**: Query `GET /api/v1/calculator/live-scores` or `GET /api/v1/calculator/tabs/sleep`.
2. **Read Notification Preferences**: Query `GET /api/v1/profile/notifications`.
3. **Schedule Local Alarms**:
   - **Bedtime Alert**: Schedule local notification at `nextSleepWindow.sleepStart` minus `bedtimeReminderMinutes`.
   - **Caffeine Cutoff**: Schedule local notification at `caffeineResult.caffeineCutoffTime` minus `caffeineReminderMinutes`.
   - **Shift Reminder**: Schedule local notification at `shiftStartTime` minus `shiftReminderMinutes`.
4. Using `flutter_local_notifications` (Flutter) or Android `AlarmManager` / iOS `UNNotificationRequest`:
   - Pass channel ID matching the preference channel.
   - Reschedule automatically when a new calculation payload is received or when user updates preferences.

---

## 🔒 Authentication & Standard Headers

All authenticated routes require the standard Bearer header:
```http
Authorization: Bearer <accessToken>
```

Responses adhere strictly to real HTTP status codes:
- `200 OK` / `201 Created`: Success payloads.
- `400 Bad Request`: Input validation rejections.
- `401 Unauthorized`: Missing, invalid, or expired JWT.
- `403 Forbidden`: Insufficient role or access rights.
- `404 Not Found`: Resource not found.
- `409 Conflict`: Concurrency conflict (retry mutation).
- `500 Internal Server Error`: Server exception.

---

## 📅 September 2026 Directives: Analytics & History Redesign

### 1. Legal & Branding Directive: Complete Removal of Work Fitness
- **Policy**: Ryvenza is a circadian rhythm & shift-work optimization platform, NOT an occupational fitness/suitability-for-work evaluator.
- **Contract Changes**:
  - `workFitScore`, `workFit`, `workReadyLabel`, and "Aptitude au travail" are completely removed from all API endpoints (Dashboard cards, Analytics, Calculator cards, Realtime payloads).
  - Shift scheduling and work rotation tracking remain standard.

---

### 2. Advanced Nap Management (`sleepType: 'main' | 'nap'`)
- **Endpoints**: `POST /api/v1/calculator/sessions/:sessionId/sleep` and `POST /api/v1/calculator/session/:sessionId/sleep`
- **Zero-Day-Reset Invariant**: Logging a nap appends the entry to `session.napsJson`, credits sleep debt, and refreshes live scores, but **never** advances or finalizes the active circadian session.

#### Request Payload
```json
{
  "sleepType": "nap",
  "sleepStartedAt": "2026-07-28T13:30:00.000Z",
  "wakeRecordedAt": "2026-07-28T14:15:00.000Z",
  "quality": 4,
  "note": "Post-lunch power nap"
}
```

#### Response (`200 OK`)
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Sleep logged successfully",
  "data": {
    "sessionId": "cm...123",
    "status": "ACTIVE",
    "startedAt": "2026-07-28T06:00:00.000Z",
    "wakeRecordedAt": "2026-07-28T06:00:00.000Z",
    "saved": true,
    "conflicts": [],
    "message": "Nap logged.",
    "liveScores": { ... }
  }
}
```

---

### 3. Daily Timeline (`GET /api/v1/history/timeline`) — "My Day" Tab
- **Endpoint**: `GET /api/v1/history/timeline?date=YYYY-MM-DD&timezone=Europe/Paris`
- **Purpose**: Feeds the chronological "My day" (`Ma journée`) screen.
- **Boundaries**:
  - `startUtc`: Opening main sleep start instant.
  - `endUtc`: Start of next session's main sleep (if finalized) or estimated next bedtime (if ongoing).
  - `isOngoing`: `true` if active session, `false` if completed/finalized.

#### Response (`200 OK`)
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Success",
  "data": {
    "date": "2026-07-28",
    "startUtc": "2026-07-27T22:30:00.000Z",
    "endUtc": "2026-07-28T23:00:00.000Z",
    "isOngoing": true,
    "summary": {
      "globalRhythmScore": 84,
      "rhythmScoreLabel": "Optimal",
      "sleepScore": 85,
      "hydrationScore": 80,
      "caffeineScore": 90,
      "nutritionScore": 75,
      "sportScore": 70,
      "recoveryScore": 80,
      "fatigueRiskScore": 25,
      "sleepDurationMinutes": 450,
      "sleepDebtMinutes": 30
    },
    "tracks": {
      "sleep": [
        {
          "id": "cm...-main-sleep",
          "type": "main",
          "start": "2026-07-27T22:30:00.000Z",
          "end": "2026-07-28T06:00:00.000Z",
          "durationMin": 450,
          "quality": 85
        },
        {
          "id": "nap-uuid-1",
          "type": "nap",
          "start": "2026-07-28T13:30:00.000Z",
          "end": "2026-07-28T14:15:00.000Z",
          "durationMin": 45,
          "quality": 4,
          "notes": "Post-lunch power nap"
        }
      ],
      "work": [
        {
          "id": "cm...-shift",
          "type": "night",
          "start": "2026-07-28T22:00:00.000Z",
          "end": "2026-07-29T06:00:00.000Z",
          "label": "Night shift"
        }
      ],
      "hydration": [
        {
          "id": "water-uuid-1",
          "time": "2026-07-28T07:00:00.000Z",
          "volumeMl": 500,
          "totalDayMl": 500,
          "targetMl": 2500
        }
      ],
      "caffeine": [
        {
          "id": "caff-uuid-1",
          "time": "2026-07-28T08:00:00.000Z",
          "mg": 100,
          "drinkType": "espresso",
          "cutoffTime": "23:00"
        }
      ],
      "meals": [
        {
          "id": "meal-uuid-1",
          "order": 1,
          "time": "2026-07-28T09:00:00.000Z",
          "heaviness": "medium",
          "isPlanned": false
        }
      ],
      "exercise": [
        {
          "id": "sport-uuid-1",
          "start": "2026-07-28T11:00:00.000Z",
          "durationMin": 45,
          "sportType": "cardio",
          "intensity": "medium",
          "heartRateAvgBpm": 142,
          "distanceKm": 6.8,
          "readiness": "high"
        }
      ]
    },
    "recommendations": [
      {
        "category": "caffeine",
        "priority": 1,
        "title": "Caffeine Cutoff",
        "body": "Avoid caffeine after 16:00"
      }
    ]
  }
}
```

---

### 4. Overview Analytics Enhancements (`GET /api/v1/analytics`)
- **Endpoint**: `GET /api/v1/analytics?period=7d&endDate=YYYY-MM-DD`
- **Supported Periods**: `7d`, `30d`, `90d`, `1y` (or `360d`).
- **Preceding Period Comparison**:
  - `globalRhythmScore.diff`: Numerical difference vs the preceding equivalent window (e.g. current 7 days vs previous 7 days).
  - `globalRhythmScore.diffLabel`: Localized label (e.g. `"vs 7 previous days"` / `"vs 7 jours précédents"`).
- **Stacked Sleep Duration Breakdown**:
  - `sleepDuration.trend`: Daily objects containing `date`, localized single-letter `dayLabel` (L, M, M, J, V, S, D in FR; M, T, W, T, F, S, S in EN), `mainSleepMinutes`, `napMinutes`, `totalMinutes`, and `durationDisplay`.

---

### 5. In-App Notification Center & Channel Specifications

All notifications generated by background crons, delayed circadian calculations, and transactional events are delivered via Firebase Cloud Messaging (FCM) and persisted in the user's In-App Notification Center.

#### Notification Channels & Automated Triggers
| Channel | Purpose | Trigger Mechanism | User Preference Key |
| :--- | :--- | :--- | :--- |
| `bedtime_alert` | Wind-down alert before optimal bedtime | Scheduled on session calculation (`bedtimeReminderMinutes`, default: 60m) | `bedtimeAlerts` |
| `caffeine_cutoff` | Warning before caffeine clearance threshold | Scheduled on session calculation (`caffeineReminderMinutes`, default: 30m) | `caffeineCutoff` |
| `shift_reminder` | Warning before upcoming work shift starts | Scheduled on session calculation (`shiftReminderMinutes`, default: 30m) | `shiftReminders` |
| `circadian_transition` | Morning wake check-in for unsynced days | Background Cron daily at 09:00 (`0 9 * * *`) | `circadianTransitions` |
| `weekly_sport` | Sunday evening workout & recovery summary | Background Cron weekly on Sunday at 18:00 (`0 18 * * 0`) | `weeklySportReport` |
| `payment_transaction` | Stripe subscription, renewal, invoice alerts | Transactional webhook dispatch (always delivered) | *N/A (Bypasses preference filter)* |
| `system_alert` | Security and login notifications | Auth event dispatch (always delivered) | *N/A (Bypasses preference filter)* |

---

#### 5a. `GET /api/v1/notifications` — In-App Notifications Feed
Returns paginated list of user notifications, unread counts, and total items.
- **Endpoint**: `GET /api/v1/notifications`
- **Query Params**:
  - `page`: Page number (integer, default: 1).
  - `limit`: Items per page (integer, default: 20, max: 100).
  - `unreadOnly`: Filter to unread notifications only (`boolean`, default: false).
- **Auth Required**: `Bearer <token>`

##### Response (`200 OK`)
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Success",
  "data": {
    "notifications": [
      {
        "id": "cm...abc1",
        "userId": "user-uuid",
        "title": "Bedtime Wind-Down Alert",
        "body": "Your optimal sleep window opens in 60m (at 22:30). Start winding down to protect your sleep quality.",
        "data": {
          "channel": "bedtime_alert",
          "sessionId": "session-uuid"
        },
        "status": "SENT",
        "isRead": false,
        "sentAt": "2026-10-08T21:30:00.000Z",
        "createdAt": "2026-10-08T21:30:00.000Z"
      }
    ],
    "unreadCount": 3,
    "total": 12,
    "page": 1,
    "limit": 20,
    "hasMore": false
  }
}
```

---

#### 5b. `GET /api/v1/notifications/unread-count` — Top-Bar Badge Count
Lightweight endpoint for displaying the unread notification badge count in navigation bars.
- **Endpoint**: `GET /api/v1/notifications/unread-count`
- **Auth Required**: `Bearer <token>`

##### Response (`200 OK`)
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Success",
  "data": {
    "unreadCount": 3
  }
}
```

---

#### 5c. `PATCH /api/v1/notifications/:id/read` — Mark Notification Read
Marks an individual notification as read (`isRead: true`).
- **Endpoint**: `PATCH /api/v1/notifications/:id/read`
- **Auth Required**: `Bearer <token>`

##### Response (`200 OK`)
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Notification marked as read",
  "data": {
    "id": "cm...abc1",
    "isRead": true
  }
}
```

---

#### 5d. `PATCH /api/v1/notifications/read-all` — Mark All As Read
Batch marks all unread notifications as read.
- **Endpoint**: `PATCH /api/v1/notifications/read-all`
- **Auth Required**: `Bearer <token>`

##### Response (`200 OK`)
```json
{
  "success": true,
  "statusCode": 200,
  "message": "All notifications marked as read",
  "data": {
    "updatedCount": 5
  }
}
```

---

#### 5e. `DELETE /api/v1/notifications/:id` — Delete / Dismiss Notification
Permanently deletes or dismisses a notification.
- **Endpoint**: `DELETE /api/v1/notifications/:id`
- **Auth Required**: `Bearer <token>`

##### Response (`200 OK`)
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Notification deleted",
  "data": {
    "success": true
  }
}
```

---

## 14. Shift Bedtime Constraints & 30-Hour Circadian Session Lifecycle Rules

### 1. Shift Bedtime Hard Ceiling Constraint
When the user has an upcoming shift (e.g. morning shift starting at 06:00), the circadian engine guarantees that the recommended bedtime leaves enough time for full sleep recovery:
- **Wake Target**: Wake time is computed as `shiftStart - commuteMinutes - prepBuffer` (e.g. 06:00 shift $\to$ 04:30 wake).
- **Bedtime Hard Ceiling**: The engine enforces a strict mathematical upper bound:
  $$\text{latestBedtimeMin} = \text{wakeTargetMin} - \text{minSleepMin}$$
  Even if the user's chronotype is evening or daytime naps occurred, bedtime will never be placed late (e.g. 23:50 before a 06:00 shift). For an 04:30 wake and 7.5h sleep target, the engine recommends a bedtime no later than 21:00.
- **Evening Anchor Sleep Guard**: The immediate recovery sleep branch ($\le 10\text{h}$ interval) is strictly restricted to evening anchor wakeups (`wakeTime >= 18:00`, such as after an overnight shift), preventing early morning wakes from erroneously triggering daytime sleep recovery modes.

### 2. Circadian Session Lifecycle & 30-Hour Rollover
The circadian day model differs fundamentally from standard calendar days:
1. **Midnight Non-Interference**:
   - Calendar midnight (00:00) does **not** close, reset, or split an active session. Workouts, meals, and hydration logged past midnight remain linked to the active circadian day.
2. **Explicit Session Closure**:
   - **Manual End Day**: User taps *"Terminer ma journée"* (`POST /api/v1/calculator/sessions/:sessionId/end-day` or `/calculate`). The session transitions from `ACTIVE` to `FINALIZED` (`closedBy: 'MANUAL'`).
   - **Next Main Wake**: If the user did not manually close yesterday's session before going to bed, logging their next wake (`isNewMainWake: true`) automatically finalizes the previous day (`closedBy: 'NEW_WAKE'`) and starts the new circadian cycle.
3. **30-Hour Safety Expiry Window**:
   - Active sessions are stamped with `expiresAt = startedAt + 30h`.
   - If no new wake is logged and the session is not manually closed within 30 hours, it is considered stale, preventing unbounded open sessions.

---

## 15. Daily Timeline Dynamic Localization, Circadian Boundaries & Timezone Contract

### 1. Dynamic Localization in `GET /api/v1/history/timeline`
The daily timeline endpoint powers the *"My day"* (*Ma journée*) view. It dynamically translates recommendations and summary score labels to the client's current preferred language:
- **Endpoint**: `GET /api/v1/history/timeline?date=YYYY-MM-DD&locale=fr` (or `locale=en`)
- **Query Parameters**:
  - `date`: Target date key (`YYYY-MM-DD`).
  - `timezone` (optional): IANA timezone string (defaults to user baseline timezone).
  - `locale` (optional): `'fr'` | `'en'` (defaults to `user.language` or `'en'`).

#### Response Example
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Success",
  "data": {
    "date": "2026-10-10",
    "startUtc": "2026-10-09T22:30:00.000Z",
    "endUtc": "2026-10-10T22:00:00.000Z",
    "isOngoing": true,
    "summary": {
      "globalRhythmScore": 84,
      "rhythmScoreLabel": "Optimal",
      "sleepScore": 85,
      "hydrationScore": 80,
      "caffeineScore": 90,
      "nutritionScore": 75,
      "sportScore": 70,
      "recoveryScore": 80,
      "fatigueRiskScore": 25,
      "sleepDurationMinutes": 450,
      "sleepDebtMinutes": 30
    },
    "tracks": {
      "sleep": [ ... ],
      "work": [ ... ],
      "hydration": [ ... ],
      "caffeine": [ ... ],
      "meals": [ ... ],
      "exercise": [ ... ]
    },
    "recommendations": [
      {
        "category": "sleep",
        "priority": 1,
        "isPremium": false,
        "title": "Sieste d'ancrage nuit",
        "body": "Une sieste d'ancrage de 90 min entre 14:30 et 16:00 complète un cycle complet pour soutenir la vigilance nocturne.",
        "titleKey": "sleep.anchorNapTitle",
        "bodyKey": "sleep.preShiftAnchorNap",
        "bodyParams": {
          "napStart": "14:30",
          "napEnd": "16:00",
          "durationMin": 90
        }
      }
    ]
  }
}
```

#### Key Contract Assurances:
1. **Dynamic Language Switch**: Even if a session was calculated and cached in French, requesting `?locale=en` immediately translates recommendations and `rhythmScoreLabel` into English without requiring recalculation.
2. **Circadian Cycle Bounds (`startUtc` & `endUtc`)**:
   - `startUtc`: Absolute UTC timestamp of the main sleep period opening the waking cycle (or wake anchor if bedtime unrecorded).
   - `endUtc`: Absolute UTC timestamp of bedtime closing the waking cycle (from upcoming sleep window or next session).
3. **Timezone & UTC Contract**:
   - All logged timestamps (`occurredAt`, `sleepStartedAt`, `wakeRecordedAt`, etc.) are formatted and stored as UTC ISO-8601 strings.
   - Weekday calculations (such as Monday to Sunday weekly sport goals and daily timeline date matching) strictly evaluate within the user's active IANA timezone (`session.timezoneAtStart` or `profile.timezone`), preventing off-by-one calendar shifts across timezones.

---

## 16. Work Rotation Selectors, Custom Name Persistence & Schedule Aliases

### 1. Work Schedule Settings & Selectors (`GET /api/v1/calculator/work-settings`)
Provides settings for the Work Schedule configuration page (Image 5), complete with dropdown options for both built-in rotation presets and saved user custom templates:
- **Endpoint**: `GET /api/v1/calculator/work-settings`
- **Auth Required**: `Bearer <token>`

#### Response (`200 OK`)
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Work schedule settings retrieved successfully",
  "data": {
    "defaultRotation": "Syngenta",
    "rotationName": "Syngenta",
    "activeRotationKey": "custom-clabc1234",
    "availableRotations": [
      {
        "key": "three-two-two-night",
        "label": "3-2-2 Night",
        "description": "3 nights, 2 off, 2 days",
        "cycleWeeks": 1,
        "isCustom": false,
        "shiftTimesJson": { ... },
        "patternJson": [ ... ]
      },
      {
        "key": "two-two-three-continental",
        "label": "2-2-3 Continental",
        "description": "Panama / Pitman rotating shift",
        "cycleWeeks": 2,
        "isCustom": false,
        "shiftTimesJson": { ... },
        "patternJson": [ ... ]
      },
      {
        "id": "clabc1234",
        "key": "custom-clabc1234",
        "label": "Syngenta",
        "description": "Plant shift rotation",
        "cycleWeeks": 3,
        "isCustom": true,
        "shiftTimesJson": { ... },
        "patternJson": [ ... ]
      }
    ],
    "shiftReminderEnabled": true,
    "shiftReminderMinutes": 30,
    "shiftReminderDisplay": "On · 30 min before",
    "timezone": "Europe/Zurich",
    "timezoneDisplay": "CET · Geneva"
  }
}
```

### 2. Mobile Schedule Aliases (`/schedule/rotation/*`)
Mobile clients can use the following top-level aliases alongside existing `/calculator/work-rotation/*` endpoints:

| Endpoint | Method | Description |
| :--- | :--- | :--- |
| `/api/v1/schedule/rotation/my-rotation` | `GET` | Fetches active rotation with `rotationName`, shift times, and day grid. |
| `/api/v1/schedule/rotation/save` | `POST` | Upserts active rotation, saves custom template if `saveAsTemplate: true`, and updates active day. |
| `/api/v1/calculator/work-rotation` | `GET` | Primary work rotation retrieval endpoint. |
| `/api/v1/calculator/work-rotation` | `PUT` | Primary work rotation upsert endpoint. |
| `/api/v1/calculator/work-rotation/presets` | `GET` | Returns built-in system presets and custom user templates. |

#### Mobile App Integration Checklist
- [ ] In Settings > Work Schedule, populate the "Default Rotation" dropdown using `data.availableRotations`.
- [ ] For items where `isCustom: true`, show a "Custom" badge or allow the user to edit their custom cycle template.
- [ ] Observe `data.rotationName` to display the active rotation title on the home dashboard work card (e.g. *"Syngenta"* or *"3-2-2 Night"*).


