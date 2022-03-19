import 'dart:convert';

import 'package:montournoi_net_flutter/models/category.dart';
import 'package:montournoi_net_flutter/models/match.dart';
import 'package:montournoi_net_flutter/models/ranking.dart';
import 'package:montournoi_net_flutter/models/result.dart';
import 'package:montournoi_net_flutter/models/scorer.dart';
import 'package:montournoi_net_flutter/models/team.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

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

  Tournament({required this.id,required this.endDate, required this.beginDate, required this.street, required this.additional, required this.city,
    required this.zipcode, required this.phone, required this.email, required this.sport, required this.name, required this.categories});

  static Resource<List<Tournament>> get all {
    return Resource(
        url: Constants.TOURNAMENTS_URL,
        parse: (response) {
          var list = json.decode(response.body) as List;
          var tournaments = List<Tournament>.empty(growable: true);
          for (var t in list) {
            var tournament = Tournament.fromJson(t);
            tournaments.add(tournament);
          }
          return tournaments;
        }
    );
  }

  static Resource<List<Match>> matchs(id) {
    return Resource(
        url: Constants.MATCHS_URL + "${id}",
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

  static Resource<List<Ranking>> ranking(id) {
    return Resource(
        url: Constants.RANKING_URL + "${id}",
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

  static Resource<List<Result>> groups(id) {
    return Resource(
        url: Constants.GROUP_URL + "${id}",
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

  static Resource<List<Team>> teams(id) {
    return Resource(
        url: Constants.TEAMS_URL + "${id}",
        parse: (response) {
          var list = json.decode(response.body) as List;
          var teams = List<Team>.empty(growable: true);
          for (var t in list) {
            var team = Team.fromJson(t);
            teams.add(team);
          }
          return teams;
        }
    );
  }

  static Resource<List<Scorer>> scorers(id) {
    return Resource(
        url: Constants.SCORERS_URL + "${id}",
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

  static Resource<Tournament> one(id) {
    return Resource(
        url: Constants.TOURNAMENT_URL + "${id}",
        parse: (response) {
          var map = json.decode(response.body) as Map;
          return Tournament.fromJson(map as Map<String, dynamic>);
        }
    );
  }

  factory Tournament.fromJson(Map<String, dynamic> json) => _$TournamentFromJson(json);

  Map<String, dynamic> toJson() => _$TournamentToJson(this);
}