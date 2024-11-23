// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/routes/app_route.gr.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  void registerWithEmail(
      BuildContext context, String email, String password) async {
    try {
      try {
        UserCredential result = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (result.user != null) {
          showSnackBar(context: context, content: "registered successfully");
          context.maybePop();
        }
      } catch (e) {
        showSnackBar(context: context, content: e.toString());
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void signInWithEmail(
      BuildContext context, String email, String password) async {
    try {
      try {
        UserCredential result = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        if (result.user != null) {
          context.router.replaceAll([const UserInfoRoute()]);
        }
      } catch (e) {
        showSnackBar(context: context, content: e.toString());
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }
}

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance),
);
