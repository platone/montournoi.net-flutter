import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:montournoi_net_flutter/utils/date.dart';
import 'package:montournoi_net_flutter/utils/email.dart';
import 'package:montournoi_net_flutter/utils/phone.dart';
import 'package:montournoi_net_flutter/utils/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

import '../../utils/plateform.dart';
import '../../utils/string.dart';

class TournamentDetailsState extends State<TournamentDetails> {

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    var name = widget.tournament.name ?? "";
    var city = widget.tournament.city ?? "";
    var additional = widget.tournament.additional ?? "";
    var street = widget.tournament.street ?? "";
    var zipcode = widget.tournament.zipcode ?? "";
    var phone = widget.tournament.phone ?? "";
    var email = widget.tournament.email ?? "";
    var dateBetween = Date.between(widget.tournament, context);
    var streetAdditional = street + " " + additional;
    var zipcodeCity = zipcode + " " + city;
    var phoneText = Phone.label(phone, context);
    var emailText = Email.label(email, context);
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: Column(
              children: [
                DetailsNameWidget(name: name),
                if(dateBetween.trim().isNotEmpty) Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 16, right: 16, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            dateBetween,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: () {
                              _openCalendar(widget.tournament);
                            }, icon: const Icon(Icons.calendar_today_rounded)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if(dateBetween.trim().isNotEmpty) Container(
                  color: Colors.grey[300],
                  height: 1,
                ),
                if(streetAdditional.trim().isNotEmpty) Padding(
                  padding: const EdgeInsets.only(
                      top: 8, left: 16, right: 16, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              streetAdditional,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: () {
                              _openMaps(widget.tournament);
                            }, icon: const Icon(Icons.navigation_rounded)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if(zipcodeCity.trim().isNotEmpty) Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 16, right: 16, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              zipcodeCity,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                        ),
                      ),
                      if(streetAdditional.trim().isEmpty) Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: () {
                              _openMaps(widget.tournament);
                            }, icon: const Icon(Icons.navigation_rounded)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if(streetAdditional.trim().isNotEmpty || zipcodeCity.trim().isNotEmpty) Container(
                  color: Colors.grey[300],
                  height: 1,
                ),
                if(phoneText.trim().isNotEmpty) Padding(
                  padding: const EdgeInsets.only(
                      top: 8, left: 16, right: 16, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              phoneText,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: () {
                              _openPhone(widget.tournament);
                            }, icon: const Icon(Icons.phone_in_talk_rounded)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if(emailText.trim().isNotEmpty) Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 16, right: 16, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              emailText,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: () {
                              _openMail(widget.tournament);
                            }, icon: const Icon(Icons.email_rounded)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey[300],
                  height: 1,
                ),
              ],
            ),
          ),
          Row(
            children: [
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
        ],
      ),
    );
  }

  void _openMaps(Tournament tournament) {
    MapsLauncher.launchQuery(StringUtils.location(tournament));
  }

  void _openCalendar(Tournament tournament) async {
    try {
      final Event event = Event(
        title: tournament.name ?? "",
        location: StringUtils.location(tournament),
        startDate: DateTime.parse(tournament.beginDate!),
        endDate: DateTime.parse(tournament.endDate!),
      );
      Add2Calendar.addEvent2Cal(event);
    } catch (err) {
      EasyLoading.showError(StringUtils.error(err, context, false));
    }
  }

  void _openPhone(Tournament tournament) async {
    var _url = Phone.url(widget.tournament.phone ?? "", context);
    try {
      await launch(_url);
    } catch (err) {
      EasyLoading.showError(StringUtils.error(_url, context, true));
    }
  }

  void _openMail(Tournament tournament) async {
    var _url = Email.url(widget.tournament.email ?? "", context);
    try {
      await launch(_url);
    } catch (err) {
      EasyLoading.showError(StringUtils.error(_url, context, true));
    }
  }
}

class DetailsNameWidget extends StatelessWidget {

  final String name;

  const DetailsNameWidget({
    Key? key,
    required this.name,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 28, right: 28, bottom: 16),
      child: Text(name, style: Theme.of(context).textTheme.titleLarge));
  }
}

class TournamentDetails extends StatefulWidget {
  final Tournament tournament;
  const TournamentDetails({Key? key, required this.tournament}) : super(key: key);
  @override
  createState() => TournamentDetailsState();
}