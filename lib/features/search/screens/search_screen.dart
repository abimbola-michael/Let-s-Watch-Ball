import 'package:flutter/material.dart';
import 'package:watchball/shared/components/app_appbar.dart';

class SearchScreen extends StatefulWidget {
  static const route = "/search";
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(),
    );
  }
}
