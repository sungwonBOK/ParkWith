import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parkwith_mobile/features/checklist/presentation/visit_checklist_screen.dart';
import 'package:parkwith_mobile/features/venue/domain/venue.dart';

void main() {
  testWidgets('renders the venue checklist and initial progress',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VisitChecklistScreen(
          venueName: 'Everland',
          category: VenueCategory.amusementPark,
        ),
      ),
    );

    expect(find.text('Everland 방문 준비'), findsOneWidget);
    expect(find.text('예매·입장권 확인'), findsOneWidget);
    expect(find.text('날씨 확인'), findsOneWidget);
    expect(find.text('보조배터리'), findsOneWidget);
    expect(find.text('편한 신발'), findsOneWidget);
    expect(find.text('자외선 차단제'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsNWidgets(5));
    expect(find.text('준비 완료 0/5'), findsOneWidget);
  });

  testWidgets('toggles one item and updates completed progress',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VisitChecklistScreen(
          venueName: 'Everland',
          category: VenueCategory.amusementPark,
        ),
      ),
    );

    await tester.tap(find.text('편한 신발'));
    await tester.pump();

    expect(find.text('준비 완료 1/5'), findsOneWidget);
    expect(
      tester
          .widget<CheckboxListTile>(
            find.byKey(const Key('checklist-item-comfortable-shoes')),
          )
          .value,
      isTrue,
    );
    expect(
      tester
          .widget<CheckboxListTile>(
            find.byKey(const Key('checklist-item-ticket')),
          )
          .value,
      isFalse,
    );
  });
}
