import 'package:altruist_secure_flutter/SubScriptionWebPage/UI/subscriptionWePage.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/ui/homeNewScreen/NewHomeDashboard.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

class chatBoxWebView extends StatefulWidget {
  @override
  ChatBoxUrl_ createState() => ChatBoxUrl_();
}

class ChatBoxUrl_ extends State<chatBoxWebView> {

  @override
  void initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    WebViewController _controller;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: ColorConstant.AppBarColor,
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back,color: ColorConstant.TextColor,),
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NewHomeDashBoard(""),
                ))),
        title:_statusText(0),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
        initialUrl: Utils.ChatBoxUrl,
      ),

    );
  }
  Widget _statusText(status) {
    //  print("Splash Status ====== $status");
    if (status == 0) {
      return  Text(
        "Altruist Secure chat box",
        style: TextStyle(
            color:ColorConstant.TextColor,
            fontSize: 15.0,
            fontFamily: 'OpenSans'),
        textAlign: TextAlign.center,
      );
    } else if (status == 1) {
      return  Text(
        "Altruist Secure chat box",
        style: TextStyle(
            color:ColorConstant.TextColor,
            fontSize: 15.0,
            fontFamily: 'OpenSans'),
        textAlign: TextAlign.center,
      );
    } else if (status == 2) {
      return  Text(
        "Noon Secure chat box",
        style: TextStyle(
            color: ColorConstant.TextColor
            ,
            fontSize: 15.0,
            fontFamily: 'OpenSans'),
        textAlign: TextAlign.center,
      );
    }else if (status == 3) {
      return  Text(
        "Airteltigo Secure chat box",
        style: TextStyle(
            color: ColorConstant.TextColor
            ,
            fontSize: 15.0,
            fontFamily: 'OpenSans'),
        textAlign: TextAlign.center,
      );
    }
    else if (status == 4) {
      return  Text(
        "Mansard Secure chat box",
        style: TextStyle(
            color: ColorConstant.TextColor
            ,
            fontSize: 15.0,
            fontFamily: 'OpenSans'),
        textAlign: TextAlign.center,
      );
    }
  }
}
