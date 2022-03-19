// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      group: json['group'] == null
          ? null
          : Group.fromJson(json['group'] as Map<String, dynamic>),
      team: json['team'] == null
          ? null
          : Team.fromJson(json['team'] as Map<String, dynamic>),
      totalMatch: json['totalMatch'] as int?,
      totalPoint: json['totalPoint'] as int?,
      totalMatchWin: json['totalMatchWin'] as int?,
      totalMatchWinInOverTime: json['totalMatchWinInOverTime'] as int?,
      totalMatchLoose: json['totalMatchLoose'] as int?,
      totalMatchLooseInOverTime: json['totalMatchLooseInOverTime'] as int?,
      totalMatchEqual: json['totalMatchEqual'] as int?,
      totalGoal: json['totalGoal'] as int?,
      totalFailure: json['totalFailure'] as int?,
      totalPenalty: json['totalPenalty'] as int?,
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'group': instance.group,
      'team': instance.team,
      'totalMatch': instance.totalMatch,
      'totalPoint': instance.totalPoint,
      'totalMatchWin': instance.totalMatchWin,
      'totalMatchWinInOverTime': instance.totalMatchWinInOverTime,
      'totalMatchLoose': instance.totalMatchLoose,
      'totalMatchLooseInOverTime': instance.totalMatchLooseInOverTime,
      'totalMatchEqual': instance.totalMatchEqual,
      'totalGoal': instance.totalGoal,
      'totalFailure': instance.totalFailure,
      'totalPenalty': instance.totalPenalty,
    };
