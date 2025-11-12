import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/feature/appointments/data/repository/appointment_repository.dart';
import 'package:chat_app/models/appointment.dart';

final appointmentControllerProvider = Provider((ref) {
  return AppointmentController(
    appointmentRepository: ref.read(appointmentRepositoryProvider),
  );
});

class AppointmentController {
  final AppointmentRepository appointmentRepository;

  AppointmentController({required this.appointmentRepository});

  void createAppointment(BuildContext context, Appointment appointment) {
    appointmentRepository.createAppointment(context, appointment);
  }

  void updateAppointment(BuildContext context, Appointment appointment) {
    appointmentRepository.updateAppointment(context, appointment);
  }

  void deleteAppointment(BuildContext context, String appointmentId) {
    appointmentRepository.deleteAppointment(context, appointmentId);
  }

  void updateAppointmentStatus(
      BuildContext context, String appointmentId, String status) {
    appointmentRepository.updateAppointmentStatus(context, appointmentId, status);
  }
}

