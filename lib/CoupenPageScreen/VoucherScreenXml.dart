import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';

class VoucherScreenXml extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String appBarName = "OTP Verification";
  final TextEditingController coupenTextController;
  final GestureTapCallback onRegisterClick;
  final GlobalKey<FormState> formKey;

  VoucherScreenXml({
    Key key,
    this.formKey,
    this.coupenTextController,
    this.onRegisterClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: ColorConstant.AppBarColor,
        title: Text(
          "Pin Code",
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontSize: 17,
              color: ColorConstant.TextColor,
              fontFamily: 'OpenSans'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Padding(
          padding: EdgeInsets.all(20.0),
//                  child: Card(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  elevation: 5,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            maxLength: 10,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.phone,
                            controller: coupenTextController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter OTP';
                              }
                              return null;
                            },
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontFamily: 'OpenSans'),
                            decoration: InputDecoration(
                              hintText: 'Please enter pin code',
                              labelText: 'Pin Code *',
                              labelStyle: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'OpenSans'),
                              contentPadding:
                                  new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                 enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  "Provided to you by",
                  style: new TextStyle(
                      fontSize: 17, color: Colors.black, fontFamily: 'Raleway'),
                ),
                SizedBox(height: 10),
                Text(
                  "AXA Mansard Insurance Plc.",
                  style: new TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  onPressed: onRegisterClick,
                  color: ColorConstant.ButtonColor,
                  textColor: ColorConstant.TextColor,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
//                  ),
        )),
      ),
    );
  }
}
