import '../checklist_item.dart';

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
