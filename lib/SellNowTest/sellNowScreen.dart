import 'package:altruist_secure_flutter/ui/finalResultList/ResultListMain.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SellNowScreen extends StatefulWidget {
  @override
  SellNowScreenState_ createState() => SellNowScreenState_();
}

class SellNowScreenState_ extends State<SellNowScreen> {
  bool mTestVisble = false;
  bool buttonContinueVisibility = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      mTestVisble =false;
      buttonContinueVisibility =true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
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
                  builder: (context) => ResultListMain(),
                ))),
        title: _statusText(0),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Dear Customer, \n\nBased on the diagnosis of your device, we can offer you upto...... \n\nPlease click OK to confirm ",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontFamily: 'OpenSans',
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  Visibility(
                    visible: buttonContinueVisibility,
                    child :Container(
                      child: new GestureDetector(
                        onTap: (){
                          setState(() {
                            mTestVisble =true;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            // This makes the blue container full width.
                            Expanded(
                              child: Container(
                                color: ColorConstant.ButtonColor,
                                height: 40.0,
                                child: Center(
                                  child: Text(
                                    " OK ",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: ColorConstant.TextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  Visibility(
                    visible: mTestVisble ,
                    child:
                    Text(
                      "Thanks for showing your interest. We will pick up the device from your door step to evaluate and will give you the best price for the device. Our executive will call you soon to assist you further",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _statusText(status) {
    //  print("Splash Status ====== $status");
    if (status == 0) {
      return Text(
        "Sell Now",
        style: TextStyle(
          color: ColorConstant.TextColor,
          fontSize: 15.0,
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      );
    } else if (status == 1) {
      return Text(
        "Altruist Secure chat box",
        style: TextStyle(
            color: ColorConstant.TextColor,
            fontSize: 15.0,
            fontFamily: 'OpenSans'),
        textAlign: TextAlign.center,
      );
    } else if (status == 2) {
      return Text(
        "Noon Secure chat box",
        style: TextStyle(
            color: ColorConstant.TextColor,
            fontSize: 15.0,
            fontFamily: 'OpenSans'),
        textAlign: TextAlign.center,
      );
    }
    else if (status == 3) {
      return Text(
        "Airteltigo chat box",
        style: TextStyle(
            color: ColorConstant.TextColor,
            fontSize: 15.0,
            fontFamily: 'OpenSans'),
        textAlign: TextAlign.center,
      );
    } else if (status == 4) {
      return Text(
        "Mansard chat box",
        style: TextStyle(
            color: ColorConstant.TextColor,
            fontSize: 15.0,
            fontFamily: 'OpenSans'),
        textAlign: TextAlign.center,
      );
    }
  }
}
