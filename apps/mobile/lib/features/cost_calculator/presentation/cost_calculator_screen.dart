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
    return '${formatted}원';
  }
}
