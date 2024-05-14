import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../components/logo/fm_logo.dart';
import '../../components/reuseable/app_appbar.dart';
import '../../components/reuseable/app_icon_button.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        leading: FmLogo(),
        title: "Posts",
        trailing: AppIconButton(icon: EvaIcons.search),
      ),
    );
  }
}
