import 'dart:convert';

import 'package:montournoi_net_flutter/models/category.dart';
import 'package:montournoi_net_flutter/models/match.dart';
import 'package:montournoi_net_flutter/models/ranking.dart';
import 'package:montournoi_net_flutter/models/result.dart';
import 'package:montournoi_net_flutter/models/scorer.dart';
import 'package:montournoi_net_flutter/models/team.dart';
import 'package:montournoi_net_flutter/models/teamlight.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sprintf/sprintf.dart';

import '../utils/url.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule {

  final int? id;
  final String? category;
  final String? ice;
  final String? office;
  final String? room;
  final String? special;
  final String? other;
  final String? club;
  final String? date;
  final int? index;
  final String? type;
  final String? video;

  Schedule({required this.id, required this.category, required this.ice, required this.office, required this.room, required this.special,
    required this.other, required this.club, required this.date, required this.index, required this.type, required this.video, });

  factory Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}