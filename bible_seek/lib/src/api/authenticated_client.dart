import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticatedDio {
  final Dio _dio;

  AuthenticatedDio(this._dio) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final user = FirebaseAuth.instance.currentUser;

        // Add the Bearer token if the user is authenticated
        if (user != null) {
          final idToken = await user.getIdToken();
          options.headers['Authorization'] = 'Bearer $idToken';
        }

        // Proceed with the original request
        return handler.next(options);
      },
    ));
  }

  Dio get dio => _dio;
}
