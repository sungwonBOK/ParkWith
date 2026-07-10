import 'package:flutter_test/flutter_test.dart';
import 'package:parkwith_mobile/core/api/api_client.dart';
import 'package:parkwith_mobile/features/deal/data/remote_deal_repository.dart';

void main() {
  test('loads venue deals from the venue-scoped deals API endpoint', () async {
    final apiClient = _FakeApiClient({
      'success': true,
      'data': [
        {
          'id': 'everland-afternoon-pass',
          'venueId': 'everland',
          'title': 'Afternoon pass discount',
          'summary': 'Reduced admission after afternoon entry hours.',
          'discountText': 'Up to 35% off selected afternoon passes',
          'sourceUrl': 'https://www.everland.com/',
          'lastUpdatedAt': '2026-06-30',
        },
      ],
      'error': null,
    });
    final repository = RemoteDealRepository(apiClient);

    final deals = await repository.listDealsForVenue('everland');

    expect(apiClient.requestedPaths, ['/venues/everland/deals']);
    expect(deals.single.venueId, 'everland');
    expect(deals.single.title, 'Afternoon pass discount');
    expect(deals.single.lastUpdatedAt, DateTime(2026, 6, 30));
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
