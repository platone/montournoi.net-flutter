import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:sprintf/sprintf.dart';

class Email {
  static String label(String email, BuildContext context) {
    if(email != "") {
      var emailFormat = AppLocalizations.of(context)!.tournamentEmailStringFormat;
      return sprintf(emailFormat, [email]);
    }
    return "";
  }

  static url(String email, BuildContext context) {
    if(email != "") {
      var emailFormat = AppLocalizations.of(context)!.tournamentEmailUrlFormat;
      return sprintf(emailFormat, [email]);
    }
    return "";
  }
}