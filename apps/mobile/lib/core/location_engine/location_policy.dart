enum LocationSharingMode {
  off,
  mapVisible,
  findingFriends,
  background,
  batterySaver,
  stopped,
}

class LocationPolicy {
  const LocationPolicy();

  LocationUpdatePolicy resolve({
    required LocationSharingMode mode,
    required int batteryPercent,
  }) {
    if (mode == LocationSharingMode.stopped || mode == LocationSharingMode.off) {
      return const LocationUpdatePolicy.disabled();
    }

    if (batteryPercent <= 20 || mode == LocationSharingMode.batterySaver) {
      return const LocationUpdatePolicy.enabled(
        updateInterval: Duration(minutes: 2),
        highAccuracy: false,
      );
    }

    if (mode == LocationSharingMode.findingFriends) {
      return const LocationUpdatePolicy.enabled(
        updateInterval: Duration(seconds: 10),
        highAccuracy: true,
      );
    }

    if (mode == LocationSharingMode.mapVisible) {
      return const LocationUpdatePolicy.enabled(
        updateInterval: Duration(seconds: 30),
        highAccuracy: false,
      );
    }

    return const LocationUpdatePolicy.enabled(
      updateInterval: Duration(minutes: 1),
      highAccuracy: false,
    );
  }
}

class LocationUpdatePolicy {
  const LocationUpdatePolicy.enabled({
    required this.updateInterval,
    required this.highAccuracy,
  }) : enabled = true;

  const LocationUpdatePolicy.disabled()
      : enabled = false,
        updateInterval = Duration.zero,
        highAccuracy = false;

  final bool enabled;
  final Duration updateInterval;
  final bool highAccuracy;
}

