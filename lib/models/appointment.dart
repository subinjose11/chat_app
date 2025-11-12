import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment.freezed.dart';
part 'appointment.g.dart';

@freezed
class Appointment with _$Appointment {
  const factory Appointment({
    @Default('') String id,
    required String customerId,
    required String vehicleId,
    required DateTime appointmentDate,
    required String serviceType,
    String? description,
    @Default('scheduled') String status, // scheduled, confirmed, in_progress, completed, cancelled
    String? assignedMechanicId,
    int? estimatedDuration, // in minutes
    String? notes,
    DateTime? createdAt,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
}

