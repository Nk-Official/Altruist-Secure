import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:altruist_secure_flutter/ChatBoxWebview/chatBoxWebView.dart';
import 'package:path/path.dart';

class NewHomeDashBoardForm extends StatelessWidget {
  String appBarName = "Dashboard";
  final String customerName;
  final String customerDeviceName;
  final GestureTapCallback onHelpineClick;
  final GestureTapCallback onCallBackRequestClick;
  final GestureTapCallback onUploadInvoiceClick;
  final GestureTapCallback onUploadIdProofClick;
  final GestureTapCallback onSubscriptionPackClick;
  final GestureTapCallback onVerificationCertificateClick;
  final GestureTapCallback onPaymentStatusClick;
  final GestureTapCallback onRaiseClaimClick;
  final GestureTapCallback policyWordingClick;
  final GestureTapCallback onUploadVideoClick;
  final GestureTapCallback profileClick;
  final GestureTapCallback onHelpClick;
  final String subscribedProductName;
  final String subscribedProductExpiry;
  bool mStatusFlag = false;
  bool mInvoicehintFlag = false;
  bool mInvoiceFlag = false;
  bool mIDhintFlag = false;
  bool mIDuploadFlag = false;
  bool mPaymetVisibelFlag = false;
  bool mPackageVisibelFlag = false;
  bool mRaiseClaimVisibelFlag = false;
  bool mRequestCallBackVisibelFlag = false;
  bool mHelpVisibelFlag = false;
  bool policyCertificateVisibelFlag = true;
  bool policyWordingVisibelFlag = true;

  NewHomeDashBoardForm({
    Key key,
    this.customerName,
    this.customerDeviceName,
    this.onRaiseClaimClick,
    this.onVerificationCertificateClick,
    this.onSubscriptionPackClick,
    this.onUploadIdProofClick,
    this.onUploadInvoiceClick,
    this.onCallBackRequestClick,
    this.onHelpineClick,
    this.onUploadVideoClick,
    this.profileClick,
    this.subscribedProductName,
    this.policyWordingClick,
    this.subscribedProductExpiry,
    this.mStatusFlag,
    this.mInvoicehintFlag,
    this.mInvoiceFlag,
    this.mIDhintFlag,
    this.mIDuploadFlag,
    this.onPaymentStatusClick,
    this.mPaymetVisibelFlag,
    this.mPackageVisibelFlag,this.mRaiseClaimVisibelFlag,this.mRequestCallBackVisibelFlag,this.onHelpClick,this.mHelpVisibelFlag,this.policyCertificateVisibelFlag,this.policyWordingVisibelFlag
  }) : super(key: key);

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.black45, //                   <--- border color
        width: 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.transparent,
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            backgroundColor: ColorConstant.AppBarColor,
            title: Text(
              appBarName,
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontSize: 17,
                  color: ColorConstant.TextColor,
                  fontFamily: 'OpenSans'),
            ),
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Column(children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Container(
                margin: new EdgeInsets.symmetric(horizontal: 17.0),
                height: 120.0,
                width: double.infinity,
                color: Colors.transparent,
                child: Container(
                    decoration: BoxDecoration(
                        color: ColorConstant.ActiveDotsColor,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: new EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Container(
                                      width: 45.0,
                                      height: 45.0,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                              'user_profile.png',
                                            ),
                                          ))),
                                ],
                              ),
                            ),
                            Padding(
                                padding: new EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "$customerName",
                                          style: TextStyle(
                                              color: ColorConstant
                                                  .TextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                              fontFamily: 'OpenSans'),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Mobile Model: $customerDeviceName",
                                          style: TextStyle(
                                            color: ColorConstant
                                                .TextColor,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'OpenSans',
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),


//                                    Row(
//                                      children: [
//                                        Text(
//                                          "Sum Insured = 20,000(Naira)",
//                                          style: TextStyle(
//                                            color: ColorConstant
//                                                .HomeHeaderColor,
//                                            fontSize: 12.0,
//                                            fontFamily: 'OpenSans',
//                                          ),
//                                          overflow: TextOverflow.ellipsis,
//                                          softWrap: true,
//                                          textAlign: TextAlign.center,
//                                        ),
//                                      ],
//                                    ),

                                  ],
                                )),
                          ],
                        ),
                        Expanded(
                          child: Visibility( visible: mPackageVisibelFlag,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding:
                                    new EdgeInsets.symmetric(horizontal: 10.0),
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: ColorConstant.AppBarColor,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(5),
                                        bottomLeft: Radius.circular(5))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(subscribedProductName,
                                        style: TextStyle(
                                            color: ColorConstant
                                                .TextColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0,
                                            fontFamily: 'OpenSans'),
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "Expiry Date - $subscribedProductExpiry",
                                        style: TextStyle(
                                          color: ColorConstant
                                              .TextColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0,
                                          fontFamily: 'OpenSans',
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        textAlign: TextAlign.end,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 10,
              ),

              _mPoweredWidget(),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: new EdgeInsets.symmetric(horizontal: 10.0),
                child: Visibility(
                  visible: mStatusFlag,
                  child: Text(
                    //  "To complete your request process and for issusing of certificate",
                    "",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontFamily: 'OpenSans'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(height: 15.0),

              //////////////////// Payment Status /////////////////////
              new GestureDetector(
                onTap: onPaymentStatusClick,
                child: Visibility(
                  visible: mPaymetVisibelFlag,
                  child: Container(
                    height: 80.0,
                    margin: new EdgeInsets.symmetric(horizontal: 17.0),
                    child: new Card(
                      child: Padding(
                        padding: new EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: new EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50.0,
                                            height: 50.0,
                                            child: Image.asset(
                                              'payment_status.png',
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: new EdgeInsets.only(
                                            right: 10, left: 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Payment Status",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 14.0,
                                                      fontFamily: 'OpenSans'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                    color: ColorConstant.ArrowColor,
                                    height: 80,
                                    width: 52,
                                    child: Padding(
                                      padding: new EdgeInsets.all(10),
                                      child: Image.asset(
                                        'action_arrow.png',
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),

              //////////////////// Policy Cetificate/////////////////////
              new GestureDetector(
                onTap: onVerificationCertificateClick,
                child: Visibility(
                  visible: policyCertificateVisibelFlag,
                  child: Container(
                    height: 80.0,
                    margin: new EdgeInsets.symmetric(horizontal: 17.0),
                    child: new Card(
                      child: Padding(
                        padding: new EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: new EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50.0,
                                            height: 50.0,
                                            child: Image.asset(
                                              'view_certificate.png',
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: new EdgeInsets.only(
                                            right: 10, left: 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Policy Certificate",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 14.0,
                                                      fontFamily: 'OpenSans'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                    color: ColorConstant.ArrowColor,
                                    height: 80,
                                    width: 52,
                                    child: Padding(
                                      padding: new EdgeInsets.all(10),
                                      child: Image.asset(
                                        'action_arrow.png',
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              //////////////////// Policy Wording/////////////////////
              new GestureDetector(
                onTap: policyWordingClick,
                child: Visibility(
                  visible: policyWordingVisibelFlag,
                  child: Container(
                    height: 80.0,
                    margin: new EdgeInsets.symmetric(horizontal: 17.0),
                    child: new Card(
                      child: Padding(
                        padding: new EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: new EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50.0,
                                            height: 50.0,
                                            child: Image.asset(
                                              'document.png',
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: new EdgeInsets.only(
                                            right: 10, left: 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Policy Wording",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 14.0,
                                                      fontFamily: 'OpenSans'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                    color: ColorConstant.ArrowColor,
                                    height: 80,
                                    width: 52,
                                    child: Padding(
                                      padding: new EdgeInsets.all(10),
                                      child: Image.asset(
                                        'action_arrow.png',
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              /////////////////////////// Upload Invoice//////////////
              new GestureDetector(
                onTap: onUploadInvoiceClick,
                child: Visibility(
                  visible: true,
                  child: Container(
                    height: 80.0,
                    margin: new EdgeInsets.symmetric(horizontal: 17.0),
                    child: new Card(
                      child: Padding(
                        padding: new EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: new EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50.0,
                                            height: 50.0,
                                            child: Image.asset(
                                              'icons_upload_document.png',
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: new EdgeInsets.only(
                                            right: 10, left: 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Upload Invoice",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 14.0,
                                                      fontFamily: 'OpenSans'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            Visibility(
                                              visible: mInvoicehintFlag,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Please upload invoice",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 11.0,
                                                        fontFamily: 'OpenSans'),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: mInvoiceFlag,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "invoice uploaded",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 11.0,
                                                        fontFamily: 'OpenSans'),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                    color: ColorConstant.ArrowColor,
                                    height: 80,
                                    width: 52,
                                    child: Padding(
                                      padding: new EdgeInsets.all(10),
                                      child: Image.asset(
                                        'action_arrow.png',
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              /////////////////////////// Upload ID Proof//////////////
              new GestureDetector(
                onTap: onUploadIdProofClick,
                child: Visibility(
                  visible: true,
                  child: Container(
                    height: 80.0,
                    margin: new EdgeInsets.symmetric(horizontal: 17.0),
                    child: new Card(
                      child: Padding(
                        padding: new EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: new EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50.0,
                                            height: 50.0,
                                            child: Image.asset(
                                              'icons_upload_document.png',
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: new EdgeInsets.only(
                                            right: 10, left: 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  //  "Upload ID Proof",
                                                  "Upload ID Proof",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 14.0,
                                                      fontFamily: 'OpenSans'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            Visibility(
                                              visible: mIDhintFlag,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Please upload ID proof",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 11.0,
                                                        fontFamily: 'OpenSans'),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: mIDuploadFlag,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "ID Proof uploaded",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 11.0,
                                                        fontFamily: 'OpenSans'),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                    color: ColorConstant.ArrowColor,
                                    height: 80,
                                    width: 52,
                                    child: Padding(
                                      padding: new EdgeInsets.all(10),
                                      child: Image.asset(
                                        'action_arrow.png',
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              /////////////////////////// Profile Management//////////////
              new GestureDetector(
                onTap: profileClick,
                child: Visibility(
                  visible: true,
                  child: Container(
                    height: 80.0,
                    margin: new EdgeInsets.symmetric(horizontal: 17.0),
                    child: new Card(
                      child: Padding(
                        padding: new EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: new EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50.0,
                                            height: 50.0,
                                            child: Image.asset(
                                              'profile_management.png',
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: new EdgeInsets.only(
                                            right: 10, left: 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Profile Management",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 14.0,
                                                      fontFamily: 'OpenSans'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                    color: ColorConstant.ArrowColor,
                                    height: 80,
                                    width: 52,
                                    child: Padding(
                                      padding: new EdgeInsets.all(10),
                                      child: Image.asset(
                                        'action_arrow.png',
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              /////////////////////////// Raise Claim //////////////
              new GestureDetector(
                onTap: onRaiseClaimClick,
                child: Visibility(
                  visible: mRaiseClaimVisibelFlag,
                  child: Container(
                    height: 80.0,
                    margin: new EdgeInsets.symmetric(horizontal: 17.0),
                    child: new Card(
                      child: Padding(
                        padding: new EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: new EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50.0,
                                            height: 50.0,
                                            child: Image.asset(
                                              'raise_a_claim.png',
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: new EdgeInsets.only(
                                            right: 10, left: 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Raise a Claim",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 14.0,
                                                      fontFamily: 'OpenSans'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                    color: ColorConstant.ArrowColor,
                                    height: 80,
                                    width: 52,
                                    child: Padding(
                                      padding: new EdgeInsets.all(10),
                                      child: Image.asset(
                                        'action_arrow.png',
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              /////////////////////////// Request Call Back //////////////
              new GestureDetector(
                onTap: onCallBackRequestClick,
                child: Visibility(
                  visible: mRequestCallBackVisibelFlag,
                  child: Container(
                    height: 80.0,
                    margin: new EdgeInsets.symmetric(horizontal: 17.0),
                    child: new Card(
                      child: Padding(
                        padding: new EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: new EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50.0,
                                            height: 50.0,
                                            child: Image.asset(
                                              'call_back_request.png',
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: new EdgeInsets.only(
                                            right: 10, left: 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Request Call Back",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 14.0,
                                                      fontFamily: 'OpenSans'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                    color: ColorConstant.ArrowColor,
                                    height: 80,
                                    width: 52,
                                    child: Padding(
                                      padding: new EdgeInsets.all(10),
                                      child: Image.asset(
                                        'action_arrow.png',
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              /////////////////////////// HelpLine //////////////
              new GestureDetector(
                onTap: onHelpineClick,
                child: Visibility(
                  visible: false,
                  child: Container(
                    height: 80.0,
                    margin: new EdgeInsets.symmetric(horizontal: 17.0),
                    child: new Card(
                      child: Padding(
                        padding: new EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: new EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50.0,
                                            height: 50.0,
                                            child: Image.asset(
                                              'help_phone.png',
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: new EdgeInsets.only(
                                            right: 10, left: 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Helpline",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 14.0,
                                                      fontFamily: 'OpenSans'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                    color: ColorConstant.ArrowColor,
                                    height: 80,
                                    width: 52,
                                    child: Padding(
                                      padding: new EdgeInsets.all(10),
                                      child: Image.asset(
                                        'action_arrow.png',
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),

              /////////////////////////// Request Call Back //////////////
              new GestureDetector(
                onTap: onHelpClick,
                child: Visibility(
                  visible: mHelpVisibelFlag,
                  child: Container(
                    height: 80.0,
                    margin: new EdgeInsets.symmetric(horizontal: 17.0),
                    child: new Card(
                      child: Padding(
                        padding: new EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: new EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50.0,
                                            height: 50.0,
                                            child: Image.asset(
                                              'call_back_request.png',
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: new EdgeInsets.only(
                                            right: 10, left: 0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Help Line",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 14.0,
                                                      fontFamily: 'OpenSans'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                    color: ColorConstant.ArrowColor,
                                    height: 80,
                                    width: 52,
                                    child: Padding(
                                      padding: new EdgeInsets.all(10),
                                      child: Image.asset(
                                        'action_arrow.png',
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              new Visibility(
                visible: false,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 120.0,
                      height: 100.0,
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(7.0),
                            side: BorderSide(color: Colors.grey)),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Image.asset(
                              'icons_upload_document.png',
                              height: 50,
                              width: 50,
                            ),
                            Flexible(
                                child: Text(
                              "Upload Id Proof",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 11.0,
                              ),
                              textAlign: TextAlign.center,
                            )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
//          floatingActionButton: new FloatingActionButton(
//              elevation: 0.0,
//              child: new Icon(
//                Icons.chat_bubble_outline,
//                color: ColorConstant.TextColor,
//              ),
//              backgroundColor: ColorConstant.ButtonColor,
//              onPressed: () {
//                Navigator.pushReplacement(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => chatBoxWebView(),
//                    ));
//              })
//
    );
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
  Widget _status(status) {
    //  print("Splash Status ====== $status");
    if (status == 0) {
      return Image.asset(
        'altruist_secure_logo.png',
        height: 120,
        width: 80,
      );
    } else if (status == 1) {
      return Image.asset(
        'altruist_logo.png',
        height: 120,
        width: 80,
      );
    } else if (status == 2) {
      return Image.asset(
        'noon_secure_logo.png',
        height: 120,
        width: 80,
      );
    }
  }
}
