// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/feature/auth/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AccountRepository({
    required this.auth,
    required this.firestore,
  });
  Future<UserModel> fetchAccountDetails() async {
    final userId = auth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in.');
    try {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final data = result.data();
      if (data == null) {
        return const UserModel(
            id: null); // Return a default UserModel if no data
      }
      final response = UserModel.fromJson(data);
      return response;
    } on AuthException catch (e) {
      log(e.message);
      return const UserModel(id: null);
    } catch (e) {
      log(e.toString());
      return const UserModel(id: null);
    }
  }

  Future<bool> updateProfile(
      BuildContext context, UserModel userDetails) async {
     final userId = auth.currentUser?.uid;
    log(userDetails.toString());
    try {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
       if (!isNullOrEmpty(userDetails.phone_number))
          "phone_number": userDetails.phone_number,
        if (!isNullOrEmpty(userDetails.user_name))
          "user_name": userDetails.user_name,
        if (!isNullOrEmpty(userDetails.full_name))
          "full_name": userDetails.full_name,
        if (!isNullOrEmpty(userDetails.avatar_url))
          "avatar_url": userDetails.avatar_url,
    },SetOptions(merge: true));
      showSnackBar(content: "Profile updated successfully!", context: context);
      return true;
    } on AuthException catch (e) {
      log(e.message);
      showSnackBar(content: e.message, context: context);
      return false;
    } catch (e) {
      log(e.toString());
      showSnackBar(content: e.toString(), context: context);
      return false;
    }
  }
}

final accountRepositoryProvider = Provider(
  (ref) => AccountRepository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance),
);
