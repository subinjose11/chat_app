// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/models/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerRepository {
  final FirebaseFirestore firestore;

  CustomerRepository({required this.firestore});

  // Create Customer
  Future<void> createCustomer(BuildContext context, Customer customer) async {
    try {
      // Use existing ID if provided, otherwise generate new one
      final docId = customer.id.isNotEmpty ? customer.id : firestore.collection('customers').doc().id;
      final docRef = firestore.collection('customers').doc(docId);
      final customerWithId = customer.copyWith(
        id: docId,
        createdAt: DateTime.now(),
      );

      await docRef.set(customerWithId.toJson());
      
      if (context.mounted) {
        showSnackBar(content: 'Customer added successfully!', context: context);
      }
    } on FirebaseException catch (e) {
      log('Firebase error creating customer: ${e.message}');
      if (context.mounted) {
        showSnackBar(
          content: e.message ?? 'Failed to create customer',
          context: context,
        );
      }
    } catch (e) {
      log('Error creating customer: $e');
      if (context.mounted) {
        showSnackBar(content: 'Error: ${e.toString()}', context: context);
      }
    }
  }

  // Get all customers as stream
  Stream<List<Customer>> getCustomersStream() {
    try {
      return firestore
          .collection('customers')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          try {
            return Customer.fromJson({...doc.data(), 'id': doc.id});
          } catch (e) {
            log('Error parsing customer ${doc.id}: $e');
            return null;
          }
        }).whereType<Customer>().toList();
      });
    } catch (e) {
      log('Error getting customers stream: $e');
      return Stream.value([]);
    }
  }

  // Get single customer
  Future<Customer?> getCustomer(String customerId) async {
    try {
      final doc = await firestore.collection('customers').doc(customerId).get();
      if (doc.exists) {
        return Customer.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      log('Error getting customer: $e');
      return null;
    }
  }

  // Update Customer
  Future<void> updateCustomer(BuildContext context, Customer customer) async {
    try {
      await firestore.collection('customers').doc(customer.id).update(customer.toJson());
      
      if (context.mounted) {
        showSnackBar(content: 'Customer updated successfully!', context: context);
      }
    } on FirebaseException catch (e) {
      log('Firebase error updating customer: ${e.message}');
      if (context.mounted) {
        showSnackBar(
          content: e.message ?? 'Failed to update customer',
          context: context,
        );
      }
    } catch (e) {
      log('Error updating customer: $e');
      if (context.mounted) {
        showSnackBar(content: 'Error: ${e.toString()}', context: context);
      }
    }
  }

  // Delete Customer
  Future<void> deleteCustomer(BuildContext context, String customerId) async {
    try {
      await firestore.collection('customers').doc(customerId).delete();
      
      if (context.mounted) {
        showSnackBar(content: 'Customer deleted successfully!', context: context);
      }
    } on FirebaseException catch (e) {
      log('Firebase error deleting customer: ${e.message}');
      if (context.mounted) {
        showSnackBar(
          content: e.message ?? 'Failed to delete customer',
          context: context,
        );
      }
    } catch (e) {
      log('Error deleting customer: $e');
      if (context.mounted) {
        showSnackBar(content: 'Error: ${e.toString()}', context: context);
      }
    }
  }

  // Search customers
  Stream<List<Customer>> searchCustomers(String query) {
    try {
      if (query.isEmpty) {
        return getCustomersStream();
      }

      return firestore
          .collection('customers')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) {
              try {
                return Customer.fromJson({...doc.data(), 'id': doc.id});
              } catch (e) {
                return null;
              }
            })
            .whereType<Customer>()
            .where((customer) {
              final searchLower = query.toLowerCase();
              return customer.name.toLowerCase().contains(searchLower) ||
                     customer.phone.toLowerCase().contains(searchLower) ||
                     customer.email.toLowerCase().contains(searchLower);
            })
            .toList();
      });
    } catch (e) {
      log('Error searching customers: $e');
      return Stream.value([]);
    }
  }
}

final customerRepositoryProvider = Provider((ref) {
  return CustomerRepository(firestore: FirebaseFirestore.instance);
});

