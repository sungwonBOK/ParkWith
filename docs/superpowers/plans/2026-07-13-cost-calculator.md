# Cost Calculator Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build GitHub issue #5's estimated visit-cost calculator with tested domain rules and a replaceable Flutter presentation.

**Architecture:** A Flutter-independent domain input, result, and use case own all formulas and validation. A stateful presentation screen owns temporary text input and formatting, while the existing venue-list AppBar supplies only a thin navigation entry point.

**Tech Stack:** Dart, Flutter Material, `flutter_test`, existing `flutter_lints`

## Global Constraints

- Work only in GitHub issue #5's cost-calculator scope.
- Ticket and meal costs are per-person amounts multiplied by party size.
- Parking and extra budget are fixed visit amounts.
- Locker cost is unit price multiplied by locker quantity.
- Party size is at least one; all other integer inputs are zero or greater.
- UI labels, layout, widgets, defaults, navigation, and trigger behavior may change without modifying domain rules.
- Do not add persistence, server APIs, payments, live prices, packages, or location-sharing changes.
- Never show raw technical errors to users.

---

### Task 1: Domain Estimate Rules

**Files:**
- Create: `apps/mobile/lib/features/cost_calculator/domain/cost_estimate.dart`
- Create: `apps/mobile/lib/features/cost_calculator/domain/use_cases/calculate_cost_estimate.dart`
- Test: `apps/mobile/test/features/cost_calculator/domain/use_cases/calculate_cost_estimate_test.dart`

**Interfaces:**
- Consumes: integer party size, per-person ticket and meal amounts, fixed parking and extra amounts, locker unit amount and quantity.
- Produces: `CalculateCostEstimate.call(CostEstimateInput input) -> CostEstimate`, whose fields are `ticketCost`, `mealCost`, `parkingCost`, `lockerCost`, `extraBudget`, and `total`.

- [ ] **Step 1: Write failing tests for calculation and validation**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:parkwith_mobile/features/cost_calculator/domain/cost_estimate.dart';
import 'package:parkwith_mobile/features/cost_calculator/domain/use_cases/calculate_cost_estimate.dart';

void main() {
  const calculate = CalculateCostEstimate();

  test('calculates itemized and total estimated costs', () {
    const input = CostEstimateInput(
      partySize: 2,
      ticketPricePerPerson: 50000,
      mealBudgetPerPerson: 20000,
      parkingCost: 10000,
      lockerUnitPrice: 5000,
      lockerQuantity: 1,
      extraBudget: 30000,
    );

    final result = calculate(input);

    expect(result.ticketCost, 100000);
    expect(result.mealCost, 40000);
    expect(result.parkingCost, 10000);
    expect(result.lockerCost, 5000);
    expect(result.extraBudget, 30000);
    expect(result.total, 185000);
  });

  test('allows zero-valued optional costs', () {
    const input = CostEstimateInput(
      partySize: 1,
      ticketPricePerPerson: 0,
      mealBudgetPerPerson: 0,
      parkingCost: 0,
      lockerUnitPrice: 0,
      lockerQuantity: 0,
      extraBudget: 0,
    );

    expect(calculate(input).total, 0);
  });

  test('rejects a party size below one', () {
    const input = CostEstimateInput(
      partySize: 0,
      ticketPricePerPerson: 0,
      mealBudgetPerPerson: 0,
      parkingCost: 0,
      lockerUnitPrice: 0,
      lockerQuantity: 0,
      extraBudget: 0,
    );

    expect(() => calculate(input), throwsArgumentError);
  });

  test('rejects every negative cost or quantity input', () {
    const inputs = [
      CostEstimateInput(
        partySize: 1,
        ticketPricePerPerson: -1,
        mealBudgetPerPerson: 0,
        parkingCost: 0,
        lockerUnitPrice: 0,
        lockerQuantity: 0,
        extraBudget: 0,
      ),
      CostEstimateInput(
        partySize: 1,
        ticketPricePerPerson: 0,
        mealBudgetPerPerson: -1,
        parkingCost: 0,
        lockerUnitPrice: 0,
        lockerQuantity: 0,
        extraBudget: 0,
      ),
      CostEstimateInput(
        partySize: 1,
        ticketPricePerPerson: 0,
        mealBudgetPerPerson: 0,
        parkingCost: -1,
        lockerUnitPrice: 0,
        lockerQuantity: 0,
        extraBudget: 0,
      ),
      CostEstimateInput(
        partySize: 1,
        ticketPricePerPerson: 0,
        mealBudgetPerPerson: 0,
        parkingCost: 0,
        lockerUnitPrice: -1,
        lockerQuantity: 0,
        extraBudget: 0,
      ),
      CostEstimateInput(
        partySize: 1,
        ticketPricePerPerson: 0,
        mealBudgetPerPerson: 0,
        parkingCost: 0,
        lockerUnitPrice: 0,
        lockerQuantity: -1,
        extraBudget: 0,
      ),
      CostEstimateInput(
        partySize: 1,
        ticketPricePerPerson: 0,
        mealBudgetPerPerson: 0,
        parkingCost: 0,
        lockerUnitPrice: 0,
        lockerQuantity: 0,
        extraBudget: -1,
      ),
    ];

    for (final input in inputs) {
      expect(() => calculate(input), throwsArgumentError);
    }
  });
}
```

- [ ] **Step 2: Run the focused test and confirm RED**

Run from `apps/mobile`:

```powershell
flutter test test/features/cost_calculator/domain/use_cases/calculate_cost_estimate_test.dart
```

Expected: compilation fails because the domain files and types do not exist.

- [ ] **Step 3: Implement immutable input and result values**

```dart
class CostEstimateInput {
  const CostEstimateInput({
    required this.partySize,
    required this.ticketPricePerPerson,
    required this.mealBudgetPerPerson,
    required this.parkingCost,
    required this.lockerUnitPrice,
    required this.lockerQuantity,
    required this.extraBudget,
  });

  final int partySize;
  final int ticketPricePerPerson;
  final int mealBudgetPerPerson;
  final int parkingCost;
  final int lockerUnitPrice;
  final int lockerQuantity;
  final int extraBudget;
}

class CostEstimate {
  const CostEstimate({
    required this.ticketCost,
    required this.mealCost,
    required this.parkingCost,
    required this.lockerCost,
    required this.extraBudget,
  });

  final int ticketCost;
  final int mealCost;
  final int parkingCost;
  final int lockerCost;
  final int extraBudget;

  int get total =>
      ticketCost + mealCost + parkingCost + lockerCost + extraBudget;
}
```

- [ ] **Step 4: Implement the use case with all validation in domain**

```dart
import '../cost_estimate.dart';

class CalculateCostEstimate {
  const CalculateCostEstimate();

  CostEstimate call(CostEstimateInput input) {
    if (input.partySize < 1) {
      throw ArgumentError.value(input.partySize, 'partySize');
    }

    final nonNegativeValues = <int>[
      input.ticketPricePerPerson,
      input.mealBudgetPerPerson,
      input.parkingCost,
      input.lockerUnitPrice,
      input.lockerQuantity,
      input.extraBudget,
    ];
    if (nonNegativeValues.any((value) => value < 0)) {
      throw ArgumentError('Costs and quantities must not be negative.');
    }

    return CostEstimate(
      ticketCost: input.ticketPricePerPerson * input.partySize,
      mealCost: input.mealBudgetPerPerson * input.partySize,
      parkingCost: input.parkingCost,
      lockerCost: input.lockerUnitPrice * input.lockerQuantity,
      extraBudget: input.extraBudget,
    );
  }
}
```

- [ ] **Step 5: Run the focused test and confirm GREEN**

Run: `flutter test test/features/cost_calculator/domain/use_cases/calculate_cost_estimate_test.dart`

Expected: four tests pass.

- [ ] **Step 6: Commit the domain slice**

```powershell
git add apps/mobile/lib/features/cost_calculator/domain apps/mobile/test/features/cost_calculator/domain
git commit -m "Add cost calculator domain rules"
```

### Task 2: Replaceable Calculator Screen

**Files:**
- Create: `apps/mobile/lib/features/cost_calculator/presentation/cost_calculator_screen.dart`
- Test: `apps/mobile/test/features/cost_calculator/presentation/cost_calculator_screen_test.dart`

**Interfaces:**
- Consumes: optional `CalculateCostEstimate` dependency, defaulting to `const CalculateCostEstimate()`.
- Produces: `CostCalculatorScreen`, which displays editable integer inputs, a safe validation message, an itemized estimate, and a total labeled as estimated.

- [ ] **Step 1: Write failing widget tests for calculation and invalid input**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parkwith_mobile/features/cost_calculator/presentation/cost_calculator_screen.dart';

void main() {
  testWidgets('shows an itemized estimated total from manual input', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CostCalculatorScreen()),
    );

    await tester.ensureVisible(find.text('계산하기'));
    await tester.tap(find.text('계산하기'));
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
```

- [ ] **Step 2: Run the focused test and confirm RED**

Run: `flutter test test/features/cost_calculator/presentation/cost_calculator_screen_test.dart`

Expected: compilation fails because `CostCalculatorScreen` does not exist.

- [ ] **Step 3: Implement the minimum presentation**

```dart
import 'package:flutter/material.dart';

import '../domain/cost_estimate.dart';
import '../domain/use_cases/calculate_cost_estimate.dart';

class CostCalculatorScreen extends StatefulWidget {
  const CostCalculatorScreen({
    this.calculateCostEstimate = const CalculateCostEstimate(),
    super.key,
  });

  final CalculateCostEstimate calculateCostEstimate;

  @override
  State<CostCalculatorScreen> createState() => _CostCalculatorScreenState();
}

class _CostCalculatorScreenState extends State<CostCalculatorScreen> {
  final _partySizeController = TextEditingController(text: '2');
  final _ticketController = TextEditingController(text: '50000');
  final _mealController = TextEditingController(text: '20000');
  final _parkingController = TextEditingController(text: '10000');
  final _lockerPriceController = TextEditingController(text: '5000');
  final _lockerQuantityController = TextEditingController(text: '1');
  final _extraBudgetController = TextEditingController(text: '30000');

  CostEstimate? _estimate;
  bool _hasValidationError = false;

  @override
  void dispose() {
    _partySizeController.dispose();
    _ticketController.dispose();
    _mealController.dispose();
    _parkingController.dispose();
    _lockerPriceController.dispose();
    _lockerQuantityController.dispose();
    _extraBudgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('비용 계산기')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _numberField('party-size-field', '인원수', _partySizeController),
          _numberField('ticket-price-field', '1인당 티켓', _ticketController),
          _numberField('meal-budget-field', '1인당 식비', _mealController),
          _numberField('parking-cost-field', '주차비', _parkingController),
          _numberField(
            'locker-unit-price-field',
            '락커 1개 가격',
            _lockerPriceController,
          ),
          _numberField(
            'locker-quantity-field',
            '락커 수량',
            _lockerQuantityController,
          ),
          _numberField(
            'extra-budget-field',
            '추가 예산',
            _extraBudgetController,
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _calculate,
            child: const Text('계산하기'),
          ),
          if (_hasValidationError) ...[
            const SizedBox(height: 12),
            const Text('인원과 금액을 올바르게 입력해 주세요.'),
          ],
          if (_estimate case final estimate?) ...[
            const SizedBox(height: 24),
            Text('티켓 ${_formatWon(estimate.ticketCost)}'),
            Text('식비 ${_formatWon(estimate.mealCost)}'),
            Text('주차 ${_formatWon(estimate.parkingCost)}'),
            Text('락커 ${_formatWon(estimate.lockerCost)}'),
            Text('추가 예산 ${_formatWon(estimate.extraBudget)}'),
            const SizedBox(height: 8),
            Text('총 예상 금액 ${_formatWon(estimate.total)}'),
            const Text('입력한 값을 기준으로 한 예상 금액입니다.'),
          ],
        ],
      ),
    );
  }

  Widget _numberField(
    String keyName,
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        key: Key(keyName),
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  void _calculate() {
    try {
      final estimate = widget.calculateCostEstimate(
        CostEstimateInput(
          partySize: int.parse(_partySizeController.text.trim()),
          ticketPricePerPerson: int.parse(_ticketController.text.trim()),
          mealBudgetPerPerson: int.parse(_mealController.text.trim()),
          parkingCost: int.parse(_parkingController.text.trim()),
          lockerUnitPrice: int.parse(_lockerPriceController.text.trim()),
          lockerQuantity: int.parse(_lockerQuantityController.text.trim()),
          extraBudget: int.parse(_extraBudgetController.text.trim()),
        ),
      );
      setState(() {
        _estimate = estimate;
        _hasValidationError = false;
      });
    } on FormatException {
      _showValidationError();
    } on ArgumentError {
      _showValidationError();
    }
  }

  void _showValidationError() {
    setState(() {
      _estimate = null;
      _hasValidationError = true;
    });
  }

  String _formatWon(int value) {
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
    return '$formatted원';
  }
}
```

The screen contains no multiplication or total formulas.

- [ ] **Step 4: Run the focused widget tests and confirm GREEN**

Run: `flutter test test/features/cost_calculator/presentation/cost_calculator_screen_test.dart`

Expected: two tests pass.

- [ ] **Step 5: Commit the presentation slice**

```powershell
git add apps/mobile/lib/features/cost_calculator/presentation apps/mobile/test/features/cost_calculator/presentation
git commit -m "Add cost calculator screen"
```

### Task 3: Venue-List Entry Point and Full Verification

**Files:**
- Modify: `apps/mobile/lib/features/venue/presentation/venue_list_screen.dart`
- Modify: `apps/mobile/test/features/venue/presentation/venue_list_screen_test.dart`
- Modify: `apps/mobile/lib/features/cost_calculator/README.md`

**Interfaces:**
- Consumes: `CostCalculatorScreen` as a navigation destination.
- Produces: an AppBar `IconButton` with key `cost-calculator-button` that pushes the calculator screen.

- [ ] **Step 1: Write the failing navigation test**

Add to `venue_list_screen_test.dart`:

```dart
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
```

Import `CostCalculatorScreen` in the test.

- [ ] **Step 2: Run the venue widget test and confirm RED**

Run: `flutter test test/features/venue/presentation/venue_list_screen_test.dart`

Expected: the navigation test fails because the AppBar button is absent.

- [ ] **Step 3: Add the thin navigation action**

Import `CostCalculatorScreen` in `venue_list_screen.dart` and add this AppBar action without moving calculation state into the venue screen:

```dart
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
```

- [ ] **Step 4: Update the feature README**

Replace the README with:

```markdown
# cost_calculator

## 역할

- 인원과 선택 옵션 기준 예상 총비용을 계산한다.
- 정확하지 않은 값은 예상 금액임을 표시한다.

## 계산 규칙

- 티켓과 식비는 1인당 금액에 인원수를 곱한다.
- 주차비와 추가 예산은 방문 전체의 고정 금액이다.
- 락커 비용은 개당 금액에 수량을 곱한다.
- 인원수는 1 이상, 다른 금액과 수량은 0 이상 정수만 허용한다.

## 구조

- 계산과 검증은 `domain`에 둔다.
- 입력 상태, 금액 표시, 오류 문구는 `presentation`에 둔다.
- UI 구성과 이동 경로가 바뀌어도 계산 규칙을 변경하지 않는다.

## 제외 범위

- 영속화와 서버 API
- 결제와 실시간 가격 연동
- 위치 공유
```

- [ ] **Step 5: Run all mobile verification**

Run from `apps/mobile`:

```powershell
dart format --output=none --set-exit-if-changed lib test
flutter test
flutter analyze
```

Expected: formatting check exits zero, all tests pass, and analysis reports `No issues found!`.

- [ ] **Step 6: Review scope and commit implementation**

Run from the repository root:

```powershell
git status --short
git diff --check
git diff --stat
```

Confirm only issue #5 cost-calculator files, the venue-list navigation action/test, the approved plan, and no location-sharing files are changed. Then commit:

```powershell
git add apps/mobile/lib/features/cost_calculator/README.md apps/mobile/lib/features/venue/presentation/venue_list_screen.dart apps/mobile/test/features/venue/presentation/venue_list_screen_test.dart docs/superpowers/plans/2026-07-13-cost-calculator.md
git commit -m "Add cost calculator navigation"
```
