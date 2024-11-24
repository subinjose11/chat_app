// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String?,
      user_name: json['user_name'] as String?,
      avatar_url: json['avatar_url'] as String?,
      updated_at: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_name': instance.user_name,
      'avatar_url': instance.avatar_url,
      'updated_at': instance.updated_at,
    };
