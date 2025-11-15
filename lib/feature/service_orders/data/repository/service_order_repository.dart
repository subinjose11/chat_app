// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/models/service_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ServiceOrderRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ServiceOrderRepository({
    required this.firestore,
    required this.storage,
  });

  // Upload photo to Firebase Storage
  Future<String?> uploadPhoto(XFile photo, String orderId, String type) async {
    try {
      final ref = storage
          .ref()
          .child('service_orders')
          .child(orderId)
          .child('$type/${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(File(photo.path));
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log('Error uploading photo: $e');
      return null;
    }
  }

  // Create ServiceOrder
  Future<void> createServiceOrder(
    BuildContext context,
    ServiceOrder serviceOrder,
    List<XFile> beforePhotos,
    List<XFile> afterPhotos,
  ) async {
    try {
      // Use existing ID if provided, otherwise generate new one
      final orderId = serviceOrder.id.isNotEmpty
          ? serviceOrder.id
          : firestore.collection('service_orders').doc().id;
      final docRef = firestore.collection('service_orders').doc(orderId);

      // Upload photos
      List<String> beforeUrls = [];
      List<String> afterUrls = [];

      for (var photo in beforePhotos) {
        final url = await uploadPhoto(photo, orderId, 'before');
        if (url != null) beforeUrls.add(url);
      }

      for (var photo in afterPhotos) {
        final url = await uploadPhoto(photo, orderId, 'after');
        if (url != null) afterUrls.add(url);
      }

      final orderWithData = serviceOrder.copyWith(
        id: orderId,
        createdAt: DateTime.now(),
        beforePhotos: beforeUrls,
        afterPhotos: afterUrls,
      );

      await docRef.set(orderWithData.toJson());

      if (context.mounted) {
        showSnackBar(
            content: 'Service order created successfully!', context: context);
      }
    } on FirebaseException catch (e) {
      log('Firebase error creating service order: ${e.message}');
      if (context.mounted) {
        showSnackBar(
          content: e.message ?? 'Failed to create service order',
          context: context,
        );
      }
    } catch (e) {
      log('Error creating service order: $e');
      if (context.mounted) {
        showSnackBar(content: 'Error: ${e.toString()}', context: context);
      }
    }
  }

  // Get all service orders as stream
  Stream<List<ServiceOrder>> getServiceOrdersStream() {
    try {
      return firestore
          .collection('service_orders')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) {
              try {
                return ServiceOrder.fromJson({...doc.data(), 'id': doc.id});
              } catch (e) {
                log('Error parsing service order ${doc.id}: $e');
                return null;
              }
            })
            .whereType<ServiceOrder>()
            .toList();
      });
    } catch (e) {
      log('Error getting service orders stream: $e');
      return Stream.value([]);
    }
  }

  // Get service orders with pagination
  Future<List<ServiceOrder>> getServiceOrdersPaginated({
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = firestore
          .collection('service_orders')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) {
            try {
              return ServiceOrder.fromJson(
                  {...doc.data() as Map<String, dynamic>, 'id': doc.id});
            } catch (e) {
              log('Error parsing service order ${doc.id}: $e');
              return null;
            }
          })
          .whereType<ServiceOrder>()
          .toList();
    } catch (e) {
      log('Error getting paginated service orders: $e');
      return [];
    }
  }

  // Get service order document for pagination
  Future<DocumentSnapshot?> getServiceOrderDocument(String orderId) async {
    try {
      final doc =
          await firestore.collection('service_orders').doc(orderId).get();
      return doc.exists ? doc : null;
    } catch (e) {
      log('Error getting service order document: $e');
      return null;
    }
  }

  // Get service orders by vehicle
  Stream<List<ServiceOrder>> getServiceOrdersByVehicle(String vehicleId) {
    try {
      return firestore
          .collection('service_orders')
          .where('vehicleId', isEqualTo: vehicleId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) {
              try {
                return ServiceOrder.fromJson({...doc.data(), 'id': doc.id});
              } catch (e) {
                log('Error parsing service order ${doc.id}: $e');
                return null;
              }
            })
            .whereType<ServiceOrder>()
            .toList();
      });
    } catch (e) {
      log('Error getting vehicle service orders: $e');
      return Stream.value([]);
    }
  }

  // Get service orders by vehicle with pagination
  Future<List<ServiceOrder>> getServiceOrdersByVehiclePaginated({
    required String vehicleId,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = firestore
          .collection('service_orders')
          .where('vehicleId', isEqualTo: vehicleId)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) {
            try {
              return ServiceOrder.fromJson(
                  {...doc.data() as Map<String, dynamic>, 'id': doc.id});
            } catch (e) {
              log('Error parsing service order ${doc.id}: $e');
              return null;
            }
          })
          .whereType<ServiceOrder>()
          .toList();
    } catch (e) {
      log('Error getting paginated vehicle service orders: $e');
      return [];
    }
  }

  // Get service orders by customer
  Stream<List<ServiceOrder>> getServiceOrdersByCustomer(String customerId) {
    try {
      return firestore
          .collection('service_orders')
          .where('customerId', isEqualTo: customerId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) {
              try {
                return ServiceOrder.fromJson({...doc.data(), 'id': doc.id});
              } catch (e) {
                log('Error parsing service order ${doc.id}: $e');
                return null;
              }
            })
            .whereType<ServiceOrder>()
            .toList();
      });
    } catch (e) {
      log('Error getting customer service orders: $e');
      return Stream.value([]);
    }
  }

  // Get single service order
  Future<ServiceOrder?> getServiceOrder(String orderId) async {
    try {
      final doc =
          await firestore.collection('service_orders').doc(orderId).get();
      if (doc.exists) {
        return ServiceOrder.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      log('Error getting service order: $e');
      return null;
    }
  }

  // Get single service order as stream
  Stream<ServiceOrder?> getServiceOrderStream(String orderId) {
    try {
      return firestore
          .collection('service_orders')
          .doc(orderId)
          .snapshots()
          .map((doc) {
        if (doc.exists) {
          try {
            return ServiceOrder.fromJson({...doc.data()!, 'id': doc.id});
          } catch (e) {
            log('Error parsing service order: $e');
            return null;
          }
        }
        return null;
      });
    } catch (e) {
      log('Error getting service order stream: $e');
      return Stream.value(null);
    }
  }

  // Update ServiceOrder
  Future<void> updateServiceOrder(
      BuildContext context, ServiceOrder serviceOrder) async {
    try {
      await firestore
          .collection('service_orders')
          .doc(serviceOrder.id)
          .update(serviceOrder.toJson());

      if (context.mounted) {
        showSnackBar(
            content: 'Service order updated successfully!', context: context);
      }
    } on FirebaseException catch (e) {
      log('Firebase error updating service order: ${e.message}');
      if (context.mounted) {
        showSnackBar(
          content: e.message ?? 'Failed to update service order',
          context: context,
        );
      }
    } catch (e) {
      log('Error updating service order: $e');
      if (context.mounted) {
        showSnackBar(content: 'Error: ${e.toString()}', context: context);
      }
    }
  }

  // Update service order status
  Future<void> updateServiceOrderStatus(
    BuildContext context,
    String orderId,
    String status,
  ) async {
    try {
      final updates = <String, dynamic>{
        'status': status,
      };

      if (status == 'completed') {
        updates['completedAt'] = DateTime.now().toIso8601String();
      }

      await firestore.collection('service_orders').doc(orderId).update(updates);

      if (context.mounted) {
        showSnackBar(content: 'Status updated to $status', context: context);
      }
    } catch (e) {
      log('Error updating service order status: $e');
      if (context.mounted) {
        showSnackBar(content: 'Error: ${e.toString()}', context: context);
      }
    }
  }

  // Delete ServiceOrder
  Future<void> deleteServiceOrder(BuildContext context, String orderId) async {
    try {
      await firestore.collection('service_orders').doc(orderId).delete();

      if (context.mounted) {
        showSnackBar(
            content: 'Service order deleted successfully!', context: context);
      }
    } on FirebaseException catch (e) {
      log('Firebase error deleting service order: ${e.message}');
      if (context.mounted) {
        showSnackBar(
          content: e.message ?? 'Failed to delete service order',
          context: context,
        );
      }
    } catch (e) {
      log('Error deleting service order: $e');
      if (context.mounted) {
        showSnackBar(content: 'Error: ${e.toString()}', context: context);
      }
    }
  }

  // Delete all service orders for a vehicle
  Future<void> deleteAllServiceOrdersByVehicle(
      BuildContext context, String vehicleId) async {
    try {
      // Get all service orders for the vehicle
      final snapshot = await firestore
          .collection('service_orders')
          .where('vehicleId', isEqualTo: vehicleId)
          .get();

      if (snapshot.docs.isEmpty) {
        return; // No orders to delete
      }

      // Use batch write to delete all orders (max 500 per batch)
      final batches = <WriteBatch>[];
      WriteBatch? currentBatch = firestore.batch();
      int batchCount = 0;

      for (var doc in snapshot.docs) {
        currentBatch!.delete(doc.reference);
        batchCount++;

        // Firestore batch limit is 500 operations
        if (batchCount >= 500) {
          batches.add(currentBatch);
          currentBatch = firestore.batch();
          batchCount = 0;
        }
      }

      // Add the last batch if it has operations
      if (batchCount > 0 && currentBatch != null) {
        batches.add(currentBatch);
      }

      // Execute all batches
      for (var batch in batches) {
        await batch.commit();
      }

      log('Deleted ${snapshot.docs.length} service orders for vehicle $vehicleId');
    } on FirebaseException catch (e) {
      log('Firebase error deleting service orders: ${e.message}');
      if (context.mounted) {
        showSnackBar(
          content: e.message ?? 'Failed to delete service orders',
          context: context,
        );
      }
      rethrow;
    } catch (e) {
      log('Error deleting service orders: $e');
      if (context.mounted) {
        showSnackBar(content: 'Error: ${e.toString()}', context: context);
      }
      rethrow;
    }
  }

  // Get analytics data
  Future<Map<String, dynamic>> getAnalytics() async {
    try {
      final ordersSnapshot = await firestore.collection('service_orders').get();

      double totalRevenue = 0;
      int completedOrders = 0;
      int pendingOrders = 0;
      int activeOrders = 0;

      // Today's statistics
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      int todayOrders = 0;
      double todayRevenue = 0.0;

      for (var doc in ordersSnapshot.docs) {
        final order = ServiceOrder.fromJson({...doc.data(), 'id': doc.id});

        // Overall statistics
        if (order.status == 'completed' || order.status == 'delivered') {
          totalRevenue += order.totalCost;
          completedOrders++;
        } else if (order.status == 'pending') {
          pendingOrders++;
        } else if (order.status == 'in_progress') {
          activeOrders++;
        }

        // Today's statistics
        if (order.createdAt != null &&
            order.createdAt!.isAfter(todayStart) &&
            order.createdAt!.isBefore(todayEnd)) {
          todayOrders++;
          if (order.status == 'completed' || order.status == 'delivered') {
            todayRevenue += order.totalCost;
          }
        }
      }

      return {
        'totalRevenue': totalRevenue,
        'completedOrders': completedOrders,
        'pendingOrders': pendingOrders,
        'activeOrders': activeOrders,
        'totalOrders': ordersSnapshot.size,
        'todayOrders': todayOrders,
        'todayRevenue': todayRevenue,
      };
    } catch (e) {
      log('Error getting analytics: $e');
      return {
        'totalRevenue': 0.0,
        'completedOrders': 0,
        'pendingOrders': 0,
        'activeOrders': 0,
        'totalOrders': 0,
      };
    }
  }
}

final serviceOrderRepositoryProvider = Provider((ref) {
  return ServiceOrderRepository(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  );
});
