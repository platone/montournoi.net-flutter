import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class i18n {

  static BuildContext? _context;

  static String? loadingLabel;

  static void init(BuildContext context) {
    i18n._context = context;
    i18n.loadingLabel = AppLocalizations.of(context)!.applicationLoading;
  }

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(i18n._context!)!;
  }
}

