
import 'package:flutter/cupertino.dart';
import 'package:montournoi_net_flutter/mixin/refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../services/webservice.dart';
import '../../utils/plateform.dart';

abstract class AbstractScreen<T extends StatefulWidget, E> extends State<T> with Refresh {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => {preData(), loadData(), postData(),});
  }

  preData() async {
  }

  loadData() async {
    populate(true);
  }

  postData() async {
    Plateform.showInterstitial();
  }

  populate(bool loader) async {
    throw UnimplementedError();
  }

  @override
  RefreshController refreshController() {
    return _refreshController;
  }

  void load(bool loader, Refresh refresh,  Resource<E> resource, void Function(dynamic param) function) {
    refresh.startLoading(loader: loader);
    Webservice().load(resource).then((entity) => {
      function(entity),
      refresh.endLoading(loader: loader)
    }, onError: (error) => {
      refresh.errorLoading(error.toString())
    });
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}