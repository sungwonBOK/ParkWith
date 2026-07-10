import 'deal_dto.dart';

class DealListResponseDto {
  const DealListResponseDto({
    required this.success,
    required this.data,
  });

  final bool success;
  final List<DealDto> data;

  factory DealListResponseDto.fromJson(Map<String, Object?> json) {
    final rawData = json['data'];
    return DealListResponseDto(
      success: json['success'] as bool? ?? false,
      data: rawData is List
          ? rawData
              .whereType<Map<String, Object?>>()
              .map(DealDto.fromJson)
              .toList(growable: false)
          : const [],
    );
  }
}
