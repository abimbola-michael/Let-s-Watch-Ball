import 'package:hive_flutter/hive_flutter.dart';
import 'package:watchball/firebase/firestore_methods.dart';
import 'package:watchball/utils/utils.dart';

import '../../contact/models/phone_contact.dart';
import '../models/user.dart';

//final AuthMethods authMethods = AuthMethods();
final FirestoreMethods firestoreMethods = FirestoreMethods();

Future<User> createUser(String userId, String email, String username,
    String phoneNumber, String photo) async {
  // final time = DateTime.now().millisecondsSinceEpoch.toString();
  final time = timeNow;
  final user = User(
    id: userId,
    name: username,
    email: email,
    phone: phoneNumber.replaceAll("-", ""),
    createdAt: time,
    modifiedAt: time,
    bio: "",
    photo: photo,
  );
  await firestoreMethods.setValue(["users", userId], value: user.toMap());
  return user;
}

Future<List<User>> readAllUsers([bool withoutMe = true]) {
  return firestoreMethods.getValues((map) => User.fromMap(map), ["users"],
      where: ["id", "!=", myId]);
}

Future addContact(String userId, String phone, String name,
    void Function(PhoneContact contact) onGet) {
  final time = timeNow;
  final contact = PhoneContact(
    id: userId,
    phone: phone,
    name: name,
    createdAt: time,
    modifiedAt: time,
    canSeeStories: true,
    canMessage: true,
    canInviteToWatch: true,
    canJoinWatch: true,
  );
  onGet(contact);
  return firestoreMethods
      .setValue(["users", userId, "contacts", phone], value: contact.toMap());
}

Future<List<PhoneContact>> readContacts(
    List<String> numbers, String? lastTime) {
  return firestoreMethods.getValues(
      (map) => PhoneContact.fromMap(map), ["users"],
      where: ["phone", "in", numbers]);
}

Future<List<User>> readContactUsers(List<String> numbers) {
  return firestoreMethods.getValues((map) => User.fromMap(map), [
    "users"
  ], where: [
    "phone",
    "in",
    numbers,
  ]);
}

Stream<User?> streamUser(String userId) async* {
  yield* firestoreMethods
      .getValueStream((map) => User.fromMap(map), ["users", userId]);
}

Future<User?> getUser(String userId) async {
  final usersBox = Hive.box<User>("users");
  User? user = usersBox.get(userId);
  if (user == null) {
    user = await firestoreMethods
        .getValue((map) => User.fromMap(map), ["users", userId]);
    if (user != null) {
      usersBox.put(userId, user);
    }
  }
  return user;
}

Future updateUser(String userId, Map<String, dynamic> value) {
  return firestoreMethods.updateValue(["users", userId], value: value);
}

Future removeUser(String userId) {
  return firestoreMethods.removeValue(["users", userId]);
}
