import 'package:chat_app/feature/auth/data/model/user_model.dart';
import 'package:chat_app/feature/auth/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController {
  final AuthRepository authRepository;
  AuthController({
    required this.authRepository,
  });

  void registerWithEmail(BuildContext context, String email, String password) {
    authRepository.registerWithEmail(context, email, password);
  }

  void signInWithEmail(BuildContext context, String email, String password) {
    authRepository.signInWithEmail(context, email, password);
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    await authRepository.signInWithGoogle(context);
  }

  void addUserDetails(
    BuildContext context,
    String? profilePic,
    String userName,
  ) {
    UserModel userDetails = UserModel(
        user_name: userName,
        avatar_url: profilePic,
        updated_at: DateTime.now().toIso8601String());
    authRepository.addUserDetails(context, userDetails);
  }
}

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});
