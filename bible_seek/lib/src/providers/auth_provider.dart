import 'package:bible_seek/src/api/authenticated_client.dart';
import 'package:bible_seek/src/config/config.dart';
import 'package:bible_seek/src/models/app_user.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Watches Firebase auth state. When user signs in/out, dependents refresh.
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Loads backend user via POST /api/auth/session with Bearer token.
/// Refreshes when auth state changes (sign-in/sign-out).
final currentUserProvider = FutureProvider.autoDispose<AppUser?>((ref) async {
  ref.watch(authStateProvider); // depend on auth state
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  // Wait for Firebase id token to be ready (avoids 401 race after sign-in).
  await user.getIdToken(true);
  await Future<void>.delayed(const Duration(milliseconds: 400));

  final dio = AuthenticatedDio(Dio()).dio;
  final response = await dio.post(
    '${AppConfig.currentHost}/api/auth/session',
    options: Options(
      headers: <String, String>{'Content-Type': 'application/json'},
    ),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception(
        'Failed to load session: ${response.statusCode} ${response.statusMessage}');
  }

  final data = response.data;
  if (data == null || data is! Map) {
    throw Exception('Invalid session response');
  }

  return AppUser.fromJson(Map<String, dynamic>.from(data));
});

/// PATCH /api/me to update name, bio, location. Invalidates currentUserProvider on success.
Future<void> updateProfile({
  required String name,
  String? bio,
  String? location,
}) async {
  final dio = AuthenticatedDio(Dio()).dio;
  final body = <String, dynamic>{
    'name': name,
    if (bio != null) 'bio': bio,
    if (location != null) 'location': location,
  };
  await dio.patch(
    '${AppConfig.currentHost}/api/me',
    data: body,
    options: Options(
      headers: <String, String>{'Content-Type': 'application/json'},
    ),
  );
}
