import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:montournoi_net_flutter/models/category.dart';
import 'package:montournoi_net_flutter/models/event.dart';
import 'package:montournoi_net_flutter/models/team.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/url.dart';

part 'livematch.g.dart';

@JsonSerializable()
class LiveMatch {

  final int? id;
  final String? name;
  final String? group;

  LiveMatch({required this.id, required this.name, required this.group,});

  factory LiveMatch.fromJson(Map<String, dynamic> json) => _$LiveMatchFromJson(json);

  Map<String, dynamic> toJson() => _$LiveMatchToJson(this);

  static Resource<LiveMatch> one(context, id) {
    var url = URL.url(context, URL.MATCH_URL, "/${id}");
    return Resource(
        url: url,
        parse: (response) {
          var map = json.decode(response.body) as Map;
          return LiveMatch.fromJson(map as Map<String, dynamic>);
        }
    );
  }
}