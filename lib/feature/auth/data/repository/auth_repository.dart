// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/feature/auth/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

// import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;
  AuthRepository({
    required this.auth,
    required this.firestore,
    required this.googleSignIn,
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
        context.go('/login');
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
            context.go('/user-info');
          } else {
            context.go('/home');
          }
        } else {
          // User document doesn't exist, redirect to complete profile
          context.go('/user-info');
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

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return;
      }

      // Obtain auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final userId = userCredential.user!.uid;

        // Check if user document exists in Firestore
        final userDoc = await firestore.collection('users').doc(userId).get();

        if (!userDoc.exists) {
          // Create new user document with Google account data
          await firestore.collection('users').doc(userId).set({
            'email': userCredential.user!.email,
            'full_name': userCredential.user!.displayName,
            'avatar_url': userCredential.user!.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'userId': userId,
          });
          log('New Google user created in Firestore');
        }

        // Check if user has completed profile setup
        final userData = userDoc.exists ? userDoc.data() : null;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-In Successful')),
        );

        if (userData?['user_name'] == null || userData?['user_name'] == '') {
          // Profile incomplete, redirect to user info page
          context.go('/user-info');
        } else {
          // Profile complete, redirect to home
          context.go('/home');
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Google Sign-In failed';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          message = 'An account already exists with a different sign-in method';
          break;
        case 'invalid-credential':
          message = 'Invalid credentials. Please try again';
          break;
        case 'operation-not-allowed':
          message = 'Google Sign-In is not enabled';
          break;
        default:
          message = e.message ?? 'Google Sign-In failed';
      }
      log('Google Sign-In error: ${e.code} - ${e.message}');
      showSnackBar(content: message, context: context);
    } catch (e) {
      log('Unexpected Google Sign-In error: $e');
      showSnackBar(
          content: 'Google Sign-In failed: ${e.toString()}', context: context);
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
      context.go('/home');
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
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    googleSignIn: GoogleSignIn(),
  ),
);
