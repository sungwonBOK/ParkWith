# Visit Checklist Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an in-memory, venue-category visit checklist that renders five approved items, toggles completion, resets when closed, and opens from venue detail.

**Architecture:** Keep immutable checklist data and all template/toggle rules in `features/checklist/domain`. A standalone stateful screen owns only the current list for its route lifetime, while venue detail supplies the selected venue name and existing `VenueCategory` through a thin navigation action.

**Tech Stack:** Flutter, Dart, `flutter_test`, Material widgets

## Global Constraints

- Implement only GitHub issue #6.
- Each template contains exactly three common items and two category-specific items.
- Completion state exists only while the checklist route remains open.
- Do not add persistence, server APIs, trip-room sharing, custom items, deletion, reordering, or a `data` layer.
- Do not add location sharing or future event, regional restaurant, and local-food tabs.
- Use the existing `VenueCategory` enum without introducing an alternate category type.

---

### Task 1: Checklist item model and category templates

**Files:**
- Create: `apps/mobile/lib/features/checklist/domain/checklist_item.dart`
- Create: `apps/mobile/lib/features/checklist/domain/use_cases/get_visit_checklist_template.dart`
- Test: `apps/mobile/test/features/checklist/domain/use_cases/get_visit_checklist_template_test.dart`

**Interfaces:**
- Consumes: `VenueCategory` from `features/venue/domain/venue.dart`
- Produces: `ChecklistItem({required String id, required String label, bool isCompleted = false})`, `ChecklistItem.copyWith`, and `GetVisitChecklistTemplate.call(VenueCategory)`

- [x] **Step 1: Write failing template tests**

```dart
void main() {
  const getTemplate = GetVisitChecklistTemplate();

  test('builds the five-item water park template', () {
    final items = getTemplate(VenueCategory.waterPark);

    expect(items, hasLength(5));
    expect(items.map((item) => item.label), [
      '예매·입장권 확인',
      '날씨 확인',
      '보조배터리',
      '수영복',
      '수건',
    ]);
    expect(items.every((item) => !item.isCompleted), isTrue);
    expect(items.map((item) => item.id).toSet(), hasLength(5));
  });

  test('builds the five-item amusement park template', () {
    final items = getTemplate(VenueCategory.amusementPark);

    expect(items, hasLength(5));
    expect(items.map((item) => item.label), [
      '예매·입장권 확인',
      '날씨 확인',
      '보조배터리',
      '편한 신발',
      '자외선 차단제',
    ]);
    expect(items.every((item) => !item.isCompleted), isTrue);
    expect(items.map((item) => item.id).toSet(), hasLength(5));
  });
}
```

- [x] **Step 2: Run the focused test and verify RED**

Run: `flutter test test/features/checklist/domain/use_cases/get_visit_checklist_template_test.dart`

Expected: compilation failure because `ChecklistItem` and `GetVisitChecklistTemplate` do not exist.

- [x] **Step 3: Implement the immutable model and exhaustive templates**

```dart
class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.label,
    this.isCompleted = false,
  });

  final String id;
  final String label;
  final bool isCompleted;

  ChecklistItem copyWith({bool? isCompleted}) {
    return ChecklistItem(
      id: id,
      label: label,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
```

`GetVisitChecklistTemplate.call` returns a fresh fixed-length list assembled from three common constants and the two items selected by an exhaustive `switch` on `VenueCategory`. IDs are `ticket`, `weather`, `power-bank`, `swimsuit`, `towel`, `comfortable-shoes`, and `sunscreen`.

- [x] **Step 4: Run the focused test and verify GREEN**

Run: `flutter test test/features/checklist/domain/use_cases/get_visit_checklist_template_test.dart`

Expected: 2 tests pass.

### Task 2: Immutable checklist toggle rule

**Files:**
- Create: `apps/mobile/lib/features/checklist/domain/use_cases/toggle_checklist_item.dart`
- Test: `apps/mobile/test/features/checklist/domain/use_cases/toggle_checklist_item_test.dart`

**Interfaces:**
- Consumes: `List<ChecklistItem>` and a stable item ID
- Produces: `ToggleChecklistItem.call(List<ChecklistItem> items, String itemId)`

- [x] **Step 1: Write failing toggle tests**

```dart
test('returns a new list with only the selected item toggled', () {
  const items = [
    ChecklistItem(id: 'ticket', label: '예매·입장권 확인'),
    ChecklistItem(id: 'weather', label: '날씨 확인'),
  ];

  final result = const ToggleChecklistItem()(items, 'weather');

  expect(identical(result, items), isFalse);
  expect(result[0].isCompleted, isFalse);
  expect(result[1].isCompleted, isTrue);
  expect(items.every((item) => !item.isCompleted), isTrue);
});

test('leaves the list unchanged for an unknown item id', () {
  const items = [ChecklistItem(id: 'ticket', label: '예매·입장권 확인')];

  final result = const ToggleChecklistItem()(items, 'unknown');

  expect(identical(result, items), isTrue);
});
```

- [x] **Step 2: Run the focused test and verify RED**

Run: `flutter test test/features/checklist/domain/use_cases/toggle_checklist_item_test.dart`

Expected: compilation failure because `ToggleChecklistItem` does not exist.

- [x] **Step 3: Implement the minimum toggle use case**

```dart
class ToggleChecklistItem {
  const ToggleChecklistItem();

  List<ChecklistItem> call(List<ChecklistItem> items, String itemId) {
    if (!items.any((item) => item.id == itemId)) {
      return items;
    }

    return items
        .map(
          (item) => item.id == itemId
              ? item.copyWith(isCompleted: !item.isCompleted)
              : item,
        )
        .toList(growable: false);
  }
}
```

- [x] **Step 4: Run all checklist domain tests and verify GREEN**

Run: `flutter test test/features/checklist/domain`

Expected: 4 tests pass.

### Task 3: Standalone checklist screen

**Files:**
- Create: `apps/mobile/lib/features/checklist/presentation/visit_checklist_screen.dart`
- Test: `apps/mobile/test/features/checklist/presentation/visit_checklist_screen_test.dart`

**Interfaces:**
- Consumes: `venueName`, `VenueCategory`, `GetVisitChecklistTemplate`, and `ToggleChecklistItem`
- Produces: `VisitChecklistScreen` with five `CheckboxListTile` widgets and progress text `준비 완료 N/5`

- [x] **Step 1: Write failing widget tests**

Create tests that pump `VisitChecklistScreen(venueName: 'Everland', category: VenueCategory.amusementPark)`, assert the title `Everland 방문 준비`, all five amusement-park labels, five checkboxes, and `준비 완료 0/5`. A second test taps `편한 신발`, then asserts `준비 완료 1/5` and that only the checkbox keyed `checklist-item-comfortable-shoes` is selected.

- [x] **Step 2: Run the focused widget test and verify RED**

Run: `flutter test test/features/checklist/presentation/visit_checklist_screen_test.dart`

Expected: compilation failure because `VisitChecklistScreen` does not exist.

- [x] **Step 3: Implement the route-lifetime stateful screen**

Initialize `_items` once in `initState` with `widget.getTemplate(widget.category)`. Render a `Scaffold`, an AppBar titled `'<venueName> 방문 준비'`, progress text `준비 완료 <completed>/<total>`, and one keyed `CheckboxListTile` per item. In `onChanged`, replace `_items` using `widget.toggleItem(_items, item.id)` inside `setState`. Add no storage, service, provider, or error UI because the operation is local and exhaustive.

- [x] **Step 4: Run the focused widget test and verify GREEN**

Run: `flutter test test/features/checklist/presentation/visit_checklist_screen_test.dart`

Expected: 2 tests pass.

### Task 4: Venue-detail navigation, reset behavior, and feature documentation

**Files:**
- Modify: `apps/mobile/lib/features/venue/presentation/venue_detail_screen.dart`
- Modify: `apps/mobile/test/features/venue/presentation/venue_list_screen_test.dart`
- Modify: `apps/mobile/lib/features/checklist/README.md`

**Interfaces:**
- Consumes: the loaded venue's `name` and `category`
- Produces: a `visit-checklist-button` action that pushes a new `VisitChecklistScreen` instance

- [x] **Step 1: Write failing navigation and reset tests**

Add a venue-detail widget test that taps the keyed checklist button and expects `VisitChecklistScreen`, `Everland 방문 준비`, and `준비 완료 0/5`. Add a reset test that toggles `편한 신발`, pops the route, opens it again, and expects `준비 완료 0/5` with the item unchecked.

- [x] **Step 2: Run the venue presentation test and verify RED**

Run: `flutter test test/features/venue/presentation/venue_list_screen_test.dart`

Expected: failure because `visit-checklist-button` is absent.

- [x] **Step 3: Add the thin navigation action**

Import `VisitChecklistScreen` in `venue_detail_screen.dart`. Below the venue description, add an `OutlinedButton.icon` keyed `visit-checklist-button`, labeled `방문 준비 체크리스트`, and push `VisitChecklistScreen(venueName: venue.name, category: venue.category)`.

- [x] **Step 4: Correct the feature README**

Replace the obsolete trip-room state statement with: the feature provides category templates, owns completion only for the open screen, and intentionally has no persistence or sharing in issue #6.

- [x] **Step 5: Run venue and checklist tests and verify GREEN**

Run: `flutter test test/features/checklist test/features/venue/presentation/venue_list_screen_test.dart`

Expected: all checklist and venue presentation tests pass.

### Task 5: Full verification

**Files:**
- Verify all changed files only; do not broaden formatting into unrelated location-sharing files.

**Interfaces:**
- Consumes: completed implementation and tests from Tasks 1-4
- Produces: evidence for every completion criterion in the design

- [x] **Step 1: Format only changed Dart files**

Run `dart format` with the explicit changed Dart file paths from Tasks 1-4.

- [x] **Step 2: Run the complete mobile test suite**

Run: `flutter test`

Expected: all tests pass with zero failures.

- [x] **Step 3: Run static analysis**

Run: `flutter analyze`

Expected: `No issues found!`

- [x] **Step 4: Audit the diff and scope**

Run: `git diff --check`, `git status -sb`, and `git diff --stat` from the repository root. Confirm no persistence, API, trip-room, location-sharing, future-tab, dependency, or unrelated file changes were introduced.
