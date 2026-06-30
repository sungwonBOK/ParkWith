import '../domain/venue.dart';

class VenueDto {
  const VenueDto({
    required this.id,
    required this.name,
    required this.nameKo,
    required this.category,
    required this.region,
    required this.description,
  });

  factory VenueDto.fromJson(Map<String, Object?> json) {
    return VenueDto(
      id: json['id'] as String,
      name: json['name'] as String,
      nameKo: json['nameKo'] as String,
      category: json['category'] as String,
      region: json['region'] as String,
      description: json['description'] as String,
    );
  }

  final String id;
  final String name;
  final String nameKo;
  final String category;
  final String region;
  final String description;

  Venue toDomain() {
    return Venue(
      id: id,
      name: name,
      nameKo: nameKo,
      category: _categoryFromApiValue(category),
      region: region,
      description: description,
    );
  }

  VenueCategory _categoryFromApiValue(String value) {
    return switch (value) {
      'water_park' => VenueCategory.waterPark,
      'amusement_park' => VenueCategory.amusementPark,
      _ => throw ArgumentError.value(value, 'category', 'Unknown venue category'),
    };
  }
}
