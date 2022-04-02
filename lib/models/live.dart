import 'dart:convert';

import 'package:montournoi_net_flutter/models/match.dart';
import 'package:montournoi_net_flutter/models/team.dart';
import 'package:montournoi_net_flutter/models/event.dart';
import 'package:montournoi_net_flutter/models/token.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';

import '../utils/url.dart';

class Live {

  final Match? target;
  final Match? next;

  Live({this.target, this.next});

  static Resource<Live> live(context, id) {
    return Resource(
        url: URL.url(context, URL.LIVE_URL, "/${id}"),
        parse: (response) {
          Iterable body = json.decode(response.body);
          List<Match> posts = List<Match>.from(body.map((model)=> Match.fromJson(model)));
          return Live(target: posts[0], next: posts.length > 1 ? posts[1] : null);
        }
    );
  }

  static Resource<bool> delete(context, event) {
    return Resource(
        url: URL.url(context, URL.EVENT_URL, "/${event.id}"),
        parse: (response) {
          return true;
        }
    );
  }

  static BodyResource<bool> post(context, event) {
    return BodyResource(
        url: URL.url(context, URL.EVENT_URL, null),
        body: json.encode(event),
        parse: (response) {
          return true;
        }
    );
  }

  static Resource<bool> close(context, id) {
    return Resource(
        url: URL.url(context, URL.CLOSE_URL, "/${id}"),
        parse: (response) {
          return true;
        }
    );
  }
}