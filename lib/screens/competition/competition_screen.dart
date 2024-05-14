import 'package:flutter/material.dart';
import 'package:watchball/components/reuseable/app_appbar.dart';

class CompetitionScreen extends StatefulWidget {
  static const route = "/competition";

  const CompetitionScreen({super.key});

  @override
  State<CompetitionScreen> createState() => _CompetitionScreenState();
}

class _CompetitionScreenState extends State<CompetitionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(),
    );
  }
}
