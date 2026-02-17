import 'package:bible_seek/firebase_options.dart';
import 'package:bible_seek/src/colors.dart';
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

final _lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColor.kPrimary,
    brightness: Brightness.light,
    primary: AppColor.kPrimary,
  ),
  scaffoldBackgroundColor: AppColor.kBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColor.kBackground,
    foregroundColor: AppColor.kGrayscaleDark100,
  ),
  cardTheme: CardThemeData(
    color: AppColor.kWhite,
    surfaceTintColor: Colors.transparent,
  ),
);

final _darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColor.kPrimary,
    brightness: Brightness.dark,
    primary: AppColor.kPrimary,
    surface: const Color(0xFF2d2d2d),
  ),
  scaffoldBackgroundColor: const Color(0xFF2d2d2d),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF2d2d2d),
    foregroundColor: Color(0xFFe7e8eb),
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFF3d3d3d),
    surfaceTintColor: Colors.transparent,
  ),
  listTileTheme: const ListTileThemeData(
    textColor: Color(0xFFe7e8eb),
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _lightTheme,
      darkTheme: _darkTheme,
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
