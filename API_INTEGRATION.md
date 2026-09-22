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