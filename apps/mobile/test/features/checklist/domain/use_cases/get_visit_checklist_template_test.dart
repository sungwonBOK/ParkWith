import 'package:flutter_test/flutter_test.dart';
import 'package:parkwith_mobile/features/checklist/domain/use_cases/get_visit_checklist_template.dart';
import 'package:parkwith_mobile/features/venue/domain/venue.dart';

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
