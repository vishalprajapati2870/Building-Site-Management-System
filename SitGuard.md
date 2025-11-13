# SiteGuard – Project Overview

## Tech Stack
- Flutter (Material 3) for the client UI on mobile and desktop
- Firebase Authentication for email/password sign-in
- (Planned) Firebase Cloud Firestore for persistent storage – currently mocked locally for rapid prototyping

## Roles & Demo Credentials
- Owner: `owner@demo.com` / `password`
- Worker 1: `worker@demo.com` / `password`
- Worker 2: `worker2@demo.com` / `password`
- Worker 3: `worker3@demo.com` / `password`

> The mock data generated in `lib/globals/demo_data.dart` keeps user identifiers consistent across auth, assignments, and profile views so that worker screens are populated immediately after login.

## Application Flow

- **Entry** – `HomePage` ➜ `LoginPage`
- **Owner Journey**
  - Successful login routes to `OwnerDashboardPage`
  - Dashboard seeds demo construction sites, workers, assignments, and time logs through `DataProvider.initializeMockData`
  - Owner can review KPIs, drill into `SiteDetailsPage`, create new sites via `AddSitePage`, and assign workers using `AssignWorkerDialog`
- **Worker Journey**
  - Successful login routes to `WorkerHomePage`
  - Bottom navigation exposes three tabs:
    - **Assignments** – populated from `DataProvider.getTodayAssignments` with live cards (`AssignmentCard`) that link to `CheckInPage`
    - **History** – displays validated check-in/out events from `DataProvider.timeLogs`
    - **Profile** – shows real worker information (name, email, skills, hourly rate) sourced from `AuthProvider.currentUser`

## Recent Fixes
- Centralised mock data in `DemoData` so Auth and Data providers share the same user IDs
- Updated `AuthProvider.signIn` to validate against demo credentials, seed data consistently, and surface clear error messaging
- Refreshed login helper text so test accounts match the demo data
- Ensured worker profile content shows real user details instead of placeholder “Demo User” values

## Known Gaps / Next Steps
- Replace the mock providers with Firebase-backed repositories (Firestore + Cloud Functions)
- Add profile editing for workers (contact info, password reset, skill updates)
- Connect assignments and time logs to real-time listeners for multi-user sync
- Harden validation on owner flows (duplicate assignment windows, worker availability clashes)

For quick smoke tests, log in as the owner, assign a shift to any worker, then sign in as that worker to confirm the assignment appears under the **Assignments** tab and the profile tab reflects the worker’s skills and hourly rate.
