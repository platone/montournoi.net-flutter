import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Localizations {

  static BuildContext? _context;

  static void init(BuildContext context) {
    Localizations._context = context;
  }

  static AppLocalizations of() {
    return AppLocalizations.of(Localizations._context!)!;
  }
}

