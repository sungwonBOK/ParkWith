import 'venue.dart';

abstract class VenueRepository {
  Future<List<Venue>> listVenues();
}
