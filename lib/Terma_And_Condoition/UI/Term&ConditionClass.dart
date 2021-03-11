import 'dart:math';

import 'package:altruist_secure_flutter/AboutAltruistSecure/UI/aboutAltruistSecure.dart';
import 'package:altruist_secure_flutter/SubScriptionWebPage/UI/subscriptionWePage.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/cupertino.dart';

class TermAndCondition extends StatefulWidget {
  @override
  TermandConditionState createState() => TermandConditionState();
}

class TermandConditionState extends State<TermAndCondition> {
  WebViewController _controller;
  String T_and_C_Url;

  @override
  void initState() {
    var lan = "en";
    var userId = PreferenceUtils.getString(Utils.USER_ID);
    var operatorCode = PreferenceUtils.getString(Utils.OPERATORCODE);
    T_and_C_Url = Utils.TermConditionUrl +"$lan/$userId/$operatorCode";
    print("T_and_C_Url==== $T_and_C_Url");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var checkBoxValue;
    var _isChecked = false;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Altruist Term & Conditions "),
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutAltuistSecure(),
                ))),

      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          // _loadHtmlFromAssets();
          _controller.loadUrl(T_and_C_Url);
        },
      ),
      bottomNavigationBar: Container(
          height: 50,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(0.0),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Subscription(),
                      ),
                    );
                  },
                  color: Colors.lightBlueAccent,
                  child: Text(
                    Utils.Continue,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
