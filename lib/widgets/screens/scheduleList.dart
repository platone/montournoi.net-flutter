import 'dart:collection';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:montournoi_net_flutter/dialog/signup.dart';
import 'package:montournoi_net_flutter/models/schedule.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:montournoi_net_flutter/widgets/screens/tournamentScreen.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';
import 'package:montournoi_net_flutter/utils/date.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:montournoi_net_flutter/utils/plateform.dart';
import 'package:montournoi_net_flutter/utils/security.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:montournoi_net_flutter/utils/string.dart';
import 'package:sprintf/sprintf.dart';
import '../../models/club.dart';
import '../../models/match.dart';
import '../../models/schedules.dart';
import '../../utils/box.dart';
import '../../utils/counter.dart';
import 'abstractScreen.dart';
import 'liveScreen.dart';

class SchedulesState extends AbstractScreen<SchedulesList, Schedules> {

  var _sectionFormat;
  var _dayFormat;
  var _weekFormat;

  var _headerCat;
  var _headerIce;
  var _headerOffice;

  var _period = "";

  var _dateTime = DateTime.now();

  Schedules? _schedule;

  List<DateTime> _keys = [];

  final HashMap<DateTime, List<Schedule>> _days = HashMap();

  final InAppReview inAppReview = InAppReview.instance;

  final ScrollController _scrollController = ScrollController();

  @override
  preData() async {
    _sectionFormat = AppLocalizations.of(context)!.scheduleTileDateFormat;
    _dayFormat = AppLocalizations.of(context)!.scheduleWeekDateFormat;
    _weekFormat = AppLocalizations.of(context)!.scheduleWeekTextFormat;
    _headerCat = AppLocalizations.of(context)!.headerCat;
    _headerIce = AppLocalizations.of(context)!.headerIce;
    _headerOffice = AppLocalizations.of(context)!.headerOffice;
  }

  @override
  postData() async {
    super.postData();
    if (await Counter.needReview() && await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  void populate(bool loader) {
    int id = widget.club.id ?? 0;
    double time = _dateTime.millisecondsSinceEpoch / 1000;
    load(loader, this, Schedules.one(context, id, time.toInt()), (param) {
      setState(() {
        _schedule = param;
        buildDays(_schedule);
        buildActionBar(_dateTime);
      });
    });
  }

  void buildActionBar(DateTime dateTime) {
    if(_keys.isNotEmpty) {
      var firstDay = DateFormat(_dayFormat, "fr").format(_keys.first);
      var lastDay = DateFormat(_dayFormat, "fr").format(_keys.last);
      _period = sprintf(_weekFormat, [firstDay, lastDay]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          title(widget.club)
        ),
        actions: const <Widget>[
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).focusColor),
              child: refresher(
                  ListView.builder(
                    itemCount: _keys.length,
                    itemBuilder: _buildItemsForListView,
                    controller: _scrollController,
                  ), () {
                populate(false);
              }),
            ),
            flex: 13,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
                child: Row(
                  children: [
                    Expanded(child:
                      IconButton(
                          onPressed: () {
                            _dateTime = _dateTime.subtract(Duration(days: 7));
                            populate(true);
                            _scrollController.jumpTo(0);
                          },
                          icon: const Icon(Icons.arrow_circle_left_outlined),
                      ),
                      flex: 1,
                    ),
                    Expanded(child:
                      Text(_period,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      flex: 3,
                    ),
                    Expanded(child:
                      IconButton(
                          onPressed: () {
                            _dateTime = _dateTime.add(Duration(days: 7));
                            populate(true);
                            _scrollController.jumpTo(0);
                          },
                          icon: const Icon(Icons.arrow_circle_right_outlined)
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
                child: AdmobBanner(
                  adUnitId: Plateform.adMobBannerId(context),
                  adSize: AdmobBannerSize.BANNER,
                ),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  ListTile _buildItemsForListView(BuildContext context, int index) {
    var date = _keys.elementAt(index);
    var schedules = _days[date];
    var title = DateFormat(_sectionFormat, "fr").format(date);
    var height = (schedules?.length ?? 0) + 1;
    BoxDecoration boxDecoration = Box.boxDecorationColor(HexColor(_schedule?.club?.backgroundColor ?? "#FFFFFF"), 16);
    return ListTile(
      title: Card(
        child: Container(
          height: Constants.CLUB_HEIGHT * height,
          decoration: boxDecoration,
          child:
              Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: dayTitle(title),
                  ),
                  Row(
                    children: [
                      Expanded (
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                for(var schedule in schedules!)
                                  generateSchedule(schedule)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        ),
        elevation: Constants.LIST_ELEVATION,
        margin: const EdgeInsets.all(Constants.LIST_MARGIN),
        shadowColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Expanded logoImage(Club? club) {
    return Expanded(
      child: ClipRect(
        child: CachedNetworkImage(
          imageUrl: club!.image!,
          height: Constants.CLUB_HEIGHT,
          width: Constants.CLUB_HEIGHT,
          fit: BoxFit.contain,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
      flex: 1,
    );
  }

  void buildDays(Schedules? schedule) {
    _days.clear();
    for (var schedule in schedule?.days ?? []) {
      var date = Date.utc(schedule.date) ;
      if(!_days.containsKey(date)) {
        _days[date] = [];
      }
      _days[date]!.add(schedule);
    }
    _keys = _days.keys.toList();
    _keys.sort((a, b) => a.compareTo(b),);
  }

  generateSchedule(Schedule? schedule) {
    switch(schedule?.type) {
      case 'TYPE_SPECIAL':
        return SpecialSchedule(schedule: schedule);
      case 'TYPE_OTHER':
        return OtherSchedule(schedule: schedule);
      case 'TYPE_NORMAL':
      default:
        return SimpleSchedule(schedule: schedule);
    }
  }

  dayTitle(String title) {
    return Column(
      children: [
        Text(title.toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          children: [
            dayHeader(_headerCat),
            dayHeader(_headerIce),
            dayHeader(_headerOffice),
          ],
        )
      ],
    );
  }

  dayHeader(String text) {
    return Expanded (
      child: Container(
        alignment: Alignment.center,
        height: Constants.CLUB_HEIGHT / 2,
        child: Text(
          text,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold,),
        ),
      ),
      flex: 2,
    );
  }

  String title(Club? club) {
    var titleFormat = AppLocalizations.of(context)!.titleFormat;
    return sprintf(titleFormat, [club?.name ?? ""]);
  }
}

class ScheduleItem extends StatelessWidget {
  const ScheduleItem({
    Key? key,
  }) :  super(key: key);
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
  Widget generateLine(String? text, double fontSize, int flex, FontWeight fontWeight) {
      return Expanded(
        child: Container(
          alignment: Alignment.center,
          height: Constants.CLUB_HEIGHT,
          decoration: BoxDecoration(border: Border.all(width: 0.1),),
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0, right: 2.0, bottom: 2.0, left: 2.0, ),
            child: Text(text ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: fontSize, fontWeight: fontWeight,), maxLines: 3, overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        flex: flex,
      );
  }
}

class SimpleSchedule extends ScheduleItem {

  final Schedule? schedule;

  const SimpleSchedule({Key? key, required this.schedule}) : super(key: key);

  // decoration: BoxDecoration(border: Border.all(width: 0.1),),

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.CLUB_HEIGHT,
      alignment: Alignment.center,
      child: Row(
        children: [
          generateLine(schedule?.category, 11, 2, FontWeight.bold),
          generateLine(schedule?.ice, 11, 2, FontWeight.bold),
          generateLine(schedule?.office, 11, 2, FontWeight.normal),
        ],
      ),
    );
  }
}

class SpecialSchedule extends ScheduleItem {

  final Schedule? schedule;

  const SpecialSchedule({Key? key, required this.schedule}) : super(key: key);

  // decoration: BoxDecoration(border: Border.all(width: 0.1),),

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.CLUB_HEIGHT,
      alignment: Alignment.center,
      child: Row(
        children: [
          generateLine(schedule?.special, 13, 6, FontWeight.bold),
        ],
      ),
    );
  }
}

class OtherSchedule extends ScheduleItem {

  final Schedule? schedule;

  const OtherSchedule({Key? key, required this.schedule}) : super(key: key);

  // decoration: BoxDecoration(border: Border.all(width: 0.1),),

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.CLUB_HEIGHT,
      alignment: Alignment.center,
      child: Row(
        children: [
          generateLine(schedule?.category, 11, 2, FontWeight.bold),
          generateLine(schedule?.other, 11, 4, FontWeight.normal),
        ],
      ),
    );
  }
}

class SchedulesList extends StatefulWidget {
  final Club club;
  const SchedulesList({Key? key, required this.club}) : super(key: key);
  @override
  createState() => SchedulesState();
}