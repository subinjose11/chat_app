import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    @Default('') String id,
    required String title,
    required String body,
    @Default('info') String type, // info, success, warning, error, reminder
    String? targetScreen,
    Map<String, dynamic>? data,
    @Default(false) bool isRead,
    DateTime? createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

