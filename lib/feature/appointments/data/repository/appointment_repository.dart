import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/models/appointment.dart';

final appointmentRepositoryProvider = Provider((ref) {
  return AppointmentRepository(
    firestore: FirebaseFirestore.instance,
  );
});

final appointmentsStreamProvider = StreamProvider.autoDispose<List<Appointment>>((ref) {
  return ref.read(appointmentRepositoryProvider).getAppointmentsStream();
});

final upcomingAppointmentsStreamProvider = StreamProvider.autoDispose<List<Appointment>>((ref) {
  return ref.read(appointmentRepositoryProvider).getUpcomingAppointmentsStream();
});

class AppointmentRepository {
  final FirebaseFirestore firestore;

  AppointmentRepository({required this.firestore});

  // Create Appointment
  Future<void> createAppointment(BuildContext context, Appointment appointment) async {
    try {
      final docId = appointment.id.isNotEmpty
          ? appointment.id
          : firestore.collection('appointments').doc().id;
      final docRef = firestore.collection('appointments').doc(docId);
      final appointmentWithId = appointment.copyWith(
        id: docId,
        createdAt: DateTime.now(),
      );
      await docRef.set(appointmentWithId.toJson());
      if (context.mounted) {
        showSnackBar(context: context, content: 'Appointment scheduled successfully');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  // Get All Appointments Stream
  Stream<List<Appointment>> getAppointmentsStream() {
    return firestore
        .collection('appointments')
        .orderBy('appointmentDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Appointment.fromJson(doc.data());
      }).toList();
    });
  }

  // Get Upcoming Appointments Stream
  Stream<List<Appointment>> getUpcomingAppointmentsStream() {
    final now = DateTime.now();
    return firestore
        .collection('appointments')
        .where('appointmentDate', isGreaterThanOrEqualTo: now)
        .where('status', whereIn: ['scheduled', 'confirmed'])
        .orderBy('appointmentDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Appointment.fromJson(doc.data());
      }).toList();
    });
  }

  // Update Appointment
  Future<void> updateAppointment(BuildContext context, Appointment appointment) async {
    try {
      await firestore
          .collection('appointments')
          .doc(appointment.id)
          .update(appointment.toJson());
      if (context.mounted) {
        showSnackBar(context: context, content: 'Appointment updated successfully');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  // Delete Appointment
  Future<void> deleteAppointment(BuildContext context, String appointmentId) async {
    try {
      await firestore.collection('appointments').doc(appointmentId).delete();
      if (context.mounted) {
        showSnackBar(context: context, content: 'Appointment cancelled successfully');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  // Update Appointment Status
  Future<void> updateAppointmentStatus(
      BuildContext context, String appointmentId, String status) async {
    try {
      await firestore.collection('appointments').doc(appointmentId).update({
        'status': status,
      });
      if (context.mounted) {
        showSnackBar(context: context, content: 'Status updated successfully');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }
}

