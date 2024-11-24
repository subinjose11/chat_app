// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/routes/app_route.gr.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

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
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) {
        context.router.maybePop();
      }
    } on AuthException catch (error) {
      showSnackBar(content: error.message, context: context);
    } catch (e) {
      showSnackBar(content: e.toString(), context: context);
    }
  }

  void signInWithEmail(
      BuildContext context, String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session != null) {
        context.router.replaceAll([const UserInfoRoute()]);
      } else {
        showSnackBar(
            content: 'Login failed. Please try again.', context: context);
      }
    } on AuthException catch (e) {
      log(e.message);
      showSnackBar(content: e.message, context: context);
    } catch (e) {
      log(e.toString());
      showSnackBar(content: e.toString(), context: context);
    }
  }
}

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance),
);
