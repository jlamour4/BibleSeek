import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Local storage for recently opened topics. Max 10 items.
/// Uses SharedPreferences. Topic IDs are stored as strings.
class RecentTopicsStorage {
  static const String _key = 'recent_topics';
  static const int _maxRecents = 10;

  /// Returns recents in order (most recent first).
  static Future<List<({String id, String name})>> getRecents() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null || json.isEmpty) return [];

    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map((e) {
            if (e is Map && e['id'] != null && e['name'] != null) {
              return (id: e['id'] as String, name: e['name'] as String);
            }
            return null;
          })
          .whereType<({String id, String name})>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Adds or moves topic to front. Keeps max [_maxRecents] items.
  static Future<void> addRecent(String id, String name) async {
    var recents = await getRecents();
    recents = recents.where((r) => r.id != id).toList();
    recents.insert(0, (id: id, name: name));
    if (recents.length > _maxRecents) {
      recents = recents.take(_maxRecents).toList();
    }

    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(
      recents.map((r) => {'id': r.id, 'name': r.name}).toList(),
    );
    await prefs.setString(_key, json);
  }

  /// Clears all recents.
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
