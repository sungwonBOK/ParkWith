import 'package:flutter/material.dart';

import '../core/api/api_client.dart';
import '../core/config/api_config.dart';
import '../features/venue/data/remote_venue_repository.dart';
import '../features/venue/domain/use_cases/get_venue.dart';
import '../features/venue/domain/use_cases/list_venues.dart';
import '../features/venue/domain/venue_repository.dart';
import '../features/venue/presentation/venue_list_screen.dart';

class ParkWithApp extends StatelessWidget {
  ParkWithApp({
    VenueRepository? venueRepository,
    super.key,
  }) : venueRepository = venueRepository ??
            RemoteVenueRepository(
              HttpApiClient(baseUrl: ApiConfig.fromEnvironment().baseUri),
            );

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
      ),
    );
  }
}
