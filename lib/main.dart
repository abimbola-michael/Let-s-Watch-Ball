import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
//import 'package:flutter_timezone_plus/flutter_timezone_plus.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';
import 'package:watchball/features/main/screens/main_screen.dart';
import 'package:watchball/features/onboarding/screens/login_screen.dart';
import 'package:watchball/features/onboarding/screens/signup_screen.dart';
import 'package:watchball/features/onboarding/screens/welcome_screen.dart';
import 'package:watchball/features/payment/screens/match_payment_screen.dart';
import 'package:watchball/features/settings/screens/settings_and_more_screen.dart';
import 'package:watchball/features/wallet/screens/select_users_screen.dart';
import 'package:watchball/features/watch/screens/invite_watchers_screen.dart';
import 'package:watchball/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'shared/providers/theme_provider.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/watch/screens/join_watch_screen.dart';
import 'features/watch/screens/watch_match_request_screen.dart';
import 'features/watch/screens/watch_match_screen.dart';
import 'features/watch/screens/watchers_screen.dart';
import 'features/watch/services/live_stream_service.dart';

late SharedPreferences sharedPreferences;
//String? currentTimeZone;

//const baseUrl = "http://75.119.146.90:8009/swagger";
// final dio = Dio(
//   BaseOptions(
//       //baseUrl: baseUrl,
//       // connectTimeout: const Duration(seconds: 5),
//       // receiveTimeout: const Duration(seconds: 3),
//       // sendTimeout: const Duration(seconds: 3),
//       followRedirects: true
//       // validateStatus: (status) {
//       //   return status != null && status < 500;
//       // }),
//       ),
// );
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();

  await Hive.initFlutter();
  await Hive.openBox("user");
  await Hive.openBox("users");
  await Hive.openBox("contacts");
  await Hive.openBox("stories");
  await Hive.openBox("messages");
  await Hive.openBox("matches");
  await Hive.openBox("invites");
  await Hive.openBox("watcheds");
  await Hive.openBox("lastTimes");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class NavigateBackIntent extends Intent {}

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
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.backspace): NavigateBackIntent(),
      },
      actions: {
        NavigateBackIntent: CallbackAction(
          onInvoke: (Intent intent) {
            navigatorKey.currentState?.pop();
            return null;
          },
        ),
      },
      // initialRoute: FirebaseAuth.instance.currentUser == null
      //     ? OnboardingScreen.route
      //     : MainScreen.route,
      initialRoute: OnboardingScreen.route,
      routes: {
        OnboardingScreen.route: (_) => const OnboardingScreen(),
        WelcomeScreen.route: (_) => const WelcomeScreen(),
        LoginScreen.route: (_) => const LoginScreen(),
        SignupScreen.route: (_) => const SignupScreen(),
        MainScreen.route: (_) => const MainScreen(),
        SettingsAndMoreScreen.route: (_) => const SettingsAndMoreScreen(),
        WatchMatchScreen.route: (_) => const WatchMatchScreen(),
        WatchMatchRequestScreen.route: (_) => const WatchMatchRequestScreen(),
        InviteWatchersScreen.route: (_) => const InviteWatchersScreen(),
        JoinWatchScreen.route: (_) => const JoinWatchScreen(),
        MatchPaymentScreen.route: (_) => const MatchPaymentScreen(),
        SelectedUsersScreen.route: (_) => const SelectedUsersScreen(),
      },
    );
  }
}
