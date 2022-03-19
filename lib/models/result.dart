import 'package:montournoi_net_flutter/models/team.dart';
import 'package:json_annotation/json_annotation.dart';
import 'group.dart';

part 'result.g.dart';

@JsonSerializable()
class Result {

  final Group? group;

  final Team? team;

  final int? totalMatch;

  final int? totalPoint;

  final int? totalMatchWin;

  final int? totalMatchWinInOverTime;

  final int? totalMatchLoose;

  final int? totalMatchLooseInOverTime;

  final int? totalMatchEqual;

  final int? totalGoal;

  final int? totalFailure;

  final int? totalPenalty;

  Result({required this.group, required this.team, required this.totalMatch, required this.totalPoint, required this.totalMatchWin,
    required this.totalMatchWinInOverTime, required this.totalMatchLoose, required this.totalMatchLooseInOverTime, required this.totalMatchEqual,
    required this.totalGoal, required this.totalFailure, required this.totalPenalty});

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}