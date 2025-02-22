import 'dart:io';
import 'dart:math';

import 'package:country_code_picker_plus/country_code_picker_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/features/main/screens/main_screen.dart';
import 'package:watchball/firebase/auth_methods.dart';
import 'package:watchball/features/user/services/user_service.dart';
import 'package:watchball/main.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../shared/views/loading_overlay.dart';
import '../../../shared/components/logo.dart';
import '../../../utils/country_code_utils.dart';
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
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool usernameExist = false;
  bool acceptTerms = false;
  bool canGoogleSignIn = kIsWeb || !Platform.isWindows;

  bool loading = false;
  String countryDialCode = "";
  @override
  void initState() {
    super.initState();
    getCountryCode();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void getCountryCode() async {
    //final code = await getSimCountryCode();
    final code = await getCurrentCountryCode();
    await getCurrentCountryDialingCode();

    // if (code != null) {
    //   countryCode = code;
    // }
    setState(() {});
  }

  void signUp() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final username = _usernameController.text.trim();
      final name = getValidName(_nameController.text.trim());
      final phoneNumber =
          _phoneNumberController.text.trim().replaceAll(" ", "");
      final number =
          phoneNumber.startsWith("0") ? phoneNumber.substring(1) : phoneNumber;

      usernameExist = await usernameExists(username);

      if (usernameExist) {
        if (!mounted) return;
        context.showSnackBar("Username already exist");
        setState(() {});
        return;
      }

      //await Future.delayed(const Duration(seconds: 2));
      try {
        final result = await authMethods.createAccount(email, password);
        if (result.user == null) return;
        await createUser(result.user!.uid, email, username, name,
            "$countryDialCode$number", "");
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
        child: SingleChildScrollView(
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
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Expanded(
                    //       child: AppTextField(
                    //         hintText: "Name",
                    //         controller: _nameController,
                    //       ),
                    //     ),
                    //     const SizedBox(width: 10),
                    //     Expanded(
                    //       child: AppTextField(
                    //         hintText: "Phone number",
                    //         controller: _phoneNumberController,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    AppTextField(
                      hintText: "Username",
                      controller: _usernameController,
                      validator: (value) {
                        if (usernameExist) {
                          return "Username already exist";
                        }
                        return null;
                      },
                    ),
                    AppTextField(
                      hintText: "Name",
                      controller: _nameController,
                    ),
                    AppTextField(
                      hintText: "Phone number",
                      controller: _phoneNumberController,
                      validator: (value) {
                        if (value!.startsWith("+")) {
                          return "Select Country dial code and just input the rest of your number";
                        }
                        return null;
                      },
                      prefix: SizedBox(
                        width: 50,
                        child: CountryCodePicker(
                          textStyle: context.bodyMedium?.copyWith(color: tint),
                          padding: const EdgeInsets.only(left: 10),
                          mode: CountryCodePickerMode.bottomSheet,
                          initialSelection:
                              countryCode.isNotEmpty ? countryCode : "US",
                          showFlag: false,
                          showDropDownButton: false,
                          dialogBackgroundColor: bgTint,
                          onChanged: (country) {
                            setState(() {
                              countryDialCode = country.dialCode;
                            });
                          },
                        ),
                      ),
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
      ),
    );
  }
}
