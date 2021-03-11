import 'dart:developer';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/ui/homeNewScreen/NewHomeDashboard.dart';

import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:webview_flutter/webview_flutter.dart';

class RaiseAClaimWebView extends StatefulWidget {
  @override
  RaiseAClaimWebView____ createState() => RaiseAClaimWebView____();
}

class RaiseAClaimWebView____ extends State<RaiseAClaimWebView> {
  String viewCerticate;
  var RaiseaClaim;

  @override
  void initState() {
    super.initState();
    var userId = PreferenceUtils.getString(Utils.USER_ID);
    var token = PreferenceUtils.getString(Utils.JWT_TOKEN);
    RaiseaClaim = Utils.RaiseAclaimUrl + userId + "?" + "jwtToken=" + token;
    log('RaiseaClaim Url: $RaiseaClaim');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewHomeDashBoard(""))),
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.AppBarColor,
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ColorConstant.TextColor,
            ),
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NewHomeDashBoard(""),
                ))),
        title: Text(
          'Raise a claim',
          style: TextStyle(
              color: ColorConstant.TextColor,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans'),
        ),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: RaiseaClaim,
      ),
    ),
    );
  }
}
