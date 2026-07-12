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
