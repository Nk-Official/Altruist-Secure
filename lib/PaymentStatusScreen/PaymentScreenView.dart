import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/ui/homeNewScreen/NewHomeDashboard.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:io' as io;
import 'package:flutter/material.dart';

class PaymentScreenView extends StatelessWidget {
  String Subdate;
  String Lastsubdate;
  String Nextsubdate;
  String Paymentpack;
  String Totalamount;
  String Paidamount;
  String TrancationID;
  String BillPartnerName;
  String PaymentStatus;
  bool clickButtonVisibility;
  GestureTapCallback onUnSubscribe;

  PaymentScreenView({
    Key key,
    this.Subdate,
    this.Lastsubdate,
    this.Nextsubdate,
    this.Paymentpack,
    this.Totalamount,
    this.Paidamount,
    this.TrancationID,
    this.BillPartnerName,
    this.clickButtonVisibility,
    this.onUnSubscribe,
    this.PaymentStatus
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => NewHomeDashBoard(""))),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstant.AppBarColor,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ColorConstant.TextColor),
              onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewHomeDashBoard(""),
                  ))),
          title: Text(
            Utils.PaymentStatus,
            style: TextStyle(
                color: ColorConstant.TextColor,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans'),
          ),
        ),
        body: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Container(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [

              Row(
                children: [
                  Padding(
                      padding: new EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [


                          Row(
                            children: [
                              Text(
                                "Payment Status",
                                style: TextStyle(
                                    color: ColorConstant
                                        .HomeHeaderColorTextBlackColor,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                              PaymentStatus.toString() == null ? "" :  PaymentStatus.toString(),
                                style: TextStyle(
                                    color: ColorConstant
                                        .HomeHeaderColorTextBlackColor,
                                    fontSize: 15.0,
                                    fontFamily: 'OpenSans'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                Utils.SubDate,
                                style: TextStyle(
                                    color: ColorConstant
                                        .HomeHeaderColorTextBlackColor,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                Subdate.toString() == null ? "" :  Subdate.toString(),
                                style: TextStyle(
                                  color: ColorConstant
                                      .HomeHeaderColorTextBlackColor,
                                  fontSize: 15.0,
                                  fontFamily: 'OpenSans',
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                Utils.Lastcha,
                                style: TextStyle(
                                    color: ColorConstant
                                        .HomeHeaderColorTextBlackColor,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(children: [
                            Text(
                              Lastsubdate.toString() == null ? "" :  Lastsubdate.toString(),
                              style: TextStyle(
                                color:
                                    ColorConstant.HomeHeaderColorTextBlackColor,
                                fontSize: 15.0,
                                fontFamily: 'OpenSans',
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          ]),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                Utils.Nextcha,
                                style: TextStyle(
                                    color: ColorConstant
                                        .HomeHeaderColorTextBlackColor,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(children: [
                            Text(
                              Nextsubdate.toString() == null ? "" :  Nextsubdate.toString(),
                              style: TextStyle(
                                color:
                                    ColorConstant.HomeHeaderColorTextBlackColor,
                                fontSize: 15.0,
                                fontFamily: 'OpenSans',
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          ]),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                Utils.Packty,
                                style: TextStyle(
                                    color: ColorConstant
                                        .HomeHeaderColorTextBlackColor,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                Paymentpack,
                                style: TextStyle(
                                  color: ColorConstant
                                      .HomeHeaderColorTextBlackColor,
                                  fontSize: 17.0,
                                  fontFamily: 'OpenSans',
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                Utils.TotalAmm,
                                style: TextStyle(
                                    color: ColorConstant
                                        .HomeHeaderColorTextBlackColor,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                Totalamount == null ? "" : Totalamount,
                                style: TextStyle(
                                  color: ColorConstant
                                      .HomeHeaderColorTextBlackColor,
                                  fontSize: 15.0,
                                  fontFamily: 'OpenSans',
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                Utils.PaidAmm,
                                style: TextStyle(
                                    color: ColorConstant
                                        .HomeHeaderColorTextBlackColor,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                Paidamount == null ? "" : Paidamount,
                                style: TextStyle(
                                  color: ColorConstant
                                      .HomeHeaderColorTextBlackColor,
                                  fontSize: 15.0,
                                  fontFamily: 'OpenSans',
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),


                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                Utils.BillPartnerName,
                                style: TextStyle(
                                    color: ColorConstant
                                        .HomeHeaderColorTextBlackColor,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                BillPartnerName == null ? "" : BillPartnerName,
                                style: TextStyle(
                                  color: ColorConstant
                                      .HomeHeaderColorTextBlackColor,
                                  fontSize: 15.0,
                                  fontFamily: 'OpenSans',
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                Utils.TransactionID,
                                style: TextStyle(
                                    color: ColorConstant
                                        .HomeHeaderColorTextBlackColor,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                TrancationID == null ? "" : TrancationID,
                                style: TextStyle(
                                  color: ColorConstant
                                      .HomeHeaderColorTextBlackColor,
                                  fontSize: 15.0,
                                  fontFamily: 'OpenSans',
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),

                          SizedBox(height: 10.0),
                        ],
                      )),
                ],
              ),
            ],
          )),
          Visibility(
            visible: clickButtonVisibility,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: onUnSubscribe,
                      color: ColorConstant.ButtonColor,
                      textColor: ColorConstant.TextColor,
                      child: Text(Utils.UnSubscribe),
                    ),
                    // This makes the blue container full width.
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
