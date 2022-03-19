import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:montournoi_net_flutter/screens/tournamentScreen.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';
import 'package:montournoi_net_flutter/utils/date.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:montournoi_net_flutter/utils/i18n.dart';

class TournamentsState extends State<TournamentsList> {

  List<Tournament> _tournaments = List.empty(growable: false);

  @override
  void initState() {
    super.initState();
    _populateTournaments();
  }

  void _populateTournaments() {
    EasyLoading.show(status: i18n.loadingLabel);
    Webservice().load(Tournament.all).then((tournaments) => {
      setState(() => {
        _tournaments = tournaments,
      }),
      EasyLoading.dismiss()
    }, onError: (error) => {
      EasyLoading.showError(error.toString())
    });
  }

  ListTile _buildItemsForListView(BuildContext context, int index) {
    return ListTile(
      title: Card(
        child: Container(
          height: 100,
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child:
                InkWell(
                  splashColor: Colors.red.withAlpha(30),
                  onTap: () {
                    _openTournament(_tournaments[index]);
                  },
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ListTile(
                            title: Text(_tournaments[index].name!, style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,),
                            subtitle: Text(Date.between(_tournaments[index], context), style: const TextStyle(color: Colors.black26,fontSize: 18), maxLines: 1,),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: _categoryList(_tournaments[index]),
                                    ),
                                  )
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(onPressed: () {}, icon: const Icon(Icons.play_circle_fill)),
                                      const SizedBox(width: 8,),
                                      IconButton(onPressed: () {
                                        _openTournament(_tournaments[index]);
                                      }, icon: const Icon(Icons.remove_red_eye_rounded)),
                                      const SizedBox(width: 8,),
                                      IconButton(onPressed: () {}, icon: const Icon(Icons.navigation_rounded)),
                                    ],
                                  ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                flex:8 ,
              ),
            ],
          ),
        ),
        elevation: Constants.LIST_ELEVATION,
        margin: const EdgeInsets.all(Constants.LIST_MARGIN),
        shadowColor: Colors.blueAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.applicationName),
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: Container(
                decoration: const BoxDecoration(color: Colors.blueAccent),
                child: ListView.builder(
                  itemCount: _tournaments.length,
                  itemBuilder: _buildItemsForListView,
                ),
              ),
            ),
          ],
        ),
    );
  }

  List<Widget> _categoryList(Tournament tournament) {
    return tournament.categories.map((c) =>
        Container(
          decoration: const BoxDecoration(color: Colors.red),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0, bottom: 4.0),
            child: Text(c.name ?? "", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        )
    ).toList();
  }

  void _openTournament(Tournament tournament) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TournamentScreen(tournament: tournament),
      ),
    );
  }
}

class TournamentsList extends StatefulWidget {
  const TournamentsList({Key? key}) : super(key: key);
  @override
  createState() => TournamentsState();
}