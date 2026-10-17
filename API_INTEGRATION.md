# Ryvenza API — Frontend Integration Guide: Weekly Sport Objective & Multi-Session Update
**Target Audience: Mobile (Flutter / iOS / Android) & Web Frontend Engineers**  
*Last Updated: 2026-10-17*

---

## 1. Summary of Changes

### What Changed on Backend
Previously, the backend calculated the weekly sport objective by counting the number of **distinct calendar days** with at least one workout. As a result, logging multiple workouts on the same day (or morning and evening workouts during a night shift) only counted as **1 workout** toward the weekly goal.

The backend has been updated to count **individual completed workout sessions**:
1. **Multi-Session Support**: If a user completes 3 workouts in one day, or trains at 8 PM and again at 6 AM during a night shift, each session counts separately toward `weeklySportStats.workoutsCompletedThisWeek`.
2. **Weekly Objective Accuracy**: If the user's weekly goal is 5 (`weeklyGoal: 5`), completing 5 separate workouts during the Monday–Sunday week will now correctly reach `5/5` (`isGoalMet: true`), regardless of whether two or more sessions occurred on the same calendar day or circadian session.
3. **No Breaking Contract Changes**: The field names, types, and schema structures remain 100% backward-compatible.

---

## 2. Affected Endpoints & Events

1. **`GET /api/v1/calculator/live-scores`** (and Socket.IO `/realtime` `liveScores` event):
   - Path: `cards.sport.weeklySportStats`
2. **`GET /api/v1/calculator/tabs/sport`** (and `tabs.sport` in live scores):
   - Path: `weeklySportStats` and `thisWeek`
3. **`POST /api/v1/calculator/quick-log`**:
   - Immediate recalculation and broadcast with updated `weeklySportStats`.

---

## 3. Data Contracts & Schema Reference

### 3.1 `weeklySportStats` Object

Returned in both `cards.sport.weeklySportStats` and `tabs.sport.weeklySportStats`:

```typescript
export interface WeeklySportStats {
  weeklyGoal: number;               // User's target workouts per week (e.g. 5)
  workoutsCompletedThisWeek: number; // Total completed sessions this week (e.g. 3, 5, etc.)
  daysRemainingInWeek: number;       // Days remaining in Monday-to-Sunday cycle (7 - dayIndex)
  isGoalMet: boolean;                // true when workoutsCompletedThisWeek >= weeklyGoal
  isOnPace: boolean;                 // true when (workoutsRemaining <= daysRemainingInWeek)
}
```

#### Example Payload (`GET /api/v1/calculator/live-scores`)
```json
{
  "success": true,
  "statusCode": 200,
  "data": {
    "cards": {
      "sport": {
        "score": 85,
        "label": "Good level",
        "subtitle": "95m today",
        "sportReadiness": "medium",
        "weeklySportStats": {
          "weeklyGoal": 5,
          "workoutsCompletedThisWeek": 3,
          "daysRemainingInWeek": 2,
          "isGoalMet": false,
          "isOnPace": true
        }
      }
    }
  }
}
```

---

### 3.2 `thisWeek` Calendar Array (`GET /api/v1/calculator/tabs/sport`)

The `thisWeek` array represents the 7-day Monday-to-Sunday calendar progression. On days with multiple workouts, `day.sessions` will contain **all** completed workout entries for that day:

```json
{
  "success": true,
  "statusCode": 200,
  "data": {
    "weeklySportStats": {
      "weeklyGoal": 5,
      "workoutsCompletedThisWeek": 3,
      "daysRemainingInWeek": 2,
      "isGoalMet": false,
      "isOnPace": true
    },
    "thisWeek": [
      {
        "date": "2026-10-12T00:00:00.000Z",
        "dayLabel": "Mon",
        "isFuture": false,
        "isRestDay": false,
        "sessions": [
          {
            "id": "c7a8...",
            "sportType": "cardio",
            "displayType": "Running",
            "durationMinutes": 45,
            "intensity": "medium",
            "zoneLabel": "Z3",
            "displaySummary": "Mon · 45m · Z3",
            "recoveryLoadScore": 23
          },
          {
            "id": "d9b1...",
            "sportType": "strength",
            "displayType": "Strength",
            "durationMinutes": 30,
            "intensity": "high",
            "zoneLabel": "Z4",
            "displaySummary": "Mon · 30m · Z4",
            "recoveryLoadScore": 35
          }
        ]
      },
      {
        "date": "2026-10-13T00:00:00.000Z",
        "dayLabel": "Tue",
        "isFuture": false,
        "isRestDay": false,
        "sessions": [
          {
            "id": "e3f2...",
            "sportType": "cardio",
            "displayType": "Cycling",
            "durationMinutes": 20,
            "intensity": "low",
            "zoneLabel": "Z1",
            "displaySummary": "Tue · 20m · Z1",
            "recoveryLoadScore": 10
          }
        ]
      },
      {
        "date": "2026-10-14T00:00:00.000Z",
        "dayLabel": "Wed",
        "isFuture": false,
        "isRestDay": true,
        "sessions": []
      }
    ]
  }
}
```

---

## 4. Frontend Integration Checklist

Please review the following items in the mobile/web frontend codebase:

- [ ] **Bind Progress Directly to `workoutsCompletedThisWeek`**:
  Ensure the sport goal progress bar / label (e.g. `"3/5 sessions"`) directly reads:
  ```dart
  // Example Flutter / Dart
  final completed = weeklySportStats.workoutsCompletedThisWeek;
  final goal = weeklySportStats.weeklyGoal;
  final text = "$completed / $goal completed";
  ```
  *(Avoid counting days manually via `thisWeek.where((d) => d.sessions.isNotEmpty).length`, as a single day can now contain multiple workouts).*

- [ ] **Render Multiple Sessions in Day Columns (`thisWeek`)**:
  When displaying the Monday–Sunday week overview, iterate over `day.sessions` (e.g. `ListView` / `Column`) rather than assuming at most 1 session card per day.

- [ ] **Night Shift Cross-Midnight Workouts**:
  Workouts logged at 8 PM (before midnight) and 6 AM (after midnight) will appear under their respective calendar day in `thisWeek` (e.g., Monday and Tuesday), while both immediately contributing +1 to the weekly objective. No special client-side date math is required.