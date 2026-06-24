# Venue Project Init Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make ParkWith runnable as Flutter + NestJS and implement the first seed-backed venue slice.

**Architecture:** Keep generated project scaffolding separate from handcrafted feature code. API serves seed-backed venues through a `venues` module; mobile renders venues through `data`, `domain`, and `presentation` layers using local seed data first.

**Tech Stack:** Flutter, Dart widget tests, NestJS 10, Jest, TypeScript.

---

### Task 1: Tooling And Scaffold Verification

**Files:**
- Modify: `apps/mobile/pubspec.yaml`
- Modify: `apps/api/package.json`
- Generated: Flutter platform folders under `apps/mobile/`
- Generated: dependency lockfiles

- [ ] **Step 1: Verify local tooling**

Run:

```powershell
flutter --version
flutter doctor
node --version
npm --version
```

Expected: Flutter and Node commands are available. If `flutter doctor` reports a setup problem, capture the exact issue before changing files.

- [ ] **Step 2: Generate Flutter project safely**

Generate Flutter scaffold into a temporary directory, then copy platform/config files into `apps/mobile` without replacing `apps/mobile/lib`.

Run:

```powershell
flutter create --project-name parkwith_mobile --org com.parkwith C:\tmp\parkwith_mobile_generated
```

Copy only generated platform folders and required root files that do not conflict with the existing architecture.

- [ ] **Step 3: Install NestJS dependencies**

Run:

```powershell
npm install
```

Expected: `apps/api/package-lock.json` is created and `node_modules` installs successfully.

### Task 2: API Venue Slice

**Files:**
- Create: `apps/api/src/modules/venues/entities/venue.entity.ts`
- Create: `apps/api/src/modules/venues/dto/venue-response.dto.ts`
- Create: `apps/api/src/modules/venues/venues.seed.ts`
- Create: `apps/api/src/modules/venues/venues.repository.ts`
- Create: `apps/api/src/modules/venues/venues.service.ts`
- Create: `apps/api/src/modules/venues/venues.controller.ts`
- Create: `apps/api/src/modules/venues/venues.module.ts`
- Create: `apps/api/src/modules/venues/venues.service.spec.ts`
- Modify: `apps/api/src/app.module.ts`

- [ ] **Step 1: Write failing service test**

Create a Jest test that expects `VenuesService.listVenues()` to return eight seed venues and include `Caribbean Bay`.

Run:

```powershell
npm test -- venues.service.spec.ts
```

Expected: FAIL because the venue service does not exist yet.

- [ ] **Step 2: Implement seed-backed service**

Add the venue entity type, seed array, repository, and service. Keep all data in memory for MVP initialization.

- [ ] **Step 3: Add controller and module**

Expose `GET /venues` with the shared API envelope:

```json
{
  "success": true,
  "data": [],
  "error": null
}
```

Import `VenuesModule` in `AppModule`.

- [ ] **Step 4: Verify API**

Run:

```powershell
npm test -- venues.service.spec.ts
npm run build
```

Expected: test and build exit with code 0.

### Task 3: Mobile Venue Slice

**Files:**
- Create: `apps/mobile/test/features/venue/presentation/venue_list_screen_test.dart`
- Create: `apps/mobile/lib/features/venue/domain/venue.dart`
- Create: `apps/mobile/lib/features/venue/domain/venue_repository.dart`
- Create: `apps/mobile/lib/features/venue/domain/use_cases/list_venues.dart`
- Create: `apps/mobile/lib/features/venue/data/venue_dto.dart`
- Create: `apps/mobile/lib/features/venue/data/venue_seed_data.dart`
- Create: `apps/mobile/lib/features/venue/data/seed_venue_repository.dart`
- Create: `apps/mobile/lib/features/venue/presentation/venue_list_screen.dart`
- Modify: `apps/mobile/lib/app/app.dart`

- [ ] **Step 1: Write failing widget test**

Create a widget test that pumps `VenueListScreen` with a seed repository and expects `Caribbean Bay` and `Everland`.

Run:

```powershell
flutter test test/features/venue/presentation/venue_list_screen_test.dart
```

Expected: FAIL because the screen and domain types do not exist yet.

- [ ] **Step 2: Implement minimal domain and data layer**

Add the venue model, repository interface, use case, DTO, seed data, and seed repository. Keep file responsibilities small.

- [ ] **Step 3: Implement minimal presentation layer**

Add `VenueListScreen` with a loading state, error state, and seeded venue list. Wire it as the app home.

- [ ] **Step 4: Verify mobile**

Run:

```powershell
flutter test test/features/venue/presentation/venue_list_screen_test.dart
flutter analyze
```

Expected: test and analyze exit with code 0.

### Task 4: Contract And Final Verification

**Files:**
- Modify: `packages/contracts/openapi.yaml`
- Modify only if needed: `README.md` or feature README files

- [ ] **Step 1: Update OpenAPI venue response shape**

Document the `GET /venues` response envelope and venue fields.

- [ ] **Step 2: Run final verification**

Run:

```powershell
npm run build
flutter test
flutter analyze
```

Expected: all commands exit with code 0. If a command cannot run because of local tooling, record the exact blocker.

