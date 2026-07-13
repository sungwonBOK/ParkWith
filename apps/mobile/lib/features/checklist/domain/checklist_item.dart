class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.label,
    this.isCompleted = false,
  });

  final String id;
  final String label;
  final bool isCompleted;

  ChecklistItem copyWith({bool? isCompleted}) {
    return ChecklistItem(
      id: id,
      label: label,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
