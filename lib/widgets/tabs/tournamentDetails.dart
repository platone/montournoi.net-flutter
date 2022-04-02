import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:montournoi_net_flutter/utils/date.dart';
import 'package:montournoi_net_flutter/utils/email.dart';
import 'package:montournoi_net_flutter/utils/phone.dart';
import 'package:montournoi_net_flutter/utils/style.dart';

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
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DetailsNameWidget(name: name),
          Padding(
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
                        Date.between(widget.tournament, context),
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
                      IconButton(onPressed: () {}, icon: const Icon(Icons.calendar_today_rounded)),
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
          Padding(
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
                      street + " " + additional,
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
                      IconButton(onPressed: () {}, icon: const Icon(Icons.navigation_rounded)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
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
                        zipcode + " " + city,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[300],
            height: 1,
          ),
          Padding(
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
                        Phone.label(phone, context),
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
                      IconButton(onPressed: () {}, icon: const Icon(Icons.phone_in_talk_rounded)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
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
                        Email.label(email, context),
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
                      IconButton(onPressed: () {}, icon: const Icon(Icons.email_rounded)),
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
    );
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