import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/local/notification_history_repo.dart';
import 'package:chat_app/models/in_app_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notificationsAsync = ref.watch(allNotificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () async {
              await ref.read(notificationHistoryRepoProvider).markAllAsRead();
              ref.invalidate(allNotificationsProvider);
              ref.invalidate(unreadNotificationCountProvider);
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All notifications marked as read'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            tooltip: 'Mark all as read',
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'clear_all') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear All Notifications'),
                    content: const Text(
                      'Are you sure you want to delete all notifications? This cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await ref.read(notificationHistoryRepoProvider).clearAll();
                  ref.invalidate(allNotificationsProvider);
                  ref.invalidate(unreadNotificationCountProvider);
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All notifications cleared'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, color: AppColors.error),
                    SizedBox(width: 8),
                    Text('Clear All'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 80,
                    color: isDark ? AppColors.gray600 : AppColors.gray400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.gray500 : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You\'ll see notifications here',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.gray600 : AppColors.textHint,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(allNotificationsProvider);
              ref.invalidate(unreadNotificationCountProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildNotificationItem(
                    context,
                    ref,
                    notification,
                    isDark,
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Error loading notifications: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(allNotificationsProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    WidgetRef ref,
    InAppNotification notification,
    bool isDark,
  ) {
    final icon = _getNotificationIcon(notification.type);
    final color = _getNotificationColor(notification.type);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: AppColors.white,
        ),
      ),
      onDismissed: (direction) async {
        await ref
            .read(notificationHistoryRepoProvider)
            .deleteNotification(notification.id);
        ref.invalidate(allNotificationsProvider);
        ref.invalidate(unreadNotificationCountProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Notification deleted'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () async {
                  await ref
                      .read(notificationHistoryRepoProvider)
                      .addNotification(notification);
                  ref.invalidate(allNotificationsProvider);
                  ref.invalidate(unreadNotificationCountProvider);
                },
              ),
            ),
          );
        }
      },
      child: InkWell(
        onTap: () async {
          // Mark as read
          if (!notification.isRead) {
            await ref
                .read(notificationHistoryRepoProvider)
                .markAsRead(notification.id);
            ref.invalidate(allNotificationsProvider);
            ref.invalidate(unreadNotificationCountProvider);
          }

          // Navigate based on notification type
          if (notification.orderId != null && context.mounted) {
            // Navigate to service orders list where user can find and view the order
            context.pop(); // Close notifications screen
            context.push('/service-orders');
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead
                ? (isDark ? AppColors.cardBackgroundDark : AppColors.white)
                : (isDark
                    ? AppColors.primaryBlue.withOpacity(0.1)
                    : AppColors.primaryLight.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: notification.isRead
                  ? (isDark ? AppColors.gray700 : AppColors.gray200)
                  : (isDark
                      ? AppColors.primaryBlue.withOpacity(0.3)
                      : AppColors.primaryLight.withOpacity(0.5)),
              width: notification.isRead ? 1 : 2,
            ),
            boxShadow: [
              if (!notification.isRead)
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                              color: isDark ? AppColors.white : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.gray400 : AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDateTime(notification.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.gray500 : AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: isDark ? AppColors.gray600 : AppColors.gray400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'new_order':
        return Icons.add_circle;
      case 'status_change':
        return Icons.update;
      case 'reminder':
        return Icons.alarm;
      case 'summary':
        return Icons.summarize;
      case 'overdue':
        return Icons.warning;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'new_order':
        return AppColors.success;
      case 'status_change':
        return AppColors.primaryBlue;
      case 'reminder':
        return AppColors.info;
      case 'summary':
        return AppColors.gray500;
      case 'overdue':
        return AppColors.warning;
      default:
        return AppColors.gray500;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${DateFormat('HH:mm').format(dateTime)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, HH:mm').format(dateTime);
    }
  }
}

