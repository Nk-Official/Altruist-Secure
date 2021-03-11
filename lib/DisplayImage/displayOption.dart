import 'package:altruist_secure_flutter/ui/homeNewScreen/NewHomeDashboard.dart';

import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:simple_pdf_viewer/simple_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';

class DisplayImage extends StatefulWidget {
  String imageDisplay;
  DisplayImage(this.imageDisplay);

  @override
  DisplayImage_ createState() => DisplayImage_(imageDisplay);
}

class DisplayImage_ extends State<DisplayImage> {
  String imageDisplay;
  DisplayImage_(this.imageDisplay){
    // print("completeCallback,result:${viewCerticate}");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewHomeDashBoard(""))),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstant.ButtonColor,
          automaticallyImplyLeading: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,color: ColorConstant.TextColor),
              onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewHomeDashBoard(""),
                  ))),
          title:  Text('Invoice Image',style: TextStyle(
              color: ColorConstant.TextColor,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,fontFamily: 'OpenSans'),),
        ),
        body: Image.network(imageDisplay,),
          floatingActionButton: new FloatingActionButton(
              elevation: 0.0,
              child:Image.asset(
                "assets/edit.png",
              ) ,
              onPressed: (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewHomeDashBoard("invoice_edit"),
                    ));
              }
          )
      ),
    );
  }

}

