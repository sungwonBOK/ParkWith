# Cost Calculator Design

## Goal

Add the MVP visit-cost calculator from GitHub issue #5 while keeping its calculation rules independent from UI and navigation choices that may change later.

## Approved Scope

- Calculate a simple estimated visit cost from party size and manually entered options.
- Support ticket, meal, parking, locker, and extra-budget categories.
- Show input controls, an itemized estimate, and the total estimated amount.
- Add a minimal entry point from the existing venue-list flow.
- Do not add persistence, server APIs, payments, live prices, or location-sharing work.

## Calculation Rules

All monetary values use non-negative integer won amounts.

- Ticket cost: ticket price per person multiplied by party size.
- Meal cost: meal budget per person multiplied by party size.
- Parking cost: one fixed amount for the visit.
- Locker cost: locker unit price multiplied by locker quantity.
- Extra budget: one fixed amount for the visit.
- Total estimate: the sum of the five category totals.

Party size must be at least one. Locker quantity and every monetary input must be zero or greater.

## Architecture

The calculation lives entirely in `features/cost_calculator/domain`. A small input model describes the values required by the rule, and a use case returns an itemized result and total. It has no Flutter dependency and performs no IO.

The screen lives in `features/cost_calculator/presentation`. It owns temporary text-field state, converts valid integer input into the domain input model, calls the use case, and renders the returned breakdown. No `data` layer is needed because this slice does not save or fetch anything.

The existing venue-list AppBar receives a minimal calculator action. This navigation choice is deliberately thin so it can be replaced later without changing the domain API or its tests.

## UI Changeability

The MVP screen is a disposable presentation over a stable domain boundary. Labels, layout, input widgets, default values, navigation placement, and calculation trigger may change later. Business formulas, validation rules, and result fields must not be duplicated in widgets or controllers.

The presentation should depend only on the calculator use case and immutable domain values. It must not expose widget types, text controllers, or formatting concerns through the domain API.

## Error Handling

The domain rejects invalid party size, negative amounts, and negative locker quantity. The presentation prevents or catches invalid user input and shows a short Korean validation message. Raw exceptions and technical details are never shown to the user.

The result is always labeled as an estimate because manually entered prices may be inaccurate.

## Testing

Development follows TDD:

1. Add domain tests for category multiplication and total calculation, zero-valued optional categories, and invalid inputs. Run them and confirm the expected RED failures before production code.
2. Add the minimum domain implementation and confirm the focused domain tests are GREEN.
3. Add widget tests for valid calculation output, safe invalid-input feedback, and navigation from the venue list before implementing each presentation behavior.
4. Run the full mobile `flutter test` suite and `flutter analyze`.

## Completion Criteria

- Domain rules are covered by unit tests and remain independent of Flutter UI.
- The app exposes calculator inputs and an estimated total.
- Invalid input produces a safe Korean message.
- Existing mobile tests, new tests, and static analysis pass.
- No location-sharing files or behavior are changed.
