import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/network/data_state.dart';
import 'package:valarpay/features/repositories/user_repository.dart';
import 'package:valarpay/features/notifiers/user_notifier.dart';

class ProfileNotifier extends StateNotifier<DataState<String>> {
  final UserRepository _repository;

  ProfileNotifier(this._repository) : super(DataState<String>.initial());

  /// Upload profile image and update state
  Future<bool> uploadProfileImage(String filePath, String fullName,) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      await _repository.editProfileImage(filePath, fullName);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: 'Profile updated successfully',
      );
      return true;
    } catch (e, stack) {
      log('[ProfileNotifier] Upload error: $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
      );
      return false;
    }
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, DataState<String>>(
      (ref) => ProfileNotifier(ref.read(userRepositoryProvider)),
    );
