import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:montournoi_net_flutter/models/group.dart';
import 'package:montournoi_net_flutter/models/result.dart';
import 'package:montournoi_net_flutter/models/team.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';
import 'package:montournoi_net_flutter/utils/i18n.dart';
import 'package:montournoi_net_flutter/utils/string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:montournoi_net_flutter/utils/i18n.dart';

class TournamentGroupsState extends State<TournamentGroups> {

  final List<ListItem> _items = [];

  @override
  void initState() {
    super.initState();
    _populate();
  }

  void _populate() {
    EasyLoading.show(status: i18n.loadingLabel);
    Webservice().load(Tournament.groups(widget.tournament.id)).then((results) => {
          setState(() => {
            buildItems(results),
          }),
          EasyLoading.dismiss()
        },
        onError: (error) => {EasyLoading.showError(error.toString())});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(color: Colors.blueAccent),
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: _buildListViewItem,
          ),
        ),
      ),
    );
  }

  ListTile _buildListViewItem(BuildContext context, int index) {
    return ListTile(
        title: _items[index].build(context)
    );
  }

  Expanded tileImage(Team? team) {
    var image = team!.image ?? "";
    return Expanded(
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
          child: CachedNetworkImage(
            imageUrl: team.image?.replaceAll("http:", "https:") ?? "",
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

  TextStyle textStyle() {
    return const TextStyle(
        color: Color(0xFF000000),
        fontSize: 24,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500
    );
  }

  buildItems(List<Result> results) {
    HashMap<Group, List<Result>> groups = HashMap();
    for (var result in results) {
      if(!groups.containsKey(result.group)) {
        groups[result.group!] = [];
      }
      groups[result.group]!.add(result);
    }
    for (var group in groups.keys) {
      final groupItem = GroupItem(group);
      _items.add(groupItem);
      for (var result in groups[group]!) {
        final resultItem = ResultItem(result);
        _items.add(resultItem);
      }
    }
  }
}

class TournamentGroups extends StatefulWidget {
  final Tournament tournament;
  const TournamentGroups({Key? key, required this.tournament}) : super(key: key);
  @override
  createState() => TournamentGroupsState();
}

abstract class ListItem {
  Widget build(BuildContext context);
}

class GroupItem implements ListItem {
  final Group group;
  GroupItem(this.group);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.MATCHS_HEIGHT,
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                    group.name ?? "",
                    style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w900)
                ),
              ),
          ),
          Expanded(
            flex: 2,
            child: ResultItem.buildRow(
                AppLocalizations.of(context)!.totalPoint,
                AppLocalizations.of(context)!.totalMatch,
                AppLocalizations.of(context)!.totalMatchWin,
                AppLocalizations.of(context)!.totalMatchEqual,
                AppLocalizations.of(context)!.totalMatchLoose,
                AppLocalizations.of(context)!.totalDiff,
                18,
                16,
                FontWeight.w500,
                FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ResultItem implements ListItem {
  final Result result;
  ResultItem(this.result);
  @override
  Widget build(BuildContext context) {
    var data = result;
    return Card(
      child: tileContainer(
        result.team!,
        Container(
          height: Constants.MATCHS_HEIGHT,
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      data.team?.name ?? "",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  )
              ),
              Expanded(
                flex: 2,
                child: buildRow(
                    "${data.totalPoint}",
                    "${data.totalMatch}",
                    "${data.totalMatchWin}",
                    "${data.totalMatchEqual}",
                    "${data.totalMatchLoose}",
                    "${data.totalGoal! - data.totalFailure!}",
                    22,
                    18,
                    FontWeight.w900,
                    FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      elevation: Constants.LIST_ELEVATION_LITTLE,
      margin: const EdgeInsets.all(Constants.LIST_MARGIN_LITTLE),
      shadowColor: Colors.blueAccent,
    );
  }

  BoxDecoration boxDecoration(Team team) {
    return BoxDecoration(
      border: Border(
        left: BorderSide(
          color: HexColor(team.backgroundColor!),
          width: 16.0,
        ),
      ),
    );
  }

  tileContainer(Team team, Widget widget) {
    return Container(
      decoration: boxDecoration(team),
      padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
      child: widget,
    );
  }

  static Row buildRow(String totalPoint, String totalMatch, String totalMatchWin, String totalMatchEqual, String totalMatchLoose, String diff, double hightSize, double lowSize, FontWeight? hightFontWeight, FontWeight? lowFontWeight) {
    return Row(
      children: [
        Expanded(
        flex: 1,
        child: Text(
            totalPoint,
              style: TextStyle(color: Colors.black, fontSize: hightSize, fontWeight: hightFontWeight)
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.center,
            child: Text(
                  totalMatch,
                  style: TextStyle(color: Colors.black, fontSize: lowSize, fontWeight: lowFontWeight)
              ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              totalMatchWin,
              style: TextStyle(color: Colors.black, fontSize: lowSize, fontWeight: lowFontWeight)
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.center,
            child: Text(
                totalMatchEqual,
                style: TextStyle(color: Colors.black, fontSize: lowSize, fontWeight: lowFontWeight)
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.center,
            child: Text(
                totalMatchLoose,
                style: TextStyle(color: Colors.black, fontSize: lowSize, fontWeight: lowFontWeight)
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.center,
            child: Text(
                diff,
                style: TextStyle(color: Colors.black, fontSize: lowSize, fontWeight: lowFontWeight)
            ),
          ),
        ),
      ],
    );
  }
}