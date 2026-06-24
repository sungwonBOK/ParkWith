import '../venue.dart';
import '../venue_repository.dart';

class ListVenues {
  const ListVenues(this._repository);

  final VenueRepository _repository;

  Future<List<Venue>> call() {
    return _repository.listVenues();
  }
}
