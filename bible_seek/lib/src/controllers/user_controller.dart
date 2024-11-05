import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

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

    final String uid = userCredential.user?.uid ?? '';

    // await saveUserToBackend(uid, googleAccount?.displayName ?? 'Unknown name',
    //     googleAccount?.email ?? 'no-email@example.com');

    return userCredential.user;
  }

  Future<void> saveUserToBackend(
      String uid, String displayName, String email) async {
    final response = await http.post(
      Uri.parse(
          'https://your-backend-url/api/users'), // Update with your API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'uid': uid,
        'displayName': displayName,
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save user');
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
