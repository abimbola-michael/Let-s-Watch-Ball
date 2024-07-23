import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/features/main/screens/main_screen.dart';
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

class SignupScreen extends StatefulWidget {
  static const route = "/signup";

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final authMethods = AuthMethods();
  final _usernameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signUp() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final username = _usernameController.text.trim();
      final phoneNumber = _phoneNumberController.text.trim();

      //await Future.delayed(const Duration(seconds: 2));
      try {
        final result = await authMethods.createAccount(email, password);
        if (result.user == null) return;
        await createUser(result.user!.uid, email, username, phoneNumber, "");
        // await signup(email, password, firstName, lastName);
        await authMethods.sendEmailVerification();
        if (!mounted) return;

        context.showSnackBar("Verification Email sent. Check your mail", false);
        await authMethods.logOut();
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

  void siginInWithGoogle() async {
    try {
      final result = await authMethods.signInWithGoogle();
      if (result == null || result.user == null) return;
      if (result.additionalUserInfo?.isNewUser ?? false) {
        final user = result.user!;
        await createUser(user.uid, user.email ?? "", user.displayName ?? "",
            user.phoneNumber ?? "", user.photoURL ?? "");
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
      body: Stack(
        children: [
          // Positioned(
          //   top: statusBarHeight + 20,
          //  // right: 5,
          //   child: const Opacity(
          //     opacity: 0.1,
          //     child: Logo(),
          //     // child: SvgAsset(
          //     //   name: "kari_logo",
          //     //   height: 100,
          //     //   width: 196,
          //     // ),
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
                        height: statusBarHeight + 100,
                      ),
                      Text("Sign Up",
                          style: context.headlineLarge?.copyWith(fontSize: 36)),
                      const SizedBox(height: 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
                              hintText: "Username",
                              controller: _usernameController,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AppTextField(
                              hintText: "Phone number",
                              controller: _phoneNumberController,
                            ),
                          ),
                        ],
                      ),
                      AppTextField(
                        hintText: "Email",
                        controller: _emailController,
                      ),
                      AppTextField(
                        hintText: "Password",
                        controller: _passwordController,
                      ),
                      AppButton(
                        width: double.infinity,
                        title: "Sign Up",
                        onPressed: signUp,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: lightTint,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
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
