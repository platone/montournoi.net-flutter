// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Match _$MatchFromJson(Map<String, dynamic> json) => Match(
      id: json['id'] as int?,
      startDate: json['startDate'] as String?,
      receiver: json['receiver'] == null
          ? null
          : Team.fromJson(json['receiver'] as Map<String, dynamic>),
      visitor: json['visitor'] == null
          ? null
          : Team.fromJson(json['visitor'] as Map<String, dynamic>),
      events: (json['events'] as List<dynamic>)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$MatchToJson(Match instance) => <String, dynamic>{
      'id': instance.id,
      'startDate': instance.startDate,
      'receiver': instance.receiver,
      'visitor': instance.visitor,
      'events': instance.events,
      'name': instance.name,
    };
