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
