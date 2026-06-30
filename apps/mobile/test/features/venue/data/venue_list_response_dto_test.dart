import 'package:flutter_test/flutter_test.dart';
import 'package:parkwith_mobile/features/venue/data/venue_list_response_dto.dart';
import 'package:parkwith_mobile/features/venue/domain/venue.dart';

void main() {
  test('parses successful venue list API envelope into domain venues', () {
    final response = VenueListResponseDto.fromJson({
      'success': true,
      'data': [
        {
          'id': 'caribbean-bay',
          'name': 'Caribbean Bay',
          'nameKo': '캐리비안베이',
          'category': 'water_park',
          'region': 'Yongin',
          'description': 'Indoor and outdoor water park.',
        },
      ],
      'error': null,
    });

    final venues = response.toDomainList();

    expect(venues, hasLength(1));
    expect(venues.single.id, 'caribbean-bay');
    expect(venues.single.nameKo, '캐리비안베이');
    expect(venues.single.category, VenueCategory.waterPark);
  });
}
