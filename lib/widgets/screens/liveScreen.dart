
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:dart_amqp/dart_amqp.dart";
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:montournoi_net_flutter/models/event.dart';
import 'package:montournoi_net_flutter/models/live.dart';
import 'package:montournoi_net_flutter/models/match.dart';
import 'package:montournoi_net_flutter/models/params/event.dart';
import 'package:montournoi_net_flutter/models/team.dart';
import 'package:montournoi_net_flutter/models/token.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';
import 'package:montournoi_net_flutter/utils/i18n.dart';
import 'package:montournoi_net_flutter/utils/security.dart';
import 'package:montournoi_net_flutter/utils/string.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:montournoi_net_flutter/utils/plateform.dart';
import '../../models/livematch.dart';
import '../../models/liveteam.dart';
import 'abstractScreen.dart';

import 'package:flutter/foundation.dart' as Foundation;

class LiveState extends AbstractScreen<LiveScreen, Live> {

  Live? _live;

  LiveMatch? _liveMatch;

  List<LiveTeam>? _teams;

  @override
  postData() {
    super.postData();
    _subscribe();
  }

  @override
  void populate(bool refresh) {
    load(refresh, this, Live.live(context, widget.match.id), (param) {setState(() {
      _live = param;
      loadMatch();
    });});
  }

  void authenticate(void Function(dynamic param) function, param) async {
    var login = await Security.lastLogin();
    var password = await Security.lastPassword();
    Webservice().post(Token.authenticate(context, login, password), null).then((token) => {
      Security.updateToken(token),
      function(param)
    }, onError: (error) => {
      EasyLoading.showError(error.toString())
    });
  }

  void close() {
    EasyLoading.show(status: i18n.loadingLabel);
    if(Security.mustAuthenticate()) {
      authenticate(closeMatch, null);
      Navigator.pop(context);
    } else {
      closeMatch(null);
    }
  }

  void post(event) {
    EasyLoading.show(status: i18n.loadingLabel);
    if(Security.mustAuthenticate()) {
      authenticate(postEvent, event);
      Navigator.pop(context);
    } else {
      postEvent(event);
    }
  }

  void posts(param) {
   //  EasyLoading.show(status: i18n.loadingLabel);
    if(Security.mustAuthenticate()) {
      authenticate(associateTeams, param);
    } else {
      associateTeams(param);
    }
  }

  void delete(event) {
    EasyLoading.show(status: i18n.loadingLabel);
    if(Security.mustAuthenticate()) {
      authenticate(deleteEvent, event);
      Navigator.pop(context);
    } else {
      deleteEvent(event);
    }
  }

  void closeMatch(param) {
    Webservice().loads(Live.close(context, _live?.target?.id), Security.lastToken()).then((live) => {
      EasyLoading.dismiss(),
    }, onError: (error) => {
      EasyLoading.showError(error.toString())
    });
  }

  void associateTeams(param) {
    Webservice().loads(Match.teams(context, param.match, param.receiver, param.visitor), Security.lastToken()).then((match) => {
      EasyLoading.dismiss(),
      populate(true)
    }, onError: (error) => {
      EasyLoading.showError(error.toString())
    });
  }

  void loadMatch() {
    Webservice().load(LiveMatch.one(context, widget.match.id)).then((liveMatch) => {
      _liveMatch = liveMatch,
      loadTeams()
    }, onError: (error) => {
      EasyLoading.showError(error.toString())
    });
  }

  void loadTeams() {
    var group = _liveMatch?.group?.replaceAll("/api/groups", "");
    Webservice().load(LiveTeam.group(context, group)).then((teams) => {
      _teams = teams,
      EasyLoading.dismiss(),
    }, onError: (error) => {
      EasyLoading.showError(error.toString())
    });
  }

  void deleteEvent(event) {
    Webservice().delete(Live.delete(context, event), Security.lastToken()).then((live) => {
      EasyLoading.dismiss(),
      populate(true),
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.eventDeletedTitle),
      ))
    }, onError: (error) => {
      EasyLoading.showError(error.toString())
    });
  }
  void postEvent(event) {
    Webservice().post(Live.post(context, event), Security.lastToken()).then((live) => {
      EasyLoading.dismiss(),
      populate(true)
    }, onError: (error) => {
      EasyLoading.showError(error.toString())
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringUtils.match(this._live?.target, context)),
        actions: actions(),
      ),
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).focusColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeaderWidget(live: _live),
            BodyWidget(live: _live, action:_processDeleteEvent),
            Expanded(child:
              Container(
                color: Theme.of(context).primaryColorDark,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
                  child: AdmobBanner(
                    adUnitId: Plateform.adMobBannerId(context),
                    adSize: AdmobBannerSize.BANNER,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Security.isConnected() ? FloatingActionButton(
        child: const Icon(Icons.add_circle_rounded),
        onPressed: () {
          if(canAdd()) {
            onAdd();
          } else {
            showAddEventAlert();
          }
        },
      ) : null,
    );
  }

  void _subscribe() {
    if (!Foundation.kDebugMode) {
      _subscribeAsync();
    }
  }

  void _subscribeAsync() async {
    ConnectionSettings settings = ConnectionSettings(
        host: Constants.RABBITMQ_HOSTNAME,
        authProvider: const PlainAuthenticator(Constants.RABBITMQ_USERNAME, Constants.RABBITMQ_PASSWORD)
    );
    Client client = Client(settings: settings);
    Channel channel = await client.channel();
    Exchange exchange = await channel.exchange(Constants.RABBITMQ_EXCHANGE_NAME, ExchangeType.FANOUT, durable: true);
    Consumer consumer = await exchange.bindPrivateQueueConsumer([Constants.RABBITMQ_ROUTINGKEY]);
    consumer.listen((AmqpMessage message) {
      populate(false);
    });
  }

  onAdd() {
    showDialog(
      context: context,
      builder: (_) {
        return EventDialog(live: _live!, callback: (event) {
          post(event);
        });
      }
    );
  }

  List<Widget>? actions() {
    if(Security.isConnected()) {
      return [
        IconButton(
          icon: const Icon(
            Icons.group_add_rounded,
            size: 26.0,
          ),
          tooltip: AppLocalizations.of(context)!.endMatchTooltip,
          onPressed: () {
            if(canChangeTeam()) {
              _processSelectTeam();
            } else {
              showCantChangeTeamAlert();
            }
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.highlight_off_rounded,
            size: 26.0,
          ),
          tooltip: AppLocalizations.of(context)!.endMatchTooltip,
          onPressed: () {
            if(canAdd()) {
              _processEndMatch();
            } else {
              showCloseMatchAlert();
            }
          },
        ),
      ];
    } else {
      return [];
    }
  }

  void _processSelectTeam() {
    showDialog(
        context: context,
        builder: (_) {
          return TeamDialog(live: _live!, liveMatch: _liveMatch!, teams: _teams!, callback: (param) {
            posts(param);
          });
        }
    );
  }

  void _processAlert(title, content) {
    Widget cancelButton = ElevatedButton(
      child: Text(AppLocalizations.of(context)!.closeButton),
      onPressed:  () {
        Navigator.pop(context, true);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        cancelButton,
      ],
    );    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _processEndMatch() {
    Widget cancelButton = ElevatedButton(
      child: Text(AppLocalizations.of(context)!.eventFormCancelButton),
      onPressed:  () {
        Navigator.pop(context, true);
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text(AppLocalizations.of(context)!.eventFormValidateButton),
      onPressed:  () {
        Navigator.pop(context, true);
        close();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(AppLocalizations.of(context)!.eventMatchEndTitle),
      content: Text(AppLocalizations.of(context)!.eventMatchEndDescriptionTitle),
      actions: [
        cancelButton,
        continueButton,
      ],
    );    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _processDeleteEvent(event) {
    Widget cancelButton = ElevatedButton(
      child: Text(AppLocalizations.of(context)!.eventFormCancelButton),
      onPressed:  () {
        Navigator.pop(context, true);
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text(AppLocalizations.of(context)!.eventFormValidateButton),
      onPressed:  () {
        Navigator.pop(context, true);
        delete(event);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(AppLocalizations.of(context)!.eventEventDeleteTitle),
      content: Text(AppLocalizations.of(context)!.eventEventDeleteDescriptionTitle),
      actions: [
        cancelButton,
        continueButton,
      ],
    );    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool canAdd() {
    return _live?.target?.receiver != null;
  }

  bool canChangeTeam() {
    return _live?.target?.events.isEmpty ?? true;
  }

  void showAddEventAlert() {
    _processAlert(
        AppLocalizations.of(context)!.eventAddAlertTitle,
        AppLocalizations.of(context)!.eventAddAlertDesriptionTitle
    );
  }

  void showCloseMatchAlert() {
    _processAlert(
        AppLocalizations.of(context)!.matchCloseAlertTitle,
        AppLocalizations.of(context)!.matchCloseAlertDesriptionTitle
    );

  }
  void showCantChangeTeamAlert() {
    _processAlert(
        AppLocalizations.of(context)!.changeTeamAlertTitle,
        AppLocalizations.of(context)!.changeTeamAlertDesriptionTitle
    );
  }
}

class MatchTeams {
  final String? match;
  final String? visitor;
  final String? receiver;

  MatchTeams({required this.match, required this.visitor, required this.receiver,});
}

class TeamDialog extends StatefulWidget {
  final Live live;
  final LiveMatch liveMatch;
  final List<LiveTeam> teams;
  final Function callback;
  const TeamDialog({Key? key, required this.live, required this.liveMatch, required this.teams, required this.callback}) : super(key: key);
  @override
  createState() => _TeamDialogState();
}

class _TeamDialogState extends State<TeamDialog> {
  String? selectedReceiverValue;
  String? selectedVisitorValue;

  List<DropdownMenuItem<String>> receiverListTeamsValues = [];
  List<DropdownMenuItem<String>> visitorListTeamsValues = [];

  @override
  void didChangeDependencies() {
    _initTypeValues();
  }

  void _initTypeValues() {
    receiverListTeamsValues = createReceiverListValues();
    visitorListTeamsValues = createVisitorListValues();
  }

  List<DropdownMenuItem<String>> createReceiverListValues() {
    List<DropdownMenuItem<String>> listTeamsValues = [];
    for (var team in widget.teams) {
      var item = DropdownMenuItem(
          child: Text(team.name ?? ""),
          value: "${team.id}",
          enabled: selectedReceiverValue != "${team.id}",
      );
      listTeamsValues.add(item);
    }
    return listTeamsValues;
  }

  List<DropdownMenuItem<String>> createVisitorListValues() {
    List<DropdownMenuItem<String>> listTeamsValues = [];
    for (var team in widget.teams) {
      var item = DropdownMenuItem(
          child: Text(team.name ?? ""),
          value: "${team.id}",
          enabled: selectedVisitorValue != "${team.id}",
      );
      listTeamsValues.add(item);
    }
    return listTeamsValues;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.eventFormTitle),
      actions: <Widget>[
        generateReceiverTeamDropDown(),
        generateVisitorTeamDropDown(),
        Row(
          children: [
            Expanded(
                child: DialogButton(
                  onPressed: () => {
                    Navigator.pop(context)
                  },
                  child: Text(
                    AppLocalizations.of(context)!.eventFormCancelButton,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )),
            Expanded(
                child: DialogButton(
                  onPressed: () {
                    var param = MatchTeams(match: "${widget.live.target?.id}", receiver: selectedReceiverValue, visitor: selectedVisitorValue);
                    widget.callback(param);
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.eventFormValidateButton,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )),
          ],
        )
      ],
    );
  }

  DropdownButtonFormField<String> generateReceiverTeamDropDown() {
    return DropdownButtonFormField(
        value: selectedReceiverValue,
        onChanged: (String? newValue) {
          setState(() {
            selectedReceiverValue = newValue!;
            _initTypeValues();
          });
        },
        items: receiverListTeamsValues);
  }

  DropdownButtonFormField<String> generateVisitorTeamDropDown() {
    return DropdownButtonFormField(
        value: selectedVisitorValue,
        onChanged: (String? newValue) {
          setState(() {
            selectedVisitorValue = newValue!;
            _initTypeValues();
          });
        },
        items: visitorListTeamsValues);
  }
}

class EventDialog extends StatefulWidget {
  final Live live;
  final Function callback;
  const EventDialog({Key? key, required this.live, required this.callback}) : super(key: key);
  @override
  createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  String? selectedTypeValue;
  String? selectedSubtypeValue;
  String? selectedTeamValue;
  String? selectedPlayerValue;
  String? selectedFirstAssistValue;
  String? selectedSecondValue;

  List<DropdownMenuItem<String>> listTypeValues = [];
  List<DropdownMenuItem<String>> listSubtypeValues = [];
  List<DropdownMenuItem<String>> listTeamValues = [];
  List<DropdownMenuItem<String>> listPlayerValues = [];
  List<DropdownMenuItem<String>> listFirstAssistValues = [];
  List<DropdownMenuItem<String>> listSecondValues = [];

  @override
  void didChangeDependencies() {
    _initTypeValues();
  }

  void _initTypeValues() {
    listTypeValues = [
      DropdownMenuItem(child: Text(StringUtils.event("TYPE_GOAL", context)), value: "TYPE_GOAL"),
      DropdownMenuItem(child: Text(StringUtils.event("TYPE_PENALTY", context)), value: "TYPE_PENALTY"),
      DropdownMenuItem(child: Text(StringUtils.event("TYPE_PENALTY_SHOT", context)), value: "TYPE_PENALTY_SHOT"),
      DropdownMenuItem(child: Text(StringUtils.event("TYPE_KEEPER_SAVE", context)), value: "TYPE_KEEPER_SAVE"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.eventFormTitle),
      actions: <Widget>[
        generateEventTypeDropDown(),
        generateEventTeamDropDown(),
        generateEventPlayerDropDown(),
        generateEventFirstAssistDropDown(),
        generateEventSecondAssistDropDown(),
        Row(
          children: [
            Expanded(
                child: DialogButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppLocalizations.of(context)!.eventFormCancelButton,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )),
            Expanded(
                child: DialogButton(
                // String payload = "{type: 'TYPE_GOAL', owner: '/api/teams/49', subtype: null, match: ";
                  onPressed: () {
                    widget.callback(EventParam(
                      match: "/api/matches/${widget.live.target?.id}",
                      type: selectedTypeValue,
                      owner: selectedTeamValue != null ? '/api/teams/${selectedTeamValue}' : null,
                      firstAssist: selectedFirstAssistValue != null ? "/api/users/${selectedFirstAssistValue}" : null,
                      secondAssist: selectedSecondValue != null ? "/api/users/${selectedSecondValue}" : null,
                      player: selectedPlayerValue != null ? "/api/users/${selectedPlayerValue}" : null,
                      subtype: null,
                    ));
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.eventFormValidateButton,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )),
          ],
        )
      ],
    );
  }

  DropdownButtonFormField<String> generateEventTypeDropDown() {
    return DropdownButtonFormField(
        value: selectedTypeValue,
        onChanged: (String? newValue) {
          setState(() {
            selectedTypeValue = newValue!;
            selectedTeamValue = null;
            listTeamValues = [
              DropdownMenuItem(child: Text(widget.live.target?.receiver?.name ?? ""), value: "${widget.live.target?.receiver?.id}"),
              DropdownMenuItem(child: Text(widget.live.target?.visitor?.name ?? ""), value: "${widget.live.target?.visitor?.id}"),
            ];
            selectedPlayerValue = null;
            listPlayerValues = [];
            selectedFirstAssistValue = null;
            listFirstAssistValues = [];
            selectedSecondValue = null;
            listSecondValues = [];
          });
        },
        items: listTypeValues);
  }

  DropdownButtonFormField<String> generateEventTeamDropDown() {
        return DropdownButtonFormField(
            key: ValueKey(selectedTypeValue),
            value: selectedTeamValue, onChanged: (String? newValue) {
          setState(() {
            selectedTeamValue = newValue!;
            selectedPlayerValue = null;
            listPlayerValues = createEventPlayerListItem(selectedTeamValue, []);
            selectedFirstAssistValue = null;
            listFirstAssistValues = [];
            selectedSecondValue = null;
            listSecondValues = [];
          });
        },
        items: listTeamValues);
  }

  DropdownButtonFormField<String> generateEventPlayerDropDown() {
    return DropdownButtonFormField(
        value: selectedPlayerValue,
        onChanged: (String? newValue) {
          setState(() {
            selectedPlayerValue = newValue!;
            selectedFirstAssistValue = null;
            listFirstAssistValues = selectedTypeValue == 'TYPE_GOAL' ? createEventPlayerListItem(selectedTeamValue, [selectedPlayerValue!]) : [];
            selectedSecondValue = null;
            listSecondValues = [];
          });
        },
        items: listPlayerValues);
  }

  DropdownButtonFormField<String> generateEventFirstAssistDropDown() {
    return DropdownButtonFormField(
        value: selectedFirstAssistValue,
        onChanged: (String? newValue) {
          setState(() {
            selectedFirstAssistValue = newValue!;
            selectedSecondValue = null;
            listSecondValues = createEventPlayerListItem(selectedTeamValue, [selectedPlayerValue!, selectedFirstAssistValue!]);
          });
        },
        items: listFirstAssistValues);
  }

  DropdownButtonFormField<String> generateEventSecondAssistDropDown() {
    return DropdownButtonFormField(
        value: selectedSecondValue,
        onChanged: (String? newValue) {
          setState(() {
            selectedSecondValue = newValue!;
          });
        },
        items: listSecondValues);
  }

  List<DropdownMenuItem<String>> createEventPlayerListItem(teamValue, List<String> ids) {
    List<DropdownMenuItem<String>> items = [];
    if (teamValue != null) {
      var players = int.parse(teamValue!) ==
          widget.live.target?.receiver?.id
          ? widget.live.target?.receiver?.players
          : widget.live.target?.visitor?.players;
      players?.forEach((element) {
        items.add(DropdownMenuItem(
          child: Text(
            StringUtils.playern(element, context),
            style: TextStyle(color: (!ids.contains("${element.id}") ? Colors.black : Colors.black26), fontSize: 14, fontWeight: (!ids.contains("${element.id}") ? FontWeight.w300 : FontWeight.w700)),
          ),
          value: "${element.id}",
          enabled: !ids.contains("${element.id}"),
        ),
        );
      });
    }
    return items;
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
        flex: 3,
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.center,
                matchTextDirection: true,
                fit: BoxFit.cover,
                image: AssetImage("assets/live.png"),
              ),
          ),
          child: Column(
            children: [
              const Expanded(
                flex: 1,
                child: SizedBox()
              ),
              Expanded(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 0),
                          child: Row(
                            children: [
                              TeamNameWidget(team: _live?.target?.receiver),
                              TeamImageWidget(team: _live?.target?.receiver, flex: 2),
                              ScoreWidget(live: _live),
                              TeamImageWidget(team: _live?.target?.visitor, flex: 2),
                              TeamNameWidget(team: _live?.target?.visitor),
                            ],
                          ),
                        ),
                      ),
                    ),
                ),
              ),
              const Expanded(
                  flex: 1,
                  child: SizedBox()
              ),
            ],
          )
        ),
    );
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({
    Key? key,
    required Live? live, required void Function(dynamic event) action,
  }) : _live = live, _action = action, super(key: key);

  final Live? _live;

  final Function(dynamic event)? _action;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).focusColor),
        child: Center(
          child: ListView.builder(
              itemCount: _live?.target?.events?.length ?? 0,
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
                      TeamImageWidget(team: _live?.target?.events[index].owner, flex: 1),
                      EventTeamNameWidget(live: _live, index: index,),
                      EventPlayersWidget(live: _live, index: index,),
                      Security.isConnected() ? EventActionWidget(live: _live, index: index, action: _action) :  const Spacer(flex: 1),
                    ],
                  ),
                ),
        ),
        elevation: Constants.LIST_ELEVATION,
        margin: const EdgeInsets.all(Constants.LIST_MARGIN),
        shadowColor: Theme.of(context).primaryColor,
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
    required Live? live, required int index, required Function(dynamic event)? action,
  }) : _live = live, _index = index, _action = action, super(key: key);

  final Live? _live;
  final int _index;
  final Function(dynamic event)? _action;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(onPressed: () {
            null != _action? _action!(_live?.target?.events[_index]) : null;
          }, icon: const Icon(Icons.delete_rounded)),
        ],
      ),
      flex: 2,
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
        child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4,),
        child: Text(
          _live?.target?.events[_index].owner?.name ?? "",
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
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
            color: _live?.target?.events[_index].type != 'TYPE_PENALTY' ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.secondary,
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
      flex: 4,
    );
  }
}

class TeamImageWidget extends StatelessWidget {
  const TeamImageWidget({
    Key? key,
    required Team? team, required int? flex,
  }) : _team = team, _flex = flex, super(key: key);

  final Team? _team;

  final int? _flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 4),
          child: CachedNetworkImage(
            imageUrl: _team?.image?.replaceAll("http:", "https:") ?? "",
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
      flex: _flex ?? 1,
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
          child: Padding(
              padding: const EdgeInsets.only(left: 4, right: 4,),
              child: Text(
                _team?.name ?? "",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                )
            ),
          ),
        ),
        flex: 5,
    );
  }
}

class LiveScreen extends StatefulWidget {
  final Match match;
  const LiveScreen({Key? key, required this.match}) : super(key: key);
  @override
  createState() => LiveState();
}