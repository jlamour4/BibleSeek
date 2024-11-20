import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AuthenticatedClient extends http.BaseClient {
  final http.Client _inner;

  AuthenticatedClient(this._inner);

  // Override the send method to intercept and add the Bearer token
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final user = FirebaseAuth.instance.currentUser;

    // Add the Bearer token if the user is authenticated
    if (user != null) {
      final idToken = await user.getIdToken();
      request.headers['Authorization'] = 'Bearer $idToken';
    }

    // Proceed with the original request
    return _inner.send(request);
  }
}
