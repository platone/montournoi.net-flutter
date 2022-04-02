import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:sprintf/sprintf.dart';

class Date {
  static String between(Tournament tournament, BuildContext context) {
    var dateFormat = AppLocalizations.of(context)!.tournamentTileDateFormat;
    var endDateTime = tournament.endDate != null ? DateTime.parse(tournament.endDate!) : null;
    var beginDateTime = tournament.beginDate != null ? DateTime.parse(tournament.beginDate!) : null;
    var endString = endDateTime != null ? DateFormat(dateFormat, "fr").format(endDateTime) : null;
    var beginString = beginDateTime != null ? DateFormat(dateFormat, "fr").format(beginDateTime) : null;
    if(null != endString && null != beginString) {
      var stringFormat = AppLocalizations.of(context)!.tournamentTileStringFormats;
      return sprintf(stringFormat, [beginString, endString]);
    } else {
    var stringFormat = AppLocalizations.of(context)!.tournamentTileStringFormat;
      if(null != endString ) {
        return sprintf(stringFormat, endString);
      } else if(null != beginString) {
        return sprintf(stringFormat, beginString);
      }
    }
    return "";
  }

  static DateTime utc(String? date) {
    if(null != date) {
      return DateTime.parse(date.substring(0, date.length - 6));
    }
    return DateTime.fromMicrosecondsSinceEpoch(0);
  }
}