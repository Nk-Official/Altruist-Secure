import 'package:altruist_secure_flutter/ui/homeNewScreen/NewHomeDashboard.dart';

import 'package:flutter/material.dart';
import 'package:simple_pdf_viewer/simple_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';

class IDProofDisplayImage extends StatefulWidget {
  String imageDisplay;
  IDProofDisplayImage(this.imageDisplay);

  @override
  IDProofDisplayImage_ createState() => IDProofDisplayImage_(imageDisplay);
}

class IDProofDisplayImage_ extends State<IDProofDisplayImage> {
  String imageDisplay;
  IDProofDisplayImage_(this.imageDisplay){
    // print("completeCallback,result:${viewCerticate}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewHomeDashBoard(""),
                    ))),
            title: const Text('Image',style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,fontFamily: 'OpenSans'),),
          ),
          body: Image.network("https://homepages.cae.wisc.edu/~ece533/images/airplane.png",
          ),
          floatingActionButton: new FloatingActionButton(
              elevation: 0.0,
              child: new Icon(Icons.check),
              backgroundColor: new Color(0xFFE57373),
              onPressed: (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewHomeDashBoard("idproof_edit"),
                    ));
              }
          )
    );
  }

}

