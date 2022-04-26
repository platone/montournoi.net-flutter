import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:sprintf/sprintf.dart';

class Phone {
  static String label(String phone, BuildContext context) {
    if(phone != "") {
      var emailFormat = AppLocalizations.of(context)!.tournamentPhoneStringFormat;
      return sprintf(emailFormat, [phone]);
    }
    return "";
  }

  static url(String phone, BuildContext context) {
    if(phone != "") {
      var emailFormat = AppLocalizations.of(context)!.tournamentPhoneUrlFormat;
      return sprintf(emailFormat, [phone]);
    }
    return "";
  }
}