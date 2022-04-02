// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tournament _$TournamentFromJson(Map<String, dynamic> json) => Tournament(
      id: json['id'] as int?,
      endDate: json['endDate'] as String?,
      beginDate: json['beginDate'] as String?,
      street: json['street'] as String?,
      additional: json['additional'] as String?,
      city: json['city'] as String?,
      zipcode: json['zipcode'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      sport: json['sport'] as String?,
      name: json['name'] as String?,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      live: json['live'] as int?,
    );

Map<String, dynamic> _$TournamentToJson(Tournament instance) =>
    <String, dynamic>{
      'id': instance.id,
      'endDate': instance.endDate,
      'beginDate': instance.beginDate,
      'street': instance.street,
      'additional': instance.additional,
      'city': instance.city,
      'zipcode': instance.zipcode,
      'phone': instance.phone,
      'email': instance.email,
      'sport': instance.sport,
      'name': instance.name,
      'categories': instance.categories,
      'live': instance.live,
    };
