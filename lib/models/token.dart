import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:montournoi_net_flutter/models/userinfo.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';

import '../utils/url.dart';

part 'token.g.dart';

@JsonSerializable()
class Token {

  final String? token;
  final UserInfo? userInfo;

  Token({required this.token,required this.userInfo,});

  static BodyResource<Token> authenticate(context, email, password) {
    var body = jsonEncode({ 'email': email, 'password' : password });
    return BodyResource(
        url: URL.url(context, URL.AUTHENTICATE_URL, null),
        body: body,
        parse: (response) {
          var map = json.decode(response.body) as Map;
          return Token.fromJson(map as Map<String, dynamic>);
        }
    );
  }

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);
}