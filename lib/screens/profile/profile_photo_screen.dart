import 'package:flutter/material.dart';
import 'package:watchball/components/reuseable/app_appbar.dart';

class ProfilePhotoScreen extends StatefulWidget {
  static const route = "/profile-photo";

  const ProfilePhotoScreen({super.key});

  @override
  State<ProfilePhotoScreen> createState() => _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends State<ProfilePhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: "Profile Photo",
      ),
    );
  }
}
