import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:montournoi_net_flutter/utils/plateform.dart';

class URL {
  static const String EMPTY = "";

  static const String DOMAIN_LOCAL = 'http://localhost:8118/';
  static const String DOMAIN_PROD = 'https://ws.montournoi.net/';
  static const String API_URL = 'api/';
  static const String TOURNAMENT_URL = 'tournaments';
  static const String MATCH_URL = 'matches';
  static const String AUTHENTICATE_URL = 'authenticate';
  static const String TOURNAMENTS_URL = 'tournaments/research?k=';
  static const String MATCHS_URL = 'matches/day?t=';
  static const String TEAMS_URL = 'teams/tournament';
  static const String GROUPTEAMS_URL = 'teams/group';
  static const String MATCHTEAMS_URL = 'matches/teams';
  static const String GROUP_URL = 'tournaments/results';
  static const String RANKING_URL = 'tournaments/ranking';
  static const String SCORERS_URL = 'statistics/players';
  static const String STATISTICS_URL = 'statistics/teams';
  static const String LIVE_URL = 'matches/live';
  static const String CLOSE_URL = 'matches/close';
  static const String EVENT_URL = 'events';

  static String url(BuildContext context, String target, String? path) {
    String param = path ?? EMPTY;
    if(Foundation.kDebugMode && !Plateform.isMobile(context)) {
      return DOMAIN_LOCAL + API_URL + target + param;
    }
    return DOMAIN_PROD + API_URL + target + param;
  }
}

