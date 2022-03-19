import 'package:json_annotation/json_annotation.dart';

part 'team.g.dart';

@JsonSerializable()
class Team {

  final int? id;
  final String? name;
  final String? backgroundColor;
  final String? textColor;
  final String? image;
  final String? country;

  Team({required this.id,required this.name,required this.backgroundColor,required this.textColor,required this.image,required this.country,});

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  Map<String, dynamic> toJson() => _$TeamToJson(this);
}