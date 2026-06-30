import 'package:flutter/material.dart';

import '../domain/use_cases/get_venue.dart';
import '../domain/venue.dart';

class VenueDetailScreen extends StatefulWidget {
  const VenueDetailScreen({
    required this.venueId,
    required this.getVenue,
    super.key,
  });

  final String venueId;
  final GetVenue getVenue;

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  late final Future<Venue?> _venueFuture;

  @override
  void initState() {
    super.initState();
    _venueFuture = widget.getVenue(widget.venueId);
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
            ],
          );
        },
      ),
    );
  }
}
