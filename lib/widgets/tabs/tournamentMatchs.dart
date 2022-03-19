import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:montournoi_net_flutter/models/match.dart';
import 'package:montournoi_net_flutter/models/team.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:montournoi_net_flutter/screens/liveScreen.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';
import 'package:montournoi_net_flutter/utils/string.dart';
import 'package:montournoi_net_flutter/utils/i18n.dart';

class TournamentMatchsState extends State<TournamentMatchs> {

  List<Match> _matchs = List.empty(growable: false);

  @override
  void initState() {
    super.initState();
    _populate();
  }

  DateFormat format() {
    var dateFormat = AppLocalizations.of(context)!.tournamentTileHourFormat;
    return DateFormat(dateFormat, "fr");
  }

  void _populate() {
    EasyLoading.show(status: i18n.loadingLabel);
    Webservice().load(Tournament.matchs(widget.tournament.id)).then(
        (matchs) => {
              setState(() => {
                    _matchs = matchs
                        .where((element) => accept(element))
                        .toList(growable: true)
                  }),
              EasyLoading.dismiss()
            },
        onError: (error) => {EasyLoading.showError(error.toString())});
  }

  bool accept(Match element) {
    var now = DateTime.now();
    if (element.startDate != null) {
      var date = DateTime.parse(element.startDate!);
      if (widget.past) {
        return now.isAfter(date);
      } else {
        return now.isBefore(date);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(color: Colors.blueAccent),
          child: ListView.builder(
            itemCount: _matchs.length,
            itemBuilder: _buildListViewItem,
          ),
        ),
      ),
    );
  }

  ListTile _buildListViewItem(BuildContext context, int index) {
    if (_matchs[index].receiver == null || _matchs[index].visitor == null) {
      return createListTileWithoutTeamMatch(index);
    }
    return createListTileWithTeamMatch(index, context);
  }

  ListTile createListTileWithTeamMatch(int index, BuildContext context) {
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
    return ListTile(
      title: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 4, right: 8, bottom: 4),
          child: InkWell(
            splashColor: Colors.red.withAlpha(30),
            onTap: () {
              _openLive(_matchs[index]);
            },
            child: Container(
              height: Constants.MATCHS_HEIGHT,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: padding(
                        receiver(index, context, receiverScore > visitorScore),
                        context),
                    flex: 5,
                  ),
                  Expanded(
                    child: score(index, context, receiverScore, visitorScore),
                    flex: 2,
                  ),
                  Expanded(
                    child: padding(
                        visitor(index, context, visitorScore > receiverScore),
                        context),
                    flex: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
        elevation: Constants.LIST_ELEVATION,
        margin: const EdgeInsets.all(Constants.LIST_MARGIN),
        shadowColor: Colors.blueAccent,
      ),
    );
  }

  ListTile  createListTileWithoutTeamMatch(int index) {
    return ListTile(
      title: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
          child: Container(
            height: Constants.MATCHS_HEIGHT,
            color: Colors.white,
            child: Align(
              child: Text(
                _matchs[index].name ?? "",
                style: textStyle(false),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        elevation: Constants.LIST_ELEVATION,
        margin: const EdgeInsets.all(Constants.LIST_MARGIN),
        shadowColor: Colors.blueAccent,
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
        padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
        child: Text(
          StringUtils.team(team, context),
          style: textStyle(bold),
          textAlign: textAlign,
        ),
      ),
      flex: 3,
    );
  }

  Expanded tileImage(Team? team) {
    return Expanded(
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: team?.image?.replaceAll("http:", "https:") ?? "",
          height: Constants.MATCHS_HEIGHT,
          width: Constants.MATCHS_HEIGHT,
          fit: BoxFit.contain,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
      flex: 1,
    );
  }

  TextStyle scoresStyle(bool bold) {
    if (bold) {
      return const TextStyle(
          color: Color(0xFF000000),
          fontSize: 22,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold);
    } else {
      return const TextStyle(
          color: Color(0xFF000000),
          fontSize: 22,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal);
    }
  }

  TextStyle dateStyle() {
    return const TextStyle(
      color: Color(0xFF000000),
      fontSize: 18,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
    );
  }

  TextStyle textStyle(bool bold) {
    if (bold) {
      return const TextStyle(
        color: Color(0xFF000000),
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
      );
    } else {
      return const TextStyle(
        color: Color(0xFF000000),
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
      );
    }
  }

  TextStyle scoreStyle() {
    return const TextStyle(
      color: Color(0xFF000000),
      fontSize: 20,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.bold,
    );
  }

  Widget score(
      int index, BuildContext context, int receiverScore, int visitorScore) {
    var now = DateTime.now();
    var date = DateTime.parse(_matchs[index].startDate!);
    if (now.isAfter(date)) {
      return scoreValue(index, receiverScore, visitorScore);
    }
    return hourValue(index);
  }

  Widget hourValue(int index) {
    var date = DateTime.parse(_matchs[index].startDate!);
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
    );
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
