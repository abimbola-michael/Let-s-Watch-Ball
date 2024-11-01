// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:watchball/features/user/models/user.dart';

class ContactUsers {
  List<User> registeredUsers;
  List<User> unregisteredUsers;
  ContactUsers({
    required this.registeredUsers,
    required this.unregisteredUsers,
  });
}
