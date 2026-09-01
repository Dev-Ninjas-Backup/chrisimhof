# RYVENZA App Developer Integration Guide

This document describes the frontend/mobile integration for circadian sessions, sleep entry, Quick Add create/edit/delete, live recalculation, and End Day.

## Final integration decisions

The app keeps its existing screens and its existing creation endpoints:

- Continue using `POST /api/v1/calculator/session/:sessionId/sleep` for BEDTIME + WAKE-UP.
- Continue using `PATCH /api/v1/calculator/session/:sessionId/log` to add hydration, caffeine, meals, and workouts.
- Use the new resource-specific `PATCH` and `DELETE` endpoints only for editing and deleting an existing Quick Add entry.
- Do not create a new day at midnight.
- Do not create a separate main-wake screen.

The following endpoints were intentionally removed and must not be used:

- `POST /api/v1/calculator/wake`
- Resource-specific POST endpoints for hydration, caffeine, meals, or workouts

All calculator endpoints require the existing bearer-token authentication.

## Circadian session lifecycle

A session has one of these statuses:

| Status | Meaning | App behavior |
| --- | --- | --- |
| `PENDING_WAKE` | No main wake has started the next biological day | Show the existing BEDTIME + WAKE-UP form; disable Quick Add |
| `ACTIVE` | The current circadian day is running | Show scores, tabs, Quick Add, and End Day |
| `FINALIZED` | The day has ended and its final summary is immutable | Show history/final summary; do not allow mutations |

Lifecycle rules:

1. A circadian day begins when the main BEDTIME + WAKE-UP form is submitted.
2. It continues across calendar midnight.
3. Midnight never creates, closes, or resets a session.
4. Pressing End Day closes the session immediately and has priority.
5. If End Day was forgotten, submitting the next main wake closes the previous active session with `closedBy: "NEW_WAKE"` and starts the next session.
6. After End Day, the next active day is not created until the next main wake is recorded.

```text
PENDING_WAKE
    │ submit BEDTIME + WAKE-UP
    ▼
ACTIVE ───────────────────────────────┐
    │                                │
    │ End Day                        │ next main wake if End Day was forgotten
    ▼                                ▼
FINALIZED (MANUAL)              FINALIZED (NEW_WAKE)
                                      │
                                      ▼
                                  new ACTIVE
```

## App startup

Call:

```http
GET /api/v1/calculator/session
Authorization: Bearer <token>
```

Store `data.sessionId` as the current calculator session ID.

### When the response is `PENDING_WAKE`

Example:

```json
{
  "success": true,
  "data": {
    "sessionId": "session-id",
    "status": "PENDING_WAKE",
    "waitingForMainWake": true,
    "liveScores": null
  }
}
```

App behavior:

- Show the existing BEDTIME + WAKE-UP screen.
- Do not show a new or separate wake screen.
- Submit the sleep form against this `sessionId`.
- Disable Quick Add until the sleep request returns `ACTIVE`.

### When the response is `ACTIVE`

- Restore the active home/dashboard experience.
- Join the session realtime room.
- Use `startedAt` and `wakeRecordedAt` only as absolute timestamps.
- Do not compare the session with the phone's calendar date to decide whether it expired.

## BEDTIME + WAKE-UP

Use the existing endpoint:

```http
POST /api/v1/calculator/session/:sessionId/sleep
Content-Type: application/json
Authorization: Bearer <token>
```

Preferred payload:

```json
{
  "sleepStartedAt": "2026-07-27T21:08:00.000Z",
  "wakeRecordedAt": "2026-07-28T03:50:00.000Z"
}
```

Always send absolute ISO-8601 timestamps. The old `sleepStartTime` and `wakeTime` HH:MM fields remain compatible but should not be used for new app code.

### First wake or wake after manual End Day

When the current session is `PENDING_WAKE`, omit `isNewMainWake`:

```json
{
  "sleepStartedAt": "2026-07-28T21:30:00.000Z",
  "wakeRecordedAt": "2026-07-29T04:15:00.000Z"
}
```

The pending session becomes `ACTIVE`.

### Correcting the current sleep record

When editing the current active day's bedtime or wake time, omit `isNewMainWake` or send `false`:

```json
{
  "sleepStartedAt": "2026-07-27T21:20:00.000Z",
  "wakeRecordedAt": "2026-07-28T03:55:00.000Z",
  "isNewMainWake": false
}
```

The same session is updated and recalculated.

### New main wake when End Day was forgotten

There is no visible `isNewMainWake` form field. It is an internal request flag selected by app flow:

```json
{
  "sleepStartedAt": "2026-07-28T21:45:00.000Z",
  "wakeRecordedAt": "2026-07-29T04:20:00.000Z",
  "isNewMainWake": true
}
```

The backend atomically:

1. Finalizes the previous active session with `closedBy: "NEW_WAKE"`.
2. Saves its final calculation and summary.
3. Starts a new active session at `wakeRecordedAt`.
4. Applies the appropriate work rotation.
5. Returns the new `sessionId` and live scores.

Replace the stored session ID with the returned `data.sessionId` and switch the realtime room to the new session.

## Quick Add creation

Continue using:

```http
PATCH /api/v1/calculator/session/:sessionId/log
Content-Type: application/json
Authorization: Bearer <token>
```

The endpoint can append one or multiple resource types in the same request:

```json
{
  "newWaterLogs": [
    {
      "occurredAt": "2026-07-28T13:42:00.000Z",
      "volumeMl": 500
    }
  ],
  "newCaffeineLogs": [
    {
      "occurredAt": "2026-07-28T12:20:00.000Z",
      "caffeineMg": 75,
      "drinkType": "espresso"
    }
  ],
  "newMealLogs": [
    {
      "order": 4,
      "occurredAt": "2026-07-28T10:00:00.000Z",
      "plannedAt": "2026-07-28T17:00:00.000Z",
      "heaviness": "medium"
    }
  ],
  "newSportSessions": [
    {
      "occurredAt": "2026-07-28T10:40:00.000Z",
      "durationMinutes": 45,
      "intensity": "medium",
      "sportType": "cardio",
      "distanceKm": 6.8,
      "heartRateAvgBpm": 142
    }
  ],
  "dailyMealTarget": 10,
  "fatigueLevel": "low"
}
```

Valid values:

- `drinkType`: `espresso`, `coffee`, `energy`, `tea`, `custom`
- `heaviness`: `light`, `medium`, `heavy`
- `intensity`: `low`, `medium`, `high`
- `sportType`: `cardio`, `strength`, `mobility`, `mixed`, `other`
- `fatigueLevel`: `low`, `average`, `high`
- `dailyMealTarget`: 1–10

The backend adds these fields to every entry:

```ts
interface QuickAddMetadata {
  id: string;
  occurredAt?: string;
  plannedAt?: string;
  createdAt: string;
  updatedAt: string;
}
```

Store each returned `id`. It is required for edit and delete.

Creation response data includes:

```ts
interface QuickLogResult {
  sessionId: string;
  message: string;
  entries: {
    hydration: HydrationEntry[];
    caffeine: CaffeineEntry[];
    meals: MealEntry[];
    workouts: WorkoutEntry[];
  };
  quickAddSummary: QuickAddSummary;
  liveScores: LiveScores | null;
}
```

After success, replace the relevant local entry arrays and score state with the returned data. Do not calculate totals or scores independently in the app.

## Editing Quick Add entries

Use the entry ID returned by Quick Add creation, score tabs, or session data.

| Resource | Endpoint |
| --- | --- |
| Hydration | `PATCH /api/v1/calculator/sessions/:sessionId/hydration/:entryId` |
| Caffeine | `PATCH /api/v1/calculator/sessions/:sessionId/caffeine/:entryId` |
| Meal | `PATCH /api/v1/calculator/sessions/:sessionId/meals/:entryId` |
| Workout | `PATCH /api/v1/calculator/sessions/:sessionId/workouts/:entryId` |

Only changed fields need to be sent.

Hydration example:

```json
{
  "occurredAt": "2026-07-29T00:30:00.000Z",
  "volumeMl": 750
}
```

Caffeine example:

```json
{
  "occurredAt": "2026-07-28T13:00:00.000Z",
  "caffeineMg": 120,
  "drinkType": "coffee"
}
```

Meal example:

```json
{
  "plannedAt": "2026-07-29T01:00:00.000Z",
  "heaviness": "heavy"
}
```

Workout example:

```json
{
  "occurredAt": "2026-07-29T00:40:00.000Z",
  "durationMinutes": 60,
  "intensity": "high",
  "distanceKm": 8.2,
  "heartRateAvgBpm": 150
}
```

Edit response data:

```ts
interface QuickAddMutationResult<T> {
  sessionId: string;
  resource: 'hydration' | 'caffeine' | 'meals' | 'workouts';
  action: 'update' | 'delete';
  entry: T;
  entries: T[];
  quickAddSummary: QuickAddSummary;
  liveScores: LiveScores | null;
}
```

Replace the local resource list with `data.entries`. This avoids stale ordering or totals.

## Deleting Quick Add entries

| Resource | Endpoint |
| --- | --- |
| Hydration | `DELETE /api/v1/calculator/sessions/:sessionId/hydration/:entryId` |
| Caffeine | `DELETE /api/v1/calculator/sessions/:sessionId/caffeine/:entryId` |
| Meal | `DELETE /api/v1/calculator/sessions/:sessionId/meals/:entryId` |
| Workout | `DELETE /api/v1/calculator/sessions/:sessionId/workouts/:entryId` |

No request body is required.

The response's `entry` is the deleted entry and `entries` contains the remaining entries. Workout deletion also removes its synchronized `SportSessionLog` record.

## Automatic recalculation

The backend automatically recalculates and broadcasts after:

- Sleep or wake correction
- Work change
- Quick Add creation
- Quick Add edit
- Quick Add deletion
- Work rotation or override change
- New-wake rollover
- End Day finalization

The app must not call `/calculate` after every mutation. Use the `liveScores`, `quickAddSummary`, and tab data returned by the mutation or realtime event.

## Reading scores and tabs

```http
GET /api/v1/calculator/session/:sessionId/scores
```

Final response layout:

```json
{
  "success": true,
  "message": "Success",
  "data": {
    "sessionId": "session-id",
    "ready": true,
    "liveScores": {
      "globalRhythmScore": 62,
      "cards": {},
      "warnings": [],
      "lifecycle": {},
      "quickAddSummary": {},
      "derived": {},
      "nextSleepWindow": {}
    },
    "tabs": {
      "sleep": {},
      "work": {},
      "hydration": {},
      "caffeine": {},
      "nutrition": {},
      "sport": {}
    }
  }
}
```

`tabs` appears once at `data.tabs`; it is not duplicated inside `data.liveScores`.

Important fields:

- `data.liveScores.lifecycle.status`
- `data.liveScores.lifecycle.startedAt`
- `data.liveScores.lifecycle.endedAt`
- `data.liveScores.lifecycle.wakeRecordedAt`
- `data.liveScores.lifecycle.closedBy`
- `data.tabs.<resource>.logs[*].id`
- `data.tabs.sport.sessions[*].id`
- `data.tabs.nutrition.sleepImpact`

Nutrition Sleep Impact always has a stable shape:

```ts
interface NutritionSleepImpact {
  status: string;
  note: string | null;
  severity: 'none' | 'low' | 'medium' | 'high';
  triggeringMealId: string | null;
  source: 'logged' | 'planned' | null;
  reason: string;
}
```

The nutrition card uses the configured daily meal target. For example, a target of 10 must display `1/10 planned`, not `1/3 planned`.

`optimalBedtime.hoursUntilBed` counts forward to the next circadian bedtime. A bedtime after midnight must remain a positive future countdown.

## End Day

Use the existing endpoint:

```http
POST /api/v1/calculator/session/:sessionId/end
Authorization: Bearer <token>
```

The backend:

1. Runs and saves the final calculation.
2. Saves an immutable final summary.
3. Sets `endedAt`.
4. Sets `closedBy: "MANUAL"`.
5. Changes the session to `FINALIZED`.
6. Does not create the next active session.

Expected response data includes:

```json
{
  "message": "Day finalized. The next day will start at the next main wake.",
  "calculation": {},
  "finalSummary": {},
  "nextDayPreparation": {
    "waitingForMainWake": true,
    "activeSessionCreated": false
  }
}
```

After success:

- Disable Quick Add/edit/delete immediately.
- Leave the old session realtime room.
- Show the waiting-for-main-wake state.
- On the next app open, call `GET /calculator/session` to obtain a pending session.

Never schedule End Day at midnight in the app.

## Realtime integration

Socket.IO namespace:

```text
/realtime
```

After receiving an active `sessionId`, emit:

```ts
socket.emit('join_session', { sessionId });
```

Listen for:

- `live_scores`: replace home scores, summaries, and tab data after mutations.
- `dashboard`: update dashboard-only data.
- `analytics`: final calculation/history update.
- `session_ended`: disable mutations and leave the session room.

When switching sessions:

```ts
socket.emit('leave_session', { sessionId: oldSessionId });
socket.emit('join_session', { sessionId: newSessionId });
```

HTTP mutation responses remain authoritative; realtime events keep other open screens/devices synchronized.

## Timestamp handling

Use absolute ISO timestamps everywhere:

```ts
const occurredAt = selectedDate.toISOString();
```

Rules:

- Preserve the date selected by the user, not only HH:MM.
- Send the ISO instant to the API.
- Render it in the user's configured timezone.
- Do not assign entries to a session using calendar date.
- Do not reset local state at midnight.
- Do not manually add or subtract timezone offsets.

An event at `01:30` after midnight still belongs to the active circadian session that began before midnight.

## Error and mutation handling

The app should handle these cases:

- Session finalized: stop editing and refresh the current session.
- Entry not found: refresh scores/session data; the entry may have been deleted on another device.
- Validation error: display the backend message and keep the edit form open.
- Network failure: retain the user's form data and allow retry.
- Duplicate wake submission: accept the returned existing session; do not create local duplicate days.

Do not optimistically invent entry IDs. Use the backend-generated ID from the successful response.

## Recommended app state shape

```ts
interface CalculatorState {
  sessionId: string | null;
  status: 'PENDING_WAKE' | 'ACTIVE' | 'FINALIZED' | null;
  waitingForMainWake: boolean;
  liveScores: LiveScores | null;
  tabs: CalculatorTabs | null;
  hydrationEntries: HydrationEntry[];
  caffeineEntries: CaffeineEntry[];
  mealEntries: MealEntry[];
  workoutEntries: WorkoutEntry[];
}
```

Use one mutation handler for all edit/delete responses:

```ts
function applyMutationResult(result: QuickAddMutationResult<unknown>) {
  replaceResourceEntries(result.resource, result.entries);
  setQuickAddSummary(result.quickAddSummary);
  if (result.liveScores) applyLiveScores(result.liveScores);
}
```

## App implementation checklist

- [ ] Keep the existing BEDTIME + WAKE-UP screen and `/sleep` endpoint.
- [ ] Send `sleepStartedAt` and `wakeRecordedAt` as ISO timestamps.
- [ ] Send hidden `isNewMainWake: true` only when logging a new main wake after forgetting End Day.
- [ ] Keep generic PATCH `/log` for Quick Add creation.
- [ ] Store every returned Quick Add entry ID.
- [ ] Add edit controls for hydration, caffeine, meals, and workouts.
- [ ] Add delete confirmation for each resource.
- [ ] Replace local resource arrays with mutation response `entries`.
- [ ] Apply returned/realtime scores instead of calculating them locally.
- [ ] Disable all mutations for `FINALIZED` sessions.
- [ ] Show waiting-for-wake UI after End Day.
- [ ] Never create or reset a session at midnight.
- [ ] Change realtime rooms when a new wake returns a new session ID.
- [ ] Render Nutrition Sleep Impact from its stable object.
- [ ] Verify the meal card uses `dailyMealTarget`.

## Required QA scenarios

1. Start a day from `PENDING_WAKE`.
2. Correct the current sleep without creating a new session.
3. Cross midnight while keeping the same active session.
4. Add all four Quick Add resource types.
5. Edit time and data for every resource type.
6. Delete every resource type and verify totals.
7. Edit/delete a workout and verify weekly sport data.
8. Press End Day and confirm no next active session is created.
9. Forget End Day, submit the next main wake, and confirm rollover.
10. Retry the same wake request and confirm idempotency.
11. Attempt mutation after finalization and confirm rejection.
12. Test a heavy meal near sleep across midnight.
13. Test a planned meal and missing bedtime.
14. Change rotation/override while a session is active.
15. Verify no zero-minute phantom workout appears beside a real workout.
16. Verify `tabs` occurs once in the score response.
17. Verify a custom meal target such as 10 displays consistently.
18. Verify bedtime after midnight has a positive future countdown.
