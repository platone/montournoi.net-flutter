// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedules.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedules _$SchedulesFromJson(Map<String, dynamic> json) => Schedules(
      club: json['club'] == null
          ? null
          : Club.fromJson(json['club'] as Map<String, dynamic>),
      days: (json['days'] as List<dynamic>)
          .map((e) => Schedule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SchedulesToJson(Schedules instance) => <String, dynamic>{
      'club': instance.club,
      'days': instance.days,
    };
