
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class EventParam {
  final String? type;
  final String? match;
  final String? subtype;
  final String? owner;
  final String? player;
  final String? firstAssist;
  final String? secondAssist;

  EventParam({required this.type, required this.subtype, required this.match, required this.owner, required this.player, required this.firstAssist, required this.secondAssist, });

  factory EventParam.fromJson(Map<String, dynamic> json) => _$EventParamFromJson(json);

  Map<String, dynamic> toJson() => _$EventParamToJson(this);
}