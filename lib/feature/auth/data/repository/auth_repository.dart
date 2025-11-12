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

// import 'package:supabase_flutter/supabase_flutter.dart';

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
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Create initial user document in Firestore
        await firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'userId': userCredential.user!.uid,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Registration Successful! Please login.')),
        );
        context.router.replace(const LogInRoute());
      }
    } on FirebaseAuthException catch (error) {
      String message = 'Registration failed';
      switch (error.code) {
        case 'email-already-in-use':
          message = 'This email is already registered';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        default:
          message = error.message ?? 'Registration failed';
      }
      showSnackBar(content: message, context: context);
    } catch (e) {
      log('Registration error: $e');
      showSnackBar(content: e.toString(), context: context);
    }
  }

  void signInWithEmail(
      BuildContext context, String email, String password) async {
    try {
      // Sign in with Firebase Authentication
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful')),
        );

        // Check if user profile is complete in Firestore
        final userDoc = await firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data();
          log('User data: $userData');

          // Check if user has completed profile setup (has user_name)
          if (userData?['user_name'] == null || userData?['user_name'] == '') {
            context.router.replaceAll([const UserInfoRoute()]);
          } else {
            context.router.replaceAll([const HomeRoute()]);
          }
        } else {
          // User document doesn't exist, redirect to complete profile
          context.router.replaceAll([const UserInfoRoute()]);
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        default:
          message = e.message ?? 'Login failed';
      }
      log('Login error: ${e.code} - ${e.message}');
      showSnackBar(content: message, context: context);
    } catch (e) {
      log('Unexpected login error: $e');
      showSnackBar(content: e.toString(), context: context);
    }
  }

  void addUserDetails(BuildContext context, UserModel userDetails) async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) {
        showSnackBar(content: 'User not authenticated', context: context);
        return;
      }

      userDetails = userDetails.copyWith(id: userId);
      log('Saving user details: ${userDetails.toJson().toString()}');

      // Save to Firestore
      await firestore
          .collection('users')
          .doc(userId)
          .update(userDetails.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      context.router.replaceAll([const HomeRoute()]);
    } on FirebaseException catch (e) {
      log('Firestore error: ${e.message}');
      showSnackBar(
          content: e.message ?? 'Failed to update profile', context: context);
    } catch (e) {
      log('Error saving user details: $e');
      showSnackBar(content: e.toString(), context: context);
    }
  }
}

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance),
);
