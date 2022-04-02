import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:montournoi_net_flutter/models/team.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';
import 'package:montournoi_net_flutter/utils/string.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:montournoi_net_flutter/utils/i18n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/teamlight.dart';
import '../../utils/box.dart';

class TournamentTeamsState extends State<TournamentTeams> {

  List<TeamLight> _teams = List.empty(growable: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => getData());
  }

  getData() async {
    _populate();
  }

  void _populate() {
    EasyLoading.show(status: i18n.loadingLabel);
    Webservice().load(Tournament.teams(context, widget.tournament.id)).then((teams) => {
      setState(() => {
        _teams = teams,
      }),
      EasyLoading.dismiss()
    }, onError: (error) => {
      EasyLoading.dismiss(),
      EasyLoading.showError(error.toString())
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).focusColor),
          child: ListView.builder(
            itemCount: _teams.length,
            itemBuilder: _buildListViewItem,
          ),
        ),
      ),
    );
  }

  ListTile _buildListViewItem(BuildContext context, int index) {
    return ListTile(
      title: Card(
        child: tileContainer(
            _teams[index],
          Padding(
            padding: const EdgeInsets.only(
                top: 8, left: 4, right: 8, bottom: 4),
            child: Container(
              height: Constants.MATCHS_HEIGHT,
              color: Colors.white,
              child: Row(
                children: [
                  tileImage(_teams[index]),
                  tileTeam(_teams[index], context),
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
          style: textStyle(),
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

  TextStyle textStyle() {
    return const TextStyle(
        color: Color(0xFF000000),
        fontSize: 24,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500
    );
  }
}

class TournamentTeams extends StatefulWidget {
  final Tournament tournament;
  const TournamentTeams({Key? key, required this.tournament}) : super(key: key);
  @override
  createState() => TournamentTeamsState();
}