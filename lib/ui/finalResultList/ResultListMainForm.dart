import 'package:altruist_secure_flutter/ResultList/Model/resultModel.dart';
import 'package:altruist_secure_flutter/ResultList/UI/result_item_adapter.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flutter/cupertino.dart';

class ResultListMainForm extends StatelessWidget {
  final List<resultBean> assignLsit;
  final GestureTapCallback onContinueClick;
  final GestureTapCallback onContinueClickTestAgin;
  final GestureTapCallback onClickOption1;
  final GestureTapCallback onClickOption2;
  final String score;
  final String rating;
  final String deviceName;
  final String deviceBrand;
  final bool mimeitestStatus;
  final bool buttonoptionvisible;
  final bool buttonContinueVisibility;
  final bool sellVisibilty;
  final bool repairVisibilty;
  final GestureTapCallback onSellNowClick;
  final GestureTapCallback onRepairNowClick;

  ResultListMainForm(
      {Key key,
      this.assignLsit,
      this.onContinueClick,
      this.onContinueClickTestAgin,
      this.score,
      this.rating,
      this.deviceName,
      this.deviceBrand,
      this.mimeitestStatus,
      this.onClickOption1,
      this.onClickOption2,
      this.buttonoptionvisible,
      this.onSellNowClick,
      this.onRepairNowClick,
      this.buttonContinueVisibility,
      this.sellVisibilty,
      this.repairVisibilty})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'Mobile phone health check Result';
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: ColorConstant.AppBarColor,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontSize: 17,
              color: ColorConstant.TextColor,
              fontFamily: 'OpenSans'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          _mPoweredWidget(),
          SizedBox(height: 15),
          GestureDetector(
            onTap: onContinueClickTestAgin,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Image.asset(
                  'assets/refresh.png',
                  height: 20,
                  width: 20,
                ),
                Text(
                  "Test Again",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.lightBlueAccent,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "$rating",
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.lightBlueAccent,
                      ),
                      textAlign: TextAlign.end,
                    ),
//                    Text(
//                      "  $score",
//                      maxLines: 1,
//                      style: TextStyle(
//                        fontSize: 16.0,
//                        color: Colors.black54,
//                      ),
//                      textAlign: TextAlign.end,
//                    ),
                  ],
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "$deviceBrand",
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    Text(
                      "Model: $deviceName",
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    SizedBox(height: 10,),

                    Text(
                      "Please note, the test which has failed, will not be covered under your device protection plan",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Visibility(
            visible: mimeitestStatus,
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
                        "It seems your device your device rating is low and you can’t proceed further for the activation of Altruist secure",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),



//                      SizedBox(
//                        height: 10,
//                      ),
//                      GestureDetector(
//                        onTap: onClickOption1,
//                        child: RichText(
//                          text: TextSpan(
//                            children: <TextSpan>[
//                              TextSpan(
//                                text:
//                                    'Option 1 - Do you want to sell your device. If YES ',
//                                style: TextStyle(
//                                  fontSize: 14,
//                                  color: Colors.black87,
//                                  fontFamily: 'OpenSans',
//                                ),
//                              ),
//                              TextSpan(
//                                text: 'CLICK HERE',
//                                style: TextStyle(
//                                  fontSize: 14,
//                                  color: Colors.lightBlueAccent,
//                                  fontWeight: FontWeight.bold,
//                                  fontFamily: 'OpenSans',
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//
////                        child: Text(
////                            "Option 1 - Do you want to sell your device. If YES CLICK HERE",
////                            style: TextStyle(
////                              fontSize: 14,
////                              color: Colors.black87,
////                              fontFamily: 'OpenSans',
////                            ),
////                          ),
//                      ),
//                      SizedBox(
//                        height: 10,
//                      ),
////                      Text(
////                        "Thanks for showing your interest to pick up your device to sell you device. We will pick up your device from your door step to evaluate and will give you the best price of your device. Our executive will call you soon to assist you further",
////                        style: TextStyle(
////                          fontSize: 15,
////                          color: Colors.black87,
////                          fontFamily: 'OpenSans',
////                        ),
////                      ),
////                      SizedBox(
////                        height: 5,
////                      ),
//                      GestureDetector(
//                        onTap: onClickOption2,
//                        child: RichText(
//                          text: TextSpan(
//                            children: <TextSpan>[
//                              TextSpan(
//                                text:
//                                    'Option 2- Do you want to us to repair/fix your device. If YES ',
//                                style: TextStyle(
//                                  fontSize: 14,
//                                  color: Colors.black87,
//                                  fontFamily: 'OpenSans',
//                                ),
//                              ),
//                              TextSpan(
//                                text: 'CLICK HERE',
//                                style: TextStyle(
//                                  fontSize: 14,
//                                  color: Colors.lightBlueAccent,
//                                  fontWeight: FontWeight.bold,
//                                  fontFamily: 'OpenSans',
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//
////                        child: Text(
////                          "Option 2- Do you want to us to repair/fix your device. If YES CLICK HERE",
////                          style: TextStyle(
////                            fontSize: 14,
////                            color: Colors.black87,
////                            fontFamily: 'OpenSans',
////                          ),
////                        ),
//                      ),

//                      SizedBox(
//                        height: 5,
//                      ),
//                      Text(
//                        "Thanks for showing your interest to pick up your device for the repair. Our executive will call you soon to assist you further ",
//                        style: TextStyle(
//                          fontSize: 15,
//                          color: Colors.black87,
//                          fontFamily: 'OpenSans',
//                        ),
//                      ),

                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          SizedBox(
            height: 15,
          ),

          Expanded(child: _gridView()),

          Visibility(
            visible: buttonContinueVisibility,
            child: Container(
              child: new GestureDetector(
                onTap: onContinueClick,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    // This makes the blue container full width.
                    Flexible(
                      child: Container(
                        color: ColorConstant.ButtonColor,
                        height: 50.0,
                        child: Center(
                          child: Text(
                            " Continue ",
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

//          Visibility(
//            visible: buttonContinueVisibility,
//            child: Container(
//              child: new GestureDetector(
//                onTap: onContinueClick,
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  crossAxisAlignment: CrossAxisAlignment.end,
//                  children: <Widget>[
//                    // This makes the blue container full width.
//                    Flexible(
//                      child: Container(
//                        color: ColorConstant.ButtonColor,
//                        height: 50.0,
//                        child: Center(
//                          child: Text(
//                            " Continue ",
//                            style: TextStyle(
//                              fontSize: 18.0,
//                              color: ColorConstant.TextColor,
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ),
//          ),


          Visibility(
            visible: sellVisibilty,
            child: Container(
              child: new GestureDetector(
                onTap: onSellNowClick,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    // This makes the blue container full width.
                    Flexible(
                      child: Container(
                        color: ColorConstant.ButtonColor,
                        height: 50.0,
                        child: Center(
                          child: Text(
                            " Sell Now ",
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
          Divider(height: 2,color: ColorConstant.TextColor),
          Visibility(
            visible: repairVisibilty,
            child: Container(
              child: new GestureDetector(
                onTap: onRepairNowClick,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    // This makes the blue container full width.
                    Flexible(
                      child: Container(
                        color: ColorConstant.ButtonColor,
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Repair Now",
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

//          Visibility(
//            visible: true,
//         //   visible: buttonoptionvisible,
//            child: new Container(
//              color: ColorConstant.ButtonColor,
//              child: new GestureDetector(
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    // This makes the blue container full width.
//                    GestureDetector(
//                      onTap: onRepairNowClick,
//                      child: Flexible(
//                        child: Container(
//                          height: 50.0,
//                          child: Center(
//                            child: Text(
//                              "Repair Now",
//                              style: TextStyle(
//                                  fontSize: 18.0,
//                                  color: ColorConstant.TextColor,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
////                    Column(
////                      children: [
////                        Divider(
////                          thickness: 5,
////                          height: 50,
////                          color: ColorConstant.TextColor,
////                        )
////                      ],
////                    ),
//                    GestureDetector(
//                      onTap: onRepairNowClick,
//                      child: Flexible(
//                        child: Container(
//                          height: 50.0,
//                          child: Center(
//                            child: Text(
//                              "Repair Now",
//                              style: TextStyle(
//                                  fontSize: 18.0,
//                                  color: ColorConstant.TextColor,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//
////                    GestureDetector(
////                      onTap: onRepairNowClick,
////                      child: Row(
////                        mainAxisAlignment: MainAxisAlignment.end,
////                        crossAxisAlignment: CrossAxisAlignment.end,
////                        children: <Widget>[
////                          // This makes the blue container full width.
////                          Flexible(
////                            child: Container(
////                              color: ColorConstant.ButtonColor,
////                              height: 50.0,
////                              child: Center(
////                                child: Text(
////                                  "Repair Now",
////                                  style: TextStyle(
////                                    fontSize: 18.0,
////                                    color: ColorConstant.TextColor,
////                                  ),
////                                ),
////                              ),
////                            ),
////                          ),
////                        ],
////                      ),
////                    ),
//                  ],
//                ),
//              ),
//            ),
//          )
        ],

    ));
  }

  Widget _mPoweredWidget() {
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.insurance.atpl.altruist_secure_flutter" ||
        PreferenceUtils.getString(Utils.appPackageName) ==
            "com.insurance.altruistSecureFlutter") {
      return Container(
        height: 35,
        width: double.infinity,
        child: Image.asset(
          'powered_by_image.png',
        ),
      );
    } else {
      return Container();
    }
  }


  Widget _gridView() {
    if (assignLsit != null)
      return ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: assignLsit
            .map(
              (Item) => ResultAdapter(item: Item),
            )
            .toList(),
      );
  }
}
