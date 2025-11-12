// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/feature/auth/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class AccountRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AccountRepository({
    required this.auth,
    required this.firestore,
  });
  Future<UserModel> fetchAccountDetails() async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) {
        log('No authenticated user');
        return const UserModel(id: null);
      }
      
      final userDoc = await firestore.collection('users').doc(userId).get();
      
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          final response = UserModel.fromJson(userData);
          log('Fetched user data: $userData');
          return response;
        }
      }
      
      log('User document does not exist');
      return const UserModel(id: null);
    } on FirebaseException catch (e) {
      log('Firestore error: ${e.message}');
      return const UserModel(id: null);
    } catch (e) {
      log('Error fetching account details: $e');
      return const UserModel(id: null);
    }
  }

  Future<bool> updateProfile(
      BuildContext context, UserModel userDetails) async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) {
        showSnackBar(content: 'User not authenticated', context: context);
        return false;
      }
      
      log('Updating profile: $userDetails');
      
      // Prepare update data - only include non-empty fields
      final updateData = <String, dynamic>{
        'id': userId,
      };
      
      if (!isNullOrEmpty(userDetails.phone_number)) {
        updateData['phone_number'] = userDetails.phone_number;
      }
      if (!isNullOrEmpty(userDetails.user_name)) {
        updateData['user_name'] = userDetails.user_name;
      }
      if (!isNullOrEmpty(userDetails.full_name)) {
        updateData['full_name'] = userDetails.full_name;
      }
      if (!isNullOrEmpty(userDetails.avatar_url)) {
        updateData['avatar_url'] = userDetails.avatar_url;
      }
      
      updateData['updatedAt'] = FieldValue.serverTimestamp();
      
      // Update Firestore document
      await firestore.collection('users').doc(userId).update(updateData);
      
      showSnackBar(content: "Profile updated successfully!", context: context);
      return true;
    } on FirebaseException catch (e) {
      log('Firestore error: ${e.message}');
      showSnackBar(content: e.message ?? 'Failed to update profile', context: context);
      return false;
    } catch (e) {
      log('Error updating profile: $e');
      showSnackBar(content: e.toString(), context: context);
      return false;
    }
  }
}

final accountRepositoryProvider = Provider(
  (ref) => AccountRepository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance),
);
