# Location And Battery Reference

Use this reference when changing location sharing, location collection, battery saver behavior, or visit-session location lifecycle.

## Permission Timing

- Do not request location permission on app launch.
- Request location permission only after the user starts a visit session and turns on location sharing.
- Facility maps must remain usable in a limited form without location permission.

## Sharing Defaults

- Location sharing defaults to `off`.
- The user must explicitly turn it on.
- Visit end must move sharing to `stopped` and stop upload/streaming work.
- MVP stores only each user's latest location snapshot, not a movement history.

## Update Policy

| Situation | Behavior |
| --- | --- |
| Before visit | No sharing |
| Visit not started | No permission request |
| User opts in during active visit | Start sharing |
| Map visible | 10-30 second updates |
| Map not visible | Slower updates or last known location |
| Finding friends mode | Faster updates for a limited time only |
| Battery at or below 20% | Battery saver behavior |
| Visit ended | Stop sharing and expire location |

Do not use 5-second-or-faster fixed interval uploads as the default.

## Architecture

- Keep shared collection abstractions in `apps/mobile/lib/core/location_engine`.
- Keep trip-room sharing behavior in `apps/mobile/lib/features/location_sharing`.
- Native Android/iOS optimization may be added behind `core/location_engine`; do not rewrite the whole app as native.
