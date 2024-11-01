import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/firebase/auth_methods.dart';
import 'package:watchball/firebase/firestore_methods.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../shared/components/app_appbar.dart';
import '../../../shared/components/app_button.dart';
import '../../../shared/components/app_text_field.dart';
import '../../../theme/colors.dart';
import '../../onboarding/screens/welcome_screen.dart';
import '../../user/services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  final String type;
  const EditProfileScreen({super.key, required this.type});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool verifiedPassword = false;
  bool loading = false, alreadyExist = false;
  final passwordController = TextEditingController();
  final editController = TextEditingController();

  final am = AuthMethods();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    editController.dispose();
    super.dispose();
  }

  void saveDetail() async {
    if (loading || !(formKey.currentState?.validate() ?? false)) return;
    final type = widget.type;
    loading = true;
    setState(() {});

    final newValue = editController.text.trim();

    if (type == "email") {
      alreadyExist = await am.checkIfEmailExists(newValue);
    }
    if (alreadyExist) {
      setState(() {
        loading = false;
      });
      if (!mounted) return;
      context.showSnackBar("Email Already exist", true);
      return;
    }
    if (type == "email") {
      await am.updateEmail(newValue);
      await am.logOut();
      gotoStartPage();
    } else if (type == "password") {
      await am.updatePassword(newValue);
      await am.logOut();
      gotoStartPage();
    }
    await updateUserDetails(type, newValue);

    loading = false;
    if (!mounted) return;
    context.pop(newValue);
  }

  void verifyPassword() async {
    if (loading || !(formKey.currentState?.validate() ?? false)) return;
    loading = true;
    setState(() {});

    final password = passwordController.text;
    verifiedPassword = await am.comfirmPassword(password);
    if (!mounted) return;
    context.showSnackBar(
        verifiedPassword ? "Password Comfirmed" : "Incorrect Password",
        !verifiedPassword);

    loading = false;
    setState(() {});
  }

  void gotoStartPage() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      WelcomeScreen.route,
      (Route<dynamic> route) => false, // Remove all routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: "Change ${widget.type.toCapitalSpaceCase}",
        trailing: !verifiedPassword
            ? null
            : IconButton(
                onPressed: saveDetail, icon: const Icon(EvaIcons.checkmark)),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              if (verifiedPassword)
                AppTextField(
                  controller: editController,
                  titleText: widget.type.toCapitalSpaceCase,
                  hintText: "Enter ${widget.type.toCapitalSpaceCase}",
                ),
              if (!verifiedPassword) ...[
                AppTextField(
                  controller: passwordController,
                  titleText: "Password",
                  hintText: "Enter Password",
                ),
                //const SizedBox(height: 20),
                AppButton(
                  title: "Comfirm Password",
                  loading: loading,
                  bgColor: primaryColor.withOpacity(loading ? 0.5 : 1),
                  onPressed: loading ? null : verifyPassword,
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
