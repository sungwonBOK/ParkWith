import 'package:flutter_test/flutter_test.dart';
import 'package:parkwith_mobile/core/api/api_client.dart';
import 'package:parkwith_mobile/features/venue/data/remote_venue_repository.dart';

void main() {
  test('loads venues from the venues API endpoint', () async {
    final apiClient = _FakeApiClient({
      'success': true,
      'data': [
        {
          'id': 'everland',
          'name': 'Everland',
          'nameKo': 'Everland',
          'category': 'amusement_park',
          'region': 'Yongin',
          'description': 'Large amusement park.',
        },
      ],
      'error': null,
    });
    final repository = RemoteVenueRepository(apiClient);

    final venues = await repository.listVenues();

    expect(apiClient.requestedPaths, ['/venues']);
    expect(venues.single.name, 'Everland');
    expect(venues.single.nameKo, 'Everland');
  });

  test('loads a venue detail from the venues API endpoint', () async {
    final apiClient = _FakeApiClient({
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
    final repository = RemoteVenueRepository(apiClient);

    final venue = await repository.getVenueById('everland');

    expect(apiClient.requestedPaths, ['/venues/everland']);
    expect(venue?.name, 'Everland');
  });

  test('returns null when the venue detail API returns not found', () async {
    final apiClient = _FakeApiClient({
      'success': false,
      'data': null,
      'error': {
        'code': 'VENUE_NOT_FOUND',
        'message': 'Venue could not be found.',
      },
    });
    final repository = RemoteVenueRepository(apiClient);

    final venue = await repository.getVenueById('unknown-venue');

    expect(apiClient.requestedPaths, ['/venues/unknown-venue']);
    expect(venue, isNull);
  });
}

class _FakeApiClient implements ApiClient {
  _FakeApiClient(this.response);

  final Map<String, Object?> response;
  final List<String> requestedPaths = [];

  @override
  Future<Map<String, Object?>> getJson(String path) async {
    requestedPaths.add(path);
    return response;
  }
}
