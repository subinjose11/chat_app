import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/feature/appointments/data/repository/appointment_repository.dart';
import 'package:chat_app/feature/appointments/presentation/controller/appointment_controller.dart';
import 'package:chat_app/models/appointment.dart';

class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appointmentsAsync = ref.watch(upcomingAppointmentsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: appointmentsAsync.when(
        data: (appointments) {
          if (appointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_available_outlined, size: 64,
                      color: isDark ? AppColors.gray600 : AppColors.gray400),
                  const SizedBox(height: 16),
                  Text('No Upcoming Appointments', style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.white : AppColors.textPrimary)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Container(
                key: ValueKey('appointment_${appointment.id}'),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(
                      color: isDark ? Colors.black26 : AppColors.gray300.withOpacity(0.3),
                      blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(appointment.serviceType, style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.white : AppColors.textPrimary)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(appointment.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(appointment.status.toUpperCase(), style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold,
                              color: _getStatusColor(appointment.status))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: AppColors.primaryBlue),
                        const SizedBox(width: 4),
                        Text(DateFormat('MMM dd, yyyy - hh:mm a').format(appointment.appointmentDate),
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                                color: AppColors.primaryBlue)),
                      ],
                    ),
                    if (appointment.description != null) ...[
                      const SizedBox(height: 8),
                      Text(appointment.description!, style: TextStyle(
                          fontSize: 14, color: isDark ? AppColors.gray400 : AppColors.textSecondary)),
                    ],
                    if (appointment.estimatedDuration != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 14, color: AppColors.gray500),
                          const SizedBox(width: 4),
                          Text('Duration: ${appointment.estimatedDuration} minutes', style: TextStyle(
                              fontSize: 12, color: isDark ? AppColors.gray400 : AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => _showAddAppointmentDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Book Appointment'),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
      case 'confirmed':
        return const Color(0xFF2196F3); // Blue - Appointment scheduled
      case 'in_progress':
        return const Color(0xFFFF9800); // Orange - Appointment in progress
      case 'completed':
        return const Color(0xFF4CAF50); // Green - Appointment completed
      case 'cancelled':
        return const Color(0xFFEF5350); // Red - Appointment cancelled
      default:
        return AppColors.gray500; // Gray - Unknown status
    }
  }

  void _showAddAppointmentDialog(BuildContext context, WidgetRef ref) {
    final serviceTypeController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Book Appointment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: serviceTypeController,
                  decoration: const InputDecoration(labelText: 'Service Type')),
              const SizedBox(height: 16),
              TextField(controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Date & Time'),
                subtitle: Text(DateFormat('MMM dd, yyyy - hh:mm a').format(selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedDate),
                    );
                    if (time != null) {
                      selectedDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                    }
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (serviceTypeController.text.isEmpty) return;
              
              final appointment = Appointment(
                customerId: '', // Link in full implementation
                vehicleId: '', // Link in full implementation
                appointmentDate: selectedDate,
                serviceType: serviceTypeController.text,
                description: descriptionController.text.isEmpty ? null : descriptionController.text,
              );

              ref.read(appointmentControllerProvider).createAppointment(context, appointment);
              Navigator.pop(context);
            },
            child: const Text('Book'),
          ),
        ],
      ),
    );
  }
}

