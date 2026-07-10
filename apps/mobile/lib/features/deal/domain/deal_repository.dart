import 'deal.dart';

abstract class DealRepository {
  Future<List<Deal>> listDealsForVenue(String venueId);
}
