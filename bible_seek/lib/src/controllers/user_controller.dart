import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bible_seek/src/api/authenticated_client.dart';
import 'package:dio/dio.dart';
import '../config/config.dart';

class UserController {
  static User? user = FirebaseAuth.instance.currentUser;

  Future<User?> loginWithGoogle() async {
    final GoogleSignInAccount? googleAccount = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleAccount?.authentication;

    // signing in with firebase auth
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    await saveUserToBackend(user);

    return userCredential.user;
  }

  Future<void> saveUserToBackend(User? user) async {
    final dio = AuthenticatedDio(Dio()).dio;

    if (user == null) {
      print("User is null, skipping save.");
      return;
    }

    final uid = user.uid;
    final displayName = user.displayName ?? '';
    final email = user.email ?? '';
    final profilePictureUrl = user.photoURL ?? '';

    // Extract the auth provider
    String authProvider = user.providerData.isNotEmpty
        ? user.providerData.first.providerId
        : 'firebase';

    // Map Firebase provider IDs to your own values
    if (authProvider == 'google.com') authProvider = 'google';
    if (authProvider == 'facebook.com') authProvider = 'facebook';
    if (authProvider == 'password') authProvider = 'email';

    final response = await dio.post(
      '${AppConfig.currentHost}/api/users',
      options: Options(
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      ),
      data: jsonEncode(<String, dynamic>{
        'username': uid,
        'name': displayName,
        'email': email,
        'profilePictureUrl': profilePictureUrl,
        'authProvider': authProvider,
        'authProviderId': uid,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Failed to save user: ${response.statusCode} ${response.statusMessage}');
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
