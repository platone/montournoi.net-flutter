import 'package:montournoi_net_flutter/models/team.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ranking.g.dart';

@JsonSerializable()
class Ranking {

  final int? id;

  final Team? team;

  final int? position;

  Ranking({required this.id, required this.team, required this.position});

  factory Ranking.fromJson(Map<String, dynamic> json) => _$RankingFromJson(json);

  Map<String, dynamic> toJson() => _$RankingToJson(this);
}