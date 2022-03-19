import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:montournoi_net_flutter/models/team.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:sprintf/sprintf.dart';

class UIUtils {
  static Container separator() {
    return Container(
      color: Colors.grey[300],
      height: 1,
    );
  }
}