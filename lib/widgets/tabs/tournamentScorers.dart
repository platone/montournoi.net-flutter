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

  String? selectedTeamValue;

  List<DropdownMenuItem<String>> teamsValues = [];

  List<Scorer> _scorers = List.empty(growable: false);

  List<Scorer> _filteredScorers = List.empty(growable: false);

  @override
  void populate(bool loader) {
    load(loader, this, Tournament.scorers(context, widget.tournament.id), (param) {
      setState(() {
        _scorers = param;
        selectedTeamValue = null;
        initFilter();
        updateScorer();
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
                itemCount: _filteredScorers.length + 1,
                itemBuilder: _buildListViewItem,
              ), () {
            populate(false);
          }),
        ),
      ),
    );
  }

  ListTile _buildListViewItem(BuildContext context, int index) {
    if(index == 0) {
      return _buildListViewHeaderItem(context, index);
    }
    return _buildListViewPlayerItem(context, index - 1);
  }

  final teamDropDownKey = GlobalKey<FormState>();

  ListTile _buildListViewHeaderItem(BuildContext context, int index) {
    return ListTile(
      title: Container(
        padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
        child: Container(
          height: Constants.MATCHS_HEIGHT,
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: Padding(
                  padding: EdgeInsets.only(),
                  child: Row(
                    children: [
                      Expanded(
                        child: generateTeamDropDown(),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.clear,
                        ),
                        onPressed: () {
                          populate(true);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: buildRow(
                  AppLocalizations.of(context)!.totalPoint,
                  AppLocalizations.of(context)!.totalGoal,
                  AppLocalizations.of(context)!.totalAssist,
                  AppLocalizations.of(context)!.totalPenality,
                  14,
                  12,
                  FontWeight.w500,
                  FontWeight.w500,
                ),
              ),

              // tileImage(_scorers[index]),
              // tileNumber(points(_scorers[index]), context),
            ],
          ),
        ),
      ),
    );
  }

  ListTile _buildListViewPlayerItem(BuildContext context, int index) {
    var scorer = _filteredScorers[index];
    var total = scorer.total;
    var goal = scorer.goal;
    var assists = int.parse(scorer.firstAssist!) + int.parse(scorer.secondAssist!);
    var penalities = scorer.penalities;
    return ListTile(
      title: Card(
        child: tileContainer(
          scorer,
            Container(
              height: Constants.MATCHS_HEIGHT,
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Row(
                        children: [
                          tileImage(scorer),
                          tileTeam(scorer, context),
                        ],
                      )
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: buildRow(
                      "${total}",
                      "${goal}",
                      "${assists}",
                      "${penalities}",
                      14,
                      12,
                      FontWeight.w500,
                      FontWeight.w500,
                    ),
                  ),

                  // tileImage(_scorers[index]),
                  // tileNumber(points(_scorers[index]), context),
                ],
              ),
            ),
        ),
      ),
    );
  }

  Expanded tileImage(Scorer? scorer) {
    return Expanded(
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.only(),
          child: CachedNetworkImage(
            imageUrl: scorer?.image?.replaceAll("http:", "https:") ?? "",
            height: Constants.MATCHS_LOGOM_HEIGHT,
            width: Constants.MATCHS_LOGOM_HEIGHT,
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
      flex: 3,
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
        fontWeight: FontWeight.w500
    );
  }

  String? points(Scorer scorer) {
    var total = scorer.total;
    var goal = scorer.goal;
    var assists = int.parse(scorer.firstAssist!) + int.parse(scorer.secondAssist!);
    var scorerFormat = AppLocalizations.of(context)!.scorerNumbers;
    return sprintf(scorerFormat, [total, goal, assists]);
  }

  static Row buildRow(String totalPoint, String totalGoal, String totalAssist, String totalPenality, double hightSize, double lowSize, FontWeight? hightFontWeight, FontWeight? lowFontWeight) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.center,
            child: Text(
                totalPoint,
                style: TextStyle(color: Colors.black, fontSize: hightSize, fontWeight: hightFontWeight)
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.center,
            child: Text(
                totalGoal,
                style: TextStyle(color: Colors.black, fontSize: lowSize, fontWeight: lowFontWeight)
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.center,
            child: Text(
                totalAssist,
                style: TextStyle(color: Colors.black, fontSize: lowSize, fontWeight: lowFontWeight)
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.center,
            child: Text(
                totalPenality,
                style: TextStyle(color: Colors.black, fontSize: lowSize, fontWeight: lowFontWeight)
            ),
          ),
        ),
      ],
    );
  }

  void initFilter() {
    teamsValues = createTeamValues();
  }

  List<DropdownMenuItem<String>> createTeamValues() {
    var teams = {};
    List<DropdownMenuItem<String>> values = [];
    for (var scorer in _scorers) {
      var team = scorer.team;
      if(!teams.containsKey(team)) {
        var item = DropdownMenuItem(
          child: Text(team ?? ""),
          value: "${scorer.team}",
        );
        values.add(item);
        teams[team] = true;
      }
    }
    return values;
  }

  DropdownButtonFormField<String> generateTeamDropDown() {
    return DropdownButtonFormField(
        key: teamDropDownKey,
        value: selectedTeamValue,
        onChanged: (String? newValue) {
          setState(() {
            selectedTeamValue = newValue!;
            updateScorer();
          });
        },
        items: teamsValues);
  }

  void updateScorer() {
    if((selectedTeamValue ?? "").isNotEmpty) {
      _filteredScorers = _scorers.where((element) => element.team == selectedTeamValue).toList(growable: false);
    }else {
      _filteredScorers = _scorers;
    }
  }
}

class TournamentScorers extends StatefulWidget {
  final Tournament tournament;
  const TournamentScorers({Key? key, required this.tournament}) : super(key: key);
  @override
  createState() => TournamentScorersState();
}