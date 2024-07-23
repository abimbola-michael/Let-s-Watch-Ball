import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier(super.state);
  void updateUser(User user) {
    state = user;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>(
  (ref) {
    return UserNotifier(null);
  },
);
