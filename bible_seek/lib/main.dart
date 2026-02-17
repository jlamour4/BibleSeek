import 'package:bible_seek/firebase_options.dart';
import 'package:bible_seek/src/design/app_theme.dart';
import 'package:bible_seek/src/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/common.dart';
import 'src/home.dart';
import 'src/search.dart';
import 'src/topic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GoogleSignIn.instance.initialize();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      builder: (context, child) {
        final theme = Theme.of(context);

        return ProviderScope(
          overrides: [
            themeProvider.overrideWithValue(theme),
          ],
          child: child!,
        );
      },
      routes: {
        '/': (context) => MyHomePage(),
        // '/favorites': (context) => FavoritesPage(),
        '/search': (context) => SearchPage(),
        '/topic': (context) => TopicPage(),
        // '/verse': (context) => VersesPage(),
        '/login': (context) => SigninPage(),
        // '/messages': (context) => MessagingPage(),
      },
    );
  }
}
