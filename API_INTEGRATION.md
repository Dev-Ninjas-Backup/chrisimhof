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