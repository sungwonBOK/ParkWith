abstract interface class LocationEngine {
  Future<LocationPermissionState> getPermissionState();

  Future<LocationPermissionState> requestPermission();

  Stream<LocationReading> watchLocation(LocationWatchOptions options);

  Future<void> stop();
}

enum LocationPermissionState {
  unknown,
  granted,
  denied,
  permanentlyDenied,
}

class LocationReading {
  const LocationReading({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.capturedAt,
  });

  final double latitude;
  final double longitude;
  final int accuracyMeters;
  final DateTime capturedAt;
}

class LocationWatchOptions {
  const LocationWatchOptions({
    required this.updateInterval,
    required this.highAccuracy,
  });

  final Duration updateInterval;
  final bool highAccuracy;
}

