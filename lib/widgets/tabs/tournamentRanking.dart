import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:montournoi_net_flutter/models/ranking.dart';
import 'package:montournoi_net_flutter/models/team.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';
import 'package:montournoi_net_flutter/utils/i18n.dart';
import 'package:montournoi_net_flutter/utils/string.dart';

import '../../utils/box.dart';
import '../screens/abstractScreen.dart';

class TournamentRankingState  extends AbstractScreen<TournamentRanking, List<Ranking>> {

  List<Ranking> _rankings = List.empty(growable: false);

  @override
  void populate(bool loader) {
    load(loader, this, Tournament.ranking(context, widget.tournament.id), (param) {
      setState(() {
        _rankings = param;
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
                itemCount: _rankings.length,
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
          _rankings[index].team!,
          Padding(
            padding: const EdgeInsets.only(
                top: 8, left: 4, right: 8, bottom: 4),
            child: Container(
              height: Constants.MATCHS_HEIGHT,
              color: Colors.white,
              child: Row(
                children: [
                  tilePosition(_rankings[index].position),
                  tileImage(_rankings[index].team),
                  tileTeam(_rankings[index].team, context),
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

  Expanded tilePosition(int? position) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
        child: Text(
          "${position}",
          style: textStyle(28),
          textAlign: TextAlign.start,
        ),
      ),
      flex: 1,
    );
  }

  Expanded tileImage(Team? team) {
    return Expanded(
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
          child: CachedNetworkImage(
            imageUrl: team?.image?.replaceAll("http:", "https:") ?? "",
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

  Expanded tileTeam(Team? team, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
        child: Text(
          StringUtils.team(team, context),
          style: textStyle(24),
          textAlign: TextAlign.start,
        ),
      ),
      flex: 5,
    );
  }

  tileContainer(Team team, Widget widget) {
    return Container(
      decoration: Box.boxDecorationTeam(team, 16.0),
      padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
      child: widget,
    );
  }

  TextStyle textStyle(double size) {
    return TextStyle(
        color: const Color(0xFF000000),
        fontSize: size,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500
    );
  }
}

class TournamentRanking extends StatefulWidget {
  final Tournament tournament;
  const TournamentRanking({Key? key, required this.tournament}) : super(key: key);
  @override
  createState() => TournamentRankingState();
}