import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:montournoi_net_flutter/models/match.dart';
import 'package:montournoi_net_flutter/models/team.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:montournoi_net_flutter/widgets/screens/liveScreen.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';
import 'package:montournoi_net_flutter/utils/string.dart';

import '../../utils/box.dart';
import '../../utils/date.dart';
import '../screens/abstractScreen.dart';

class TournamentMatchsState extends AbstractScreen<TournamentMatchs, List<Match>> {

  List<String> _day = List.empty(growable: true);
  List<int> _indexes = List.empty(growable: true);

  List<Match> _matchs = List.empty(growable: false);

  DateFormat format() {
    var dateFormat = AppLocalizations.of(context)!.tournamentTileHourFormat;
    return DateFormat(dateFormat, "fr");
  }

  @override
  void populate(bool loader) {
    load(loader, this, Tournament.matchs(context, widget.tournament.id), (param) {
      setState(() {
        _day.clear();
        _indexes.clear();
        _matchs = param
            .where((element) => accept(element))
            .toList(growable: true);
        updateDay();
      });
    });
  }

  bool accept(Match element) {
    if(widget.past) {
      return element.ended ?? false;
    }
    return !(element.ended ?? false);
  }

  void updateDay() {
    int index = 0;
    for (var match in _matchs) {
      var startDate = DateTime.parse(match.startDate!);
      var dateFormat = AppLocalizations.of(context)!.tournamentTileDateFormat;
      var dayString = DateFormat(dateFormat, "fr").format(startDate);
      if(!_day.contains(dayString)) {
        _day.add(dayString);
        _indexes.add(index);
      }
      index++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).focusColor),
          child: refresher(
              ListView.builder(
                itemCount: _matchs.length,
                itemBuilder: createListTile,
              ), () {
                populate(false);
              }),
        ),
      ),
    );
  }

  ListTile createListTile(BuildContext context, int index) {
    var receiverScore = _matchs[index]
        .events
        .where((element) =>
            element.type == 'TYPE_GOAL' &&
            element.owner?.id == _matchs[index].receiver?.id)
        .length;
    var visitorScore = _matchs[index]
        .events
        .where((element) =>
            element.type == 'TYPE_GOAL' &&
            element.owner?.id == _matchs[index].visitor?.id)
        .length;
    bool addTitle = _indexes.contains(index);
    var startDate = DateTime.parse(_matchs[index].startDate!);
    var dateFormat = AppLocalizations.of(context)!.matchTileDateFormat;
    var dayString = DateFormat(dateFormat, "fr").format(startDate);
    var isAvailable = available(_matchs[index]);
    return ListTile(
      title: addTitle ? Padding(
        padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, top: 16.0),
        child: Text(
          dayString.toUpperCase(),
          style: dateStyle(),
        ),
      ) : null,
      subtitle: Card(
        child: Container(
            decoration: Box.boxDecorationTeams(_matchs[index].receiver, _matchs[index].visitor, 16.0),
            child: InkWell(
                splashColor: Colors.red.withAlpha(30),
                onTap: () {
                  _openLive(_matchs[index]);
                },
                child: Container(
                  height: isAvailable ? Constants.MATCHS_HEIGHT : Constants.MATCHS_HEIGHT * 1.25,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: isAvailable ? padding(
                            receiver(index, context, receiverScore > visitorScore),
                            context) : const SizedBox.shrink(),
                        flex: flexFor(_matchs[index].receiver),
                      ),
                      Expanded(
                        child: isAvailable ? score(index, context, receiverScore, visitorScore) : title(index, context),
                        flex: 3,
                      ),
                      Expanded(
                        child: isAvailable ? padding(
                            visitor(index, context, visitorScore > receiverScore),
                            context) : const SizedBox.shrink(),
                        flex: flexFor(_matchs[index].visitor),
                      ),
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

  Padding padding(Widget widget, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 0, right: 0, bottom: 8),
      child: widget,
    );
  }

  Widget visitor(int index, BuildContext context, bool bold) {
    return row(_matchs[index].visitor, MainAxisAlignment.start, context, bold);
  }

  Widget receiver(int index, BuildContext context, bool bold) {
    return row(_matchs[index].receiver, MainAxisAlignment.end, context, bold);
  }

  Widget row(Team? team, MainAxisAlignment mainAxisAlignment,
      BuildContext context, bool bold) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        mainAxisAlignment == MainAxisAlignment.end
            ? tileTeam(team, context, TextAlign.end, bold && widget.past)
            : tileImage(team),
        mainAxisAlignment == MainAxisAlignment.start
            ? tileTeam(team, context, TextAlign.start, bold && widget.past)
            : tileImage(team),
      ],
    );
  }

  Expanded tileTeam(
      Team? team, BuildContext context, TextAlign textAlign, bool bold) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 4, right: 4, bottom: 0),
        child: Text(
          StringUtils.team(team, context),
          style: textStyle(bold),
          textAlign: textAlign,
        ),
      ),
      flex: 4,
    );
  }

  Expanded tileImage(Team? team) {
    return Expanded(
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: team?.image?.replaceAll("http:", "https:") ?? "",
          height: Constants.MATCHS_LOGO_HEIGHT,
          width: Constants.MATCHS_LOGO_HEIGHT,
          fit: BoxFit.contain,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
      flex: 1,
    );
  }

  TextStyle scoresStyle(bool bold) {
    return TextStyle(
        color: const Color(0xFF000000),
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal
    );
  }

  TextStyle dateStyle() {
    return const TextStyle(
      color: Color(0xFF000000),
      fontSize: 14,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle textStyle(bool bold) {
    return TextStyle(
      color: const Color(0xFF000000),
      fontSize: 12,
      fontStyle: FontStyle.normal,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle scoreStyle() {
    return const TextStyle(
      color: Color(0xFF000000),
      fontSize: 14,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.bold,
    );
  }

  Widget score(int index, BuildContext context, int receiverScore, int visitorScore) {
    var now = DateTime.now();
    var date = Date.utc(_matchs[index].startDate);
    if (now.isAfter(date) || (_matchs[index].ended ?? false)) {
      return scoreValue(index, receiverScore, visitorScore);
    }
    return hourValue(index);
  }

  Widget title(int index, BuildContext context) {
    return padding(
        Column(
          children: [
            hourValue(index),
            Text(
              _matchs[index].name ?? "",
              style: textStyle(false),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        context);
  }

  Widget hourValue(int index) {
    var date = Date.utc(_matchs[index].startDate);
    return padding(
        Text(
          format().format(date),
          style: dateStyle(),
          textAlign: TextAlign.center,
        ),
        context);
  }

  Widget scoreValue(int index, int receiverScore, int visitorScore) {
    var widget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(" $receiverScore ",
            style: scoresStyle(receiverScore > visitorScore)),
        Text("-", style: scoresStyle(false)),
        Text(" $visitorScore ",
            style: scoresStyle(visitorScore > receiverScore))
      ],
    );
    return padding(widget, context);
  }

  void _openLive(Match match) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveScreen(match: match),
      ),
    ).then((value) {
      populate(true);
    });
  }

  available(Match match) {
    return match.receiver != null || match.visitor != null;
  }

  flexFor(Team? team) {
    return null != team ? 6 : 0;
  }
}
class TournamentMatchs extends StatefulWidget {
  final bool past;
  final Tournament tournament;

  const TournamentMatchs(
      {Key? key, required this.tournament, required this.past})
      : super(key: key);

  @override
  createState() => TournamentMatchsState();
}
