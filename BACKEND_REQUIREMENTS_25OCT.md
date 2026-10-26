# RYVENZA Backend Review & Action Items (25-10-2026 Review)
**Target**: Backend API & Recommendation Engine (`api.ryvenza.app`)  
**Context**: Review by Christian Imhof regarding sleep recommendations, shift transitions, and timezone handling.

---

## Summary of Points Requiring Backend Action

| Point | Title | Affected Endpoints | Summary of Backend Fix |
|---|---|---|---|
| **Point 02** | **Use actual next shift for sleep window** | `GET /api/v1/calculator/optimal-bedtime`<br>`GET /api/v1/dashboard`<br>`GET /api/v1/calculator/session` | When a user is on a Day Off, the bedtime recommendation engine must look ahead in the user's work rotation calendar to find their actual next non-off shift, instead of assuming standard morning shift (`06:00`). |
| **Point 03** | **Excessive awake time (>22h) during shift transitions** | Circadian Calculation Engine<br>`optimalBedtime`<br>`hoursUntilBed` | Fix algorithm to cap maximum continuous awake time (max 16–17h). When transitioning from a Day Off into a Night Shift, suggest a transition sleep (e.g. around 01:00) or an intermediate sleep/nap protocol rather than keeping the user awake for 22.5 to 25 hours. |
| **Point 07** | **Timezone & Daylight Saving Time (DST) Synchronisation** | `PUT /api/v1/calculator/work-settings`<br>All circadian & history queries | Ensure the backend adjusts calculation windows dynamically upon receiving updated timezone strings (e.g. `Europe/Zurich` during DST transitions), maintaining exact local time consistency. |

---

## 1. Point 02: Use Actual Next Shift for the Sleep Window

### The Issue
* **Christian's Report**: On Sunday (Day Off), Christian finished his morning shifts and was resuming night shifts on Monday/Tuesday. However, the system assumed a shift at `06:00` and recommended sleeping `20:45 – 04:30`.
* **Root Cause in Backend**:
  * The backend sleep recommendation engine does not query the user's active custom rotation calendar (`/api/v1/calculator/work-rotation/calendar`) when determining the upcoming shift buffer.
  * When today is `shiftType: "off"`, the calculation falls back to default morning hours (`06:00`).

### Backend Action Required
1. **Calendar Lookahead**:
   * When evaluating the upcoming shift for sleep recommendations, inspect the user's calendar schedule starting from `today` forward.
   * If today is `off`, find the **first upcoming non-off day** in the calendar (e.g. tomorrow night at `22:00`).
2. **Include in API Response**:
   * In `GET /api/v1/calculator/session/$sessionId/sleep` and `GET /api/v1/dashboard`, return explicit fields:
     ```json
     {
       "nextShiftStart": "22:00",
       "nextShiftType": "night",
       "nextShiftDate": "2026-10-26",
       "isDayOffToday": true
     }
     ```
   * Do not default `nextShiftStart` to `06:00` when the user has no morning shift scheduled.

---

## 2. Point 03: Bedtime Calculation & Transitions to Night Shifts (CRITICAL)

### The Issue
* **Christian's Concrete Test Case**:
  * **Sunday 25 October, 09:07 AM** (Woke up at 08:00 AM on a Day Off).
  * **Home Card Displayed**:
    * `HEURE DE COUCHER OPTIMALE`: **06:30**
    * `Countdown`: **dans 21h 23m** (which points to 06:30 AM Monday morning).
  * **Implied Time Awake**:
    * Wake up Sunday at 08:00 ➔ Bedtime Monday at 06:30 ➔ **22 hours 30 minutes awake continuously!**
    * If Christian had woken up at 05:00, the implied awake time would be **25 hours**.
* **Root Cause**:
  * The backend circadian engine rigidly aligns the sleep window to the upcoming night shift (suggesting the user sleep in the morning/afternoon right before the night shift).
  * However, it completely disregards **when the user last woke up** and **how long they will have been awake**.

### Scientific & Practical Requirement
Humans cannot safely remain awake for 22.5 to 25 hours before starting a night shift. The backend must implement a **progressive transition protocol**:

1. **Cap Maximum Awake Duration**:
   * No recommended bedtime should exceed **16 to 17 hours** from the user's last recorded wake-up timestamp.
2. **Transition Protocol from Day Off / Morning to Night Shift**:
   * Instead of telling the user to stay awake all through Sunday night until 06:30 Monday morning:
     * **Option A (Intermediate / Anchor Sleep)**: Suggest an intermediate sleep Sunday night (e.g., bedtime around `01:00` or `00:30`, waking up around `08:00` or `09:00`), followed by a pre-shift afternoon nap before the night shift.
     * **Option B (Progressive Delay)**: Suggest sleeping Sunday night at a delayed hour (e.g. `02:00 – 10:00`) to gradually shift the circadian phase.
3. **Dynamic Recalculation Based on Actual Logged Sleep**:
   * When a user logs a sleep (e.g., wake-up logged at `08:00`), immediately recalculate `optimalBedtime` using `lastSleepEnd + safeWakefulnessLimit`.
   * If the user deviates from the proposed schedule, the engine must adapt from their *actual* state, not the theoretical one.
4. **Consistency**:
   * Ensure `optimalBedtime` in `GET /api/v1/dashboard` matches the sleep window returned in `GET /api/v1/calculator/optimal-bedtime`.

---

## 3. Point 07: Timezone and Daylight Saving Time (DST) Synchronisation

### The Issue
* Christian noted: *"Check that the correct local times are consistently used in the work schedule, sleep recommendations and history."*
* The app already detects phone timezone changes (via `flutter_timezone`) and sends the local timezone string to:
  `PUT /api/v1/calculator/work-settings` with `{ "timezone": "<iana_timezone>" }` (e.g. `Europe/Zurich`).
* In addition, the mobile app now triggers this synchronization automatically whenever the app is resumed from background.

### Backend Action Required
1. **Timezone Storage & Verification**:
   * Confirm that when the backend receives `timezone: "Europe/Zurich"`, it stores this on the user's active session and work rotation.
2. **DST / Daylight Saving Offset Handling**:
   * Ensure the backend uses an IANA timezone library (such as Moment-Timezone, date-fns-tz, or Luxon) rather than a fixed hour offset (e.g. `UTC+1` vs `UTC+2`).
   * When clocks change (such as the end of Daylight Saving Time in late October in Europe), shift start times (e.g. `06:00` or `22:00`) must remain strictly at `06:00` and `22:00` local time, and not shift by ±1 hour.
3. **True UTC Conversion**:
   * Confirm all event timestamps (`occurredAt`, `start`, `end`) stored in UTC are converted to/from the user's active profile timezone accurately.

---

## Summary of Completed Frontend Updates (For Reference)

The following frontend fixes corresponding to this review have already been implemented and validated in the Flutter app:
1. **Point 01 (Display Saved Rotation Name)**: Fixed display logic so active custom rotation displays its user-assigned name (« Syngenta ») instead of falling back to « Personnalisé ».
2. **Point 02 (Frontend Fallback)**: Sleep screen now inspects the rotation calendar rather than defaulting to morning `06:00` when on a day off.
3. **Point 04 (Explicit Sleep Action)**: Updated button text to always say **« Enregistrez votre dernier sommeil »** (`"Log your last sleep"`).
4. **Point 05 (Card Height & Spacing)**: Reduced BedtimeCard height to 175px, scaled character mascot to 135px with proportional margins, eliminating excessive blank space.
5. **Point 06 (Timeline Translation)**: Replaced hardcoded English string « Main Sleep » with localized **« Sommeil principal »** / **« Sieste »** and localized all meal/caffeine labels.
6. **Point 07 (App Lifecycle Timezone Listener)**: Added `WidgetsBindingObserver` to re-sync device timezone silently every time the app is brought to foreground.
