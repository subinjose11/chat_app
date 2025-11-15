import 'package:freezed_annotation/freezed_annotation.dart';

part 'in_app_notification.freezed.dart';
part 'in_app_notification.g.dart';

@freezed
class InAppNotification with _$InAppNotification {
  const factory InAppNotification({
    @Default('') String id,
    required String title,
    required String body,
    @Default('info')
    String type, // new_order, status_change, reminder, summary, overdue
    String? orderId,
    String? vehicleId,
    String? customerId,
    @Default(false) bool isRead,
    required DateTime createdAt,
    Map<String, dynamic>? data,
  }) = _InAppNotification;

  factory InAppNotification.fromJson(Map<String, dynamic> json) =>
      _$InAppNotificationFromJson(json);
}
