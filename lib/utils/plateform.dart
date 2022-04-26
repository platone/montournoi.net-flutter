import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/foundation.dart' as Foundation;
import 'package:shared_preferences/shared_preferences.dart';

import 'counter.dart';

class Plateform {

  static String INTERSTITIAL_COUNTER_KEY = "INTERSTITIAL_COUNTER_KEY";

  static bool isIos(BuildContext context) {
    var platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS;
  }
  static bool isAndroid(BuildContext context) {
    var platform = Theme.of(context).platform;
    return platform == TargetPlatform.android;
  }
  static bool isMobile(BuildContext context) {
    return Plateform.isIos(context) || Plateform.isAndroid(context);
  }

  static String adMobBannerId(BuildContext context) {
    if(Foundation.kDebugMode) {
      if(Plateform.isMobile(context)) {
        return AdmobBanner.testAdUnitId;
      }
      return "";
    }
    return "ca-app-pub-8400721193062595/1982332751";
  }

  static String adMobInterstitielId(BuildContext context) {
    if(Foundation.kDebugMode) {
      if(Plateform.isMobile(context)) {
        return AdmobBanner.testAdUnitId;
      }
      return "";
    }
    return "ca-app-pub-8400721193062595/1816531398";
  }

  static Future<void> showInterstitial() async {
    if( await Counter.needInterstitial()) {
      AdmobInterstitial? interstitialAd;
      interstitialAd = AdmobInterstitial(
          adUnitId: AdmobInterstitial.testAdUnitId,
          listener: (event, args) {
            if (event == AdmobAdEvent.loaded) {
              interstitialAd?.show();
            }
            if (event == AdmobAdEvent.failedToLoad) {
              print("Error loading Interstitial !");
            }
          }
      );
      interstitialAd.load();
    }
  }
}