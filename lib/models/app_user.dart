import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    @Default('') String id,
    required String name,
    required String email,
    String? phone,
    String? photoUrl,
    @Default('mechanic') String role, // owner, manager, mechanic, staff
    @Default(true) bool isActive,
    @Default([]) List<String> permissions,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}

