import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/core/services/backup_service.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _serviceReminders = true;
  bool _autoBackup = false;
  String _themeMode = 'system'; // light, dark, system

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                        'AutoTrack Pro',
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

          // Appearance Section
          _buildSectionTitle(isDark, 'Appearance'),
          const SizedBox(height: 12),
          _buildSettingsCard(
            isDark,
            [
              _buildThemeSelector(isDark),
            ],
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
                'Receive notifications for important updates',
                Icons.notifications,
                _notificationsEnabled,
                (value) {
                  setState(() => _notificationsEnabled = value);
                },
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                isDark,
                'Push Notifications',
                'Get push notifications on your device',
                Icons.mobile_friendly,
                _pushNotifications,
                (value) {
                  setState(() => _pushNotifications = value);
                },
                enabled: _notificationsEnabled,
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                isDark,
                'Email Notifications',
                'Receive notifications via email',
                Icons.email,
                _emailNotifications,
                (value) {
                  setState(() => _emailNotifications = value);
                },
                enabled: _notificationsEnabled,
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                isDark,
                'Service Reminders',
                'Get reminders for upcoming services',
                Icons.alarm,
                _serviceReminders,
                (value) {
                  setState(() => _serviceReminders = value);
                },
                enabled: _notificationsEnabled,
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
                'Payments',
                'Track payments and revenue',
                Icons.payment,
                () => context.push('/payments'),
              ),
              const Divider(height: 1),
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

  Widget _buildThemeSelector(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.palette, color: AppColors.gray500, size: 24),
              const SizedBox(width: 12),
              Text(
                'Theme',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildThemeOption(
                    'Light', 'light', Icons.light_mode, isDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child:
                    _buildThemeOption('Dark', 'dark', Icons.dark_mode, isDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildThemeOption(
                    'System', 'system', Icons.settings_brightness, isDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
      String label, String value, IconData icon, bool isDark) {
    final isSelected = _themeMode == value;

    return GestureDetector(
      onTap: () {
        setState(() => _themeMode = value);
        // TODO: Apply theme change
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label theme will be applied')),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlue.withOpacity(0.1)
              : (isDark ? AppColors.gray800 : AppColors.gray100),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBlue
                : (isDark ? AppColors.gray700 : AppColors.gray300),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryBlue : AppColors.gray500,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primaryBlue : AppColors.gray600,
              ),
            ),
          ],
        ),
      ),
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
}
