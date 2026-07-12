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
