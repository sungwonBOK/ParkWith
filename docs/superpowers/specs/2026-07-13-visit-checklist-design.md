# Visit Checklist Design

## Goal

Implement GitHub issue #6 as a small venue-category checklist that users can view and toggle before a visit, while keeping future persistence, trip-room sharing, and venue discovery tabs outside this slice.

## Approved Scope

- Provide five default preparation items for each supported venue category.
- Build each template from three common items and two category-specific items.
- Show the checklist from the existing venue-detail flow.
- Allow each item to be toggled and show completed-item progress.
- Keep completion state only while the checklist screen remains open.
- Do not add persistence, server APIs, trip-room sharing, custom items, deletion, or reordering.
- Do not add location sharing or future event, regional restaurant, and local-food tabs.

## Default Templates

Every venue category includes these common items:

- 예매·입장권 확인
- 날씨 확인
- 보조배터리

Water parks also include:

- 수영복
- 수건

Amusement parks also include:

- 편한 신발
- 자외선 차단제

Each template contains exactly five initially incomplete items. Item identifiers are stable within the template and do not depend on their display order.

## Architecture

The checklist feature remains under `features/checklist` and follows the existing Flutter `domain` and `presentation` split. No `data` layer is needed because this slice performs no IO.

The domain contains an immutable checklist-item model, a template use case that accepts the existing `VenueCategory`, and a toggle use case that returns a new list with only the selected item changed. Template composition and state-transition rules stay outside widgets.

The presentation contains a standalone checklist screen. It receives the venue name and category, loads the domain template once, owns only the current in-memory list, and renders five checkboxes plus completed progress. Closing the screen discards the state; reopening it creates a fresh template.

The venue-detail screen receives a thin `방문 준비 체크리스트` action that opens the checklist screen. This navigation choice may later move into a tab or menu without changing checklist domain code.

## Future Venue Tabs

Venue-related events, well-known regional restaurants, and local foods are planned as separate future tabs. This checklist slice must not introduce tab infrastructure, discovery models, external data sources, or placeholder screens for them.

The checklist screen and domain API remain independent so future venue-detail navigation can compose them without merging their state or responsibilities.

## Error Handling

Template selection is exhaustive over the current `VenueCategory` enum and requires no external data. The screen does not display raw exceptions or technical messages. An unknown checklist item identifier is treated as no state change rather than creating or deleting an item.

## Testing

Development follows TDD:

1. Domain tests first verify that water-park and amusement-park templates contain the three common and two correct category-specific items.
2. Domain tests verify that toggling returns a new list, changes only the selected item, and leaves unknown identifiers unchanged.
3. Widget tests verify item rendering, progress display, and checkbox toggling.
4. Venue-detail widget tests verify navigation into the checklist with the selected venue's name and category.
5. Run the full mobile `flutter test` suite and `flutter analyze`.

## Completion Criteria

- Both venue categories render exactly five approved default items.
- Toggle behavior and template composition are covered by domain tests.
- The checklist screen renders, toggles items, and updates completed progress.
- Leaving and reopening the screen resets all items to incomplete.
- The existing venue-detail flow opens the checklist without coupling checklist code to future venue tabs.
- Full mobile tests and static analysis pass.
- No persistence, trip-room, event, restaurant, local-food, or location-sharing implementation is introduced.
