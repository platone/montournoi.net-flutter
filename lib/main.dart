import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:montournoi_net_flutter/utils/theme.dart';
import 'package:montournoi_net_flutter/widgets/screens/clubsList.dart';
import 'package:montournoi_net_flutter/widgets/screens/homeScreen.dart';
import 'package:montournoi_net_flutter/widgets/screens/tournamentsList.dart';
import 'package:page_transition/page_transition.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:admob_flutter/admob_flutter.dart';

import 'animation/custom_animation.dart';

void main() {
  runApp(MyApp());
  configLoading();
  Admob.initialize();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(1.0)
    ..userInteractions = false
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  late String appInfo = "";

  @override
  Widget build(BuildContext context) {
    _init(context);
    return MaterialApp(
      // showPerformanceOverlay: true,
      onGenerateTitle: (BuildContext context) =>
        AppLocalizations.of(context)!.applicationTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', ''),
      ],
      theme: Themes.simple(),
      home: AnimatedSplashScreen(
          duration: 3000,
          splash: Column(
            children: [
              const Expanded(
                child: Image(
                  image: AssetImage('assets/loading.png'),
                ),
                flex: 4,
              ),
              Expanded(
                child: Text(appInfo, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400)),
                flex: 2,
              ),
            ],
          ),
          nextScreen: const HomeScreen(),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
          backgroundColor: Colors.blueAccent),
      builder: EasyLoading.init(),
    );
  }

  void _init(BuildContext context) {
    initApp(context);
  }

  void initApp(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    appInfo = "v${version} (${buildNumber})";
  }
}