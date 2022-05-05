import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:montournoi_net_flutter/models/player.dart';

import '../services/webservice.dart';
import '../utils/url.dart';

part 'team.g.dart';

@JsonSerializable()
class Team {

  final int? id;
  final String? name;
  final String? backgroundColor;
  final String? textColor;
  final String? image;
  final String? country;
  final List<Player>? players;

  Team({required this.id,required this.name,required this.backgroundColor,required this.textColor,required this.image,required this.country,required this.players,});

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  Map<String, dynamic> toJson() => _$TeamToJson(this);
}