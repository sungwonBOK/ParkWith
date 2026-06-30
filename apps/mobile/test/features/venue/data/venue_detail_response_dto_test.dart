import 'package:flutter_test/flutter_test.dart';
import 'package:parkwith_mobile/features/venue/data/venue_detail_response_dto.dart';
import 'package:parkwith_mobile/features/venue/domain/venue.dart';

void main() {
  test('parses successful venue detail API envelope into a domain venue', () {
    final response = VenueDetailResponseDto.fromJson({
      'success': true,
      'data': {
        'id': 'everland',
        'name': 'Everland',
        'nameKo': 'Everland',
        'category': 'amusement_park',
        'region': 'Yongin',
        'description': 'Large amusement park.',
      },
      'error': null,
    });

    final venue = response.toDomain();

    expect(venue?.id, 'everland');
    expect(venue?.category, VenueCategory.amusementPark);
  });

  test('parses venue not found API envelope into null', () {
    final response = VenueDetailResponseDto.fromJson({
      'success': false,
      'data': null,
      'error': {
        'code': 'VENUE_NOT_FOUND',
        'message': 'Venue could not be found.',
      },
    });

    expect(response.toDomain(), isNull);
  });
}
