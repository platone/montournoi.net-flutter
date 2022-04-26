import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:montournoi_net_flutter/models/player.dart';
import 'package:montournoi_net_flutter/models/scorer.dart';
import 'package:montournoi_net_flutter/models/team.dart';
import 'package:montournoi_net_flutter/models/event.dart';
import 'package:montournoi_net_flutter/models/match.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:sprintf/sprintf.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:montournoi_net_flutter/utils/i18n.dart';

class StringUtils {
  static String team(Team? team, BuildContext context) {
    if(team != null && team.name != null) {
      return team.name!;
    }
    return "";
  }
  static String scorer(Scorer? scorer, BuildContext context) {
    return (scorer?.firstName ?? "") + (scorer?.firstName != null ? " " : "") + (scorer?.lastName ?? "");
  }
  static String player(Player? player, BuildContext context) {
    return (player?.firstName ?? "") + (player?.firstName != null ? " " : "") + (player?.lastName ?? "");
  }
  static String match(Match? match, BuildContext context) {
    return (match?.receiver?.name ?? "") + " - " + (match?.visitor?.name ?? "") ;
  }
  static int score(List<Event>? events, Team? team ) {
    if(events != null && team != null) {
      return events.where((element) => element.type == 'TYPE_GOAL' && element.owner?.id == team.id).length;
    }
    return 0;
  }
  static String type(Event? event, BuildContext context) {
    return StringUtils.event(event?.type, context).substring(0, 3).toUpperCase();
  }
  static String event(String? type, BuildContext context) {
    switch(type) {
      case "TYPE_GOAL":
        return AppLocalizations.of(context)!.typeGoal;
      case "TYPE_PENALTY":
        return AppLocalizations.of(context)!.typePenalty;
      case "TYPE_PENALTY_SHOT":
        return AppLocalizations.of(context)!.typePenaltyShot;
      case "TYPE_FACEOFF":
        return AppLocalizations.of(context)!.typeFaceOff;
      case "TYPE_KEEPER_SAVE":
        return AppLocalizations.of(context)!.typeKeeperSave;
      case "TYPE_FACEOFF_TRUE":
        return AppLocalizations.of(context)!.typeFaceOffTrue;
      case "TYPE_KEEPER_SAVE_TRUE":
        return AppLocalizations.of(context)!.typeKeeperSaveTrue;
      case "TYPE_FACEOFF_FALSE":
        return AppLocalizations.of(context)!.typeFaceOffFalse;
      case "TYPE_KEEPER_SAVE_FALSE":
        return AppLocalizations.of(context)!.typeKeeperSaveFalse;
    }
    return "";
  }

  static error(error, context, bool open) {
    if(error != "") {
      var format = open ? AppLocalizations.of(context)!.errorOpenFormat : AppLocalizations.of(context)!.errorDefaultFormat;
      return sprintf(format, [error]);
    }
    return AppLocalizations.of(context)!.errorInternal;
  }

  static String location(Tournament tournament) {
    return '${tournament.street ?? ""} ${tournament.additional ?? ""} ${tournament.zipcode ?? ""} ${tournament.city ?? ""}';
  }
}