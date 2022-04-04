
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:montournoi_net_flutter/utils/i18n.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

abstract class Refresh {

  RefreshController refreshController() {
    throw UnimplementedError();
  }

  void startLoading({bool loader = false}) {
    if(loader) {
      EasyLoading.show(status: i18n.loadingLabel);
    }
  }

  void errorLoading(String status) {
    EasyLoading.showError(status);
  }

  void endLoading({bool loader = false, Exception? error}) {
    EasyLoading.dismiss();
    if(null != error) {
      EasyLoading.showError(error.toString());
    }
    refreshController().refreshCompleted();
  }

  Widget refresher(Widget widget, VoidCallback? callback) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      controller: refreshController(),
      onRefresh: callback,
      child: widget,
    );
  }
}