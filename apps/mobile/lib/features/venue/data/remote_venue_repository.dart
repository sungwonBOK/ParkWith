import '../../../core/api/api_client.dart';
import '../domain/venue.dart';
import '../domain/venue_repository.dart';
import 'venue_list_response_dto.dart';

class RemoteVenueRepository implements VenueRepository {
  const RemoteVenueRepository(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<Venue>> listVenues() async {
    final json = await _apiClient.getJson('/venues');
    return VenueListResponseDto.fromJson(json).toDomainList();
  }
}
