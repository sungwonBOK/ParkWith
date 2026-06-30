import 'venue.dart';

abstract class VenueRepository {
  Future<List<Venue>> listVenues();

  Future<Venue?> getVenueById(String venueId);
}
