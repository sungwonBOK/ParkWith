import '../domain/venue.dart';
import 'venue_dto.dart';
import 'venue_list_response_dto.dart';

class VenueDetailResponseDto {
  const VenueDetailResponseDto({
    required this.venue,
  });

  factory VenueDetailResponseDto.fromJson(Map<String, Object?> json) {
    if (json['success'] == false && _isVenueNotFound(json['error'])) {
      return const VenueDetailResponseDto(venue: null);
    }

    if (json['success'] != true) {
      throw const VenueApiException('Venue could not be loaded.');
    }

    final data = json['data'];
    if (data is Map<String, Object?>) {
      return VenueDetailResponseDto(
        venue: VenueDto.fromJson(data),
      );
    }

    throw const VenueApiException('Venue could not be loaded.');
  }

  final VenueDto? venue;

  Venue? toDomain() {
    return venue?.toDomain();
  }

  static bool _isVenueNotFound(Object? error) {
    if (error is! Map<String, Object?>) {
      return false;
    }

    return error['code'] == 'VENUE_NOT_FOUND';
  }
}
