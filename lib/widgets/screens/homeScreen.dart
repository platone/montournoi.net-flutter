import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:montournoi_net_flutter/widgets/screens/tournamentsList.dart';

import '../../utils/constants.dart';
import '../../utils/plateform.dart';
import 'clubsList.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.applicationName),
        actions: <Widget>[],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).focusColor),
              child: Column(
                children: [
                  homeCard(AppLocalizations.of(context)!.homeTournament, Icons.article_rounded, goTournamentList()),
                  homeCard(AppLocalizations.of(context)!.homeCalendars, Icons.access_alarms, goCalendars()),
                ],
              ),
            ),
            flex: 7,
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
                child: AdmobBanner(
                  adUnitId: Plateform.adMobBannerId(context),
                  adSize: AdmobBannerSize.BANNER,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  homeCard(String text, IconData? icon, GestureTapCallback onTap) {
    return Expanded(
      child: Container(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 32, left: 32, right: 32, bottom: 32),
          child: Card(
            child: InkWell(
              splashColor: Colors.red.withAlpha(30),
              onTap: onTap,
              child: cardContent(icon, text),
            ),
            elevation: Constants.LIST_ELEVATION,
            margin: const EdgeInsets.all(Constants.LIST_MARGIN),
            shadowColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Padding cardContent(IconData? icon, String text) {
    return Padding(
            padding: const EdgeInsets.only(
                top: 32, left: 32, right: 32, bottom: 16),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.center,
                    child: LayoutBuilder(builder: (context, constraint) {
                        return Icon(icon, size: constraint.biggest.height);
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(text,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  GestureTapCallback goTournamentList() {
    return () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TournamentsList(),
        ),
      );
    };
  }

  GestureTapCallback goCalendars() {
    return () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ClubList(),
        ),
      );
    };
  }
}
