import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
import 'package:watchball/features/subscription/screens/subscription_screen.dart';
import 'package:watchball/features/wallet/screens/select_users_screen.dart';
import 'package:watchball/features/watch/screens/findorinvite_watchers_screen.dart';
import 'package:watchball/features/watch/screens/invite_watchers_screen.dart';
import 'package:watchball/firebase/firebase_notification.dart';
import 'package:watchball/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watchball/utils/utils.dart';
import 'features/message/screens/message_screen.dart';
import 'features/onboarding/screens/forgot_password_screen.dart';
import 'features/story/screens/story_screen.dart';
import 'features/user/models/user.dart';
import 'features/watch/screens/stream_match_screen.dart';
import 'features/watch/screens/watch_info_screen.dart';
import 'firebase_options.dart';
import 'shared/models/private_key.dart';
import 'shared/providers/theme_provider.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/watch/screens/join_watch_screen.dart';
import 'features/watch/screens/watch_request_screen.dart';
import 'utils/ads_utils.dart';

String countryCode = "";
String countryDialCode = "";
late SharedPreferences sharedPreferences;
PrivateKey? privateKey;
Map<String, User?> usersMap = {};
Map<String, dynamic> phoneContactsMap = {};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  if (!kIsWeb && !isAndroidAndIos) {
    DartVLC.initialize();
  }

  await Hive.initFlutter();
  await Hive.openBox<String>("users");
  await Hive.openBox<String>("contacts");
  await Hive.openBox<String>("watchers");
  await Hive.openBox<String>("details");
  //await Hive.openBox<String>("stories");
  //await Hive.openBox<String>("messages");
  //await Hive.openBox<String>("matches");
  await Hive.openBox<String>("watchs");
  Hive.box<String>("users").clear();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //privateKey = await getPrivateKey();
  await dotenv.load(fileName: ".env");

  if (!kIsWeb && Platform.isWindows) {
    //await GoogleSignInDart
  }
  if (isAndroidAndIos) {
    await MobileAds.instance.initialize();
    AdUtil().initializeAd();
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  FirebaseNotification().initNotification();

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
      title: "Watch Ball",
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
        ForgotPasswordScreen.route: (_) => const ForgotPasswordScreen(),
        MainScreen.route: (_) => const MainScreen(),
        SettingsAndMoreScreen.route: (_) => const SettingsAndMoreScreen(),
        SubscriptionScreen.route: (_) => const SubscriptionScreen(),
        StreamMatchScreen.route: (_) => const StreamMatchScreen(),
        WatchRequestScreen.route: (_) => const WatchRequestScreen(),
        FindOrInviteWatchersScreen.route: (_) =>
            const FindOrInviteWatchersScreen(),
        InviteWatchersScreen.route: (_) => const InviteWatchersScreen(),
        JoinWatchScreen.route: (_) => const JoinWatchScreen(),
        WatchInfoScreen.route: (_) => const WatchInfoScreen(),
        MatchPaymentScreen.route: (_) => const MatchPaymentScreen(),
        SelectedUsersScreen.route: (_) => const SelectedUsersScreen(),
        MessageScreen.route: (_) => const MessageScreen(),
        StoryScreen.route: (_) => const StoryScreen(),
      },
    );
  }
}
