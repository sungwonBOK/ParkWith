# ParkWith Agent Instructions

These instructions apply to the entire repository.

## Always Follow

- Keep changes inside the documented MVP unless the user explicitly expands scope.
- Prefer small, focused files with one clear responsibility.
- Before creating a new file, search for an existing file, component, use case, service, or module with the same responsibility.
- Keep UI, business rules, and external IO separate.
- In Flutter features, use `data`, `domain`, and `presentation` layers.
- Put business rules and use cases in `domain`, not inside screens.
- Put API, DTO, cache, and repository implementations in `data`.
- Avoid broad shared abstractions until the same pattern appears in at least two or three places.
- When a file approaches 250-300 lines, review whether responsibilities should be split into smaller files.
- Do not refactor code unrelated to the user's request. If a supporting refactor is necessary, keep it minimal and explain why.
- Do not leave temporary code, unused variables, unused functions, or unused packages.
- Use clear names that match the project documents.
- Do not hardcode secrets, API keys, tokens, or private URLs.
- Do not show raw technical errors directly to users.

## Project Naming

- Flutter files use lowercase with underscores.
- NestJS folders use lowercase with hyphens.
- Use these feature names consistently:
  - `trip_room`
  - `location_sharing`
  - `venue_map`
  - `saved_place`

Avoid alternate names such as `party`, `group`, `loc`, or `map2` for the same concepts.

## When To Load Extra Guidance

Use the project skill at `.codex/skills/playmate-location-safety` only when changing:

- location sharing
- battery behavior
- visit session start/end behavior
- privacy-sensitive photo or lost-item flows
- location data retention or deletion
- MVP boundary decisions for sensitive features

For ordinary UI, refactors, styling, or simple feature work, do not load those detailed policies unless the change touches the areas above.

## Useful Documents

- `docs/requirements/MVP_SCOPE.md`
- `docs/architecture/ARCHITECTURE_GUIDE.md`
- `docs/ai-rules/AI_CODING_RULES.md`

## Reporting

After changes, summarize what changed, which files changed, what was tested, and any remaining risks.
