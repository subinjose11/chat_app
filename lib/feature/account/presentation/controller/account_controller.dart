// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/feature/account/data/account_repo/account_repo.dart';
import 'package:chat_app/feature/account/presentation/state/account_state.dart';
import 'package:chat_app/feature/account/presentation/ui/account_screen.dart';
import 'package:chat_app/feature/auth/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountController extends StateNotifier<AccountState> {
  final AccountRepository accountRepository;
  AccountController(this.accountRepository, super.state);

  Future<void> fetchAccountDetails(BuildContext context) async {
    try {
      state = state.copyWith(
          accountStatus: AccountStatus.loading); // Update loading state
      final result = await accountRepository.fetchAccountDetails();
      if (result.id != null) {
        log(result.toString());
        state = state.copyWith(
          accountStatus: AccountStatus.success,
          userDetails: result,
        );
      } else {
        state = state.copyWith(
          accountStatus: AccountStatus.failed,
          errorMessage: "Something went wrong, try again",
        );
      }
    } catch (e) {
      state = state.copyWith(
        accountStatus: AccountStatus.failed,
        errorMessage: "Something went wrong, try again",
      );
    }
  }

  void updateProfile(WidgetRef ref, BuildContext context, String? profilePic,
      String? userName, String? fullName, String? phone, String? email) async {
    UserModel userDetails = UserModel(
        user_name: userName,
        full_name: fullName,
        phone_number: phone,
        avatar_url: profilePic,
        updated_at: DateTime.now().toIso8601String());
    final result = await accountRepository.updateProfile(context, userDetails);
    if (result) {
      ref.read(accountControllerProvider.notifier).fetchAccountDetails(context);
      context.router.maybePop();
    }
  }
}

final accountControllerProvider =
    StateNotifierProvider<AccountController, AccountState>((ref) {
  final accountRepository = ref.watch(accountRepositoryProvider);
  return AccountController(accountRepository, const AccountState());
});
