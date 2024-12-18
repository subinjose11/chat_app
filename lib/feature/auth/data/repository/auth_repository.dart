// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/feature/auth/data/model/user_model.dart';
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
        context.router.replace(const LogInRoute());
      }
    } on AuthException catch (error) {
      showSnackBar(content: error.message, context: context);
    } catch (e) {
      showSnackBar(content: e.toString(), context: context);
    }
  }

  void signInWithEmail(
      BuildContext context, String email, String password) async {
    final SupabaseClient supabase = Supabase.instance.client;
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session != null) {
        // Fetch data from the 'profiles' table
        final result = await supabase.from('profiles').select();
        log(result.toString());
        if (result.first["user_name"] == null) {
          context.router.replaceAll([const UserInfoRoute()]);
        } else {
          context.router.replaceAll([const HomeRoute()]);
        }
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

  void addUserDetails(BuildContext context, UserModel userDetails) async {
    final SupabaseClient supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser!.id;
    userDetails = userDetails.copyWith(id: userId);
    log(userDetails.toJson().toString());
    try {
      await supabase.from('profiles').upsert(userDetails.toJson());
      context.router.replaceAll([const HomeRoute()]);
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
