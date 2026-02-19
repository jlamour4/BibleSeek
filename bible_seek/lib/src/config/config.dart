class AppConfig {
  static const String localHost = 'http://192.168.1.169:8080';
  static const String devHost = 'https://dev.yourapp.com';
  static const String prodHost = 'https://api.yourapp.com';

  // Set this to switch environments
  static const String currentHost = localHost;

  /// Path for saved/favorited verses. GET /api/me/favorites → List<TopicVerseItemDto>
  static const String savedVersesPath = '/api/me/favorites';
}
