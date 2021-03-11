import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

class ApproveImageScreen extends StatelessWidget {
  final bool visiblityImageStatus;
  final bool visibleInvoiceUploadStatus;
  final GestureTapCallback clickUplaodInvoice;
  final GestureTapCallback clickCheckStatus;

  ApproveImageScreen({
    Key key,
    this.visiblityImageStatus,
    this.visibleInvoiceUploadStatus,
    this.clickUplaodInvoice,
    this.clickCheckStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'Invoice Upload Status';
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
              fontFamily: 'Raleway'),
        ),
      ),
      body:  Column(
          children: [
            SizedBox(height: 50,),
            Visibility(
              visible:visibleInvoiceUploadStatus,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              child: Align(
                child: Container(
                  margin: new EdgeInsets.fromLTRB(20,0,20,0),
                  child: SizedBox(

                    width: double.infinity,
                    height: 100,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(3.2),
                      ),
                      color:ColorConstant.ButtonColor,
                      onPressed: clickUplaodInvoice,
                      child: Text(
                        "Upload Invoice",
                        style: new TextStyle(
                            fontSize:22,
                            color: Colors.white,
                            fontFamily: 'Raleway'),
                      ),
                    ),
                  ),

                ),
              ),
            ),

            SizedBox(height: 100,),

            Visibility(
              visible: visiblityImageStatus,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              child: Align(
                child: Container(
                  margin: new EdgeInsets.fromLTRB(20,0,20,0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(3.2),
                      ),
                      color:ColorConstant.ButtonColor,
                      onPressed: clickCheckStatus,
                      child: Text(
                        "Check Status",
                        style: new TextStyle(
                            fontSize:22,
                            color: Colors.white,
                            fontFamily: 'Raleway'),
                      ),
                    ),
                  ),

                ),
              ),
            ),
          ],
      ),
    );
  }
}
