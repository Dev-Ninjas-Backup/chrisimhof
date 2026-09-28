# Ryvenza Backend Requirements: Analytics & History Redesign
**Authoritative Specification for Backend Engineers**  
*Date: September 28, 2026*  
*Reference: RYVENZA Analytics Developer Briefs (EN-2 & Overview EN) + Client Directives*

---

## 📋 Context & Purpose

The client (Chris) has finalized the design and product rules for the **Analytics / History** section of RYVENZA. This redesign introduces a 2-tab architecture:
1. **"My day" (`Ma journée`)**: A continuous, horizontal daily timeline bounded by main sleep cycles, displaying 6 life tracks (Sleep, Work, Hydration, Caffeine, Meals, Exercise), inline event inspection, and 4 recommendation types (including strategic Naps).
2. **"Overview" (`Vue d'ensemble`)**: Period-based analytics (7d, 30d, 90d, 1y) with arbitrary date range pagination (`<` / `>`), preceding period comparisons, rhythm evolution trends, and a stacked sleep vs. nap duration breakdown.

Additionally, the client has issued an **urgent legal & branding directive**: **RYVENZA must completely remove any assessment or mention of "Work Fitness" / "Fitness for Work" ("Aptitude au travail").**

Below are the exact requirements, endpoint definitions, and payload schemas needed from the backend team.

---

## 🚨 Priority 1: Removal of "Work Fitness" / "Fitness for Work"

### Directive
> *"RYVENZA should not assess or indicate whether someone is fit or unfit for work. That is not something the app should determine. Please remove this from the Analytics page and anywhere else."*

### Backend Actions Required
1. **Remove `workFitScore` from `GET /api/v1/analytics`**:
   - In `avgScores`: Remove `workFitScore` (keep only `sleepScore`, `hydrationScore`, `caffeineScore`, `nutritionScore`, `sportScore`).
   - In `scoreTrend`: Remove `workFitScore` from daily trend items.
2. **Calculator & Live Score Responses**:
   - Ensure no cards, subtitles, or recommendations use the wording `"Fit for work"`, `"Unfit for work"`, `"Aptitude au travail"`, or `"Work readiness"`.
   - Work shift tracking remains standard: shift times (`08:00 - 16:00`), shift types (`day`, `evening`, `night`, `off`), and transition prep are completely fine.

---

## 🛌 Priority 2: Advanced Nap Management (Future Scope Topic 2 Completion)

The client's new design heavily features **naps** (both logged naps in the timeline and active nap recommendations).

### 1. Distinguish "Main Sleep" vs "Nap"
- **Main Sleep (Anchor Sleep)**: The primary extended rest period that anchors the circadian cycle and closes/advances the day session.
- **Nap**: A shorter recovery sleep (e.g. 15–90 min) taken during the waking period or before a night shift.
- **Rule**: Logging a nap must **NEVER** close, advance, or rollover the active session (`sessionId`).

### 2. Update Sleep Logging Endpoint
`POST /api/v1/calculator/sessions/:sessionId/sleep`

#### Request Body:
```json
{
  "sleepStartedAt": "2026-09-26T15:30:00.000Z",
  "wakeRecordedAt": "2026-09-26T16:00:00.000Z",
  "quality": 80,
  "sleepType": "nap" // "main" | "nap" (default: "main")
}
```

### 3. Dynamic Nap Recommendations
The engine should actively recommend naps when appropriate (e.g., accumulated sleep debt > 60 min, transition day before night shift, or afternoon circadian dip) with suggested duration (e.g., 20–30 min power nap or 90 min anchor nap).

---

## ⏱️ Priority 3: New Endpoint — Daily Timeline (`GET /api/v1/history/timeline`)

To power the **"My day" (`Ma journée`)** tab, the frontend needs to fetch all events that occurred during a specific logical day.

- **Endpoint**: `GET /api/v1/history/timeline`
- **Auth**: `Bearer <token>`
- **Query Parameters**:
  - `date`: `YYYY-MM-DD` (Start date of the logical day)
  - `timezone`: (Optional) User's local timezone, e.g., `Europe/Zurich` (defaults to user profile timezone)

### Logical Day Boundary Definition
As per the developer brief:
> *"A day runs from the start of one main sleep to the start of the next. Include the opening sleep and the waking period after it; the next main sleep belongs to the next day. No fixed 24-hour limit: 26 Sep 07:00 to 27 Sep 08:00 = 25 hours. For an ongoing day, label the recommended next main sleep start as an estimated endpoint."*

### Expected Response Payload (`200 OK`)
```json
{
  "success": true,
  "statusCode": 200,
  "data": {
    "date": "2026-09-26",
    "range": {
      "startUtc": "2026-09-26T05:00:00.000Z",
      "endUtc": "2026-09-27T06:00:00.000Z",
      "startLocal": "2026-09-26 07:00",
      "endLocal": "2026-09-27 08:00",
      "totalDurationHours": 25.0,
      "isOngoing": false
    },
    "tracks": {
      "sleep": [
        {
          "id": "sleep-1",
          "type": "main",
          "startLocal": "07:00",
          "endLocal": "14:30",
          "startUtc": "2026-09-26T05:00:00.000Z",
          "endUtc": "2026-09-26T12:30:00.000Z",
          "durationMinutes": 450,
          "display": "7h 30m"
        },
        {
          "id": "nap-1",
          "type": "nap",
          "startLocal": "17:30",
          "endLocal": "18:00",
          "startUtc": "2026-09-26T15:30:00.000Z",
          "endUtc": "2026-09-26T16:00:00.000Z",
          "durationMinutes": 30,
          "display": "30m"
        }
      ],
      "work": [
        {
          "id": "shift-1",
          "shiftType": "night",
          "startLocal": "22:00",
          "endLocal": "06:00",
          "startUtc": "2026-09-26T20:00:00.000Z",
          "endUtc": "2026-09-27T04:00:00.000Z",
          "display": "Night shift · 22:00-06:00"
        }
      ],
      "hydration": [
        {
          "id": "hyd-1",
          "timeLocal": "15:00",
          "timeUtc": "2026-09-26T13:00:00.000Z",
          "amountMl": 500,
          "display": "Water · 500ml"
        },
        {
          "id": "hyd-2",
          "timeLocal": "18:30",
          "timeUtc": "2026-09-26T16:30:00.000Z",
          "amountMl": 750,
          "display": "Water · 750ml"
        }
      ],
      "caffeine": [
        {
          "id": "caff-1",
          "timeLocal": "15:15",
          "timeUtc": "2026-09-26T13:15:00.000Z",
          "amountMg": 100,
          "name": "Coffee",
          "display": "Coffee · 100mg"
        }
      ],
      "meals": [
        {
          "id": "meal-1",
          "timeLocal": "16:00",
          "timeUtc": "2026-09-26T14:00:00.000Z",
          "mealType": "main",
          "display": "Main Meal"
        }
      ],
      "exercise": [
        {
          "id": "sport-1",
          "timeLocal": "19:00",
          "timeUtc": "2026-09-26T17:00:00.000Z",
          "durationMinutes": 45,
          "activityType": "Running",
          "display": "Running · 45 min"
        }
      ]
    },
    "recommendations": [
      {
        "category": "exercise",
        "timeLocal": "19:00",
        "title": "Optimal Workout Window",
        "body": "Your circadian temperature and alertness peak around 19:00."
      },
      {
        "category": "nap",
        "timeLocal": "17:30",
        "title": "Power Nap",
        "body": "A 20–30 minute nap will refresh alertness before your night shift."
      },
      {
        "category": "caffeine_cutoff",
        "timeLocal": "20:00",
        "title": "Caffeine Cut-off",
        "body": "Avoid caffeine after 20:00 to protect recovery sleep."
      },
      {
        "category": "sleep",
        "timeLocal": "07:30",
        "title": "Recommended Sleep Window",
        "body": "Wind down post-shift for optimal morning recovery."
      }
    ]
  }
}
```

---

## 📊 Priority 4: Enhancements to `GET /api/v1/analytics` ("Overview" Tab)

To support **"Vue d'ensemble" (`4.jpg`)**, the existing `/api/v1/analytics` endpoint needs four specific enhancements.

### 1. Date Range & Period Pagination Parameters
The user can navigate through past periods using `<` and `>` arrows or pick an end date from the calendar.
- Add query parameter: `endDate=YYYY-MM-DD` (defaults to current date if omitted).
- Support `period`: `"7d"` | `"30d"` | `"90d"` | `"1y"`.
- *Example*: `GET /api/v1/analytics?period=7d&endDate=2026-09-27` calculates metrics for September 21–27, 2026, and compares them with the preceding 7 days (September 14–20, 2026).

### 2. Preceding Period Comparison on `globalRhythmScore`
Currently, the backend returns:
```json
"globalRhythmScore": {
  "average": 72,
  "latest": 75,
  "highest": 85
}
```
**Required update**: Add `diff` (delta in percentage points against the preceding equivalent period):
```json
"globalRhythmScore": {
  "average": 72,
  "latest": 75,
  "highest": 85,
  "diff": 5, // e.g. +5 pts vs preceding period
  "diffLabel": "vs 7 jours précédents"
}
```

### 3. Stacked Sleep & Nap Duration Breakdown
To render the stacked bar chart (**Main Sleep** in emerald + **Naps** in light mint) and period nap summary:
```json
"sleepDuration": {
  "avgMinutes": 450,
  "avgDisplay": "7 h 30",
  "totalNapsInPeriod": 3,
  "trend": [
    {
      "date": "2026-09-21",
      "dayLabel": "L",
      "mainSleepMinutes": 420,
      "napMinutes": 0,
      "totalMinutes": 420
    },
    {
      "date": "2026-09-22",
      "dayLabel": "M",
      "mainSleepMinutes": 420,
      "napMinutes": 30,
      "totalMinutes": 450
    },
    {
      "date": "2026-09-23",
      "dayLabel": "M",
      "mainSleepMinutes": 480,
      "napMinutes": 0,
      "totalMinutes": 480
    },
    {
      "date": "2026-09-24",
      "dayLabel": "J",
      "mainSleepMinutes": 390,
      "napMinutes": 0,
      "totalMinutes": 390
    },
    {
      "date": "2026-09-25",
      "dayLabel": "V",
      "mainSleepMinutes": 450,
      "napMinutes": 45,
      "totalMinutes": 495
    },
    {
      "date": "2026-09-26",
      "dayLabel": "S",
      "mainSleepMinutes": 480,
      "napMinutes": 0,
      "totalMinutes": 480
    },
    {
      "date": "2026-09-27",
      "dayLabel": "D",
      "mainSleepMinutes": 480,
      "napMinutes": 60,
      "totalMinutes": 540
    }
  ]
}
```

### 4. 5 Domain Indicators (`avgScores`)
Ensure `avgScores` returns clean 0–100 percentage values for the 5 lifestyle domains:
```json
"avgScores": {
  "sportScore": 71,
  "hydrationScore": 82,
  "caffeineScore": 58,
  "nutritionScore": 64,
  "sleepScore": 76
}
```
*(Notice: `workFitScore` is completely omitted).*

---

## 📋 Implementation Checklist for Backend Team

- [ ] **Work Fitness Removal**: Remove `workFitScore` from `avgScores` and `scoreTrend` in `/api/v1/analytics`. Ensure no endpoint returns work suitability judgments.
- [ ] **Nap Management (Sleep Engine)**:
  - [ ] Add `sleepType: "nap" | "main"` to `POST /api/v1/calculator/sessions/:sessionId/sleep`.
  - [ ] Guarantee logging a nap **never** closes or advances the active session.
  - [ ] Generate strategic nap recommendations when appropriate.
- [ ] **Daily Timeline Endpoint**:
  - [ ] Implement `GET /api/v1/history/timeline?date=YYYY-MM-DD`.
  - [ ] Compute logical day boundaries from opening main sleep to next main sleep.
  - [ ] Return the 6 tracks with local/UTC timestamps and duration/amount values.
  - [ ] Include historical recommendations for the given date.
- [ ] **Analytics Overview Enhancements**:
  - [ ] Support `endDate=YYYY-MM-DD` and `period="1y"` on `GET /api/v1/analytics`.
  - [ ] Add `diff` comparison to `globalRhythmScore`.
  - [ ] Provide `mainSleepMinutes`, `napMinutes`, and `totalNapsInPeriod` in `sleepDuration`.
