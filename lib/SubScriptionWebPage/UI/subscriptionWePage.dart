import 'dart:async';
import 'dart:developer';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/ui/homeNewScreen/NewHomeDashboard.dart';

import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/cupertino.dart';

class Subscription extends StatefulWidget {
  @override
  SubscriptionState createState() => SubscriptionState();
}

class SubscriptionState extends State<Subscription> {
  WebViewController _controller;
  var SubUrl;
  var SubTempUrl;
  bool mButtonvisibilty = false;
  bool mButtonvisibiltyState = true;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<String> _onUrlChanged;

  @override
  void initState() {
    super.initState();
    PreferenceUtils.init();
//    SubUrl = Utils.SubscriptionUrl +
//        "/{userId}/source/{source}/country/{countryId}/operator/{operatorCode}/lang/{language}?jwtToken";
//    SubTempUrl =
//        'https://ins.liveabuzz.com/altsecure-gw-web/web/subsPlan/240/source/1/country/91/operator/123/lang/en?jwtToken=eyJ0eXBlIjoiSldUIiwia2lkIjoiMTU4NzYyNTE0NDU2NyIsImFsZyI6IlJTNTEyIn0.eyJpc3MiOiJBbHRfU2VjdXJlX1ZhbGlkYXRlX1Rva2VuIiwiZXhwIjoxNjE5MTYxMTI4LCJqdGkiOiJpb0FzNGtMN0wyNG5DcVFIdHdvQ3VnIiwiaWF0IjoxNTg3NjI1MTI4LCJuYmYiOjE1ODc2MjUwMDgsInN1YiI6IjkxOTg3NzM2Njg5NSJ9.TKPh2HEKX4GL_fv8Fp9jhvhXHjs6ivRKD5mMvpW72JqeOi3TJ2J5t3hH4TWa4KISmTxGSdtGKHAVQ018Ag63KvFcZfmGw_s4b2MM1gsNLcVcB4_E7FnM71sOzMtrwO_meAXFiRJsC_3Xy5TF9dqjkYiWhgrKbyOjxHcQ7BQ1jf5xrwOVDy-8pH2BnAExs4-QlJMOvMqAP1TgAL61aQIoqEWGKdIoAPaVaRivYvc_JY3GFMu9uJr5qMHl6NpAwZj8_Se0Fk9FMBIBnOzeQTP7k4XR-bpAfBNvyGqaV7IIEfiqaS-NTllEjHa5b9QD7NMJpy51Qr4FIysu2nzrvX0_sg';

    setState(() {
      mButtonvisibilty = false;
      mButtonvisibiltyState = true;
    });

    var userId = PreferenceUtils.getString(Utils.USER_ID);
    var token = PreferenceUtils.getString(Utils.JWT_TOKEN);
    var countryCode = PreferenceUtils.getString(Utils.COUNTRY_ID);
    SubUrl = Utils.SubscriptionUrl +
        userId +
        "/source/" +
        StringConstants.SOURCE +
        "/country/" +
        countryCode +
        "/operator/" +
        PreferenceUtils.getString(Utils.OPERATORCODE) +
        "/lang/en?jwtToken=" +
        token;
    print('SubScription Url: $SubUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      resizeToAvoidBottomPadding: false,
//      appBar: AppBar(
//        title: Text(" Choose your subscription plan "),
//      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: SubUrl,
        onPageStarted: (url) {
          print('onPageStarted Url: $url');
        },
        onPageFinished: (url) {
          print('onPageFinished Url: $url');
          if (url.toString() ==
              "https://web.altruistsecure.com/web/unauthorize") {
            mButtonvisibilty = false;
            mSetstateFunction(false);
            print('unauthorize method Called');
          }

          if (url.toString() == "https://web.altruistsecure.com/web/error") {
            mButtonvisibilty = false;
            mSetstateFunction(false);
            log('error method Called');
            mStateError();
          }

          if (url.toString() == "https://web.altruistsecure.com/web/pending") {
            mButtonvisibilty = false;
            mSetstateFunction(false);
            log('error method Called');
            mStateError();
          }

          if (url.toString() ==
              "https://web.altruistsecure.com/web/alreadySub") {
            mButtonvisibilty = false;
            mSetstateFunction(true);
            mStateSuccess();
            print('alreadySub method Called');
          }

          if (url.toString() == "https://web.altruistsecure.com/web/success") {
            mButtonvisibilty = false;
            mSetstateFunction(true);
            mStateSuccess();
            print('success method Called');
          }
        },
//          onWebViewCreated: (WebViewController webViewController) {
//            _controller = webViewController;
//            _controller.clearCache();
//            log('Load Url: $SubUrl');
//            _controller.loadUrl(SubUrl);
//          },
      ),
//      bottomNavigationBar: Container(
//          height: 50,
//          child: Column(
//            children: <Widget>[
//              Visibility(
//                visible: mButtonvisibilty,
//                child: Container(
//                  color: Colors.transparent,
//                  width: MediaQuery.of(context).size.width,
//                  height: 40,
//                  child: FlatButton(
//                    shape: new RoundedRectangleBorder(
//                      borderRadius: new BorderRadius.circular(0.0),
//                    ),
//                    onPressed: () {
//                      EventTracker.logEvent("SUBSCRIPTION_CONTINUE_CLICK");
//                      Navigator.pushReplacement(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => NewHomeDashBoard(""),
//                            settings: RouteSettings(name: 'HomeDashBoard')),
//                      );
//                    },
//                    color: ColorConstant.ButtonColor,
//                    child: Text(
//                      Utils.Continue,
//                      style: TextStyle(
//                        color: ColorConstant.TextColor,
//                        fontFamily: 'OpenSans',
//                        fontSize: 16.0,
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            ],
//          )),
    );
  }

  void mSetstateFunction(bool status) {
    setState(() {
      if (status == false) {
     //   mButtonvisibiltyState = true;
      } else {
     //   mButtonvisibiltyState = false;
      }
      //mButtonvisibilty = status;
    });
  }

  void mStateSuccess() {
    Future.delayed(Duration(seconds: 10), () {
      Navigator.pushReplacement(
        this.context,
        MaterialPageRoute(
            builder: (context) => NewHomeDashBoard(""),
            settings: RouteSettings(name: 'HomeDashBoard')),
      );
    });
  }

  void mStateError() {
    Future.delayed(Duration(seconds: 10), () {
      Navigator.pushReplacement(
        this.context,
        MaterialPageRoute(
            builder: (context) => Subscription(),
            settings: RouteSettings(name: 'Subscription')),
      );
    });
  }
}
