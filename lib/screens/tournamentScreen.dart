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
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            title: Text(tournament.name ?? ""),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.article_rounded)),
                Tab(icon: Icon(Icons.access_alarms_rounded)),
                Tab(icon: Icon(Icons.access_time_rounded)),
                Tab(icon: Icon(Icons.group_rounded)),
                Tab(icon: Icon(Icons.account_box_rounded)),
                Tab(icon: Icon(Icons.sort_rounded)),
                Tab(icon: Icon(Icons.album_rounded)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TournamentDetails(tournament: tournament),
              TournamentMatchs(tournament: tournament, past: false,),
              TournamentMatchs(tournament: tournament, past: true,),
              TournamentTeams(tournament: tournament),
              TournamentGroups(tournament: tournament),
              TournamentRanking(tournament: tournament),
              TournamentScorers(tournament: tournament),
            ],
          ),
        ),
      ),
    );
  }
}
