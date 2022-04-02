// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventParam _$EventParamFromJson(Map<String, dynamic> json) => EventParam(
      type: json['type'] as String?,
      subtype: json['subtype'] as String?,
      match: json['match'] as String?,
      owner: json['owner'] as String?,
      player: json['player'] as String?,
      firstAssist: json['firstAssist'] as String?,
      secondAssist: json['secondAssist'] as String?,
    );

Map<String, dynamic> _$EventParamToJson(EventParam instance) =>
    <String, dynamic>{
      'type': instance.type,
      'match': instance.match,
      'subtype': instance.subtype,
      'owner': instance.owner,
      'player': instance.player,
      'firstAssist': instance.firstAssist,
      'secondAssist': instance.secondAssist,
    };
