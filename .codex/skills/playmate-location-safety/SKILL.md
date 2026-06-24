---
name: playmate-location-safety
description: Use when changing ParkWith features that touch location sharing, battery behavior, visit-session start/end logic, privacy-sensitive photo or lost-item flows, location data retention/deletion, or MVP boundary decisions for sensitive features. Helps keep location, privacy, and battery rules out of always-loaded project instructions while still enforcing them when relevant.
---

# ParkWith Location Safety

Use this skill only for changes involving location, battery, privacy-sensitive flows, visit session lifecycle, or sensitive MVP scope decisions.

## Read First

Read only the references needed for the task:

- `references/location-battery.md`: location permission, update intervals, native extension boundaries
- `references/privacy.md`: location/photo/logging/data-retention privacy rules
- `references/mvp-boundaries.md`: MVP exclusions and optional feature boundaries

## Workflow

1. Identify whether the change touches location, battery, privacy, or MVP scope.
2. Read the relevant reference file.
3. Keep implementation scoped to the correct feature or policy module.
4. Add or update tests/checklists for permission denial, visit end, network failure, and privacy-sensitive logging when relevant.
5. Update the matching document under `docs/policies` or `docs/requirements` if behavior changes.

## Hard Rules

- Do not request location permission on app launch.
- Do not enable location sharing before a visit session starts.
- Do not continue location sharing after a visit session ends.
- Do not make 5-second-or-faster fixed interval uploads the default.
- Do not log precise coordinates or personal information.
- Do not add real-time wait time prediction during MVP.
