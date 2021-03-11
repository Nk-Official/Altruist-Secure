import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/ui/homeNewScreen/NewHomeDashboard.dart';

import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:io' as io;
import 'package:flutter/material.dart';

class IDProofView extends StatelessWidget {
  GestureTapCallback buttonUploadFrontID;
  GestureTapCallback buttonUploadFrontIDEdit;
  GestureTapCallback buttonUploadBackID;
  GestureTapCallback buttonUploadBackIDEdit;
  bool buttonVisibilty;
  bool imageVisible;
  bool editImage;
  bool buttonbackVisibilty;
  bool imageVisibleback;
  bool editImageback;
  String FrontImage;
  String BackImage;

  IDProofView({
    Key key,
    this.buttonVisibilty,
    this.imageVisible,
    this.editImage,
    this.buttonbackVisibilty,
    this.imageVisibleback,
    this.editImageback,
    this.buttonUploadFrontID,
    this.buttonUploadFrontIDEdit,
    this.buttonUploadBackID,
    this.buttonUploadBackIDEdit,
    this.FrontImage,
    this.BackImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewHomeDashBoard(""))),
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.AppBarColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back,color: ColorConstant.TextColor),
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NewHomeDashBoard(""),
                ))),
        title: Text(
          Utils.UploadIDProof,
          style: TextStyle(
              color: ColorConstant.TextColor,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans'),
        ),
      ),
      body: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        Expanded(child: Container(
          constraints: new BoxConstraints.expand(),
          alignment: FractionalOffset.center,
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                alignment: FractionalOffset.center,
                height: 30,
                width: double.infinity,
                child: Text(
                  "ID Proof-Front Side",
                  style: new TextStyle(
                      fontSize: 16, color: Colors.black, fontFamily: 'Raleway'),
                ),
              ),

              Stack(
                alignment: FractionalOffset.center,
                children: <Widget>[
                  Container(
                    height: 200,
                    width: 200,
                    child: Visibility(
                        visible: imageVisible,
                        child: Image.network(
                          FrontImage,
                          fit: BoxFit.cover,
                        )
                        //fit: BoxFit.fitWidth,
                        ),
                  ),
                  Visibility(
                    visible: buttonVisibilty,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: new EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          child: RaisedButton(
                            onPressed: buttonUploadFrontID,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(3.2),
                            ),
                            color: ColorConstant.ButtonColor,
//                                onPressed: _getSensorTest,
                            child: Text(
                              Utils.UploadFrontID,
                              style: new TextStyle(
                                  fontSize: 16,
                                  color:ColorConstant.TextColor,
                                  fontFamily: 'Raleway'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: imageVisible,
                      child: Positioned(
                          bottom: 10.0,
                          right: 10.0,
                          child: InkWell(
                            onTap: buttonUploadFrontIDEdit,
                            child: Image.asset(
                              "assets/edit.png",
                              width: 40,
                              height: 40,
                            ),
                          )))
                ],
              )
            ],
          ),
        )),
        Divider(color: Colors.black,),
        Expanded(child: Container(
          constraints: new BoxConstraints.expand(),
          alignment: FractionalOffset.center,
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                alignment: FractionalOffset.center,
                height: 30,
                width: double.infinity,
                child: Text(
                  "ID Proof-Back Side",
                  style: new TextStyle(
                      fontSize: 16, color: Colors.black, fontFamily: 'Raleway'),
                ),
              ),
              SizedBox(height: 20),


              Stack(
                alignment: FractionalOffset.center,
                children: <Widget>[
                  Container(
                    height: 200,
                    width: 200,
                    child:  Visibility(
                        visible: imageVisibleback,
                        child:Image.network(BackImage, fit: BoxFit.cover,))
                  ),
                  Visibility(
                    visible: buttonbackVisibilty,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: new EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          child: RaisedButton(
                            onPressed: buttonUploadBackID,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(3.2),
                            ),
                            color: ColorConstant.ButtonColor,
//                                onPressed: _getSensorTest,
                            child: Text(
                              Utils.UploadBackID,
                              style: new TextStyle(
                                  fontSize: 16,
                                  color: ColorConstant.TextColor,
                                  fontFamily: 'Raleway'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: editImageback,
                      child: Positioned(
                          bottom: 10.0,
                          right: 10.0,
                          child: InkWell(
                            onTap: buttonUploadBackIDEdit,
                            child: Image.asset(
                              "assets/edit.png",
                              width: 40,
                              height: 40,
                            ),
                          )))
                ],
              )

            ],
          ),
        )),
      ]),
      ),
    );

  }
  Widget _BackImage(String BackImage) {
    //  print("Splash Status ====== $status");
    if (BackImage != null) {
      return   Image.network(
        BackImage,
        fit: BoxFit.cover,
      );
    }
  }
}
