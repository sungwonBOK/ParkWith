import 'package:flutter_test/flutter_test.dart';
import 'package:parkwith_mobile/features/checklist/domain/checklist_item.dart';
import 'package:parkwith_mobile/features/checklist/domain/use_cases/toggle_checklist_item.dart';

void main() {
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
    const items = [
      ChecklistItem(id: 'ticket', label: '예매·입장권 확인'),
    ];

    final result = const ToggleChecklistItem()(items, 'unknown');

    expect(identical(result, items), isTrue);
  });
}
