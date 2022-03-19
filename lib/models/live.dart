import 'dart:convert';

import 'package:montournoi_net_flutter/models/match.dart';
import 'package:montournoi_net_flutter/models/team.dart';
import 'package:montournoi_net_flutter/models/event.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';

class Live {

  final Match? target;
  final Match? next;

  Live({this.target, this.next});

  static Resource<Live> live(id) {
    return Resource(
        url: Constants.LIVE_URL + "${id}",
        parse: (response) {
          Iterable body = json.decode(response.body);
          List<Match> posts = List<Match>.from(body.map((model)=> Match.fromJson(model)));
          return Live(target: posts[0], next: posts[1]);
        }
    );
  }
}