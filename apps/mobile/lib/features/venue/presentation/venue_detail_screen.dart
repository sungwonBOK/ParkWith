import 'package:flutter/material.dart';

import '../../checklist/presentation/visit_checklist_screen.dart';
import '../../deal/domain/deal.dart';
import '../../deal/domain/use_cases/list_venue_deals.dart';
import '../domain/use_cases/get_venue.dart';
import '../domain/venue.dart';

class VenueDetailScreen extends StatefulWidget {
  const VenueDetailScreen({
    required this.venueId,
    required this.getVenue,
    required this.listVenueDeals,
    super.key,
  });

  final String venueId;
  final GetVenue getVenue;
  final ListVenueDeals listVenueDeals;

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  late final Future<Venue?> _venueFuture;
  late final Future<List<Deal>> _dealsFuture;

  @override
  void initState() {
    super.initState();
    _venueFuture = widget.getVenue(widget.venueId);
    _dealsFuture = widget.listVenueDeals(widget.venueId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venue detail'),
      ),
      body: FutureBuilder<Venue?>(
        future: _venueFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Venue could not be loaded.'),
            );
          }

          final venue = snapshot.data;
          if (venue == null) {
            return const Center(
              child: Text('Venue could not be found.'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                venue.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text('${venue.categoryLabel} - ${venue.region}'),
              const SizedBox(height: 16),
              Text(venue.description),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                key: const Key('visit-checklist-button'),
                icon: const Icon(Icons.checklist),
                label: const Text('방문 준비 체크리스트'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => VisitChecklistScreen(
                        venueName: venue.name,
                        category: venue.category,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Deals',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<Deal>>(
                future: _dealsFuture,
                builder: (context, dealSnapshot) {
                  if (dealSnapshot.connectionState != ConnectionState.done) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: LinearProgressIndicator(),
                    );
                  }

                  if (dealSnapshot.hasError) {
                    return const Text('Deals could not be loaded.');
                  }

                  final deals = dealSnapshot.data ?? const <Deal>[];
                  if (deals.isEmpty) {
                    return const Text('No deals yet.');
                  }

                  return Column(
                    children: deals
                        .map(
                          (deal) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(deal.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(deal.discountText),
                                Text(
                                  'Updated ${_formatDate(deal.lastUpdatedAt)}',
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(growable: false),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
