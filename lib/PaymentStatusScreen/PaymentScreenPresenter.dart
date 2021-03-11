import 'dart:io';
import 'dart:math';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/custome_info_bloc.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/custome_info_event.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/custome_info_state.dart';
import 'package:altruist_secure_flutter/models/requests/PaymentRequest/PaymentRequest.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:sweetalert/sweetalert.dart';
import 'PaymentScreenView.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class PaymentScreenPresenter extends StatefulWidget {
  @override
  PaymentScreenPresenterState createState() => PaymentScreenPresenterState();
}

class PaymentScreenPresenterState extends State<PaymentScreenPresenter> {
  CustomeInfoBloc _bloc;
  bool isLoadingProgress = false;
  bool buttonVisibilty_ = false;
  bool buttonbackVisibilty_ = false;
  bool imageVisibleback_ = false;
  bool editImageback_ = false;
  String FrontImage_ = "";
  String BackImage_ = "";
  GlobalKey<FormState> _formKey;
  String SubscriptionDate;
  String LastChargeDate;
  String NextChargeDate;
  String PackTypeDate;
  String TotalAmount;
  String PaidAmount;
  String TransactionID;
  String BillPartnerName;
  String PaymentStatus_;

  @override
  void initState() {
    PreferenceUtils.init();
    _bloc = CustomeInfoBloc(apisRepository: ApisRepository());
    SubscriptionDate = "";
    LastChargeDate = "";
    NextChargeDate = "";
    PackTypeDate = "";
    TotalAmount = "";
    PaidAmount = "";
    var userId = (PreferenceUtils.getString(Utils.USER_ID));
    var msdn = (PreferenceUtils.getString(Utils.MSISDN));
    var paymentRequest = PaymentRequest(userId: userId, msisdn: msdn);
    _bloc.add(PaymentStatusEvent(paymentRequest: paymentRequest));
    super.initState();
  }

  Future<String> dateReturn(String date) async {
    String Date_ = date;
    print("Before Parse === $date");
    DateTime todayDate =
        DateTime.fromMillisecondsSinceEpoch((int.parse(Date_)) * 1000);
    Date_ = formatDate(todayDate, [dd, '-', mm, '-', yyyy]);
    print("After Parse === $date");
    return Date_;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: BlocListener(
        bloc: _bloc,
        listener: (BuildContext context, CustomeInfoState state) {
          if (state is PaymentStatusState) {
            print("Payment SubscriptionDate ${state.SubscriptionDate}");
            print("Payment NextChargeDate ${state.NextChargeDate}");
            //    _unSubSuccessPop();
            if (state.isLoading == false && !state.isSuccess) {
              //  AppUtils.showSnackBar(context, state.message);
            } else if (state.isLoading == false && state.isSuccess) {
              if (state.SubscriptionDate =='null') {
                SubscriptionDate = "";
                print("if called");

              } else {
                print("else called");
                DateTime todayDate = DateTime.fromMillisecondsSinceEpoch(
                    (int.parse(state.SubscriptionDate)) * 1000);
                print("todayDate ${todayDate}");

                var date = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(state.SubscriptionDate));
                var formattedDate = DateFormat.yMMMd().format(date);
                print("formattedDate ${formattedDate}");

                SubscriptionDate = (formattedDate);

                //    SubscriptionDate =(await dateReturn( state.SubscriptionDate.toString())) as int  ;
                print(SubscriptionDate);
              }

              if (state.LastChargeDate =='null') {
                LastChargeDate = "";
              } else {
                var date_ = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(state.LastChargeDate));
                var formattedDate_ = DateFormat.yMMMd().format(date_);
                print("formattedDate ${formattedDate_}");
                LastChargeDate = (formattedDate_);

                var date__ = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(state.NextChargeDate));
                var formattedDate__ = DateFormat.yMMMd().format(date__);
                print("formattedDate ${formattedDate__}");

                NextChargeDate = ((formattedDate__));
              }

              PackTypeDate = state.PackTypeDate;
              TotalAmount = state.TotalAmount;
              PaidAmount = state.PaidAmount;
              TransactionID = state.TransactionID;
              BillPartnerName = state.BillPartnerName;
              if (state.PaymentStatus != null && state.PaymentStatus == "5") {
                PaymentStatus_ = "Payment in process";
              } else if (state.PaymentStatus != null &&
                  state.PaymentStatus == "1") {
                PaymentStatus_ = "Payment complete";
              }
              setState(() {});
            }
          }
          if (state is UnSubscribeState) {
            print(
                "Payment UnSub Response ${state.unSubscriptionResponse.statusDescription.errorCode}");
            print(
                "Payment UnSub Response ${state.unSubscriptionResponse.statusDescription.toJson().toString()}");
            if (state.unSubscriptionResponse.statusDescription.errorCode ==
                200) {
              PreferenceUtils.mClearPre();
              mToast(Utils.UnSubscribeText);
              Future.delayed(const Duration(seconds: 2), () async {
                if (Platform.isAndroid) {
                  SystemChannels.platform
                      .invokeMethod<void>('SystemNavigator.pop');
                } else if (Platform.isIOS) {
                  _unSubSuccessPop();
                }
              });
            } else {
              mToast(
                  state.unSubscriptionResponse.statusDescription.errorMessage);
            }
          }
        },
        child: BlocBuilder(
          bloc: _bloc,
          builder: (context, CustomeInfoState state) {
            if (state is InitialuploadIDProofState) {
              if (state.isLoading) {
                isLoadingProgress = state.isLoading;
              } else {
                isLoadingProgress = false;
              }
            }
            if (state is UnSubscribeState) {
              if (state.isLoading) {
                isLoadingProgress = state.isLoading;
              } else {
                isLoadingProgress = false;
              }
            }
            return ModalProgressHUD(
              color: Colors.black,
              inAsyncCall: isLoadingProgress,
              child: PaymentScreenView(
                key: _formKey,
                Subdate: SubscriptionDate,
                Lastsubdate: LastChargeDate,
                Nextsubdate: NextChargeDate,
                Paymentpack: PackTypeDate,
                Totalamount: TotalAmount,
                Paidamount: PaidAmount,
                BillPartnerName: BillPartnerName,
                TrancationID: TransactionID,
                PaymentStatus: PaymentStatus_,
                clickButtonVisibility: true,
                onUnSubscribe: () {
                  _unSubPop();
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void mDialogSuccess(String title, String Discription) {
    SweetAlert.show(context,
        title: title, subtitle: Discription, style: SweetAlertStyle.success);
  }
  String isEmpty(String string) {
    if (string == 'null') {
      print("if called");
    } else {
      print("else  called");
    }

  }
  Future _SubScriptionDate(String date) async {
    if (date == 'null') {
      print("if called");
    } else {
      print("else  called");
    }
  }

  /////// Custom Dialog///////
  Future<bool> _unSubPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to UnSubscribe?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  mUnSubApi();
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<bool> mUnSubDailog_() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            content: new Text(Utils.UnSubscribeText),
            actions: <Widget>[
              new FlatButton(),
              new FlatButton(),
            ],
          ),
        )) ??
        false;
  }

  void mUnSubApi() {
    String UnSubUrl = Utils.UnSubUrl_ +
        (PreferenceUtils.getString(Utils.USER_ID)) +
        "/sourceId/" +
        StringConstants.SOURCE;
    _bloc.add(UnSubscriptionEvent(url: UnSubUrl));
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  Future _unSubSuccessPop() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {},
          child: Dialog(
            backgroundColor: Colors.white,
            insetAnimationDuration: const Duration(milliseconds: 100),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              // use container to change width and height
              height: 200,
              width: 200,
              child: Column(
                children: <Widget>[
                  FlatButton(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        Utils.UnSubscribeText,
                        style: TextStyle(
                          color: ColorConstant.SponserTextColor,
                          fontFamily: 'OpenSans',
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
