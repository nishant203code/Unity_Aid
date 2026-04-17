import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/news_feed/news_feed_page.dart';
import 'screens/ngo_home/ngo_dashboard_page.dart';
import 'screens/home/home_page.dart';
import 'screens/create_post/create_post_page.dart';
import 'screens/ngo_search/ngo_search_page.dart';
import 'screens/donate/donate_page.dart';
import 'screens/settings/settings_page.dart';
import 'widgets/theme/theme_provider.dart';
import 'widgets/theme/app_colors.dart';

const bool _useFirebaseEmulators = bool.fromEnvironment(
  'USE_FIREBASE_EMULATORS',
  defaultValue: false,
);

const String _emulatorHost = String.fromEnvironment(
  'FIREBASE_EMULATOR_HOST',
  defaultValue: '127.0.0.1',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Already initialized on hot restart — safe to ignore
  }

  if (_useFirebaseEmulators) {
    // Toggle with --dart-define at runtime, avoiding code edits between local and prod runs.
    FirebaseAuth.instance.useAuthEmulator(_emulatorHost, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(_emulatorHost, 8080);
    FirebaseStorage.instance.useStorageEmulator(_emulatorHost, 9199);
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const UnityAidApp(),
    ),
  );
}

class UnityAidApp extends StatelessWidget {
  const UnityAidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'UnityAid',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.red,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.background,
            fontFamily: 'Roboto',
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            cardColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              secondary: AppColors.primary,
              surface: Colors.white,
              onPrimary: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(color: Colors.black87),
              displayMedium: TextStyle(color: Colors.black87),
              displaySmall: TextStyle(color: Colors.black87),
              headlineLarge: TextStyle(color: Colors.black87),
              headlineMedium: TextStyle(color: Colors.black87),
              headlineSmall: TextStyle(color: Colors.black87),
              titleLarge: TextStyle(color: Colors.black87),
              titleMedium: TextStyle(color: Colors.black87),
              titleSmall: TextStyle(color: Colors.black87),
              bodyLarge: TextStyle(color: Colors.black87),
              bodyMedium: TextStyle(color: Colors.black87),
              bodySmall: TextStyle(color: Colors.black54),
              labelLarge: TextStyle(color: Colors.black87),
              labelMedium: TextStyle(color: Colors.black87),
              labelSmall: TextStyle(color: Colors.black54),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.red,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.darkBackground,
            fontFamily: 'Roboto',
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.darkNavBar,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            cardColor: AppColors.darkCard,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              secondary: AppColors.primary,
              surface: AppColors.darkCard,
              onSurface: Colors.white,
              onPrimary: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(color: Colors.white),
              displayMedium: TextStyle(color: Colors.white),
              displaySmall: TextStyle(color: Colors.white),
              headlineLarge: TextStyle(color: Colors.white),
              headlineMedium: TextStyle(color: Colors.white),
              headlineSmall: TextStyle(color: Colors.white),
              titleLarge: TextStyle(color: Colors.white),
              titleMedium: TextStyle(color: Colors.white),
              titleSmall: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              bodySmall: TextStyle(color: AppColors.darkTextSecondary),
              labelLarge: TextStyle(color: Colors.white),
              labelMedium: TextStyle(color: Colors.white),
              labelSmall: TextStyle(color: AppColors.darkTextSecondary),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            listTileTheme: const ListTileThemeData(
              textColor: Colors.white,
              iconColor: Colors.white,
            ),
            dividerColor: Colors.white24,
          ),
          home: const SplashScreen(),
          routes: {
            '/userHome': (_) => const HomePage(isNGO: false),
            '/ngoHome': (_) => const HomePage(isNGO: true),
            '/news': (_) => const NewsFeedPage(),
            '/dashboard': (_) => const NGODashboardPage(),
            '/post': (_) => const CreatePostPage(),
            '/ngos': (_) => const NGOSearchPage(),
            '/donate': (_) => const DonatePage(),
            '/settings': (_) => const SettingsPage(),
          },
        );
      },
    );
  }
}
