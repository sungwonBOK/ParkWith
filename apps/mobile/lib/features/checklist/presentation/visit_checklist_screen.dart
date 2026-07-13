import 'package:flutter/material.dart';

import '../../venue/domain/venue.dart';
import '../domain/checklist_item.dart';
import '../domain/use_cases/get_visit_checklist_template.dart';
import '../domain/use_cases/toggle_checklist_item.dart';

class VisitChecklistScreen extends StatefulWidget {
  const VisitChecklistScreen({
    required this.venueName,
    required this.category,
    this.getTemplate = const GetVisitChecklistTemplate(),
    this.toggleItem = const ToggleChecklistItem(),
    super.key,
  });

  final String venueName;
  final VenueCategory category;
  final GetVisitChecklistTemplate getTemplate;
  final ToggleChecklistItem toggleItem;

  @override
  State<VisitChecklistScreen> createState() => _VisitChecklistScreenState();
}

class _VisitChecklistScreenState extends State<VisitChecklistScreen> {
  late List<ChecklistItem> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.getTemplate(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _items.where((item) => item.isCompleted).length;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.venueName} 방문 준비')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '준비 완료 $completedCount/${_items.length}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final item in _items)
            CheckboxListTile(
              key: Key('checklist-item-${item.id}'),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(item.label),
              value: item.isCompleted,
              onChanged: (_) {
                setState(() {
                  _items = widget.toggleItem(_items, item.id);
                });
              },
            ),
        ],
      ),
    );
  }
}
