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

import '../utils/url.dart';

part 'club.g.dart';

@JsonSerializable()
class Club {

  final int? id;

  final String? name;

  final String? image;

  final String? backgroundColor;

  final String? textColor;

  Club({required this.id, required this.name, required this.image, required this.backgroundColor, required this.textColor});

  static Resource<List<Club>> all(context) {
    return Resource(
        url: URL.url(context, URL.CLUBS_URL, null),
        parse: (response) {
          var list = json.decode(response.body) as List;
          var clubs = List<Club>.empty(growable: true);
          for (var t in list) {
            var club = Club.fromJson(t);
            clubs.insert(0, club);
          }
          return clubs;
        }
    );
  }

  factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);

  Map<String, dynamic> toJson() => _$ClubToJson(this);
}