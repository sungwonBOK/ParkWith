class ApiConfig {
  const ApiConfig({
    required this.baseUrl,
  });

  factory ApiConfig.fromEnvironment() {
    return const ApiConfig(
      baseUrl: String.fromEnvironment(
        'PARKWITH_API_BASE_URL',
        defaultValue: 'http://10.0.2.2:3000',
      ),
    );
  }

  final String baseUrl;

  Uri get baseUri {
    final uri = Uri.parse(baseUrl);
    if (!uri.hasScheme || uri.host.isEmpty) {
      throw const FormatException('API base URL must include scheme and host.');
    }
    return uri;
  }
}
