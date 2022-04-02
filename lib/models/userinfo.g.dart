// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userinfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      id: json['id'] as int?,
      username: json['username'] as String?,
      role: json['role'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      birthday: json['birthday'] as String?,
      licence: json['licence'] as String?,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'role': instance.role,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'birthday': instance.birthday,
      'licence': instance.licence,
    };
