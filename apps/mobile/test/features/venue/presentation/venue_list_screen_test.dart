import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parkwith_mobile/features/venue/domain/use_cases/get_venue.dart';
import 'package:parkwith_mobile/features/venue/domain/use_cases/list_venues.dart';
import 'package:parkwith_mobile/features/venue/domain/venue.dart';
import 'package:parkwith_mobile/features/venue/domain/venue_repository.dart';
import 'package:parkwith_mobile/features/venue/presentation/venue_detail_screen.dart';
import 'package:parkwith_mobile/features/venue/presentation/venue_list_screen.dart';

void main() {
  testWidgets('renders venue names', (tester) async {
    const repository = _FakeVenueRepository();

    await tester.pumpWidget(
      const MaterialApp(
        home: VenueListScreen(
          listVenues: ListVenues(repository),
          getVenue: GetVenue(repository),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Caribbean Bay'), findsOneWidget);
    expect(find.text('Everland'), findsOneWidget);
  });

  testWidgets('opens the venue detail screen when a venue is tapped', (
    tester,
  ) async {
    const repository = _FakeVenueRepository();

    await tester.pumpWidget(
      const MaterialApp(
        home: VenueListScreen(
          listVenues: ListVenues(repository),
          getVenue: GetVenue(repository),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Everland'));
    await tester.pumpAndSettle();

    expect(find.byType(VenueDetailScreen), findsOneWidget);
    expect(find.text('Large amusement park.'), findsOneWidget);
    expect(find.text('Amusement park - Yongin'), findsOneWidget);
  });

  testWidgets('shows a safe message when a venue detail is missing', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VenueDetailScreen(
          venueId: 'unknown-venue',
          getVenue: GetVenue(_MissingVenueRepository()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Venue could not be found.'), findsOneWidget);
  });
}

class _FakeVenueRepository implements VenueRepository {
  const _FakeVenueRepository();

  @override
  Future<List<Venue>> listVenues() async {
    return const [
      Venue(
        id: 'caribbean-bay',
        name: 'Caribbean Bay',
        nameKo: 'Caribbean Bay',
        category: VenueCategory.waterPark,
        region: 'Yongin',
        description: 'Large water park.',
      ),
      Venue(
        id: 'everland',
        name: 'Everland',
        nameKo: 'Everland',
        category: VenueCategory.amusementPark,
        region: 'Yongin',
        description: 'Large amusement park.',
      ),
    ];
  }

  @override
  Future<Venue?> getVenueById(String venueId) async {
    final venues = await listVenues();
    for (final venue in venues) {
      if (venue.id == venueId) {
        return venue;
      }
    }
    return null;
  }
}

class _MissingVenueRepository implements VenueRepository {
  const _MissingVenueRepository();

  @override
  Future<List<Venue>> listVenues() async {
    return const [];
  }

  @override
  Future<Venue?> getVenueById(String venueId) async {
    return null;
  }
}
