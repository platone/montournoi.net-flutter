import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:montournoi_net_flutter/dialog/signup.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:montournoi_net_flutter/widgets/screens/tournamentScreen.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';
import 'package:montournoi_net_flutter/utils/date.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:montournoi_net_flutter/utils/plateform.dart';
import 'package:montournoi_net_flutter/utils/security.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:montournoi_net_flutter/utils/string.dart';
import '../../models/token.dart';
import '../../models/match.dart';
import 'abstractScreen.dart';
import 'liveScreen.dart';

class TournamentsState extends AbstractScreen<TournamentsList, List<Tournament>> {

  bool _connected = false;

  List<Tournament> _tournaments = List.empty(growable: false);

  final InAppReview inAppReview = InAppReview.instance;

  @override
  postData() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  @override
  void populate(bool loader) {
    load(loader, this, Tournament.all(context), (param) {
      setState(() {
        _tournaments = param;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).focusColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.applicationName),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(
                _connected ? Icons.logout : Icons.login,
                size: 26.0,
              ),
              tooltip: _connected ? AppLocalizations.of(context)!.formLogoutTooltip : AppLocalizations.of(context)!.formLoginTooltip,
              onPressed: () {
                _connected ? _processLogout(): _processLogin();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: refresher(
                ListView.builder(
                  itemCount: _tournaments.length,
                  itemBuilder: _buildItemsForListView,
                ), () {
              populate(false);
            }),
            flex: 7,
          ),
          Row(
            children: [
              Expanded(child:
              Container(
                color: Theme.of(context).primaryColorDark,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
                  child: AdmobBanner(
                    adUnitId: Plateform.adMobBannerId(context),
                    adSize: AdmobBannerSize.BANNER,
                  ),
                ),
              ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ListTile _buildItemsForListView(BuildContext context, int index) {
    return ListTile(
      title: Card(
        child: Container(
          height: 100,
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child:
                InkWell(
                  splashColor: Colors.red.withAlpha(30),
                  onTap: () {
                    _openTournament(_tournaments[index]);
                  },
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ListTile(
                            title: Text(_tournaments[index].name!,
                              style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold,), maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4, left: 0, right: 0, bottom: 4),
                              child: Text(Date.between(_tournaments[index], context),
                                style: const TextStyle(color: Colors.black26,fontSize: 16, fontWeight: FontWeight.bold,), maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        for ( var category in _tournaments[index].categories )  Container(
                                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0, bottom: 4.0),
                                            child: Text(
                                                category.name ?? "",
                                                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (hasLive(_tournaments[index])) IconButton(onPressed: () {_processLive(_tournaments[index].live);}, icon: const Icon(Icons.play_circle_fill)),
                                      if (_tournaments[index].city != null || _tournaments[index].zipcode != null) IconButton(onPressed: () { _openMaps(_tournaments[index]);}, icon: const Icon(Icons.navigation_rounded)),
                                      IconButton(onPressed: () {_openTournament(_tournaments[index]);}, icon: const Icon(Icons.remove_red_eye_rounded)),
                                    ],
                                  ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                flex:8 ,
              ),
            ],
          ),
        ),
        elevation: Constants.LIST_ELEVATION,
        margin: const EdgeInsets.all(Constants.LIST_MARGIN),
        shadowColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _openTournament(Tournament tournament) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TournamentScreen(tournament: tournament),
      ),
    );
  }

  void _processLogout() {
    Security.logout();
    setState(() {
      _connected = false;
    });
  }

  void _processLogin() {
    showDialog(
        context: context,
        builder: (_) {
          return SignUpDialog(callback: (connected) {
            setState(() {
              _connected = connected;
            });
          });
        }
    );
  }

  void _processLive(int? live) {
    if(null != live) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LiveScreen(match: Match(id: live, name: null, events: [], receiver: null, startDate: null, visitor: null)),
        ),
      );
    }
  }

  bool hasLive(Tournament tournament) {
    return (tournament.live ?? 0) > 0;
  }

  void _openMaps(Tournament tournament) {
    MapsLauncher.launchQuery(StringUtils.location(tournament));
  }
}

class TournamentsList extends StatefulWidget {
  const TournamentsList({Key? key}) : super(key: key);
  @override
  createState() => TournamentsState();
}