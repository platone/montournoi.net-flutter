import 'package:flutter/material.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:montournoi_net_flutter/widgets/tabs/tournamentDetails.dart';
import 'package:montournoi_net_flutter/widgets/tabs/tournamentGroups.dart';
import 'package:montournoi_net_flutter/widgets/tabs/tournamentMatchs.dart';
import 'package:montournoi_net_flutter/widgets/tabs/tournamentRanking.dart';
import 'package:montournoi_net_flutter/widgets/tabs/tournamentScorers.dart';
import 'package:montournoi_net_flutter/widgets/tabs/tournamentTeams.dart';

class TournamentScreen extends StatelessWidget {
  const TournamentScreen({Key? key, required this.tournament})
      : super(key: key);

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: (tournament.showScorers ?? true) ? 7 : 6,
        child: Scaffold(
          appBar: AppBar(
            title: Text(tournament.name ?? ""),
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
    tabView.add(TournamentDetails(tournament: tournament));
    tabView.add(TournamentMatchs(tournament: tournament, past: false,));
    tabView.add(TournamentMatchs(tournament: tournament, past: true,));
    tabView.add(TournamentTeams(tournament: tournament));
    tabView.add(TournamentGroups(tournament: tournament));
    tabView.add(TournamentRanking(tournament: tournament));
    if((tournament.showScorers ?? true)) {
      tabView.add(TournamentScorers(tournament: tournament));
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
    if((tournament.showScorers ?? true)) {
      tabView.add(const Tab(icon: Icon(Icons.album_rounded)));
    }
    return tabView;
  }
}
