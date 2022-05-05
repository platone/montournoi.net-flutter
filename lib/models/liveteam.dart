import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:montournoi_net_flutter/models/player.dart';

import '../services/webservice.dart';
import '../utils/url.dart';

part 'liveteam.g.dart';

@JsonSerializable()
class LiveTeam {

  final int? id;
  final String? name;
  final String? backgroundColor;
  final String? textColor;
  final String? image;
  final String? country;

  LiveTeam({required this.id,required this.name,required this.backgroundColor,required this.textColor,required this.image,required this.country,});

  factory LiveTeam.fromJson(Map<String, dynamic> json) => _$LiveTeamFromJson(json);

  Map<String, dynamic> toJson() => _$LiveTeamToJson(this);

  static Resource<List<LiveTeam>> group(context, group) {
    var url = URL.url(context, URL.GROUPTEAMS_URL, "$group");
    return Resource(
        url: url,
        parse: (response) {
          var list = json.decode(response.body) as List;
          var teams = List<LiveTeam>.empty(growable: true);
          for (var t in list) {
            var tournament = LiveTeam.fromJson(t);
            teams.insert(0, tournament);
          }
          return teams;
        }
    );
  }
}