class Deal {
  const Deal({
    required this.id,
    required this.venueId,
    required this.title,
    required this.summary,
    required this.discountText,
    required this.sourceUrl,
    required this.lastUpdatedAt,
  });

  final String id;
  final String venueId;
  final String title;
  final String summary;
  final String discountText;
  final String sourceUrl;
  final DateTime lastUpdatedAt;
}
