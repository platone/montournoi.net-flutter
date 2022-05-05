// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liveteam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveTeam _$LiveTeamFromJson(Map<String, dynamic> json) => LiveTeam(
      id: json['id'] as int?,
      name: json['name'] as String?,
      backgroundColor: json['backgroundColor'] as String?,
      textColor: json['textColor'] as String?,
      image: json['image'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$LiveTeamToJson(LiveTeam instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'backgroundColor': instance.backgroundColor,
      'textColor': instance.textColor,
      'image': instance.image,
      'country': instance.country,
    };
