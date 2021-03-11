import 'dart:async';
import 'dart:math';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/bloc.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/custome_info_event.dart';
import 'package:altruist_secure_flutter/blocs/login_process/bloc.dart';
import 'package:altruist_secure_flutter/blocs/login_process/otp_login_process_bloc.dart';
import 'package:altruist_secure_flutter/models/requests/coupenRequest/CoupenRequest.dart';
import 'package:altruist_secure_flutter/ui/homeNewScreen/NewHomeDashboard.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:altruist_secure_flutter/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'VoucherScreenXml.dart';

class VoucherScreenPresenter extends StatefulWidget {
  @override
  _VoucherScreenPresenterState createState() => _VoucherScreenPresenterState();
}

class _VoucherScreenPresenterState extends State<VoucherScreenPresenter> {
  CustomeInfoBloc _bloc;
  GlobalKey<FormState> _formKey;
  TextEditingController _CoupenTextController;

  @override
  void initState() {
    super.initState();
    PreferenceUtils.init();
    _formKey = GlobalKey<FormState>();
    _CoupenTextController = TextEditingController();
    _bloc = CustomeInfoBloc(apisRepository: ApisRepository());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: BlocListener(
        bloc: _bloc,
        listener: (BuildContext context, CustomeInfoState state) {
          if (state is CoupenVerifyStatusState) {
            if (state.isLoading == false && !state.isSuccess) {
             // AppUtils.showSnackBar(context, state.coupenResponse.errorMessage);
              print("Coupen Verify Response  === ${state.coupenResponse}");
              print("Coupen Verify message  === ${state.coupenResponse.statusDescription.errorMessage}");
              _showMyDialog(0,Utils.pin_code,state.coupenResponse.statusDescription.errorMessage);
            } else if (state.isLoading == false && state.isSuccess) {



              print("Coper Verify Response  === ${state.coupenResponse}");
              _showMyDialog(1,Utils.pin_code,"Congratulations! Your handset is secured under Device Protection by AXA Mansard Secure.");
            }
          }
        },
        child: BlocBuilder(
          bloc: _bloc,
          builder: (context, CustomeInfoState state) {
            return ModalProgressHUD(
              color: Colors.black,
              inAsyncCall:
                  state is CoupenVerifyStatusState && state.isLoading != null
                      ? state.isLoading
                      : false,
              child: VoucherScreenXml(
                formKey: _formKey,
                coupenTextController: _CoupenTextController,
                onRegisterClick: () {
                  if (_formKey.currentState.validate()) {
                    var userId =
                        int.parse(PreferenceUtils.getString(Utils.USER_ID));
                    var msdn = (PreferenceUtils.getString(Utils.MSISDN));
                    var Imei = (PreferenceUtils.getString(Utils.IMEI));
                    if (_CoupenTextController.text.length < 10) {
                      mToast(Utils.invalid_voucher_code);
                    } else {
                      var paymentRequest = CoupenRequest(
                          userId: userId,
                          source: StringConstants.SOURCE,
                          msisdn: msdn,
                          coupenCode: _CoupenTextController.text.toString(),
                          imei: Imei);
                      _bloc.add(CoupenRequestStatusEvent(
                          coupenRequest: paymentRequest));
                    }
                    // var Imei = "232323232323232";

                  }
                },
              ),
            );
          },
        ),
    ));
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        break;
      default:
        break;
    }
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  void mIntent() {
    print(PreferenceUtils.getString(Utils.VerificationId));
  }

  Future<void> _showMyDialog(int type,String piCode, String message ) async {
    print("Message in Dialog == $message");
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(piCode),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(Utils.Ok),
              onPressed: () {
                if(type == 1){
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewHomeDashBoard(""),
                        settings: RouteSettings(name: 'NewHomeDashBoard')),
                  );
                }else{
                  Navigator.of(context).pop();
                }

              },
            ),
          ],
        );
      },
    );
  }




}
