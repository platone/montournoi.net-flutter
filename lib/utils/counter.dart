import 'package:shared_preferences/shared_preferences.dart';

class Counter {

  static int APPREVIEW_COUNTER_TARGET = 7;

  static int INTERSTITIAL_COUNTER_TARGET = 21;

  static String APPREVIEW_COUNTER_KEY = "APPREVIEW_COUNTER_KEY";

  static String INTERSTITIAL_COUNTER_KEY = "INTERSTITIAL_COUNTER_KEY";

  static Future<int> interstitialCounter() async {
    final prefs = await SharedPreferences.getInstance();
    var value = prefs.getInt(INTERSTITIAL_COUNTER_KEY) ?? 0;
    value += 1;
    await prefs.setInt(INTERSTITIAL_COUNTER_KEY, value <= INTERSTITIAL_COUNTER_TARGET ? value : 0 );
    return value;
  }

  static Future<bool> needInterstitial() async {
    var counter = await interstitialCounter();
    return counter == INTERSTITIAL_COUNTER_TARGET;
  }

  static Future<int> appReviewCounter() async {
    final prefs = await SharedPreferences.getInstance();
    var value = prefs.getInt(APPREVIEW_COUNTER_KEY) ?? 0;
    value += 1;
    await prefs.setInt(APPREVIEW_COUNTER_KEY, value);
    return value;
  }

  static Future<bool> needReview() async {
    var counter = await appReviewCounter();
    return counter == APPREVIEW_COUNTER_TARGET;
  }
}