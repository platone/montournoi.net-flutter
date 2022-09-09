import 'dart:convert';

import 'package:montournoi_net_flutter/models/category.dart';
import 'package:montournoi_net_flutter/models/match.dart';
import 'package:montournoi_net_flutter/models/ranking.dart';
import 'package:montournoi_net_flutter/models/result.dart';
import 'package:montournoi_net_flutter/models/schedule.dart';
import 'package:montournoi_net_flutter/models/scorer.dart';
import 'package:montournoi_net_flutter/models/team.dart';
import 'package:montournoi_net_flutter/models/teamlight.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sprintf/sprintf.dart';

import '../utils/url.dart';
import 'club.dart';

part 'schedules.g.dart';

@JsonSerializable()
class Schedules {

  final Club? club;

  final List<Schedule> days;

  Schedules({required this.club, required this.days, });

  static Resource<Schedules> one(context, int club, int time) {
    var url = sprintf(URL.SCHEDULES_URL, ["$club", "$time"]);
    return Resource(
        url: URL.url(context, url, null),
        parse: (response) {
          var map = json.decode(response.body) as Map;
          return Schedules.fromJson(map as Map<String, dynamic>);
        }
    );
  }

  factory Schedules.fromJson(Map<String, dynamic> json) => _$SchedulesFromJson(json);

  Map<String, dynamic> toJson() => _$SchedulesToJson(this);
}