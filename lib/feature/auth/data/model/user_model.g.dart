// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String?,
      user_name: json['user_name'] as String?,
      full_name: json['full_name'] as String?,
      avatar_url: json['avatar_url'] as String?,
      phone_number: json['phone_number'] as String?,
      updated_at: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_name': instance.user_name,
      'full_name': instance.full_name,
      'avatar_url': instance.avatar_url,
      'phone_number': instance.phone_number,
      'updated_at': instance.updated_at,
    };
