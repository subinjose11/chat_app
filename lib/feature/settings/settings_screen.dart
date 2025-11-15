import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/core/services/backup_service.dart';
import 'package:chat_app/core/services/notification_controller.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _autoBackup = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notificationPrefs = ref.watch(notificationControllerProvider);
    final notificationController =
        ref.read(notificationControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Workshop Owner',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'RN Auto garage',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Edit profile
                  },
                  icon: const Icon(Icons.edit, color: AppColors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Notifications Section
          _buildSectionTitle(isDark, 'Notifications'),
          const SizedBox(height: 12),
          _buildSettingsCard(
            isDark,
            [
              _buildSwitchTile(
                isDark,
                'Enable Notifications',
                'Master toggle for all notifications',
                Icons.notifications_active,
                notificationPrefs.enabled,
                (value) => notificationController.updateEnabled(value),
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                isDark,
                'New Service Orders',
                'Notify when new order is created',
                Icons.add_circle,
                notificationPrefs.newOrderNotifications,
                (value) =>
                    notificationController.updateNewOrderNotifications(value),
                enabled: notificationPrefs.enabled,
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                isDark,
                'Status Changes',
                'Notify when order status changes',
                Icons.update,
                notificationPrefs.statusChangeNotifications,
                (value) => notificationController
                    .updateStatusChangeNotifications(value),
                enabled: notificationPrefs.enabled,
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                isDark,
                'Daily Summary',
                'Get daily work summary every morning',
                Icons.summarize,
                notificationPrefs.dailySummaryNotifications,
                (value) => notificationController
                    .updateDailySummaryNotifications(value),
                enabled: notificationPrefs.enabled,
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                isDark,
                '30-Day Reminders',
                'Follow-up reminders for completed orders',
                Icons.event_repeat,
                notificationPrefs.monthlyReminderNotifications,
                (value) => notificationController
                    .updateMonthlyReminderNotifications(value),
                enabled: notificationPrefs.enabled,
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                isDark,
                'Overdue Order Alerts',
                'Alert for orders taking too long',
                Icons.warning,
                notificationPrefs.overdueOrderNotifications,
                (value) => notificationController
                    .updateOverdueOrderNotifications(value),
                enabled: notificationPrefs.enabled,
              ),
              const Divider(height: 1),
              _buildActionTile(
                isDark,
                'Daily Summary Time',
                '${notificationPrefs.dailySummaryHour.toString().padLeft(2, '0')}:${notificationPrefs.dailySummaryMinute.toString().padLeft(2, '0')}',
                Icons.schedule,
                () => _showTimePicker(
                  context,
                  notificationPrefs.dailySummaryHour,
                  notificationPrefs.dailySummaryMinute,
                  (hour, minute) => notificationController
                      .updateDailySummaryTime(hour, minute),
                ),
              ),
              const Divider(height: 1),
              _buildActionTile(
                isDark,
                'Overdue Threshold',
                '${notificationPrefs.overdueThresholdDays} days',
                Icons.timer,
                () => _showThresholdPicker(
                  context,
                  notificationPrefs.overdueThresholdDays,
                  (days) =>
                      notificationController.updateOverdueThresholdDays(days),
                ),
              ),
              const Divider(height: 1),
              _buildActionTile(
                isDark,
                'Test Notification',
                'Send a test notification',
                Icons.notification_add,
                () => notificationController.sendTestNotification(),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Data & Backup Section
          _buildSectionTitle(isDark, 'Data & Backup'),
          const SizedBox(height: 12),
          _buildSettingsCard(
            isDark,
            [
              _buildSwitchTile(
                isDark,
                'Auto Backup',
                'Automatically backup data daily',
                Icons.backup,
                _autoBackup,
                (value) {
                  setState(() => _autoBackup = value);
                },
              ),
              const Divider(height: 1),
              _buildActionTile(
                isDark,
                'Backup Now',
                'Create a backup of all data',
                Icons.cloud_upload,
                () {
                  _showBackupDialog(context);
                },
              ),
              const Divider(height: 1),
              _buildActionTile(
                isDark,
                'Restore Data',
                'Restore from a previous backup',
                Icons.cloud_download,
                () {
                  _showRestoreDialog(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Business Features Section
          _buildSectionTitle(isDark, 'Business Features'),
          const SizedBox(height: 12),
          _buildSettingsCard(
            isDark,
            [
              _buildActionTile(
                isDark,
                'Expenses',
                'Manage business expenses',
                Icons.receipt_long,
                () => context.push('/expenses'),
              ),
              const Divider(height: 1),
              _buildActionTile(
                isDark,
                'Inventory',
                'Track parts and stock levels',
                Icons.inventory_2,
                () => context.push('/inventory'),
              ),
              const Divider(height: 1),
              _buildActionTile(
                isDark,
                'Appointments',
                'Schedule and manage appointments',
                Icons.event,
                () => context.push('/appointments'),
              ),
              const Divider(height: 1),
              _buildActionTile(
                isDark,
                'Analytics',
                'View business insights and charts',
                Icons.analytics,
                () => context.push('/analytics'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Security Section
          _buildSectionTitle(isDark, 'Security'),
          const SizedBox(height: 12),
          _buildSettingsCard(
            isDark,
            [
              _buildActionTile(
                isDark,
                'Biometric Authentication',
                'Enable fingerprint/face unlock',
                Icons.fingerprint,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Biometric authentication available in device settings')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // About Section
          _buildSectionTitle(isDark, 'About'),
          const SizedBox(height: 12),
          _buildSettingsCard(
            isDark,
            [
              _buildActionTile(
                isDark,
                'Help & Support',
                'Get help and contact support',
                Icons.help,
                () {
                  // TODO: Navigate to help
                },
              ),
              const Divider(height: 1),
              _buildActionTile(
                isDark,
                'Terms & Privacy',
                'View terms of service and privacy policy',
                Icons.policy,
                () {
                  // TODO: Navigate to terms
                },
              ),
              const Divider(height: 1),
              _buildInfoTile(
                isDark,
                'App Version',
                '1.0.0',
                Icons.info,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Logout Button
          ElevatedButton.icon(
            onPressed: () {
              _showLogoutDialog(context);
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(bool isDark, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.white : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSettingsCard(bool isDark, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : AppColors.gray300.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(
    bool isDark,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged, {
    bool enabled = true,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: enabled ? AppColors.gray500 : AppColors.gray400,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: enabled
              ? (isDark ? AppColors.white : AppColors.textPrimary)
              : AppColors.gray400,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? AppColors.gray400 : AppColors.textSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
        activeColor: AppColors.primaryBlue,
      ),
    );
  }

  Widget _buildActionTile(
    bool isDark,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.gray500),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.white : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? AppColors.gray400 : AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.gray400),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile(
    bool isDark,
    String title,
    String value,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.gray500),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.white : AppColors.textPrimary,
        ),
      ),
      trailing: Text(
        value,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? AppColors.gray400 : AppColors.textSecondary,
        ),
      ),
    );
  }

  Future<void> _showBackupDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Backup Data'),
          content: const Text(
            'This will create a backup of all your workshop data including vehicles, customers, and service records.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                // Show loading
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Creating backup...')),
                );

                try {
                  final backupFile = await BackupService.backupAllData();

                  if (backupFile != null && context.mounted) {
                    // Share the backup file
                    await BackupService.shareBackup(backupFile);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Backup created and shared successfully!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to create backup'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              child: const Text('Backup'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRestoreDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Restore Data'),
          content: const Text(
            'This will restore your data from a previous backup. Current data will be replaced.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                // Show loading
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Restoring data...')),
                );

                try {
                  final success = await BackupService.restoreFromBackup();

                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data restored successfully!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Restore cancelled or failed'),
                        backgroundColor: AppColors.warning,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
              ),
              child: const Text('Restore'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
                context.go('/login');
                // TODO: Implement logout
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showTimePicker(
    BuildContext context,
    int currentHour,
    int currentMinute,
    Function(int hour, int minute) onTimeSelected,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: currentHour, minute: currentMinute),
    );

    if (picked != null) {
      onTimeSelected(picked.hour, picked.minute);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Daily summary time updated to ${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  Future<void> _showThresholdPicker(
    BuildContext context,
    int currentDays,
    Function(int days) onDaysSelected,
  ) async {
    int selectedDays = currentDays;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Overdue Threshold'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Orders in progress for more than:'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: selectedDays > 1
                            ? () => setState(() => selectedDays--)
                            : null,
                        icon: const Icon(Icons.remove_circle),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$selectedDays days',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: selectedDays < 30
                            ? () => setState(() => selectedDays++)
                            : null,
                        icon: const Icon(Icons.add_circle),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    onDaysSelected(selectedDays);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Overdue threshold set to $selectedDays days'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
