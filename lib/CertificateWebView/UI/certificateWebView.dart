
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:simple_pdf_viewer/simple_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';

import 'dart:io' as io;

class CertificateWebViewForm extends StatelessWidget {
  bool mDownloadoption, mEmailoption;
  String viewCerticate;
  final GestureTapCallback onDownloadClick;
  final GestureTapCallback onEmailSendClick;
  final GestureTapCallback onBackPress;

  CertificateWebViewForm({
    Key key,
    this.mDownloadoption,
    this.mEmailoption,
    this.viewCerticate,
    this.onDownloadClick,
    this.onEmailSendClick,
    this.onBackPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onBackPress,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor:ColorConstant.AppBarColor,
            automaticallyImplyLeading: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back,color:  ColorConstant.TextColor,), onPressed: onBackPress),
            title:  Text('Policy Certificate',
              style: TextStyle(
                  color: ColorConstant.TextColor,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans'),
            ),
            actions: <Widget>[
              Visibility(
                visible: mDownloadoption,
                child: IconButton(
                  icon: Icon(
                    Icons.file_download,
                    color:  ColorConstant.TextColor,
                  ),
                  onPressed: onDownloadClick,

//                onPressed:
//                    () {
//                  // do something
//                 // _requestDownload(viewCerticate);
//
//                    },
                ),
              ),
              Visibility(
                  visible: mEmailoption,
                  child: IconButton(
                    icon: Icon(
                      Icons.email,
                      color:  ColorConstant.TextColor,
                    ),
                    onPressed: onEmailSendClick,
//                  onPressed: () {
//                    PreferenceUtils.setString(Utils.EmailFlag,"1");
////                    send();
//                   // _bloc.add(EmailEvent());
//
//                    // do something
//                    // _requestDownload(viewCerticate);
//                  },
                  )),
            ],
          ),
          body: SimplePdfViewerWidget(
            completeCallback: (bool result) {
              print("completeCallback,result:${result}");
            },
            initialUrl: viewCerticate,
          ),
        ));
  }
}
