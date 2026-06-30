import '../../../core/api/api_client.dart';
import '../domain/venue.dart';
import '../domain/venue_repository.dart';
import 'venue_detail_response_dto.dart';
import 'venue_list_response_dto.dart';

class RemoteVenueRepository implements VenueRepository {
  const RemoteVenueRepository(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<Venue>> listVenues() async {
    final json = await _apiClient.getJson('/venues');
    return VenueListResponseDto.fromJson(json).toDomainList();
  }

  @override
  Future<Venue?> getVenueById(String venueId) async {
    final encodedVenueId = Uri.encodeComponent(venueId);
    final json = await _apiClient.getJson('/venues/$encodedVenueId');
    return VenueDetailResponseDto.fromJson(json).toDomain();
  }
}
