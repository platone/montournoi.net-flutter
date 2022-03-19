// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['id'] as int?,
      type: json['type'] as String?,
      subtype: json['subtype'] as String?,
      owner: json['owner'] == null
          ? null
          : Team.fromJson(json['owner'] as Map<String, dynamic>),
      player: json['player'] == null
          ? null
          : Player.fromJson(json['player'] as Map<String, dynamic>),
      firstAssist: json['firstAssist'] == null
          ? null
          : Player.fromJson(json['firstAssist'] as Map<String, dynamic>),
      secondAssist: json['secondAssist'] == null
          ? null
          : Player.fromJson(json['secondAssist'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'subtype': instance.subtype,
      'owner': instance.owner,
      'player': instance.player,
      'firstAssist': instance.firstAssist,
      'secondAssist': instance.secondAssist,
    };
