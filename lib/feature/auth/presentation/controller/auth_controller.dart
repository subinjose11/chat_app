import 'package:chat_app/feature/auth/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AuthController {
  final AuthRepository authRepository;
  final Ref ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });


  void registerWithEmail(BuildContext context, String email, String password) {
    authRepository.registerWithEmail(context, email,password);
  }

  void signInWithEmail(BuildContext context, String email, String password) {
    authRepository.signInWithEmail(context, email,password);
  }


}

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

