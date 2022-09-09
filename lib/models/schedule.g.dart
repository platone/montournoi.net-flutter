// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      id: json['id'] as int?,
      category: json['category'] as String?,
      ice: json['ice'] as String?,
      office: json['office'] as String?,
      room: json['room'] as String?,
      special: json['special'] as String?,
      other: json['other'] as String?,
      club: json['club'] as String?,
      date: json['date'] as String?,
      index: json['index'] as int?,
      type: json['type'] as String?,
      video: json['video'] as String?,
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'ice': instance.ice,
      'office': instance.office,
      'room': instance.room,
      'special': instance.special,
      'other': instance.other,
      'club': instance.club,
      'date': instance.date,
      'index': instance.index,
      'type': instance.type,
      'video': instance.video,
    };
