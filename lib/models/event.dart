import 'package:montournoi_net_flutter/models/team.dart';
import 'package:montournoi_net_flutter/models/player.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {

  final int? id;
  final String? type;
  final String? subtype;
  final Team? owner;
  final Player? player;
  final Player? firstAssist;
  final Player? secondAssist;

  Event({required this.id, required this.type, required this.subtype, required this.owner, required this.player, required this.firstAssist, required this.secondAssist, });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}