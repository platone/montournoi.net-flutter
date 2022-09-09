import 'package:flutter/material.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:montournoi_net_flutter/widgets/tabs/tournamentDetails.dart';
import 'package:montournoi_net_flutter/widgets/tabs/tournamentGroups.dart';
import 'package:montournoi_net_flutter/widgets/tabs/tournamentMatchs.dart';
import 'package:montournoi_net_flutter/widgets/tabs/tournamentRanking.dart';
import 'package:montournoi_net_flutter/widgets/tabs/tournamentScorers.dart';
import 'package:montournoi_net_flutter/widgets/tabs/tournamentTeams.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:showcaseview/showcaseview.dart';

class TournamentScreen extends StatefulWidget {
  final Tournament tournament;
  const TournamentScreen({Key? key, required this.tournament}) : super(key: key);
  @override
  createState() => _TournamentScreen();
}

class _TournamentScreen extends State<TournamentScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: (widget.tournament.showScorers ?? true) ? 7 : 6,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.tournament.name ?? ""),
            bottom: TabBar(
              tabs: generateTabList(),
            ),
          ),
          body: TabBarView(
            children: generateTabView(),
          ),
        ),
      ),
    );
  }

  List<Widget> generateTabView() {
    var tabView = List<Widget>.empty(growable: true);
    tabView.add(TournamentDetails(tournament: widget.tournament));
    tabView.add(TournamentMatchs(tournament: widget.tournament, past: false,));
    tabView.add(TournamentMatchs(tournament: widget.tournament, past: true,));
    tabView.add(TournamentTeams(tournament: widget.tournament));
    tabView.add(TournamentGroups(tournament: widget.tournament));
    tabView.add(TournamentRanking(tournament: widget.tournament));
    if((widget.tournament.showScorers ?? true)) {
      tabView.add(TournamentScorers(tournament: widget.tournament));
    }
    return tabView;
  }

  List<Widget> generateTabList() {
    var tabView = List<Widget>.empty(growable: true);
    tabView.add(const Tab(icon: Icon(Icons.article_rounded)));
    tabView.add(const Tab(icon: Icon(Icons.access_alarms_rounded)));
    tabView.add(const Tab(icon: Icon(Icons.access_time_rounded)));
    tabView.add(const Tab(icon: Icon(Icons.group_rounded)));
    tabView.add(const Tab(icon: Icon(Icons.account_box_rounded)));
    tabView.add(const Tab(icon: Icon(Icons.sort_rounded)));
    if((widget.tournament.showScorers ?? true)) {
      tabView.add(const Tab(icon: Icon(Icons.album_rounded)));
    }
    return tabView;
  }
}
