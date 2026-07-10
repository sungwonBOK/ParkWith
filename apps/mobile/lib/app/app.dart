import 'package:flutter/material.dart';

import '../core/api/api_client.dart';
import '../core/config/api_config.dart';
import '../features/deal/data/remote_deal_repository.dart';
import '../features/deal/domain/deal_repository.dart';
import '../features/deal/domain/use_cases/list_venue_deals.dart';
import '../features/venue/data/remote_venue_repository.dart';
import '../features/venue/domain/use_cases/get_venue.dart';
import '../features/venue/domain/use_cases/list_venues.dart';
import '../features/venue/domain/venue_repository.dart';
import '../features/venue/presentation/venue_list_screen.dart';

class ParkWithApp extends StatelessWidget {
  ParkWithApp({
    DealRepository? dealRepository,
    VenueRepository? venueRepository,
    super.key,
  })  : dealRepository = dealRepository ?? _createRemoteDealRepository(),
        venueRepository = venueRepository ?? _createRemoteVenueRepository();

  final DealRepository dealRepository;
  final VenueRepository venueRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkWith',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF147C72)),
        useMaterial3: true,
      ),
      home: VenueListScreen(
        listVenues: ListVenues(
          venueRepository,
        ),
        getVenue: GetVenue(
          venueRepository,
        ),
        listVenueDeals: ListVenueDeals(
          dealRepository,
        ),
      ),
    );
  }

  static ApiClient _createApiClient() {
    return HttpApiClient(baseUrl: ApiConfig.fromEnvironment().baseUri);
  }

  static DealRepository _createRemoteDealRepository() {
    return RemoteDealRepository(_createApiClient());
  }

  static VenueRepository _createRemoteVenueRepository() {
    return RemoteVenueRepository(_createApiClient());
  }
}
