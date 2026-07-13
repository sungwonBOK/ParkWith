import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parkwith_mobile/features/checklist/presentation/visit_checklist_screen.dart';
import 'package:parkwith_mobile/features/cost_calculator/presentation/cost_calculator_screen.dart';
import 'package:parkwith_mobile/features/deal/domain/deal.dart';
import 'package:parkwith_mobile/features/deal/domain/deal_repository.dart';
import 'package:parkwith_mobile/features/deal/domain/use_cases/list_venue_deals.dart';
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
          listVenueDeals: ListVenueDeals(_FakeDealRepository()),
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
          listVenueDeals: ListVenueDeals(_FakeDealRepository()),
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
          listVenueDeals: ListVenueDeals(_FakeDealRepository()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Venue could not be found.'), findsOneWidget);
  });

  testWidgets('renders venue deals on the venue detail screen', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VenueDetailScreen(
          venueId: 'everland',
          getVenue: GetVenue(_FakeVenueRepository()),
          listVenueDeals: ListVenueDeals(_FakeDealRepository()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Afternoon pass discount'), findsOneWidget);
    expect(
      find.text('Up to 35% off selected afternoon passes'),
      findsOneWidget,
    );
    expect(find.text('Updated 2026-06-30'), findsOneWidget);
  });

  testWidgets('opens the visit checklist from venue detail', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VenueDetailScreen(
          venueId: 'everland',
          getVenue: GetVenue(_FakeVenueRepository()),
          listVenueDeals: ListVenueDeals(_FakeDealRepository()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('visit-checklist-button')));
    await tester.pumpAndSettle();

    expect(find.byType(VisitChecklistScreen), findsOneWidget);
    expect(find.text('Everland 방문 준비'), findsOneWidget);
    expect(find.text('준비 완료 0/5'), findsOneWidget);
  });

  testWidgets('resets the visit checklist after its route is closed', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VenueDetailScreen(
          venueId: 'everland',
          getVenue: GetVenue(_FakeVenueRepository()),
          listVenueDeals: ListVenueDeals(_FakeDealRepository()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('visit-checklist-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('편한 신발'));
    await tester.pump();

    expect(find.text('준비 완료 1/5'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('visit-checklist-button')));
    await tester.pumpAndSettle();

    expect(find.text('준비 완료 0/5'), findsOneWidget);
    expect(
      tester
          .widget<CheckboxListTile>(
            find.byKey(const Key('checklist-item-comfortable-shoes')),
          )
          .value,
      isFalse,
    );
  });

  testWidgets('opens the cost calculator from the app bar', (tester) async {
    const repository = _FakeVenueRepository();

    await tester.pumpWidget(
      const MaterialApp(
        home: VenueListScreen(
          listVenues: ListVenues(repository),
          getVenue: GetVenue(repository),
          listVenueDeals: ListVenueDeals(_FakeDealRepository()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('cost-calculator-button')));
    await tester.pumpAndSettle();

    expect(find.byType(CostCalculatorScreen), findsOneWidget);
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

class _FakeDealRepository implements DealRepository {
  const _FakeDealRepository();

  @override
  Future<List<Deal>> listDealsForVenue(String venueId) async {
    return [
      Deal(
        id: '$venueId-afternoon-pass',
        venueId: venueId,
        title: 'Afternoon pass discount',
        summary: 'Reduced admission after afternoon entry hours.',
        discountText: 'Up to 35% off selected afternoon passes',
        sourceUrl: 'https://www.everland.com/',
        lastUpdatedAt: DateTime(2026, 6, 30),
      ),
    ];
  }
}
