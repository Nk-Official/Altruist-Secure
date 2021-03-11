import 'package:altruist_secure_flutter/ui/homeNewScreen/NewHomeDashboard.dart';

import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:simple_pdf_viewer/simple_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';

class DisplayUploadIDImageImage extends StatefulWidget {
  String imageDisplay;
  DisplayUploadIDImageImage(this.imageDisplay);

  @override
  DisplayUploadIDImageImageState createState() => DisplayUploadIDImageImageState(imageDisplay);
}

class DisplayUploadIDImageImageState extends State<DisplayUploadIDImageImage> {
  String imageDisplay;
  DisplayUploadIDImageImageState(this.imageDisplay){
    // print("completeCallback,result:${viewCerticate}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back,color: ColorConstant.TextColor,),
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewHomeDashBoard(""),
                    ))),
            title: const Text('Upload ID Image',style: TextStyle(
                color: Colors.white,
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
                      builder: (context) => NewHomeDashBoard("uploadid_edit"),
                    ));
              }
          )

    );
  }

}

