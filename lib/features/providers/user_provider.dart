import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/services/session_service.dart';
import 'package:valarpay/features/models/user.dart';

final userProvider = StateNotifierProvider<UserController, UserModel?>((ref) {
  return UserController();
});

class UserController extends StateNotifier<UserModel?> {
  UserController() : super(null) {
    loadUser();
  }
  Future<void> loadUser() async {
    final user = await SessionService.getUser();
    if (user != null) {
      state = user;
    }
  }

  void setUser(UserModel user) {
    state = user;
  }

  Future<void> clearUser() async {
    state = null;
    await SessionService.logout();
  }
}
