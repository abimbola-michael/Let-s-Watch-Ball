import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:watchball/firebase/firestore_methods.dart';
import 'package:watchball/main.dart';
import 'package:watchball/utils/country_code_utils.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';

import '../../../shared/models/private_key.dart';
import '../../contact/models/phone_contact.dart';
import '../enums/enums.dart';
import '../models/contact_users.dart';
import '../models/user.dart';

//final AuthMethods authMethods = AuthMethods();
final FirestoreMethods fm = FirestoreMethods();

Future<bool> usernameExists(String username) async {
  return (await fm.getValue((map) => map, ["usernames", username])) != null;
}

Future<List<User>> searchUser(String type, String searchString) async {
  return fm.getValues<User>((map) => User.fromMap(map), ["users"],
      where: [type, "==", searchString.toLowerCase().trim()]);
}

Future<User> createUser(String userId, String email, String username,
    String name, String phoneNumber, String photo) async {
  // final time = DateTime.now().millisecondsSinceEpoch.toString();
  final time = timeNow;
  final user = User(
    id: userId,
    username: username,
    name: name,
    email: email,
    phone: phoneNumber.replaceAll("-", ""),
    createdAt: time,
    modifiedAt: time,
    photo: photo,
    token: "",
  );
  await fm.setValue(["usernames", username], value: {"username": username});
  await fm.setValue(["users", userId], value: user.toMap());
  return user;
}

Future<List<User>> readAllUsers([bool withoutMe = true]) {
  return fm.getValues((map) => User.fromMap(map), ["users"],
      where: ["id", "!=", myId]);
}

Future<PhoneContact> addPhoneContact(
    String phone, String name, ContactStatus contactStatus) async {
  final time = timeNow;
  final contact = PhoneContact(
    phone: phone,
    name: name,
    contactStatus: contactStatus,
    createdAt: time,
    modifiedAt: time,
  );

  await fm.setValue(["users", myId, "contacts_requests", phone],
      value: {"phone": phone, "createdAt": time});
  return contact;
}

Future<List<PhoneContact>> getPhoneContacts(String? lastTime) {
  return fm.getValues(
    (map) => PhoneContact.fromMap(map),
    ["users", myId, "contacts_requests"],
    order: ["modifiedAt", true],
    where: lastTime != null ? ["modifiedAt", ">", lastTime] : null,
  );
}

Future<List<User>> getUsersWithNumbers(List<String> numbers) async {
  List<String> phoneNumbers = [];
  List<User> allUsers = [];

  for (int i = 0; i < numbers.length; i++) {
    final number = numbers[i];
    String phoneNumber = "";
    if (number.startsWith("0")) {
      final dialCode = await getCurrentCountryDialingCode();
      phoneNumber = "$dialCode${number.substring(1)}";
    } else {
      phoneNumber = number.startsWith("+") ? number : "+$number";
    }
    phoneNumbers.add(phoneNumber);
    if (phoneNumbers.length == 10 || i == numbers.length - 1) {
      final users = await fm.getValues((map) => User.fromMap(map), ["users"],
          where: ["phone", "in", phoneNumbers]);
      allUsers.addAll(users);
      phoneNumbers.clear();
    }
  }

  return allUsers;
}

Stream<User?> streamUser(String userId) async* {
  yield* fm.getValueStream((map) => User.fromMap(map), ["users", userId]);
}

Future<User?> getUser(String userId, {bool useCache = true}) async {
  if (useCache) {
    final mapValue = usersMap[userId];
    if (mapValue != null) return mapValue;
  }
  final usersBox = Hive.box<String>("users");

  try {
    final user =
        await fm.getValue((map) => User.fromMap(map), ["users", userId]);
    usersBox.put(userId, user?.toJson() ?? "");
    usersMap[userId] = user;
    return user;
  } catch (e) {
    String? userValue = usersBox.get(userId);
    return (userValue ?? "").isEmpty ? null : User.fromJson(userValue!);
  }
}

Future updateProfilePhoto(String url) async {
  return fm.updateValue(["users", myId], value: {"photo": url});
}

Future removeProfilePhoto() async {
  return fm.updateValue(["users", myId], value: {"photo": ""});
}

Future updateUserDetails(String type, String value) async {
  return fm.updateValue(["users", myId], value: {type: value});
}

Future updateUser(String userId, Map<String, dynamic> value) {
  return fm.updateValue(["users", userId], value: value);
}

Future removeUser(String userId) {
  return fm.removeValue(["users", userId]);
}

Future<PrivateKey?> getPrivateKey() async {
  return fm.getValue((map) => PrivateKey.fromMap(map), ["admin", "keys"]);
}

void updateToken(String token) async {
  if (kIsWeb || (!Platform.isIOS && !Platform.isAndroid)) return;
  if (myId != "") {
    await fm.updateValue(["users", myId], value: {"token": token});
  }
}

Future<String?> getToken(String userId) async {
  return fm.getValue((map) => map["token"], ["users", userId]);
}
