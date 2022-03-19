
import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';

@JsonSerializable()
class Player {

  final int? id;
  final String? firstName;
  final String? lastName;
  final String? birthday;
  final String? licence;
  final String? lastNumber;
  final String? lastPosition;

  Player({required this.id, required this.firstName, required this.lastName, required this.birthday, required this.licence, required this.lastNumber, required this.lastPosition, });

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}