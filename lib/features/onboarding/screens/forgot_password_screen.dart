import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/features/main/screens/main_screen.dart';
import 'package:watchball/features/onboarding/screens/signup_screen.dart';
import 'package:watchball/firebase/auth_methods.dart';
import 'package:watchball/features/user/services/user_service.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../shared/views/loading_overlay.dart';
import '../../../shared/components/logo.dart';
import '../components/social.dart';
import '../../../shared/components/app_button.dart';
import '../../../shared/components/app_text_button.dart';
import '../../../shared/components/app_text_field.dart';
import '../../../theme/colors.dart';
import '../../../utils/utils.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const route = "/forgot-password";

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final authMethods = AuthMethods();

  final _emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void resetPassword() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      final email = _emailController.text.trim();

      //await Future.delayed(const Duration(seconds: 2));
      try {
        await authMethods.sendPasswordResetEmail(email);

        if (!mounted) return;

        context.showSnackBar(
            "Password Reset Email sent. Check your mail", false);
        if (!mounted) return;

        context.pushNamedAndPop(LoginScreen.route);
        //context.pushNamedTo(VerifyNumberScreen.route, args: {"email": email});
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

  void gotoLogin() {
    context.pushNamedAndPop(LoginScreen.route);
  }

  void gotoSignUp() {
    context.pushNamedAndPop(SignupScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        loading: loading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: statusBarHeight + 180,
                    ),
                    Text("Forgot Password",
                        style: context.headlineLarge?.copyWith(fontSize: 36)),
                    const SizedBox(height: 30),
                    AppTextField(
                      hintText: "Email",
                      controller: _emailController,
                    ),
                    AppButton(
                      width: double.infinity,
                      title: "Reset",
                      onPressed: resetPassword,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppTextButton(
                          text: "Sign Up",
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          onPressed: gotoSignUp,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "|",
                          style: TextStyle(
                            color: lightTint,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 10),
                        AppTextButton(
                          text: "Login",
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          onPressed: gotoLogin,
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
