import 'package:flutter/material.dart';

import '../../cost_calculator/presentation/cost_calculator_screen.dart';
import '../../deal/domain/use_cases/list_venue_deals.dart';
import '../domain/use_cases/get_venue.dart';
import '../domain/use_cases/list_venues.dart';
import '../domain/venue.dart';
import 'venue_detail_screen.dart';

class VenueListScreen extends StatefulWidget {
  const VenueListScreen({
    required this.listVenues,
    required this.getVenue,
    required this.listVenueDeals,
    super.key,
  });

  final ListVenues listVenues;
  final GetVenue getVenue;
  final ListVenueDeals listVenueDeals;

  @override
  State<VenueListScreen> createState() => _VenueListScreenState();
}

class _VenueListScreenState extends State<VenueListScreen> {
  late final Future<List<Venue>> _venuesFuture;

  @override
  void initState() {
    super.initState();
    _venuesFuture = widget.listVenues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ParkWith'),
        actions: [
          IconButton(
            key: const Key('cost-calculator-button'),
            tooltip: '비용 계산기',
            icon: const Icon(Icons.calculate_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const CostCalculatorScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Venue>>(
        future: _venuesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Venue list could not be loaded.'),
            );
          }

          final venues = snapshot.data ?? const <Venue>[];
          if (venues.isEmpty) {
            return const Center(child: Text('No venues yet.'));
          }

          return ListView.separated(
            itemCount: venues.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final venue = venues[index];
              return ListTile(
                title: Text(venue.name),
                subtitle: Text('${venue.categoryLabel} - ${venue.region}'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => VenueDetailScreen(
                        venueId: venue.id,
                        getVenue: widget.getVenue,
                        listVenueDeals: widget.listVenueDeals,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
