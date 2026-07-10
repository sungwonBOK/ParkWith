import '../../../core/api/api_client.dart';
import '../domain/deal.dart';
import '../domain/deal_repository.dart';
import 'deal_list_response_dto.dart';

class RemoteDealRepository implements DealRepository {
  const RemoteDealRepository(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<Deal>> listDealsForVenue(String venueId) async {
    final encodedVenueId = Uri.encodeComponent(venueId);
    final json = await _apiClient.getJson('/venues/$encodedVenueId/deals');
    return DealListResponseDto.fromJson(json)
        .data
        .map((deal) => deal.toDomain())
        .toList(growable: false);
  }
}
