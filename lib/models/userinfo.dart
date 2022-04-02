import 'package:json_annotation/json_annotation.dart';

part 'userinfo.g.dart';

@JsonSerializable()
class UserInfo {

  final int? id;
  final String? username;
  final String? role;
  final String? firstName;
  final String? lastName;
  final String? birthday;
  final String? licence;

  UserInfo({required this.id, required this.username, required this.role, required this.firstName, required this.lastName, required this.birthday, required this.licence,});

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}