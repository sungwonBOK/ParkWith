import '../../../venue/domain/venue.dart';
import '../checklist_item.dart';

class GetVisitChecklistTemplate {
  const GetVisitChecklistTemplate();

  static const _commonItems = [
    ChecklistItem(id: 'ticket', label: '예매·입장권 확인'),
    ChecklistItem(id: 'weather', label: '날씨 확인'),
    ChecklistItem(id: 'power-bank', label: '보조배터리'),
  ];

  List<ChecklistItem> call(VenueCategory category) {
    final categoryItems = switch (category) {
      VenueCategory.waterPark => const [
          ChecklistItem(id: 'swimsuit', label: '수영복'),
          ChecklistItem(id: 'towel', label: '수건'),
        ],
      VenueCategory.amusementPark => const [
          ChecklistItem(id: 'comfortable-shoes', label: '편한 신발'),
          ChecklistItem(id: 'sunscreen', label: '자외선 차단제'),
        ],
    };

    return List.unmodifiable([..._commonItems, ...categoryItems]);
  }
}
