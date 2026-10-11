# RYVENZA Backend Action Items & Issue Fixes
**Date**: October 10, 2026  
**Target**: Backend Development Team  
**Context**: Client Review Feedback & Integration Fixes (Ref: PDFs dated 08–09 Oct 2026)

---

## Executive Summary
Following the client's end-to-end testing, several functional and algorithmic adjustments are required on the backend API. Below is a structured checklist with endpoints, expected behavior, root causes, and payload specifications.

---

## 1. Delete an Individual Main Sleep Record
* **Client Ref**: *Corrections 03, Issue 06 ("Delete one sleep record")*
* **Current Problem**:  
  Currently, the backend only provides an endpoint to delete naps (`DELETE /api/v1/calculator/sessions/:sessionId/naps/:entryId`) and an endpoint to reset the *entire* session (`POST /reset`). If a user accidentally logs a main sleep twice or logs wrong hours, there is **no endpoint to delete that specific main sleep record** without wiping the entire day.
* **Required Endpoint**:  
  `DELETE /api/v1/calculator/sessions/:sessionId/sleep/:entryId`  
  *(or `DELETE /api/v1/history/sleep/:entryId`)*
* **Expected Behavior**:
  1. Removes the specified sleep entry by its unique ID.
  2. Recalculates total sleep duration for that session.
  3. Rolls back sleep debt calculation and recalculates affected live scores (`sleepScore`, `globalRhythmScore`).
  4. Returns updated session/liveScores payload:
     ```json
     {
       "success": true,
       "message": "Sleep entry deleted successfully",
       "data": {
         "sessionId": "cm...",
         "liveScores": { ... }
       }
     }
     ```

---

## 2. Caffeine Custom Drink Name Persistence
* **Client Ref**: *Corrections 03, Issue 01 ("Custom drink name is not saved")*
* **Current Problem**:  
  When a user logs a custom caffeine drink (e.g., `"Monster"`), the backend only accepts fixed enum values for `drinkType` (`'espresso'`, `'coffee'`, `'energy'`, `'tea'`, `'other'`). Consequently, the custom name is discarded, and the entry perpetually displays as `"autre"` / `"Other"`.
* **Affected Endpoints**:  
  * `PATCH /api/v1/calculator/session/:sessionId/log` (`newCaffeineLogs`)
  * `PATCH /api/v1/calculator/sessions/:sessionId/caffeine/:entryId`
* **Required Change**:
  1. Add an optional `drinkLabel` (or `customName`) field to the Caffeine Log schema.
  2. When returning caffeine entries in `GET /session/:id`, `quickAdd`, and `history`, include `drinkLabel`:
     ```json
     {
       "id": "caff-uuid",
       "timestamp": "14:30",
       "caffeineMg": 160,
       "drinkType": "energy",
       "drinkLabel": "Monster",
       "occurredAt": "2026-10-09T08:30:00.000Z"
     }
     ```

---

## 3. Session Meal Target Synchronization with User Profile
* **Client Ref**: *Corrections 09 Oct, Issue 02 ("Use the profile meal target")*
* **Current Problem**:  
  The user configured `defaultDailyMealTarget = 5` in their profile settings (`PATCH /api/v1/profile/baseline`). However, active daily sessions initialize with `quickAddSummary.meals.dailyTarget = 3`, displaying `0/3` on empty days instead of `0/5`.
* **Affected Endpoints**:  
  * `POST /api/v1/calculator/session` (or auto session initialization)
  * `GET /api/v1/calculator/session/:sessionId`
* **Required Change**:
  * When a new daily session is created, initialize `quickAddSummary.meals.dailyTarget` directly from the user's `profile.defaultDailyMealTarget`.
  * If a user updates their profile `defaultDailyMealTarget` mid-session, update the active session's meal target accordingly.

---

## 4. Weekly Sport Goal Progress & Days Remaining Calculation
* **Client Ref**: *Corrections 09 Oct, Issue 09 ("Verify weekly workout progress")*
* **Current Problem**:  
  Even after saving a qualifying 45-minute workout session, `sportTab.weeklySportStats` continues returning:
  ```json
  "weeklySportStats": {
    "weeklyGoal": 3,
    "workoutsCompletedThisWeek": 0,
    "daysRemainingInWeek": 0,
    "isGoalMet": false
  }
  ```
* **Affected Endpoints**:  
  * `GET /api/v1/calculator/session/:sessionId`
  * `PATCH /api/v1/calculator/session/:sessionId/log` (`newSportSessions`)
* **Required Change**:
  1. **Count Workouts**: Ensure the query aggregates all qualifying workouts recorded between Monday 00:00:00 and Sunday 23:59:59 in the user's configured timezone.
  2. **Days Remaining**: Calculate actual days remaining in the current week (from current day until Sunday).
  3. Ensure that after a workout is logged or deleted via Quick Add, `weeklySportStats` immediately recalculates and returns the updated count.

---

## 5. Audit Bedtime Recommendation Algorithm & Day Rollover Logic
* **Client Ref**: *Corrections 09 Oct (Issue 04) & Corrections 03 (Issue 02)*
* **Current Problem**:  
  * Client reported a scenario: User woke up at `04:00`, accumulated `1h 15m` of sleep debt, and has an upcoming morning shift (work at `06:00`), yet the app suggested a bedtime of `23:35` / `23:50`.
  * If bedtime is `23:50` and the user must wake up early (e.g. `04:00` or `05:00`), this only leaves ~4 hours of sleep, directly violating circadian recovery principles.
* **Affected Service**:  
  * `calculator.service.ts` / `GET /api/v1/calculator/optimal-bedtime`
* **Required Actions**:
  1. **Constrain Bedtime by Next Shift / Wake Target**: Ensure the optimal bedtime algorithm uses the upcoming scheduled shift start time and required wake-up time as hard constraints. It must never propose a bedtime that forces sleep duration below the user's minimum target (e.g. 7h+).
  2. **Document Day Rollover Threshold**: The client has specifically asked for technical documentation on how a daily session ends:
     - Is it purely manual via *"Terminer ma journée"*?
     - Or is there an automatic timer (e.g. 30 hours from opening wake)?
     - Please document the exact trigger and rollover threshold so we can present it clearly to the client.

---

## 6. Daily Timeline Language Localization & Cycle Boundaries
* **Client Ref**: *Daily Timeline (`GET /api/v1/history/timeline`)*
* **Current Problem**:  
  1. **Hardcoded French in English Profile**: When `user.language == 'EN'`, the Daily Timeline recommendations returned French titles and bodies:
     ```json
     "recommendations": [
       { "title": "Sommeil", "body": "Visez le coucher avant 22:20..." },
       { "title": "Limite caféine", "body": "Limite 18:20 — protégez votre fenêtre..." }
     ]
     ```
     *(Note: `/api/v1/calculator/session/:id/recommendations` correctly respects English, but `/api/v1/history/timeline` hardcodes French).*
  2. **Rhythm Score Label**: `summary.rhythmScoreLabel` returns `"Modéré"` instead of `"Moderate"`.
  3. **Cycle Boundaries (`startUtc` & `endUtc`)**: The client requested that the timeline cycle represent **actual main-bedtime to next main-bedtime** (e.g., 22h 30m, 25h, etc.) rather than forcing a 24-hour day.
* **Required Change**:
  * Check `user.language` when generating recommendation titles and bodies in `GET /api/v1/history/timeline`.
  * Return actual cycle start (`startUtc` = previous main sleep start) and end (`endUtc` = next main sleep start / estimated bedtime).

---

## 7. Custom Rotation Name Persistence in Selectors
* **Client Ref**: *Corrections 09 Oct, Issues 01 & 08 ("Show custom rotation name & include in selector")*
* **Current Problem**:  
  * When a user creates and activates a custom rotation, the active card displays generic `"Personnalisé"` instead of the custom name entered (e.g., `"Mon tournus 3x8"`).
  * In Work Settings, the "Default rotation" selector only lists predefined presets and `"Aucun (Fixe)"`.
* **Affected Endpoints**:  
  * `POST /api/v1/schedule/rotation/save`
  * `GET /api/v1/schedule/rotation/my-rotation`
  * `GET /api/v1/calculator/work-settings`
* **Required Change**:
  1. Store the user-provided `rotationName` with the custom rotation.
  2. Return `rotationName` in `GET /api/v1/schedule/rotation/my-rotation`.
  3. Include the user's saved custom rotation(s) in `GET /api/v1/calculator/work-settings` / rotation dropdown options.

---

---

## 8. Timezone & Timestamp Contract
* **Rule**: Flutter client always sends ISO 8601 UTC timestamps (e.g. `2026-10-09T08:30:00.000Z`) formatted via `TimezoneHelper.formatToSessionUtcIso()`.
* **Backend Requirement**: 
  1. Store timestamps in UTC.
  2. Evaluate day/week boundaries (such as weekly workout counts, meal reset, and daily cycle bounds) using the user's registered timezone from their profile (`profile.timezone` / device timezone).
  3. Avoid hardcoded timezone assumptions (e.g. do not assume Zurich offset if user is in another timezone).

---

## Summary Checklist for Backend Developer
- [ ] **B1**: Add endpoint to delete single main sleep record (`DELETE /api/v1/calculator/sessions/:sessionId/sleep/:entryId`).
- [ ] **B2**: Add `drinkLabel` field to Caffeine Log model and support in `quick-add` and `PATCH`.
- [ ] **B3**: Initialize `quickAddSummary.meals.dailyTarget` from user's `profile.defaultDailyMealTarget`.
- [ ] **B4**: Fix weekly workout count and days remaining in `sportTab.weeklySportStats`.
- [ ] **B5**: Audit bedtime algorithm (ensure next-day wake constraints apply) and document 30h rollover rule.
- [ ] **B6**: Localize recommendations in `GET /api/v1/history/timeline` based on `user.language`.
- [ ] **B7**: Return and persist custom rotation name in `my-rotation` and work settings dropdown.
- [ ] **B8**: Ensure timezone evaluations respect user profile timezone with true UTC storage.
