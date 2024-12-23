import 'package:chat_app/feature/home/presentation/widget/custom_app_bar.dart';
import 'package:chat_app/feature/status/presentation/widget/status_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not logged in.');

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      setState(() {
        _userData = doc.data();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appWidget: StatusAppBar(title: "Status")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading state
          : _error != null
              ? Center(child: Text('Error: $_error')) // Error state
              : _userData == null
                  ? const Center(
                      child: Text('No user data found.')) // Null data state
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Name: ${_userData?['name'] ?? 'Unknown'}'),
                          Text('Email: ${_userData?['email'] ?? 'Unknown'}'),
                          // Add more fields as needed
                        ],
                      ),
                    ),
    );
  }
}
