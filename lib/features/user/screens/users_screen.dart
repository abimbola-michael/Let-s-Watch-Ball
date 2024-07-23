import 'package:flutter/material.dart';
import 'package:watchball/shared/components/app_appbar.dart';

class UsersScreen extends StatefulWidget {
  static const route = "/users";

  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(),
    );
  }
}
