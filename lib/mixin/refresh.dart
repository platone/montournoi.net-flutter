
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:montournoi_net_flutter/utils/i18n.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

abstract class Refresh {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void startLoading({bool refresh = false}) {
    if(!refresh) {
      EasyLoading.show(status: i18n.loadingLabel);
    }
  }

  void endLoading({bool refresh = false, Exception? error}) {
    EasyLoading.dismiss();
    if(null != error) {
      EasyLoading.showError(error.toString());
    }
    if(refresh) {
      _refreshController.refreshCompleted();
    }
  }

  Widget refresher(Widget widget, VoidCallback? callback) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      controller: _refreshController,
      onRefresh: callback,
      child: widget,
    );
  }
}