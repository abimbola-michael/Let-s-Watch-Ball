import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../shared/views/loading_overlay.dart';
import '../components/social.dart';
import '../../../shared/components/app_container.dart';
import '../../../shared/components/app_text_button.dart';
import '../../../shared/components/button.dart';
import '../../../firebase/auth_methods.dart';
import '../../user/services/user_service.dart';
import '../../../utils/utils.dart';
import '../../main/screens/main_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const route = "/welcome";

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool loading = false;
  final authMethods = AuthMethods();

  void siginInWithGoogle() async {
    try {
      final result = await authMethods.signInWithGoogle();
      if (result == null || result.user == null) return;
      if (result.additionalUserInfo?.isNewUser ?? false) {
        final user = result.user!;
        String username =
            user.displayName?.toLowerCase().replaceAll(" ", "_") ??
                user.email?.substring(0, user.email!.indexOf("@")) ??
                "";
        while (await usernameExists(username)) {
          username += Random().nextInt(10).toString();
        }
        await createUser(
            user.uid,
            user.email ?? "",
            username,
            user.displayName ?? "",
            user.phoneNumber ?? "",
            user.photoURL ?? "");
      }
      if (!mounted) return;
      context.pushNamedAndPop(MainScreen.route);
    } on FirebaseException catch (e) {
      if (!mounted) return;
      context.showSnackBar(e.message ?? "");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        loading: loading,
        child: AppContainer(
          color: black,
          //image: const AssetImage("assets/images/png/mask.png"),
          //  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Stack(
            children: [
              // Positioned(
              //   top: statusBarHeight + 20,
              //   right: 20,
              //   child: const AppButton(
              //     fontSize: 12,
              //     title: "Skip",
              //     color: darkBlack,
              //   ),
              // ),
              Positioned(
                top: 150,
                left: 40,
                right: 40,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 45,
                      child: Text(
                        "Welcome",
                        style: context.headlineLarge?.copyWith(color: white),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: Text.rich(
                        TextSpan(
                          text: "to ",
                          style: context.headlineMedium?.copyWith(color: white),
                          children: [
                            TextSpan(
                              text: "Watch Ball",
                              style: context.headlineMedium
                                  ?.copyWith(color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Together we watch",
                      style: context.bodyMedium?.copyWith(color: white),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 30,
                left: 30,
                right: 30,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: white.withOpacity(0.5),
                            thickness: 1,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          "sign in with",
                          style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Divider(
                            color: white.withOpacity(0.5),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (!isWindows)
                      Row(
                        children: [
                          // Social(title: "FACEBOOK", icon: IonIcons.logo_facebook),
                          // SizedBox(width: 20),
                          Social(
                            title: "GOOGLE",
                            icon: IonIcons.logo_google,
                            onPressed: siginInWithGoogle,
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Button(
                      height: 50,
                      color: lightestWhite,
                      borderColor: white,
                      borderRadius: BorderRadius.circular(25),
                      child: const Text(
                        "Start with email",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: white,
                        ),
                      ),
                      onPressed: () {
                        context.pushNamedAndPop(SignupScreen.route);
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        AppTextButton(
                          text: "Login",
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            // decoration: TextDecoration.underline,
                            // decorationColor: primaryColor,
                          ),
                          onPressed: () {
                            //context.pushNamedTo(MainScreen.route);
                            context.pushNamedAndPop(LoginScreen.route);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
