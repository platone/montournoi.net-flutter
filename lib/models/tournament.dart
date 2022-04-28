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

part 'tournament.g.dart';

@JsonSerializable()
class Tournament {

  final int? id;
  final String? endDate;
  final String? beginDate;
  final String? street;
  final String? additional;
  final String? city;
  final String? zipcode;
  final String? phone;
  final String? email;
  final String? sport;
  final String? name;
  final List<Category> categories;
  final int? live;
  final bool? showScorers;

  Tournament({required this.id,required this.endDate, required this.beginDate, required this.street, required this.additional, required this.city,
    required this.zipcode, required this.phone, required this.email, required this.sport, required this.name, required this.categories, required this.live, required this.showScorers});

  static Resource<List<Tournament>> all(context) {
    return Resource(
        url: URL.url(context, URL.TOURNAMENTS_URL, null),
        parse: (response) {
          var list = json.decode(response.body) as List;
          var tournaments = List<Tournament>.empty(growable: true);
          for (var t in list) {
            var tournament = Tournament.fromJson(t);
            tournaments.insert(0, tournament);
          }
          return tournaments;
        }
    );
  }
  
  static Resource<List<Match>> matchs(context, id) {
    return Resource(
        url: URL.url(context, URL.MATCHS_URL, "${id}"),
        parse: (response) {
          var list = json.decode(response.body) as List;
          var matchs = List<Match>.empty(growable: true);
          for (var t in list) {
            var match = Match.fromJson(t);
            matchs.add(match);
          }
          return matchs;
        }
    );
  }

  static Resource<List<Ranking>> ranking(context, id) {
    return Resource(
        url: URL.url(context, URL.RANKING_URL, "/${id}"),
        parse: (response) {
          var list = json.decode(response.body) as List;
          var results = List<Ranking>.empty(growable: true);
          for (var r in list) {
            var result = Ranking.fromJson(r);
            results.add(result);
          }
          return results;
        }
    );
  }

  static Resource<List<Result>> groups(context, id) {
    return Resource(
        url: URL.url(context, URL.GROUP_URL, "/${id}"),
        parse: (response) {
          var list = json.decode(response.body) as List;
          var results = List<Result>.empty(growable: true);
          for (var r in list) {
            var result = Result.fromJson(r);
            results.add(result);
          }
          return results;
        }
    );
  }

  static Resource<List<TeamLight>> teams(context, id) {
    return Resource(
        url: URL.url(context, URL.TEAMS_URL, "/${id}"),
        parse: (response) {
          var list = json.decode(response.body) as List;
          var teams = List<TeamLight>.empty(growable: true);
          for (var t in list) {
            var team = TeamLight.fromJson(t);
            teams.add(team);
          }
          return teams;
        }
    );
  }

  static Resource<List<Scorer>> scorers(context, id) {
    return Resource(
        url: URL.url(context, URL.SCORERS_URL, "/${id}"),
        parse: (response) {
          var list = json.decode(response.body) as List;
          var scorers = List<Scorer>.empty(growable: true);
          for (var t in list) {
            var scorer = Scorer.fromJson(t);
            scorers.add(scorer);
          }
          return scorers;
        }
    );
  }

  static Resource<Tournament> one(context, id) {
    return Resource(
        url: URL.url(context, URL.TOURNAMENT_URL, "/${id}"),
        parse: (response) {
          var map = json.decode(response.body) as Map;
          return Tournament.fromJson(map as Map<String, dynamic>);
        }
    );
  }

  factory Tournament.fromJson(Map<String, dynamic> json) => _$TournamentFromJson(json);

  Map<String, dynamic> toJson() => _$TournamentToJson(this);
}