import 'dart:io';
import 'dart:math';

import 'package:altruist_secure_flutter/MainClass/mainPresenterClass.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:connectivity/connectivity.dart';
import '../main.dart';

class AppUtils {
  static String DEVICE_TOKEN = "";

  static showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  static showToast(String message, context) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  static isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }

   showAlertDialog(BuildContext context, String type, String mTitle,
      String mDescription, String buttonText) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(buttonText),
      onPressed: () async {
        if (type == "internet_required") {
          bool isNetworkAvailable = await AppUtils.isInternetAvailable();
          String errorMessage = "";
          if (!isNetworkAvailable) {
            errorMessage = StringConstants.INTERNET_ERROR;
            //mToast(errorMessage);
            print(errorMessage);

          //  AppUtils.showAlertDialog(context,"internet_required",Utils.internetRequiredTitle,errorMessage,Utils.Ok);
          } else {
          }
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(mTitle),
      content: Text(mDescription),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

 static Future<bool> checkInternetConectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return false;
    }
    return false;
  }



}
