import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:montournoi_net_flutter/models/scorer.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';
import 'package:montournoi_net_flutter/utils/string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprintf/sprintf.dart';
import 'package:montournoi_net_flutter/utils/i18n.dart';

import '../../utils/box.dart';
import '../screens/abstractScreen.dart';

class TournamentScorersState   extends AbstractScreen<TournamentScorers, List<Scorer>> {

  List<Scorer> _scorers = List.empty(growable: false);

  @override
  void populate(bool loader) {
    load(loader, this, Tournament.scorers(context, widget.tournament.id), (param) {
      setState(() {
        _scorers = param;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).focusColor),
          child: refresher(
              ListView.builder(
                itemCount: _scorers.length,
                itemBuilder: _buildListViewItem,
              ), () {
            populate(false);
          }),
        ),
      ),
    );
  }

  ListTile _buildListViewItem(BuildContext context, int index) {
    return ListTile(
      title: Card(
        child: tileContainer(
          _scorers[index],
          Padding(
            padding: const EdgeInsets.only(
                top: 8, left: 4, right: 8, bottom: 4
            ),
            child: Container(
              height: Constants.MATCHS_HEIGHT,
              color: Colors.white,
              child: Row(
                children: [
                  tileImage(_scorers[index]),
                  tileTeam(_scorers[index], context),
                  tileNumber(points(_scorers[index]), context),
                ],
              ),
            ),
          ),
        ),
        elevation: Constants.LIST_ELEVATION,
        margin: const EdgeInsets.all(Constants.LIST_MARGIN),
        shadowColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Expanded tileImage(Scorer? scorer) {
    return Expanded(
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.only(top: 2, left: 2, right: 2, bottom: 2),
          child: CachedNetworkImage(
            imageUrl: scorer?.image?.replaceAll("http:", "https:") ?? "",
            height: Constants.MATCHS_HEIGHT,
            width: Constants.MATCHS_HEIGHT,
            fit: BoxFit.contain,
            placeholder: (context, url) =>
            const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
            const Icon(Icons.error),
          ),
        ),
      ),
      flex: 1,
    );
  }

  Expanded tileTeam(Scorer? scorer, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
        child: Text(
          StringUtils.scorer(scorer, context),
          style: textStyle(),
          textAlign: TextAlign.start,
        ),
      ),
      flex: 4,
    );
  }

  Expanded tileNumber(String? number, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
        child: Text(
          number!,
          style: scoreStyle(),
          textAlign: TextAlign.end,
        ),
      ),
      flex: 3,
    );
  }

  tileContainer(Scorer scorer, Widget widget) {
    return Container(
      decoration: Box.boxDecorationScorer(scorer, 16.0),
      padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
      child: widget,
    );
  }

  TextStyle textStyle() {
    return const TextStyle(
        color: Color(0xFF000000),
        fontSize: 14,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500
    );
  }

  TextStyle scoreStyle() {
    return const TextStyle(
        color: Color(0xFF000000),
        fontSize: 14,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300
    );
  }

  String? points(Scorer scorer) {
    var total = scorer.total;
    var goal = scorer.goal;
    var assists = int.parse(scorer.firstAssist!) + int.parse(scorer.secondAssist!);
    var scorerFormat = AppLocalizations.of(context)!.scorerNumbers;
    return sprintf(scorerFormat, [total, goal, assists]);
  }
}

class TournamentScorers extends StatefulWidget {
  final Tournament tournament;
  const TournamentScorers({Key? key, required this.tournament}) : super(key: key);
  @override
  createState() => TournamentScorersState();
}