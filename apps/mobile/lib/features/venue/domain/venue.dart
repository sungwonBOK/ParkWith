enum VenueCategory {
  waterPark,
  amusementPark,
}

class Venue {
  const Venue({
    required this.id,
    required this.name,
    required this.nameKo,
    required this.category,
    required this.region,
    required this.description,
  });

  final String id;
  final String name;
  final String nameKo;
  final VenueCategory category;
  final String region;
  final String description;

  String get categoryLabel {
    return switch (category) {
      VenueCategory.waterPark => 'Water park',
      VenueCategory.amusementPark => 'Amusement park',
    };
  }
}
