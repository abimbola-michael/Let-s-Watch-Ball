import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/shared/components/app_alert_dialog.dart';
import 'package:watchball/features/main/screens/main_screen.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../firebase/firebase_notification.dart';
import '../../../shared/views/loading_overlay.dart';
import '../../../shared/components/logo.dart';
import '../components/social.dart';
import '../../../shared/components/app_button.dart';
import '../../../shared/components/app_text_button.dart';
import '../../../shared/components/app_text_field.dart';
import '../../../firebase/auth_methods.dart';
import '../../user/services/user_service.dart';
import '../../../utils/utils.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static const route = "/login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthMethods authMethods = AuthMethods();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  void dispose() {
    // TODO: implement dispose

    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void gotoSignUp() {
    context.pushNamedAndPop(SignupScreen.route);
  }

  void gotoForgotPassword() {
    context.pushNamedAndPop(ForgotPasswordScreen.route);
  }

  void gotoNext() {
    if (formKey.currentState!.validate()) {
      //context.pushNamedTo(EnterAddressScreen.route);
    }
  }

  void loginToApp() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      //await Future.delayed(const Duration(seconds: 2));

      try {
        final result = await authMethods.login(email, password);
        if (!mounted) return;

        if (result.user != null) {
          if (result.user!.emailVerified) {
            FirebaseNotification().updateFirebaseToken();
            context.pushNamedAndPop(MainScreen.route);
          } else {
            context.showAlertDialog((context) {
              return AppAlertDialog(
                title: "Verify Email",
                message:
                    "Your email is not verified. Check your email or Resend if not found or exprired",
                actions: const ["Close", "Resend"],
                onPresseds: [
                  () {
                    context.pop();
                  },
                  () async {
                    authMethods.sendEmailVerification().then((_) {
                      context.showSnackBar(
                          "Verification Email sent. Check your mail", false);
                    });
                    context.pop();
                  }
                ],
              );
            });
          }
        } else {}
      } on FirebaseException catch (e) {
        if (!mounted) return;
        context.showSnackBar(e.message ?? "");
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }

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
      extendBody: true,
      body: Stack(
        children: [
          // Positioned(
          //   top: statusBarHeight + 20,
          //   right: 5,
          //   child: const Opacity(
          //     opacity: 0.1,
          //     child: Logo(),
          //   ),
          // ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: statusBarHeight + 150,
                      ),
                      Text("Login",
                          style: context.headlineLarge?.copyWith(fontSize: 36)),
                      const SizedBox(
                        height: 20,
                      ),
                      AppTextField(
                        hintText: "Email",
                        controller: _emailController,
                      ),
                      AppTextField(
                        hintText: "Password",
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 10),
                      AppButton(
                        width: double.infinity,
                        title: "Login",
                        onPressed: loginToApp,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: lightTint,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          AppTextButton(
                            text: "Sign Up",
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            onPressed: gotoSignUp,
                          ),
                        ],
                      ),
                      Center(
                        child: AppTextButton(
                          text: "Forgot Password",
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                          onPressed: gotoForgotPassword,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: lightestBlack,
                              thickness: 1,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "Sign up with",
                            style: TextStyle(
                              color: lightBlack,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Divider(
                              color: lightestBlack,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      if (!isWindows)
                        Row(
                          children: [
                            // Social(
                            //     title: "FACEBOOK", icon: IonIcons.logo_facebook),
                            // SizedBox(width: 20),
                            Social(
                              title: "GOOGLE",
                              icon: IonIcons.logo_google,
                              onPressed: siginInWithGoogle,
                            ),
                          ],
                        ),
                      const SizedBox(height: 60),
                    ]),
              ),
            ),
          ),
          if (loading) const LoadingOverlay()
        ],
      ),
    );
  }
}
