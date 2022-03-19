import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:montournoi_net_flutter/models/live.dart';
import 'package:montournoi_net_flutter/models/match.dart';
import 'package:montournoi_net_flutter/models/team.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:montournoi_net_flutter/screens/tournamentScreen.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';
import 'package:montournoi_net_flutter/utils/date.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:montournoi_net_flutter/utils/i18n.dart';
import 'package:montournoi_net_flutter/utils/security.dart';
import 'package:montournoi_net_flutter/utils/string.dart';

class LiveState extends State<LiveScreen> {

  Live? _live;

  @override
  void initState() {
    super.initState();
    _populate();
  }

  void _populate() {
    EasyLoading.show(status: i18n.loadingLabel);
    Webservice().load(Live.live(widget.match.id)).then((live) => {
      setState(() => {
        _live = live
      }),
      EasyLoading.dismiss()
    }, onError: (error) => {
      EasyLoading.showError(error.toString())
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringUtils.match(this._live?.target, context)),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.blueAccent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeaderWidget(live: _live),
            BodyWidget(live: _live),
          ],
        )
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
    required Live? live,
  }) : _live = live, super(key: key);

  final Live? _live;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 32),
            child: Row(
              children: [
                TeamNameWidget(team: _live?.target?.receiver),
                TeamImageWidget(team: _live?.target?.receiver),
                ScoreWidget(live: _live),
                TeamImageWidget(team: _live?.target?.visitor),
                TeamNameWidget(team: _live?.target?.visitor),
              ],
            ),
          ),
        ),),
    );
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({
    Key? key,
    required Live? live,
  }) : _live = live, super(key: key);

  final Live? _live;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Container(
        decoration: const BoxDecoration(color: Colors.blueAccent),
        child: Center(
          child: ListView.builder(
              itemCount: _live?.target?.events?.length,
              itemBuilder: _buildListViewItem,
          ),
        ),
      ),
    );
  }

  ListTile _buildListViewItem(BuildContext context, int index) {
    return ListTile(
      title: Card(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
            child: Row(
              children: [
                      EventTypeListWidget(live: _live, index: index,),
                      TeamImageWidget(team: _live?.target?.events[index].owner),
                      EventTeamNameWidget(live: _live, index: index,),
                      EventPlayersWidget(live: _live, index: index,),
                      Security.isConnected() ? EventActionWidget(live: _live, index: index,) :  const Spacer(flex: 1),
                    ],
                  ),
                ),
        ),
        elevation: Constants.LIST_ELEVATION,
        margin: const EdgeInsets.all(Constants.LIST_MARGIN),
        shadowColor: Colors.blueAccent,
      ),
    );
  }
}

class EventPlayersWidget extends StatelessWidget {
  const EventPlayersWidget({
    Key? key,
    required Live? live, required int index,
  }) : _live = live, _index = index, super(key: key);

  final Live? _live;
  final int _index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Align(
          alignment: Alignment.centerLeft,
          child: Text(
              StringUtils.player(_live?.target?.events[_index].player, context),
              style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          Align(
          alignment: Alignment.centerLeft,
          child: Text(
              StringUtils.player(_live?.target?.events[_index].firstAssist, context),
              style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ),
          Align(
          alignment: Alignment.centerLeft,
          child: Text(
              StringUtils.player(_live?.target?.events[_index].secondAssist, context),
              style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class EventActionWidget extends StatelessWidget {
  const EventActionWidget({
    Key? key,
    required Live? live, required int index,
  }) : _live = live, _index = index, super(key: key);

  final Live? _live;
  final int _index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete_rounded)),
        ],
      ),
      flex: 1,
    );
  }
}

class EventTeamNameWidget extends StatelessWidget {
  const EventTeamNameWidget({
    Key? key,
    required Live? live, required int index,
  }) : _live = live, _index = index, super(key: key);

  final Live? _live;
  final int _index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
            _live?.target?.events[_index].owner?.name ?? "",
            style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      flex: 4,
    );
  }
}

class EventTypeListWidget extends StatelessWidget {
  const EventTypeListWidget({
    Key? key,
    required Live? live, required int index,
  }) : _live = live, _index = index, super(key: key);

  final Live? _live;
  final int _index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
          StringUtils.type(_live?.target?.events[_index], context),
          style: TextStyle(
            color: _live?.target?.events[_index].type != 'TYPE_PENALTY' ? Colors.blueAccent : Colors.redAccent,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
      ),
      flex: 1,
    );
  }
}

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({
    Key? key,
    required Live? live,
  }) : _live = live, super(key: key);

  final Live? _live;

  @override
  Widget build(BuildContext context) {
    var receiverScore = StringUtils.score(_live?.target?.events, _live?.target?.receiver);
    var visitorScore = StringUtils.score(_live?.target?.events, _live?.target?.visitor);
    return Expanded(
      child: Row(
        children: [
          Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text("${receiverScore}",
                  style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: (receiverScore > visitorScore ? FontWeight.w900 : FontWeight.w500), ),
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
              flex: 2
          ),
          const Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                    "-",
                    style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500, )
                ),
              ),
              flex: 1
          ),
          Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text("${visitorScore}",
                  style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: (receiverScore < visitorScore ? FontWeight.w900 : FontWeight.w500), ),
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
              flex: 2
          ),
        ],
      ),
      flex: 1,
    );
  }
}

class TeamImageWidget extends StatelessWidget {
  const TeamImageWidget({
    Key? key,
    required Team? team,
  }) : _team = team, super(key: key);

  final Team? _team;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
          child: CachedNetworkImage(
            imageUrl: _team?.image?.replaceAll("http:", "https:") ?? "",
            height: Constants.MATCHS_HEIGHT / 2,
            width: Constants.MATCHS_HEIGHT / 2,
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
}

class TeamNameWidget extends StatelessWidget {
  const TeamNameWidget({
    Key? key,
    required Team? team,
  }) : _team = team, super(key: key);

  final Team? _team;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Align(
          alignment: Alignment.center,
          child: Text(
              _team?.name ?? "",
              style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400)
          ),
        ),
        flex: 2,
    );
  }
}

class LiveScreen extends StatefulWidget {
  final Match match;
  const LiveScreen({Key? key, required this.match}) : super(key: key);
  @override
  createState() => LiveState();
}