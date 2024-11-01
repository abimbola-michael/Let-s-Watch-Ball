import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchball/features/story/models/story.dart';

import '../models/user.dart';

class UsersNotifier extends StateNotifier<List<User>> {
  UsersNotifier(super.state);

  void clearUsers(List<User> users) {
    state = [];
  }

  void setUsers(List<User> users) {
    state = users;
  }

  void addUser(User users) {
    state = [...state, users];
  }

  void removeUser(User user) {
    state = state.where((prevUser) => prevUser.id != user.id).toList();
  }
}

final usersProvider = StateNotifierProvider<UsersNotifier, List<User>>(
  (ref) {
    return UsersNotifier([]);
  },
);
