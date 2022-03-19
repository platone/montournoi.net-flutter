// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scorer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Scorer _$ScorerFromJson(Map<String, dynamic> json) => Scorer(
      id: json['id'] as int?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      birthday: json['birthday'] as String?,
      total: json['total'] as String?,
      goal: json['goal'] as String?,
      firstAssist: json['firstAssist'] as String?,
      secondAssist: json['secondAssist'] as String?,
      penalities: json['penalities'] as String?,
      team: json['team'] as String?,
      image: json['image'] as String?,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$ScorerToJson(Scorer instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'birthday': instance.birthday,
      'total': instance.total,
      'goal': instance.goal,
      'firstAssist': instance.firstAssist,
      'secondAssist': instance.secondAssist,
      'penalities': instance.penalities,
      'team': instance.team,
      'image': instance.image,
      'color': instance.color,
    };
