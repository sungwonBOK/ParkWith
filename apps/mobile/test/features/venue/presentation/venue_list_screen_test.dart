import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parkwith_mobile/features/venue/data/seed_venue_repository.dart';
import 'package:parkwith_mobile/features/venue/domain/use_cases/list_venues.dart';
import 'package:parkwith_mobile/features/venue/presentation/venue_list_screen.dart';

void main() {
  testWidgets('renders seeded venue names', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VenueListScreen(
          listVenues: ListVenues(SeedVenueRepository()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Caribbean Bay'), findsOneWidget);
    expect(find.text('Everland'), findsOneWidget);
  });
}
