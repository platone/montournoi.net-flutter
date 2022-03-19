import 'package:flutter/foundation.dart' as Foundation;

class Constants {
  static const String DOMAIN = Foundation.kDebugMode ? 'http://127.0.0.1:8118/' : 'https://ws.montournoi.net/';
  static const String API_URL = DOMAIN + 'api/';
  static const String TOURNAMENT_URL = API_URL + 'tournaments/';
  static const String TOURNAMENTS_URL = API_URL + 'tournaments/research?k=';
  static const String MATCHS_URL = API_URL + 'matches/day?t=';
  static const String TEAMS_URL = API_URL + 'teams/tournament/';
  static const String GROUP_URL = API_URL + 'tournaments/results/';
  static const String RANKING_URL = API_URL + 'tournaments/ranking/';
  static const String SCORERS_URL = API_URL + 'statistics/players/';
  static const String STATISTICS_URL = API_URL + 'statistics/teams/';
  static const String LIVE_URL = API_URL + 'matches/live/';
  static const String NEWS_PLACEHOLDER_IMAGE_ASSET_URL = 'assets/placeholder.png';
  static const double MATCHS_HEIGHT = 52.0;
  static const double LIST_MARGIN = 2.0;
  static const double LIST_MARGIN_LITTLE = 1.0;
  static const double LIST_ELEVATION = 2.0;
  static const double LIST_ELEVATION_LITTLE = 1.0;
}