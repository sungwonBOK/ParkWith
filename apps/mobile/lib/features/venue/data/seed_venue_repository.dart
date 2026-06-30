import '../domain/venue.dart';
import '../domain/venue_repository.dart';
import 'venue_dto.dart';
import 'venue_seed_data.dart';

class SeedVenueRepository implements VenueRepository {
  const SeedVenueRepository();

  @override
  Future<List<Venue>> listVenues() async {
    return venueSeedData
        .map((json) => VenueDto.fromJson(json).toDomain())
        .toList(growable: false);
  }

  @override
  Future<Venue?> getVenueById(String venueId) async {
    final venues = await listVenues();
    for (final venue in venues) {
      if (venue.id == venueId) {
        return venue;
      }
    }
    return null;
  }
}
