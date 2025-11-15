// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/models/vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleRepository {
  final FirebaseFirestore firestore;

  VehicleRepository({required this.firestore});

  // Create Vehicle
  Future<void> createVehicle(BuildContext context, Vehicle vehicle) async {
    try {
      // Use existing ID if provided, otherwise generate new one
      final docId = vehicle.id.isNotEmpty
          ? vehicle.id
          : firestore.collection('vehicles').doc().id;
      final docRef = firestore.collection('vehicles').doc(docId);
      final vehicleWithId = vehicle.copyWith(
        id: docId,
        createdAt: DateTime.now(),
      );

      await docRef.set(vehicleWithId.toJson());

      if (context.mounted) {
        showSnackBar(content: 'Vehicle added successfully!', context: context);
      }
    } on FirebaseException catch (e) {
      log('Firebase error creating vehicle: ${e.message}');
      if (context.mounted) {
        showSnackBar(
          content: e.message ?? 'Failed to create vehicle',
          context: context,
        );
      }
    } catch (e) {
      log('Error creating vehicle: $e');
      if (context.mounted) {
        showSnackBar(content: 'Error: ${e.toString()}', context: context);
      }
    }
  }

  // Get all vehicles as stream
  Stream<List<Vehicle>> getVehiclesStream() {
    try {
      return firestore
          .collection('vehicles')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) {
              try {
                return Vehicle.fromJson({...doc.data(), 'id': doc.id});
              } catch (e) {
                log('Error parsing vehicle ${doc.id}: $e');
                return null;
              }
            })
            .whereType<Vehicle>()
            .toList();
      });
    } catch (e) {
      log('Error getting vehicles stream: $e');
      return Stream.value([]);
    }
  }

  // Get vehicles with pagination
  Future<List<Vehicle>> getVehiclesPaginated({
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = firestore
          .collection('vehicles')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) {
            try {
              return Vehicle.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
            } catch (e) {
              log('Error parsing vehicle ${doc.id}: $e');
              return null;
            }
          })
          .whereType<Vehicle>()
          .toList();
    } catch (e) {
      log('Error getting paginated vehicles: $e');
      return [];
    }
  }

  // Get last document for pagination
  Future<DocumentSnapshot?> getVehicleDocument(String vehicleId) async {
    try {
      final doc = await firestore.collection('vehicles').doc(vehicleId).get();
      return doc.exists ? doc : null;
    } catch (e) {
      log('Error getting vehicle document: $e');
      return null;
    }
  }

  // Search vehicles with pagination
  Future<List<Vehicle>> searchVehiclesPaginated({
    required String query,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query firestoreQuery = firestore
          .collection('vehicles')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        firestoreQuery = firestoreQuery.startAfterDocument(lastDocument);
      }

      final snapshot = await firestoreQuery.get();
      final vehicles = snapshot.docs
          .map((doc) {
            try {
              return Vehicle.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
            } catch (e) {
              return null;
            }
          })
          .whereType<Vehicle>()
          .toList();

      if (query.isEmpty) {
        return vehicles;
      }

      final searchLower = query.toLowerCase();
      return vehicles
          .where((vehicle) =>
              vehicle.numberPlate.toLowerCase().contains(searchLower) ||
              vehicle.make.toLowerCase().contains(searchLower) ||
              vehicle.model.toLowerCase().contains(searchLower))
          .toList();
    } catch (e) {
      log('Error searching paginated vehicles: $e');
      return [];
    }
  }

  // Get vehicles by customer ID
  Stream<List<Vehicle>> getVehiclesByCustomer(String customerId) {
    try {
      return firestore
          .collection('vehicles')
          .where('customerId', isEqualTo: customerId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) {
              try {
                return Vehicle.fromJson({...doc.data(), 'id': doc.id});
              } catch (e) {
                log('Error parsing vehicle ${doc.id}: $e');
                return null;
              }
            })
            .whereType<Vehicle>()
            .toList();
      });
    } catch (e) {
      log('Error getting customer vehicles: $e');
      return Stream.value([]);
    }
  }

  // Get single vehicle
  Future<Vehicle?> getVehicle(String vehicleId) async {
    try {
      final doc = await firestore.collection('vehicles').doc(vehicleId).get();
      if (doc.exists) {
        return Vehicle.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      log('Error getting vehicle: $e');
      return null;
    }
  }

  // Get single vehicle as stream
  Stream<Vehicle?> getVehicleStream(String vehicleId) {
    try {
      return firestore
          .collection('vehicles')
          .doc(vehicleId)
          .snapshots()
          .map((doc) {
        if (doc.exists) {
          try {
            return Vehicle.fromJson({...doc.data()!, 'id': doc.id});
          } catch (e) {
            log('Error parsing vehicle: $e');
            return null;
          }
        }
        return null;
      });
    } catch (e) {
      log('Error getting vehicle stream: $e');
      return Stream.value(null);
    }
  }

  // Update Vehicle
  Future<void> updateVehicle(BuildContext context, Vehicle vehicle) async {
    try {
      final updateData = vehicle.toJson();
      // Remove id from update data as it's the document ID and shouldn't be updated
      updateData.remove('id');
      await firestore
          .collection('vehicles')
          .doc(vehicle.id)
          .update(updateData);

      if (context.mounted) {
        showSnackBar(
            content: 'Vehicle updated successfully!', context: context);
      }
    } on FirebaseException catch (e) {
      log('Firebase error updating vehicle: ${e.message}');
      if (context.mounted) {
        showSnackBar(
          content: e.message ?? 'Failed to update vehicle',
          context: context,
        );
      }
    } catch (e) {
      log('Error updating vehicle: $e');
      if (context.mounted) {
        showSnackBar(content: 'Error: ${e.toString()}', context: context);
      }
    }
  }

  // Delete Vehicle
  Future<void> deleteVehicle(BuildContext context, String vehicleId) async {
    try {
      await firestore.collection('vehicles').doc(vehicleId).delete();

      if (context.mounted) {
        showSnackBar(
            content: 'Vehicle deleted successfully!', context: context);
      }
    } on FirebaseException catch (e) {
      log('Firebase error deleting vehicle: ${e.message}');
      if (context.mounted) {
        showSnackBar(
          content: e.message ?? 'Failed to delete vehicle',
          context: context,
        );
      }
    } catch (e) {
      log('Error deleting vehicle: $e');
      if (context.mounted) {
        showSnackBar(content: 'Error: ${e.toString()}', context: context);
      }
    }
  }

  // Search vehicles
  Stream<List<Vehicle>> searchVehicles(String query) {
    try {
      if (query.isEmpty) {
        return getVehiclesStream();
      }

      return firestore.collection('vehicles').snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) {
              try {
                return Vehicle.fromJson({...doc.data(), 'id': doc.id});
              } catch (e) {
                return null;
              }
            })
            .whereType<Vehicle>()
            .where((vehicle) {
              final searchLower = query.toLowerCase();
              return vehicle.numberPlate.toLowerCase().contains(searchLower) ||
                  vehicle.make.toLowerCase().contains(searchLower) ||
                  vehicle.model.toLowerCase().contains(searchLower);
            })
            .toList();
      });
    } catch (e) {
      log('Error searching vehicles: $e');
      return Stream.value([]);
    }
  }
}

final vehicleRepositoryProvider = Provider((ref) {
  return VehicleRepository(firestore: FirebaseFirestore.instance);
});
