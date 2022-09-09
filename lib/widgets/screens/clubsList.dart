import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:montournoi_net_flutter/dialog/signup.dart';
import 'package:montournoi_net_flutter/models/tournament.dart';
import 'package:montournoi_net_flutter/widgets/screens/tournamentScreen.dart';
import 'package:montournoi_net_flutter/utils/constants.dart';
import 'package:montournoi_net_flutter/utils/date.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:montournoi_net_flutter/utils/plateform.dart';
import 'package:montournoi_net_flutter/utils/security.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:montournoi_net_flutter/utils/string.dart';
import '../../models/club.dart';
import '../../models/match.dart';
import '../../utils/counter.dart';
import 'abstractScreen.dart';
import 'scheduleList.dart';
import 'liveScreen.dart';

class ClubsState extends AbstractScreen<ClubList, List<Club>> {

  List<Club> _clubs = List.empty(growable: false);

  final InAppReview inAppReview = InAppReview.instance;

  final ScrollController _scrollController = ScrollController();

  @override
  preData() async {
  }

  @override
  postData() async {
    super.postData();
    if (await Counter.needReview() && await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  @override
  void populate(bool loader) {
    load(loader, this, Club.all(context), (param) {
      setState(() {
        _clubs = param;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.homeClubs),
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
                    itemCount: _clubs.length,
                    itemBuilder: _buildItemsForListView,
                    controller: _scrollController,
                  ), () {
                populate(false);
              }),
            ),
            flex: 7,
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
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
    );
  }

  ListTile _buildItemsForListView(BuildContext context, int index) {
    return ListTile(
      title: Card(
        child: Container(
          height: Constants.CLUB_HEIGHT,
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child:
                InkWell(
                  splashColor: Colors.red.withAlpha(30),
                  onTap: () {
                    _openCalendar(_clubs[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Expanded(
                            child: logoImage(_clubs[index]),
                            flex: 1,
                          ),
                          Expanded(
                            child: Text(_clubs[index].name!,
                              style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold,), maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: IconButton(onPressed: () {_openCalendar(_clubs[index]);}, icon: const Icon(Icons.remove_red_eye_rounded)),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                flex:1,
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

  logoImage(Club? club) {
    String url = club!.image!;
    return ClipRect(
        child: CachedNetworkImage(
          imageUrl: "http:${url}",
          height: Constants.CLUB_HEIGHT,
          width: Constants.CLUB_HEIGHT,
          fit: BoxFit.contain,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
  }

  void _openCalendar(Club club) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SchedulesList(club: club),
      ),
    );
  }
}

class ClubList extends StatefulWidget {
  const ClubList({Key? key}) : super(key: key);
  @override
  createState() => ClubsState();
}