import 'package:bible_seek/firebase_options.dart';
import 'package:bible_seek/src/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/common.dart';
import 'src/home.dart';
import 'src/search.dart';
import 'src/topic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF2d2d2d),
      ),
      builder: (context, child) {
        final theme = Theme.of(context);

        return ProviderScope(
          overrides: [
            /// We override "themeProvider" with a valid theme instance.
            /// This allows providers such as "tagThemeProvider" to read the
            /// current theme, without having a BuildContext.
            themeProvider.overrideWithValue(theme),
          ],
          child: ListTileTheme(
            textColor: const Color(0xFFe7e8eb),
            child: child!,
          ),
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
