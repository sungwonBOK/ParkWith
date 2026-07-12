import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parkwith_mobile/features/cost_calculator/presentation/cost_calculator_screen.dart';

void main() {
  testWidgets('shows an itemized estimated total from manual input', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: CostCalculatorScreen()),
    );

    await tester.ensureVisible(find.text('계산하기'));
    await tester.tap(find.text('계산하기'));
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pump();

    expect(find.text('티켓 100,000원'), findsOneWidget);
    expect(find.text('식비 40,000원'), findsOneWidget);
    expect(find.text('주차 10,000원'), findsOneWidget);
    expect(find.text('락커 5,000원'), findsOneWidget);
    expect(find.text('추가 예산 30,000원'), findsOneWidget);
    expect(find.text('총 예상 금액 185,000원'), findsOneWidget);
  });

  testWidgets('shows a safe Korean message for invalid input', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CostCalculatorScreen()),
    );

    await tester.enterText(find.byKey(const Key('party-size-field')), '0');
    await tester.ensureVisible(find.text('계산하기'));
    await tester.tap(find.text('계산하기'));
    await tester.pump();

    expect(find.text('인원과 금액을 올바르게 입력해 주세요.'), findsOneWidget);
  });
}
