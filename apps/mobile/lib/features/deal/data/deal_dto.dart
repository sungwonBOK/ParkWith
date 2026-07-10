import '../domain/deal.dart';

class DealDto {
  const DealDto({
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
  final String lastUpdatedAt;

  factory DealDto.fromJson(Map<String, Object?> json) {
    return DealDto(
      id: json['id'] as String,
      venueId: json['venueId'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      discountText: json['discountText'] as String,
      sourceUrl: json['sourceUrl'] as String,
      lastUpdatedAt: json['lastUpdatedAt'] as String,
    );
  }

  Deal toDomain() {
    return Deal(
      id: id,
      venueId: venueId,
      title: title,
      summary: summary,
      discountText: discountText,
      sourceUrl: sourceUrl,
      lastUpdatedAt: DateTime.parse(lastUpdatedAt),
    );
  }
}
