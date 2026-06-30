import '../domain/venue.dart';
import 'venue_dto.dart';

class VenueListResponseDto {
  const VenueListResponseDto({
    required this.venues,
  });

  factory VenueListResponseDto.fromJson(Map<String, Object?> json) {
    if (json['success'] != true) {
      throw const VenueApiException('Venue list could not be loaded.');
    }

    final data = json['data'];
    if (data is! List) {
      throw const VenueApiException('Venue list could not be loaded.');
    }

    return VenueListResponseDto(
      venues: data.map(_venueFromJson).toList(growable: false),
    );
  }

  final List<VenueDto> venues;

  List<Venue> toDomainList() {
    return venues.map((venue) => venue.toDomain()).toList(growable: false);
  }

  static VenueDto _venueFromJson(Object? value) {
    if (value is Map<String, Object?>) {
      return VenueDto.fromJson(value);
    }

    throw const VenueApiException('Venue list could not be loaded.');
  }
}

class VenueApiException implements Exception {
  const VenueApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
