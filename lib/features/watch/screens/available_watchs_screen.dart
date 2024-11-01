// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:watchball/features/watch/models/watch.dart';
// import 'package:watchball/features/watch/providers/available_watchs_provider.dart';
// import 'package:watchball/features/watch/screens/watch_request_screen.dart';
// import 'package:watchball/shared/views/loading_overlay.dart';
// import 'package:watchball/utils/extensions.dart';

// import '../../../main.dart';
// import '../../../shared/views/empty_list_view.dart';
// import '../../../utils/utils.dart';
// import '../../contact/models/phone_contact.dart';
// import '../../match/utils/match_utils.dart';
// import '../../user/models/user.dart';
// import '../../user/services/user_service.dart';
// import '../providers/search_watchs_provider.dart';
// import '../services/watch_service.dart';
// import 'watch_match_screen.dart';
// import '../components/watch_item.dart';

// class AvailableWatchsScreen extends ConsumerStatefulWidget {
//   const AvailableWatchsScreen({super.key});

//   @override
//   ConsumerState<AvailableWatchsScreen> createState() =>
//       _AvailableWatchsScreenState();
// }

// class _AvailableWatchsScreenState extends ConsumerState<AvailableWatchsScreen> {
//   List<Watch> watchs = [];
//   bool loading = false, reachedBottom = false;
//   StreamSubscription? watchSub;
//   int limit = 10;
//   List<PhoneContact> phoneContacts = [];
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     readContacts();
//   }

//   @override
//   void dispose() {
//     watchSub?.cancel();
//     super.dispose();
//   }

//   void readContacts() async {
//     final usersBox = Hive.box<String>("users");
//     final phoneContactsBox = Hive.box<String>("contacts");
//     phoneContacts =
//         phoneContactsBox.values.map((e) => PhoneContact.fromJson(e)).toList();
//     final users = usersBox.values.map((e) => User.fromJson(e)).toList();

//     phoneContacts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

//     for (var contact in phoneContacts) {
//       phoneContactsMap[contact.phone] = contact.id;
//     }
//     if (kIsWeb || !Platform.isAndroid || !Platform.isIOS) {
//       final contacts = await getContacts(
//           phoneContacts.isNotEmpty ? phoneContacts.last.createdAt : null);
//       for (int i = 0; i < contacts.length; i++) {
//         final contact = contacts[i];
//         phoneContactsBox.put(contact.id, contact.toJson());
//         final user = await getUser(contact.id);
//         if (user != null && user.id != myId) {
//           user.phoneName = contact.name;
//           users.add(user);
//         }
//       }
//       // ref.read(contactsProvider.notifier).setPhoneContacts(phoneContacts);
//       // ref.read(usersProvider.notifier).setUsers(users);
//       setState(() {});
//       return;
//     }

//     // Request contact permission
//     if (!(await FlutterContacts.requestPermission())) return;

//     List<Contact> contacts = await FlutterContacts.getContacts();
//     for (int i = 0; i < contacts.length; i++) {
//       final contact = contacts[i];
//       for (var phone in contact.phones) {
//         final phoneNumber = phone.number.replaceAll("-", "");
//         if (phoneContactsMap[phoneNumber] == null) {
//           final numberUsers = await getUsersWithNumbers([phoneNumber]);
//           if (numberUsers.isNotEmpty) {
//             for (int i = 0; i < numberUsers.length; i++) {
//               final user = numberUsers[i];
//               user.phoneName = contact.displayName;
//               if (user.id != myId) {
//                 users.add(user);
//               }
//               final phoneContact =
//                   await addContact(user.id, user.phone, contact.displayName);
//               phoneContact.user = user;
//               phoneContactsBox.put(user.id, phoneContact.toJson());
//               usersBox.put(user.id, user.toJson());
//             }
//           }
//           phoneContactsMap[phoneNumber] = "";
//         }
//       }
//     }
//     readAvailableWatchs();
//   }

//   void readAvailableWatchs() async {
//     loading = true;
//     setState(() {});

//     List<Watch> newWatchs = [];
//     while (phoneContacts.isNotEmpty) {
//       final end = phoneContacts.length > 10 ? 10 : phoneContacts.length;
//       final ids = phoneContacts.sublist(0, end).map((e) => e.id).toList();
//       //final stream = readWatchsStream(ids);
//       final watchs = await readWatchs(ids);
//       for (int i = 0; i < watchs.length; i++) {
//         final watch = watchs[i];
//         await updateWatchUsers(watch);
//         this.watchs.add(watch);
//         newWatchs.add(watch);
//         for (int j = 0; j < watch.watchersIds.length; j++) {
//           final watcherId = watch.watchersIds[j];
//           if (ids.contains(watcherId)) continue;
//           phoneContacts.removeWhere((element) => element.id == watcherId);
//         }
//       }
//       phoneContacts.removeRange(0, end);
//       if (newWatchs.length >= limit) break;
//     }
//     ref.read(availableWatchsProvider.notifier).setWatchs(watchs);
//     reachedBottom = newWatchs.length < limit || phoneContacts.isNotEmpty;
//     loading = false;
//     setState(() {});
//     // watchSub = readWatchsStream().listen((watchChanges) {
//     //   for (int i = 0; i < watchChanges.length; i++) {
//     //     final watchChange = watchChanges[i];
//     //     final watch = watchChange.value;
//     //     if (watchChange.added) {
//     //       watchs.add(watch);
//     //     } else if (watchChange.modified) {
//     //       final index = watchs.indexWhere((element) => element.id == watch.id);
//     //       if (index != -1) {
//     //         watchs[index] = watch;
//     //       }
//     //     } else {
//     //       watchs.removeWhere((element) => element.id == watch.id);
//     //     }
//     //   }
//     //   if (loading) loading = false;
//     //   setState(() {});
//     // });
//   }

//   void joinWatch(BuildContext context, Watch watch) async {
//     context.pushNamedTo(WatchRequestScreen.route, args: {"watch": watch});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final searchText = ref.watch(searchWatchProvider);
//     final watchs = this.watchs.where((watch) {
//       final match = getMatchInfo(watch.match);
//       final namesString = watch.users.map((user) => user.username).join(" ");
//       return match.homeName.toLowerCase().contains(searchText) ||
//           match.awayName.toLowerCase().contains(searchText) ||
//           match.league.toLowerCase().contains(searchText) ||
//           namesString.contains(searchText);
//     }).toList();

//     return watchs.isEmpty
//         ? loading
//             ? const Center(child: CircularProgressIndicator())
//             : const EmptyListView(message: "No watch")
//         : ListView.builder(
//             itemCount: watchs.length + (loading ? 1 : 0),
//             itemBuilder: (context, index) {
//               if (index == watchs.length - 1 && !loading && !reachedBottom) {
//                 readAvailableWatchs();
//               }
//               if (loading && (!reachedBottom && index == watchs.length)) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               final watch = watchs[index];
//               return WatchItem(
//                 watch: watch,
//                 onPressed: () => joinWatch(context, watch),
//               );
//             },
//           );
//   }
// }
