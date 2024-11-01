// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:watchball/main.dart';
// import 'package:watchball/shared/components/app_appbar.dart';

// import '../../contact/models/phone_contact.dart';
// import '../../user/models/user.dart';
// import 'package:watchball/features/user/components/user_select_item.dart';

// class InviteContactsScreen extends StatefulWidget {
//   const InviteContactsScreen({super.key});

//   @override
//   State<InviteContactsScreen> createState() => _InviteContactsScreenState();
// }

// class _InviteContactsScreenState extends State<InviteContactsScreen> {
//   bool isSearch = false;

//   List<User> unregisteredUsers = [];
//   final searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     readContacts();
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   void readContacts() async {
//     if (kIsWeb || !Platform.isAndroid || !Platform.isIOS) return;
//     final usersBox = Hive.box<String>("users");
//     final phoneContactsBox = Hive.box<String>("contacts");
//     List<PhoneContact> phoneContacts =
//         phoneContactsBox.values.map((e) => PhoneContact.fromJson(e)).toList();

//     phoneContacts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//     //Map<String, dynamic> phoneContactsMap = {};

//     for (var contact in phoneContacts) {
//       phoneContactsMap[contact.phone] = contact.id;
//     }
//     // Request contact permission
//     if (!(await FlutterContacts.requestPermission())) return;

//     List<Contact> contacts = await FlutterContacts.getContacts();
//     for (int i = 0; i < contacts.length; i++) {
//       final contact = contacts[i];
//       for (var phone in contact.phones) {
//         final phoneNumber = phone.number.replaceAll("-", "");
//         if (phoneContactsMap[phoneNumber] == null) {
//           final numberUsers = await getUsersWithNumber(phoneNumber);
//           if (numberUsers.isNotEmpty) {
//             for (int i = 0; i < numberUsers.length; i++) {
//               final user = numberUsers[i];
//               user.phoneName = contact.displayName;
//               await addContact(user.id, user.phone, contact.displayName,
//                   (contact) {
//                 contact.user = user;
//                 phoneContactsBox.put(user.id, contact.toJson());
//                 usersBox.put(user.id, user.toJson());
//               });
//             }
//           } else {
//             final unregisteredUser = User(
//                 id: phoneNumber,
//                 name: contact.displayName,
//                 email: "",
//                 phone: phoneNumber,
//                 photo: "",
//                 createdAt: "",
//                 modifiedAt: "",
//                 token: "",
//                 sub: "",
//                 subExpiryTime: "");
//             unregisteredUsers.add(unregisteredUser);
//           }
//           phoneContactsMap[phoneNumber] = "";
//         }
//       }
//     }

//     setState(() {});
//   }

//   void startSearch() {
//     isSearch = true;
//     setState(() {});
//   }

//   void updateSearch(String value) {
//     setState(() {});
//     // ref
//     //     .read(searchMatchProvider.notifier)
//     //     .updateSearch(value.trim().toLowerCase());
//   }

//   void stopSearch() {
//     searchController.clear();
//     isSearch = false;
//     setState(() {});
//   }

//   void inviteContact() {}
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const AppAppBar(title: "Invite Contacts"),
//       body: ListView.builder(
//         shrinkWrap: true,
//         itemCount: unregisteredUsers.length,
//         itemBuilder: (context, index) {
//           final user = unregisteredUsers[index];
//           // final bool selected =
//           //     selectedUsers.indexWhere((element) => element.id == user.id) !=
//           //         -1;
//           return UserSelectItem(
//             user: user,
//             selected: false,
//             onPressed: () {
//               // if (user.email.isEmpty) {
//               //   inviteContact();
//               // } else {
//               //   toggleSelect(user);
//               // }
//             },
//           );
//         },
//       ),
//     );
//   }
// }
