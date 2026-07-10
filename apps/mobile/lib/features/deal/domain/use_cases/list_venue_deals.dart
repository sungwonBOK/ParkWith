import '../deal.dart';
import '../deal_repository.dart';

class ListVenueDeals {
  const ListVenueDeals(this._repository);

  final DealRepository _repository;

  Future<List<Deal>> call(String venueId) {
    return _repository.listDealsForVenue(venueId);
  }
}
