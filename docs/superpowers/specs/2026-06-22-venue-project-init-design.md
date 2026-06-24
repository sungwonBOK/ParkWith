# Venue Project Init Design

## Goal

Turn the ParkWith skeleton into a runnable Flutter + NestJS baseline and prepare the first MVP venue slice.

## Approved Scope

- Initialize the Flutter app structure without overwriting existing `lib/` feature architecture.
- Install and verify NestJS dependencies.
- Add a seed-backed `GET /venues` API.
- Add a mobile venue list entry screen that can render venue seed data through the feature layers.
- Do not add database persistence, auth, map SDK integration, admin tooling, crawling, or location sharing in this slice.

## Architecture

The API owns the authoritative initial venue seed data for this slice. `venues` stays in `apps/api/src/modules/venues/` with a module, controller, service, repository, DTO, and entity type.

The Flutter app keeps the existing `data`, `domain`, and `presentation` split under `apps/mobile/lib/features/venue/`. The first screen uses a repository interface and local seed implementation so mobile can be verified even before HTTP wiring is introduced.

## Data Shape

Each venue contains:

- `id`
- `name`
- `category`: `water_park` or `amusement_park`
- `region`
- `description`

The initial list contains the MVP venues from the handoff:

- Caribbean Bay
- Ocean World
- Lotte Water Park
- Woongjin Play Doci Waterdoci
- Everland
- Lotte World Adventure Seoul
- Lotte World Adventure Busan
- Gyeongju World

## Testing

- API: unit tests for venue service list behavior and response envelope.
- Mobile: widget test for the venue list screen rendering seeded venue names.
- Project verification: `npm run build` in `apps/api`; `flutter analyze` and `flutter test` in `apps/mobile`.

