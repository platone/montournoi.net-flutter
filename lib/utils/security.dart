import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:montournoi_net_flutter/models/token.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:montournoi_net_flutter/utils/i18n.dart';

import '../services/webservice.dart';

class Security {

  static String LOGIN_KEY = "LOGIN_KEY";

  static String PASSWORD_KEY = "PASSWORD_KEY";

  static Token? _token;

  static DateTime? _date;

  static bool isConnected() {
    return null != _token && !mustAuthenticate();
  }

  static updateToken(Token token) {
    _token = token;
    _date = DateTime.now();
  }

  static bool mustAuthenticate() {
    if(null != _date) {
      var now = DateTime.now();
      return now.difference(_date!).inSeconds >= 1800;
    }
    return true;
  }

  static lastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(LOGIN_KEY);
  }

  static lastPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(PASSWORD_KEY);
  }

  static updateCredentials(String? login, String? password) async {
    final prefs = await SharedPreferences.getInstance();
    if(null != login && null != password) {
      await prefs.setString(Security.LOGIN_KEY, login);
      await prefs.setString(Security.PASSWORD_KEY, password);
    }
  }

  static void authenticate(BuildContext context, void Function(dynamic result) function) async {
    var login = await Security.lastLogin();
    var password = await Security.lastPassword();
    if(null != login && null != password) {
      EasyLoading.show(status: i18n.loadingLabel);
      Webservice().post(Token.authenticate(context, login, password), null).then((token) => {
        Security.updateToken(token),
        function(true)
      }, onError: (error) => {
        EasyLoading.showError(error.toString())
      });
    } else {
     function(false);
    }
  }

  static Token? lastToken() {
    return _token;
  }

  static Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(Security.LOGIN_KEY);
    prefs.remove(Security.PASSWORD_KEY);
  }
}