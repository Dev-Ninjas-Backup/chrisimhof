# RYVENZA — B2B Enterprise Licensing & Microsoft SSO Specification

> **Document Version**: 1.0  
> **Date**: October 2026  
> **Status**: Architecture Specification & Future Scope Roadmap  
> **Applies to**: Mobile App (Flutter), Backend API (Node.js/Go/Python), and Admin/HR Web Dashboard  

---

## 1. Context & Executive Summary

The client (Chris) is preparing meetings with enterprise prospects (e.g., **Syngenta**) to sell bulk enterprise contracts (e.g., 500–1,000 corporate licenses). 
This document captures:
1. The client's original questions and requirements.
2. The recommended response for client enterprise discussions.
3. The exact technical requirements for the **Backend**, **Admin / HR Dashboard**, and **Flutter Mobile App** when this feature is greenlit.

---

## 2. Client Inquiries (From `client-message2.txt`)

> *"I have a few questions about how we could manage B2B subscriptions and company licences in RYVENZA. I'm asking because I have meetings with companies, and I'd like to be able to explain how the system could work:*
> 1. *Can we have two separate systems: B2C through Apple/Google and B2B through company contracts?*
> 2. *Could employees log in using their professional Microsoft accounts (Entra ID/SSO)?*
> 3. *Could RYVENZA automatically identify their company and grant Premium access?*
> 4. *Can we limit the number of assigned licences per company (e.g. 500 or 1,000)?*
> 5. *Could licences be automatically released when employees leave or delete their accounts?*
> 6. *Could everything be managed through our admin dashboard without displaying employees' personal information?*
> 7. *What would you recommend technically? Are there any limitations or better alternatives?"*

---

## 3. Client Meeting Talking Points (Executive Briefing)

* **Dual-Track Revenue (B2C + B2B)**: Fully allowed under Apple App Store Review Guideline 3.1.3(c) (*Multi-User / Enterprise Services*). Enterprise clients pay via direct corporate invoicing/bank transfer (**0% Apple/Google cut**), while individual consumers pay via in-app purchases.
* **Microsoft Entra ID (SSO)**: Microsoft Sign-In is already active in the RYVENZA mobile app. Corporate employees log in seamlessly with corporate credentials.
* **Automatic Seat Allocation**: The backend inspects the authenticated email domain (e.g., `@syngenta.com`) or Azure Tenant ID and activates Premium instantly.
* **Hard/Soft Quotas**: Once the purchased seat limit is reached (e.g. 500/500), new sign-ins receive a graceful notification to contact their HR administrator (driving contract upsells).
* **Seat Recycling**: Licenses return to the pool upon account deletion or 60/90 days of inactivity.
* **Strict GDPR & Worker Privacy**: Employers can see aggregated engagement metrics (e.g., *78% adoption rate*), but **never individual employee sleep, caffeine, or circadian records**.
* **Account Portability**: When an employee leaves the company, their circadian history remains with them; the account simply reverts to the Free tier.

---

## 4. Technical Architecture: Backend & Database Requirements (~75% of Effort)

### 4.1 Database Schemas

#### 1. `companies` Table
```sql
CREATE TABLE companies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,                    -- e.g. 'Syngenta'
    domain VARCHAR(255) NOT NULL UNIQUE,          -- e.g. 'syngenta.com'
    tenant_id VARCHAR(255),                       -- Optional: Microsoft Azure Tenant ID
    total_licenses INT NOT NULL DEFAULT 0,         -- e.g. 500
    active_licenses INT NOT NULL DEFAULT 0,        -- Current assigned count
    contract_start_date TIMESTAMP WITH TIME ZONE,
    contract_end_date TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN DEFAULT TRUE,
    inactivity_reclaim_days INT DEFAULT 60,       -- Auto-release after X inactive days
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### 2. `company_licenses` Table
```sql
CREATE TABLE company_licenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_active_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    status VARCHAR(50) DEFAULT 'ACTIVE',          -- 'ACTIVE', 'REVOKED', 'INACTIVE'
    UNIQUE(company_id, user_id)
);
```

#### 3. `users` Table Extension
```sql
ALTER TABLE users ADD COLUMN subscription_type VARCHAR(50) DEFAULT 'B2C'; -- 'B2C' or 'B2B'
ALTER TABLE users ADD COLUMN company_id UUID REFERENCES companies(id);
ALTER TABLE users ADD COLUMN is_premium BOOLEAN DEFAULT FALSE;
```

---

### 4.2 Backend Business Logic & APIs

#### 1. Enhanced Microsoft Sign-In Endpoint (`POST /api/v1/auth/microsoft`)
When Microsoft authentication succeeds with email (e.g., `alice@syngenta.com`):
1. Extract email domain: `syngenta.com`.
2. Lookup in `companies` table where `domain = 'syngenta.com'` and `is_active = true`.
3. If company found:
   - Check if user already holds an active license $\rightarrow$ Refresh `last_active_at`, set `is_premium = true`.
   - If user does not have a license:
     - Check `active_licenses < total_licenses`.
     - **If seats available**: Insert into `company_licenses`, increment `active_licenses` by 1, set `user.is_premium = true`.
     - **If quota exceeded (500/500)**: Return `200 OK` but with flag:
       ```json
       {
         "user": { ... },
         "isPremium": false,
         "b2bStatus": {
           "companyName": "Syngenta",
           "licenseAvailable": false,
           "message": "All corporate licenses are currently in use."
         }
       }
       ```
4. If no company contract matches domain $\rightarrow$ Proceed with normal Free/B2C user flow.

#### 2. License Inactivity Cron Job (Scheduled Nightly)
```text
Cron: 0 2 * * * (Run daily at 2:00 AM UTC)
Logic: 
  Find all company_licenses where last_active_at < NOW() - INTERVAL '60 days'.
  Update status to 'INACTIVE'.
  Decrement company.active_licenses.
  Set user.is_premium = false.
```

---

## 5. Admin / HR Web Dashboard Requirements (~15% of Effort)

The web portal enables Chris and client HR managers to oversee enterprise accounts.

### 5.1 Company Management Views
* **Add / Edit Company**: Set Company Name, Allowed Domain (`syngenta.com`), Contract Term, Total Licenses (`500`).
* **License Utilization Gauges**:
  * Visual progress bar: `420 / 500 Seats Allocated (84% Adoption)`.
  * Status indicator: `Active`, `Expiring in 30 Days`, `Over Quota`.

### 5.2 Privacy & GDPR Safeguards
* **Zero Health Data Exposure**:
  * The dashboard must **never** show sleep times, caffeine consumption, hydration data, or heart rate.
  * The HR roster only displays:
    * Anonymized identifier or User Name.
    * Date joined / License allocated date.
    * Last active timestamp (e.g., `2026-10-10`).
    * Revoke / Reassign action button.

---

## 6. Mobile App (Flutter) Changes Required (~10% of Effort)

The mobile foundation is already in place. Only minor UI handling and state checks are needed:

### 6.1 What is Already Done
* **Microsoft Authentication**: Already fully integrated in [`MicrosoftAuthService`](lib/features/auth/microsoft_signin/service/microsoft_auth_service.dart) via `flutter_appauth`.
* **Token Delivery**: Passes authorization to backend endpoint `/api/v1/auth/microsoft`.

### 6.2 Mobile Changes to Implement in the Future

#### 1. Quota Exceeded Dialog
In [`SignInController`](lib/features/auth/sign_in/controller/sign_in_controller.dart):
When the backend returns `licenseAvailable == false`:
```dart
Get.dialog(
  AlertDialog(
    title: Text('Corporate Licenses Full'),
    content: Text(
      'All enterprise licenses for ${response.b2bStatus.companyName} are currently in use. '
      'Please contact your HR administrator to request additional access.',
    ),
    actions: [
      TextButton(
        onPressed: () => Get.back(),
        child: Text('Continue as Free User'),
      ),
    ],
  ),
);
```

#### 2. Plan Badge in Profile / Settings
* Normal user: `Plan: Premium (Personal)`
* B2B user: `Plan: Enterprise (Syngenta)`

#### 3. Expired License Fallback Notification
If a user was on a corporate plan that expired or was revoked:
* Show a non-intrusive toast or banner:
  > *"Your company subscription has ended. Your circadian profile and history are preserved. You are now on the Free plan."*

---

## 7. App Store & Legal Compliance Summary

| Requirement | Apple / Google Guideline | RYVENZA Compliance Approach |
| :--- | :--- | :--- |
| **B2B Billing Outside Stores** | Apple Guideline 3.1.3(c) *Enterprise Services* | Allowed because contracts are multi-user corporate licenses sold directly to businesses. |
| **B2C Purchases** | Apple Guideline 3.1.1 *In-App Purchases* | Handled via StoreKit / Google Play Billing (or RevenueCat wrapper). |
| **Health Data Privacy** | GDPR / Swiss FADP / HIPAA principles | Health data is encrypted and strictly isolated from the employer dashboard. |
| **Data Retention on Departure** | GDPR Right to Data Portability | Employees retain full ownership of their personal circadian tracking history. |

---

## 8. Development Effort Estimate

| Component | Scope | Estimated Effort |
| :--- | :--- | :---: |
| **Backend API & Database** | Tables, domain routing, quota logic, cron job | 2–3 Days |
| **HR / Admin Web Portal** | Company setup, license counters, seat revocation | 2–3 Days |
| **Flutter Mobile App** | Quota popup, enterprise badge, fallback message | 0.5–1 Day |
| **Total Turnaround** | Full B2B enterprise capabilities | **~1 Sprint (1–1.5 Weeks)** |
