# RYVENZA — Future Scope & Next Development Phase

This document consolidates the agreed feature roadmap and architectural enhancements planned for the next development phase following the current beta stabilization.

---

## Roadmap Summary Table

| # | Topic | Area | Source | Objective & High-Level Scope |
|---|---|---|---|---|
| **1** | **Sport — Weekly Objective & Adaptive Rest** | Fitness & Recovery | Client Roadmap | Allow users to define weekly training targets; calculate adaptive rest day recommendations based on completed workouts, recovery score, and remaining days. |
| **2** | **Advanced Nap Management** | Sleep Engine | Client Roadmap | Distinguish between primary overnight sleep and daytime naps; factor naps into recovery scores without creating, closing, or resetting the circadian day session. |
| **3** | **Dynamic Caffeine Influence** | Metabolic Calculation | Client Roadmap | Ensure caffeine quantity and timing actively shift sleep recommendations and circadian windows in real time upon create, edit, or delete. |
| **4** | **Active Profile & Baseline Influence** | Personalization | Client Roadmap | Utilize stored profile parameters (chronotype, sleep targets, sport goals) as active inputs for calculations and advice rather than static storage. |
| **5** | **Named Custom Work Schedules & Auto-Progression** | Work Schedule | Client Feedback (#4) | Allow users to assign custom names (e.g. *"Syngenta"*) to custom work rotations, display by name in shift options, and maintain calendar auto-progression. |
| **6** | **Persistent Default Daily Meal Goal** | Nutrition Feature | Client Feedback (#9) | Allow users to set and persist their preferred default daily meal count (e.g., 5 meals) with *"Save as default"* so it does not reset to 3 each day. |
| **7** | **Multi-Day / Date Range Overrides** | Work Schedule | Technical Audit | Add a date range picker / batch apply tool to set shift overrides (e.g., vacation, sick leave, block shifts) across multiple days in a single action. |
| **8** | **Account Deletion Safeguards** | Security & Auth | Technical Audit | Require current password re-confirmation before executing permanent account deletion to prevent accidental or unauthorized data loss. |
| **9** | **12-Hour vs. 24-Hour Time Format Support** | UI / Localization | Technical Audit | Provide automatic device-locale detection and an explicit Settings toggle for 12h (AM/PM) and 24h military time formats. |

---

## Detailed Specifications

---

### Part I: Advanced Algorithmic & Personalization Capabilities (Client Roadmap)

#### 1. Sport — Weekly Objective & Adaptive Rest
* **Background & Goal**:
  Currently, workouts are logged and tracked on a day-to-day basis. Users should be able to define a weekly training frequency target (e.g., 3, 4, or 5 workouts per week).
* **Proposed Logic & Behavior**:
  * **Weekly Goal Tracking**: The system evaluates total workouts completed against the weekly target and remaining days in the rotation/week.
  * **Adaptive Rest Recommendation**: If a user is on track with their weekly target and exhibits low recovery or elevated sleep debt, RYVENZA will proactively recommend a rest day or active recovery session (e.g., mobility/stretching) with the confidence that their weekly target will not be compromised.
  * **Intelligent Catch-Up Warning**: If days are running out to meet the weekly target, the recommendation engine advises prioritizing a workout session when physical readiness permits.

#### 2. Advanced Nap Management
* **Background & Goal**:
  Shift workers frequently rely on daytime power naps or pre-shift naps. Currently, logging sleep can risk closing the active session or triggering session rollover prematurely if not carefully separated.
* **Proposed Logic & Behavior**:
  * **Explicit Classification**: Clearly separate "Main Sleep" (anchor sleep that transitions the circadian day) from "Naps / Recovery Sleep".
  * **Zero Day Reset on Naps**: Logging a nap must influence recovery load, alertness curves, and daily energy scores, but must **never** close, reset, or advance the active circadian day session (`sessionId`).
  * **Deficit Mitigation**: Nap duration should actively reduce acute sleep debt for the upcoming shift while leaving main bedtime algorithms intact.

#### 3. Dynamic Caffeine Influence
* **Background & Goal**:
  Caffeine is a critical tool for shift workers, but late intake impairs sleep latency and sleep architecture.
* **Proposed Logic & Behavior**:
  * **Metabolic Half-Life Modeling**: Model caffeine decay based on total milligrams and intake timestamp (e.g., 5–7 hour half-life curve).
  * **Real-Time Recalculation**: When a caffeine entry is added, edited, or deleted, the backend and frontend dynamically update:
    * The caffeine cut-off threshold.
    * The recommended bedtime (shifting bedtime if active caffeine in the system exceeds tolerance at the scheduled sleep time).
    * Dynamic recommendation advice across the Dashboard and Sleep cards.

#### 4. Active Profile & Baseline Parameter Integration
* **Background & Goal**:
  Personal baseline parameters collected during onboarding (sleep targets, chronotype, activity baseline, work profile) are currently stored, but should directly drive algorithmic decisions.
* **Proposed Logic & Behavior**:
  * **Chronotype Alignment**: Early birds (morning chronotypes) vs. night owls (evening chronotypes) should have distinct baseline circadian phase curves, influencing optimal meal timing, energy peaks, and alertness forecasts.
  * **Personalized Sleep Targets**: Use the individual's specific baseline target (e.g., 7h 45m or 8h 15m) rather than generalized 8-hour assumptions when computing sleep deficit and recovery pacing.
  * **Sport Profile Adaptation**: Adjust daily recovery thresholds based on whether the user's sport profile is sedentary, moderate, strength-focused, or endurance-focused.

---

### Part II: Custom Work & Nutrition Capabilities (Client Items #4 & #9)

#### 5. Named Custom Work Schedules & Cycle Auto-Progression (Item #4)
* **Background & Goal**:
  Users want to create custom rotation schedules specific to their workplace (e.g., *"Syngenta"*, *"Novartis 3x8"*, *"Hospital Shift B"*) and see them listed by name alongside standard templates.
* **Proposed Logic & Behavior**:
  * **Custom Rotation Naming**: Add a user-defined `name` field to custom rotation creation and persistence (`CustomRotationPrefs` / backend rotation schema).
  * **Template Integration**: Display the saved custom rotation prominently in the Work Schedule selection screen under its user-assigned name instead of defaulting to *"None"*.
  * **Continuous Auto-Progression**: Confirm and ensure mathematically that once activated:
    $$\text{Pattern Index} = (\text{Current Date} - \text{Start Date})_{\text{days}} \pmod{7 \times \text{Cycle Weeks}}$$
    The rotation automatically calculates the correct active shift for any future date, maintaining continuous synchronization without requiring daily logins.

#### 6. Persistent Default Daily Meal Goal (Item #9)
* **Background & Goal**:
  Users who follow a specific nutrition regimen (e.g., 4 or 5 meals/snacks per day) have to manually re-adjust their meal target each day because it resets to the standard default of 3 upon day rollover.
* **Proposed Logic & Behavior**:
  * **"Save as Default" Option**: Add a *"Save as default"* checkbox or toggle in the meal target adjustment bottom sheet / screen (`MealTiming` / `NutritionController`).
  * **Persistent Storage**: Save the preferred default target in `SharedPreferencesHelper.defaultDailyMealTarget`.
  * **Automatic Initialization**: When a new day session initializes (via "End My Day" or main sleep rollover), the app sets the new day's initial meal target to the user's saved default instead of reverting to 3.

---

### Part III: Usability, Security & Localization Enhancements (Technical Audit)

#### 7. Multi-Day / Date Range Overrides (Work Schedule)
* **Current State**:
  In the upcoming work schedule, shift overrides can only be applied day by day. If an employee takes a 1-week vacation, sick leave, or block of night shifts, they must tap and configure each calendar day individually.
* **Proposed Solution**:
  * Implement a multi-day range selector in `work_schedule_settings_screen.dart` (e.g., *"Set 'Off' from Oct 10 to Oct 17"* or *"Batch Apply Night Shift"*).
  * Enable employees to configure leaves, holiday blocks, or custom rotations with a single confirmation.

#### 8. Account Deletion Safeguards
* **Current State**:
  In `delete_account_screen.dart`, permanent account deletion executes immediately upon tapping the button once checkboxes are marked.
* **Proposed Solution**:
  * Introduce an authentication re-prompt requiring the user to re-enter their current password before triggering the permanent account purge.
  * Protects against accidental clicks, unauthorized access on shared devices, and compliance concerns.

#### 9. 12-Hour vs. 24-Hour Time Format Support
* **Current State**:
  Time pickers, timelines, and time displays across the app are hardcoded to the 24-hour military format (`22:30`, `06:00`).
* **Proposed Solution**:
  * Add automatic detection based on device locale settings (e.g., standard 12-hour format with AM/PM for `en_US` / UK locales, 24-hour format for `fr_FR` / continental Europe).
  * Provide an explicit toggle in Settings allowing users to customize their preferred display format regardless of locale.

---

## Next Steps & Phase Transition

1. **Current Phase**: Finalize and lock down the current functional beta (verification of existing endpoints, Quick-Add stability, translation completeness, and presentation readiness).
2. **Next Phase**: Schedule technical planning and implementation for the 9 items detailed above.
