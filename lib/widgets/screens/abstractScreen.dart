
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:montournoi_net_flutter/mixin/refresh.dart';
import 'package:montournoi_net_flutter/utils/i18n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/webservice.dart';

abstract class AbstractScreen<T extends StatefulWidget, E> extends State<T> with Refresh {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => {preData(), loadData(), postData(),});
  }

  preData() async {
  }

  loadData() async {
    populate(false);
  }

  postData() async {
  }

  populate(bool refresh) async {
    throw UnimplementedError();
  }

  @override
  void load(bool refresh, Resource<E> resource, void Function(dynamic param) function) {
    if(refresh) {
      EasyLoading.show(status: i18n.loadingLabel);
    }
    Webservice().load(resource).then((entity) => {
      function(entity),
      if(refresh) {
        EasyLoading.dismiss()
      }
    }, onError: (error) => {
      EasyLoading.showError(error.toString())
    });
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}