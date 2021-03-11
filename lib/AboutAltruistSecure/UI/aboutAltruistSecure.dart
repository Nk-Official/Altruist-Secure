import 'package:altruist_secure_flutter/SubScriptionWebPage/UI/subscriptionWePage.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:altruist_secure_flutter/Terma_And_Condoition/UI/Term&ConditionClass.dart';
import 'package:toast/toast.dart';

class AboutAltuistSecure extends StatefulWidget {
  @override
  AboutAltuistSecureState createState() => AboutAltuistSecureState();
}

class AboutAltuistSecureState extends State<AboutAltuistSecure> {
  WebViewController _controller;
  bool isLoading = false;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("About Altruist Secure",
              style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,fontFamily: 'OpenSans'),
          ),
          automaticallyImplyLeading: false,
        ),
        body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: Utils.AboutUsUrl,
//          onWebViewCreated: (WebViewController webViewController) {
//            _controller = webViewController;
//            // _loadHtmlFromAssets();
//            _controller.loadUrl(Utils.AboutUsUrl);
//          },
        ),
        bottomNavigationBar: Container(
            height: 90,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        toggleCheckbox(value);
                      },
                      activeColor: Colors.lightBlueAccent,
                      checkColor: Colors.white,
                      tristate: false,
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TermAndCondition(),
                          ),
                        );
                        },
                      child: Text("Read and accept Terms & Conditions ",
                        style: TextStyle(fontFamily: 'OpenSans'),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(0.0),
                    ),
                    onPressed: () {
                      if (isChecked == false) {
                        mToast("Please accept Terms & Conditions");
                      } else {
                        EventTracker.logEvent("TERMS_CONDITIONS_CONTINUE_CLICK");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Subscription(),
                              settings: RouteSettings(name: 'Subscription')),
                        );
                      }
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

  void toggleCheckbox(bool value) {
    if (isChecked == false) {
      // Put your code here which you want to execute on CheckBox Checked event.
      setState(() {
        isChecked = true;
        //  resultHolder = 'Checkbox is CHECKED';
      });
    } else {
      // Put your code here which you want to execute on CheckBox Un-Checked event.
      setState(() {
        isChecked = false;
        //  resultHolder = 'Checkbox is UN-CHECKED';
      });
    }
  }

  checkboxChecked(bool value) {
    setState(() {});
    print(value);
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }
}
