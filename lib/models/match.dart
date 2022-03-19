import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:montournoi_net_flutter/models/category.dart';
import 'package:montournoi_net_flutter/models/event.dart';
import 'package:montournoi_net_flutter/models/team.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'match.g.dart';

@JsonSerializable()
class Match {

  final int? id;
  final String? startDate;
  final Team? receiver;
  final Team? visitor;
  final List<Event> events;
  final String? name;

  Match({required this.id, required this.startDate, required this.receiver, required this.visitor, required this.events, required this.name});

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);

  Map<String, dynamic> toJson() => _$MatchToJson(this);
}