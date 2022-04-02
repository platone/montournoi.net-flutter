import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:montournoi_net_flutter/models/token.dart';
import 'package:montournoi_net_flutter/services/webservice.dart';
import 'package:montournoi_net_flutter/utils/security.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:montournoi_net_flutter/utils/i18n.dart';

class SignUpDialog extends StatefulWidget {
  final Function callback;
  const SignUpDialog({Key? key, required this.callback}) : super(key: key);
  @override
  createState() => _SignUpDialogState();
}

class _SignUpDialogState extends State<SignUpDialog> {

  String? loginValue;

  String? passwordValue;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.formLogintTitle),
      actions: <Widget>[
        TextFormField(
          key: const Key('username'),
          controller: null,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.formLogin,
            suffixIcon: const Icon(Icons.account_circle),
            filled: true,
          ),
          onChanged: (value) {
            setState(() {
              loginValue = value;
            });
          },
        ),
        TextFormField(
          key: const Key('password'),
          controller: null,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.formPassword,
            suffixIcon: const Icon(Icons.password),
            filled: true,
          ),
          onChanged: (value) {
            setState(() {
              passwordValue = value;
            });
          },
          obscureText: true,
        ),
        Row(
          children: [
            Expanded(
                child: DialogButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppLocalizations.of(context)!.eventFormCancelButton,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
              )),
            Expanded(
                child: DialogButton(
                  onPressed: () {
                    if(null != loginValue && null != passwordValue) {
                      EasyLoading.show(status: i18n.loadingLabel);
                      Webservice().post(Token.authenticate(context, loginValue, passwordValue), null).then((token) => {
                        Security.updateToken(token),
                        Security.updateCredentials(loginValue, passwordValue),
                        EasyLoading.dismiss(),
                        Navigator.pop(context),
                        widget.callback(Security.isConnected())
                      }, onError: (error) => {
                        EasyLoading.showError(error.toString())
                      });
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.eventFormValidateButton,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
              )),
          ],
        )
      ],
    );
  }
}