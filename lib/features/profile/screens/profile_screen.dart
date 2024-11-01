import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:watchball/features/settings/screens/settings_and_more_screen.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../firebase/firestore_methods.dart';
import '../../../firebase/storage_methods.dart';
import '../../../shared/components/app_alert_dialog.dart';
import '../../../utils/utils.dart';
import '../../about/components/about_item.dart';
import '../../../shared/components/logo.dart';
import '../../../shared/components/app_appbar.dart';
import '../../../shared/components/app_icon_button.dart';
import '../../../shared/components/app_tabbar.dart';
import '../../user/mocks/users.dart';
import '../../user/models/user.dart';
import '../../user/providers/user_provider.dart';
import '../../user/services/user_service.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;
  const ProfileScreen({
    super.key,
    this.userId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //final _pageController = PageController();

  int currentIndex = 0;

  // void updateTab(int index) {
  //   _pageController.jumpToPage(index);
  // }
  String? filePath;
  User? user;
  bool loading = false;
  bool uploadingOrRemoving = false;

  StorageMethods sm = StorageMethods();
  FirestoreMethods fm = FirestoreMethods();
  String userId = "";

  @override
  void initState() {
    super.initState();
    userId = widget.userId ?? myId;
    readUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _pageController.dispose();
    super.dispose();
  }

  void updatePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void readUser() async {
    loading = true;
    setState(() {});
    user = await getUser(userId);
    loading = false;
    setState(() {});
  }

  void changePhoto() async {
    final result = await context.showAlertDialog((context) {
      return AppAlertDialog(
          title: "Select Photo",
          message: "How do you want to select photo?",
          actions: const [
            "Camera",
            "Gallery"
          ],
          onPresseds: [
            () => context.pop("camera"),
            () => context.pop("gallery")
          ]);
    });

    final file = await ImagePicker().pickImage(
        source: result == "gallery" ? ImageSource.gallery : ImageSource.camera);
    if (file != null) {
      setState(() {
        filePath = file.path;
      });
    }
  }

  void uploadPhoto() {
    if (filePath == null || user == null) return;
    setState(() {
      uploadingOrRemoving = true;
    });
    sm.uploadFile(["users", myId, "profile_photo"], filePath!, "photo",
        onComplete: (url, thumbnail) async {
      await updateProfilePhoto(url);
      setState(() {
        user!.photo = url;
        uploadingOrRemoving = false;
        filePath = null;
      });
    });
  }

  void removePhoto() async {
    if (filePath != null) {
      setState(() {
        filePath = null;
      });
      return;
    }
    if (user == null || user!.photo.isEmpty) return;

    final result = await context.showComfirmationDialog(
        "Delete Photo", "Are you sure you delete your profile photo");
    if (!result) return;

    setState(() {
      uploadingOrRemoving = true;
    });
    await removeProfilePhoto();
    setState(() {
      uploadingOrRemoving = false;
      user!.photo = "";
      filePath = null;
    });
  }

  // void viewContacts() {}

  void gotoEditProfilePage(String type) async {
    if (user == null) return;
    final newValue = await context.pushTo(EditProfileScreen(type: type));
    if (newValue == null) return;
    final map = user!.toMap();
    map[type] = newValue;
    user = User.fromMap(map);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppAppBar(
        hideBackButton: true,
        leading: const Logo(),
        title: "Profile",
        trailing: userId != myId
            ? null
            : AppIconButton(
                icon: EvaIcons.menu,
                onPressed: () {
                  context.pushNamedTo(SettingsAndMoreScreen.route);
                },
              ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: lightestTint,
                          image: filePath != null
                              ? DecorationImage(
                                  image: FileImage(File(filePath!)))
                              : user?.photo != null
                                  ? DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          user!.photo))
                                  : null,
                        ),
                        child: filePath != null || user?.photo != null
                            ? null
                            : Icon(
                                EvaIcons.person,
                                size: 60,
                                color: tint,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: changePhoto,
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: primaryColor,
                            child: Icon(
                              IonIcons.camera,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                      if (uploadingOrRemoving) const CircularProgressIndicator()
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (filePath != null ||
                          (user?.photo ?? "").isNotEmpty) ...[
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: removePhoto,
                          child: Text(
                            filePath != null ? "Remove Photo" : "Delete Photo",
                            style:
                                context.bodyMedium?.copyWith(color: Colors.red),
                          ),
                        ),
                      ],
                      if (filePath != null)
                        TextButton(
                          onPressed: uploadPhoto,
                          child: Text(
                            "Save Photo",
                            style: context.bodyMedium
                                ?.copyWith(color: primaryColor),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AboutItem(
                    title: "Username",
                    value: user?.name ?? "",
                    editable: userId == myId,
                    onEdit: () => gotoEditProfilePage("username"),
                  ),
                  AboutItem(
                    title: "Name",
                    value: user?.name ?? "",
                    editable: userId == myId,
                    onEdit: () => gotoEditProfilePage("name"),
                  ),
                  if (userId == myId)
                    AboutItem(
                      title: "Phone Number",
                      value: user?.phone ?? "",
                      editable: userId == myId,
                      onEdit: () => gotoEditProfilePage("phone"),
                    ),

                  AboutItem(
                    title: "Best Player",
                    value: user?.bestPlayer ?? "",
                    editable: userId == myId,
                    onEdit: () => gotoEditProfilePage("bestPlayer"),
                  ),
                  AboutItem(
                    title: "Best Club",
                    value: user?.bestClub ?? "",
                    editable: userId == myId,
                    onEdit: () => gotoEditProfilePage("bestClub"),
                  ),
                  AboutItem(
                    title: "Best Country",
                    value: user?.bestCountry ?? "",
                    editable: userId == myId,
                    onEdit: () => gotoEditProfilePage("bestCountry"),
                  ),
                  // if (userId == myId) ...[
                  //   AboutItem(
                  //     title: "Email",
                  //     value: user?.email ?? "",
                  //     editable: true,
                  //     onEdit: () => gotoEditProfilePage("email"),
                  //   ),
                  //   AboutItem(
                  //     title: "Password",
                  //     value: "",
                  //     editable: true,
                  //     onEdit: () => gotoEditProfilePage("password"),
                  //   ),
                  // ]

                  // Text(
                  //   userOne.name,
                  //   style: context.headlineMedium?.copyWith(fontSize: 18),
                  // ),
                  // ProfileStatItem(
                  //   title: "Contacts",
                  //   count: 278,
                  //   onPressed: viewContacts,
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // const AboutItem(title: "My Football Nickname", value: "Rooney"),
                  // const AboutItem(title: "My Goat", value: "Messi"),
                  // const AboutItem(title: "My Favorite Club", value: "Real Madrid"),
                  // const AboutItem(title: "My Favorite Country", value: "England"),
                ],
              ),
              // child: NestedScrollView(
              //     headerSliverBuilder: (context, innerScrolled) {
              //       return [
              //         SliverAppBar(
              //           expandedHeight: 180,
              //           // pinned: true,
              //           // floating: true,
              //           backgroundColor: transparent,
              //           flexibleSpace: Column(
              //             mainAxisSize: MainAxisSize.min,
              //             children: [
              //               const SizedBox(
              //                 height: 20,
              //               ),
              //               AppContainer(
              //                 borderRadius: BorderRadius.circular(30),
              //                 height: 100,
              //                 width: 100,
              //                 borderColor: lightTint,
              //                 borderWidth: 5,
              //                 image: AssetImage(userOne.photo.toJpg),
              //               ),
              //               const SizedBox(
              //                 height: 8,
              //               ),
              //               Text(
              //                 userOne.name,
              //                 style: context.headlineMedium?.copyWith(fontSize: 18),
              //               ),
              //               const SizedBox(
              //                 height: 20,
              //               ),
              //               const AboutItem(
              //                   title: "My Football Nickname", value: "Rooney"),
              //               const AboutItem(title: "My Goat", value: "Messi"),
              //               const AboutItem(title: "My Club", value: "Real Madrid"),
              //             ],
              //           ),
              //         )
              //       ];
              //     },
              //     body: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [

              //       ],
              //     )),
            ),
      // floatingActionButton: FloatingActionButton.small(
      //   onPressed: () {},
      //   child: const Icon(EvaIcons.edit_outline),
      // ),
    );
  }
}
