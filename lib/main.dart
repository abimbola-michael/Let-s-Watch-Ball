import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchball/screens/main_screen.dart';
import 'package:watchball/screens/match/match_info_screen.dart';
import 'package:watchball/screens/settings/settings_and_more_screen.dart';
import 'package:watchball/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'providers/theme_provider.dart';

late SharedPreferences sharedPreferences;

const baseUrl = "http://75.119.146.90:8009/swagger";
final dio = Dio(
  BaseOptions(
      baseUrl: baseUrl,
      // connectTimeout: const Duration(seconds: 5),
      // receiveTimeout: const Duration(seconds: 3),
      // sendTimeout: const Duration(seconds: 3),
      followRedirects: true
      // validateStatus: (status) {
      //   return status != null && status < 500;
      // }),
      ),
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: "Let's Watch Ball",
      themeMode: theme == "light" ? ThemeMode.light : ThemeMode.dark,
      darkTheme: darkThemeData,
      theme: lightThemeData,
      initialRoute: MainScreen.route,
      routes: {
        MainScreen.route: (_) => const MainScreen(),
        SettingsAndMoreScreen.route: (_) => const SettingsAndMoreScreen(),
        MatchInfoScreen.route: (_) => const MatchInfoScreen(),
      },
    );
  }
}
