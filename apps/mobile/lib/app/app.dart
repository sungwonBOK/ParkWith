import 'package:flutter/material.dart';

import '../features/venue/data/seed_venue_repository.dart';
import '../features/venue/domain/use_cases/list_venues.dart';
import '../features/venue/presentation/venue_list_screen.dart';

class ParkWithApp extends StatelessWidget {
  const ParkWithApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkWith',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF147C72)),
        useMaterial3: true,
      ),
      home: const VenueListScreen(
        listVenues: ListVenues(
          SeedVenueRepository(),
        ),
      ),
    );
  }
}
