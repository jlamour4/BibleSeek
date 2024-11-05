// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCKaXN7gjAOaCEiKJlx4VoarTt5noUdeWI',
    appId: '1:580469799823:web:736f766bcb2469c32de9fa',
    messagingSenderId: '580469799823',
    projectId: 'bibleseek-3ade5',
    authDomain: 'bibleseek-3ade5.firebaseapp.com',
    databaseURL: 'https://bibleseek-3ade5-default-rtdb.firebaseio.com',
    storageBucket: 'bibleseek-3ade5.firebasestorage.app',
    measurementId: 'G-J9GQGBFQ0D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB8oA7dJHysH8xyI63VZviFGDpvzhqDqhc',
    appId: '1:580469799823:android:670dbd860feccdeb2de9fa',
    messagingSenderId: '580469799823',
    projectId: 'bibleseek-3ade5',
    databaseURL: 'https://bibleseek-3ade5-default-rtdb.firebaseio.com',
    storageBucket: 'bibleseek-3ade5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD589p81sT8epXmwB9fUZRl47Wp3vYkIeY',
    appId: '1:580469799823:ios:5d4a9f00489f32bb2de9fa',
    messagingSenderId: '580469799823',
    projectId: 'bibleseek-3ade5',
    databaseURL: 'https://bibleseek-3ade5-default-rtdb.firebaseio.com',
    storageBucket: 'bibleseek-3ade5.firebasestorage.app',
    iosClientId:
        '580469799823-3mcu495l5h77fdaqjg7scr1ia2nfbh2s.apps.googleusercontent.com',
    iosBundleId: 'com.example.bibleSeek',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD589p81sT8epXmwB9fUZRl47Wp3vYkIeY',
    appId: '1:580469799823:ios:5d4a9f00489f32bb2de9fa',
    messagingSenderId: '580469799823',
    projectId: 'bibleseek-3ade5',
    databaseURL: 'https://bibleseek-3ade5-default-rtdb.firebaseio.com',
    storageBucket: 'bibleseek-3ade5.firebasestorage.app',
    iosClientId:
        '580469799823-3mcu495l5h77fdaqjg7scr1ia2nfbh2s.apps.googleusercontent.com',
    iosBundleId: 'com.example.bibleSeek',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCL1H-JR-WhomH4s2adpxmJpON3xJqrn1Y',
    appId: '1:580469799823:web:ee82d8e91545635e2de9fa',
    messagingSenderId: '580469799823',
    projectId: 'bibleseek-3ade5',
    authDomain: 'bibleseek-3ade5.firebaseapp.com',
    databaseURL: 'https://bibleseek-3ade5-default-rtdb.firebaseio.com',
    storageBucket: 'bibleseek-3ade5.firebasestorage.app',
    measurementId: 'G-9TZ2K0KJ42',
  );
}