import '../venue.dart';
import '../venue_repository.dart';

class GetVenue {
  const GetVenue(this._repository);

  final VenueRepository _repository;

  Future<Venue?> call(String venueId) {
    return _repository.getVenueById(venueId);
  }
}
