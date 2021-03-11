//import 'package:altruist_secure_flutter/RegistrationForm/UI/Registration.dart';
//import 'package:altruist_secure_flutter/ResultList/Model/resultModel.dart';
//import 'package:altruist_secure_flutter/ResultList/UI/result_item_adapter.dart';
//import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
//import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
//import 'package:altruist_secure_flutter/Vibration/UI/vibration_test.dart';
//import 'package:altruist_secure_flutter/ui/registrationProcess/RegistrationProcess.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'dart:io' show Platform;
//
//class ResultList extends StatefulWidget {
//  ResultList__ createState() => ResultList__();
//}
//
//class ResultList__ extends State<ResultList> {
//  List<resultBean> itemList;
//  List<resultBean> itemListIOS;
//  List<resultBean> assignLsit;
//
//  @override
//  void initState() {
//    PreferenceUtils.init();
//    itemList = _itemList();
//    itemListIOS = _itemListIOS();
//    if (Platform.isAndroid) {
//      assignLsit = itemList;
//    } else if (Platform.isIOS) {
//      // iOS-specific code
//      assignLsit = itemListIOS;
//    }
//
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final title = 'Result';
//    final TextEditingController _textController = new TextEditingController();
//    _textController.text = "85/100";
//    return Scaffold(
//      resizeToAvoidBottomPadding: false,
//      appBar: AppBar(
//        title: Text(
//          title,
//          textAlign: TextAlign.center,
//          style: new TextStyle(
//              fontSize: 17, color: Colors.white,  fontFamily: 'OpenSans'),
//        ),
//        automaticallyImplyLeading: false,
//      ),
//      body: Column(
//        mainAxisSize: MainAxisSize.max,
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          SizedBox(height: 15),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.end,
//            children: <Widget>[
//
//              GestureDetector(
//                onTap: mIntentTestAgain,
//                child:  Image.asset(
//                  'assets/refresh.png',
//                  height: 20,
//                  width: 20,
//                ),
//              ),
//
//
//                 Text(
//                  "Test Again",
//                  maxLines: 1,
//                  style: TextStyle(
//                    fontSize: 16.0,
//                    color: Colors.lightBlueAccent,
//                      fontFamily: 'OpenSans',
//                  ),
//                  textAlign: TextAlign.end,
//                ),
//
//
//            ],
//          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.end,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              new Padding(
//                padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
//                child: Row(
//                  children: <Widget>[
//                    Text(
//                      "Rating",
//                      maxLines: 1,
//                      style: TextStyle(
//                        fontSize: 16.0,
//                        color: Colors.lightBlueAccent,
//                          fontFamily: 'OpenSans',
//                      ),
//                      textAlign: TextAlign.end,
//                    ),
//                    Text(
//                      "  85/100",
//                      maxLines: 1,
//                      style: TextStyle(
//                        fontSize: 16.0,
//                        color: Colors.black54,
//                          fontFamily: 'OpenSans',
//                      ),
//                      textAlign: TextAlign.end,
//                    ),
//                  ],
//                ),
//              )
//            ],
//          ),
//          Column(
//            children: <Widget>[
//              new Padding(
//                padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
//                child: Column(
//                  children: <Widget>[
//                    Text(
//                      "Device Name",
//                      maxLines: 1,
//                      style: TextStyle(
//                        fontSize: 12.0,
//                        color: Colors.grey,
//                          fontFamily: 'OpenSans',
//                      ),
//                      textAlign: TextAlign.start,
//                    ),
//                    Text(
//                      "by Brand Name",
//                      maxLines: 1,
//                      style: TextStyle(
//                        fontSize: 12.0,
//                        color: Colors.lightBlueAccent,
//                          fontFamily: 'OpenSans',
//                      ),
//                      textAlign: TextAlign.start,
//                    ),
//                  ],
//                ),
//              )
//            ],
//          ),
//          Expanded(child: _gridView()),
//          new Container(
//            child: new GestureDetector(
//              onTap: () {
//                Navigator.pushReplacement(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) => RegistrationProcess("","","",""),
////                    builder: (context) => Registration(),
//                  ),
//                );
//              },
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                crossAxisAlignment: CrossAxisAlignment.end,
//                children: <Widget>[
//                  // This makes the blue container full width.
//                  Expanded(
//                    child: Container(
//                      color: Colors.blueAccent,
//                      height: 50.0,
//                      child: Center(
//                        child: Text(
//                          " Continue ",
//                          style: TextStyle(
//                            fontSize: 18.0,
//                            color: Colors.white,
//                              fontFamily: 'OpenSans',
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  Widget _gridView() {
//    return ListView(
//      shrinkWrap: true,
//      scrollDirection: Axis.vertical,
//      children: assignLsit
//          .map(
//            (Item) => ResultAdapter(item: Item),
//          )
//          .toList(),
//    );
//  }
//
//  List<resultBean> _itemList() {
//    return [
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/mobile_phone_vibrating_blue.png',
//        testName: 'Display Test ',
//        status: PreferenceUtils.getString(Utils.Display_),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/mobile_phone_vibrating_blue.png',
//        testName: 'Vibration Test ',
//        status: PreferenceUtils.getString(Utils.vibration),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/sim_card_blue.png',
//        testName: 'Sim Test',
//        status: PreferenceUtils.getString(Utils.sim),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/speaker_blue.png',
//        testName: 'Speaker Test',
//        status: PreferenceUtils.getString(Utils.Speaker),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/headphones_blue.png',
//        testName: 'HeadPhone Test',
//        status: PreferenceUtils.getString(Utils.Headphone),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/flash_blue.png',
//        testName: 'Flash Test',
//        status: PreferenceUtils.getString(Utils.Flash),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/camera_blue.png',
//        testName: 'Camera Test',
//        status: PreferenceUtils.getString(Utils.Camera),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/camera_blue.png',
//        testName: 'Front Camera Test',
//        status: PreferenceUtils.getString(Utils.Front_Camera),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/wifi_blue.png',
//        testName: 'Wifi Test',
//        status: PreferenceUtils.getString(Utils.Wifi),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/bluetooth_blue.png',
//        testName: 'Bluetooth Test',
//        status: PreferenceUtils.getString(Utils.Bluetooth),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Light Sensor Test',
//        status: PreferenceUtils.getString(Utils.Light_Sensor),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Battery Test',
//        status: PreferenceUtils.getString(Utils.Battery_Sensor),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Proximity Sensor Test',
//        status: PreferenceUtils.getString(Utils.Proximity_Sensor),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Gravity Sensor Test',
//        status: PreferenceUtils.getString(Utils.Gravity_Sensor),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Magnetic Sensor Test',
//        status: PreferenceUtils.getString(Utils.Magnetic_Sensor),
//      ),
//    ];
//  }
//
//  List<resultBean> _itemListIOS() {
//    return [
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/mobile_phone_vibrating_blue.png',
//        testName: 'Vibration Test ',
//        status: PreferenceUtils.getString(Utils.vibration),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/sim_card_blue.png',
//        testName: 'Sim Test',
//        status: PreferenceUtils.getString(Utils.sim),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/speaker_blue.png',
//        testName: 'Speaker Test',
//        status: PreferenceUtils.getString(Utils.Speaker),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/headphones_blue.png',
//        testName: 'HeadPhone Test',
//        status: PreferenceUtils.getString(Utils.Headphone),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/flash_blue.png',
//        testName: 'Flash Test',
//        status: PreferenceUtils.getString(Utils.Flash),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/camera_blue.png',
//        testName: 'Camera Test',
//        status: PreferenceUtils.getString(Utils.Camera),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/camera_blue.png',
//        testName: 'Front Camera Test',
//        status: PreferenceUtils.getString(Utils.Front_Camera),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/wifi_blue.png',
//        testName: 'Wifi Test',
//        status: PreferenceUtils.getString(Utils.Wifi),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/bluetooth_blue.png',
//        testName: 'Bluetooth Test',
//        status: PreferenceUtils.getString(Utils.Bluetooth),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Battery Test',
//        status: PreferenceUtils.getString(Utils.Battery_Sensor),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Proximity Sensor Test',
//        status: PreferenceUtils.getString(Utils.Proximity_Sensor),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Gravity Sensor Test',
//        status: PreferenceUtils.getString(Utils.Gravity_Sensor),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Magnetic Sensor Test',
//        status: PreferenceUtils.getString(Utils.Magnetic_Sensor),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Accelerometer Sensor Test',
//        status: PreferenceUtils.getString(Utils.Accelerometer_Sensor),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Location Sensor Test',
//        status: PreferenceUtils.getString(Utils.Location_Sensor),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Barometer Sensor Test',
//        status: PreferenceUtils.getString(Utils.Barometer_Sensor),
//      ),
//      resultBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Fringerprint Sensor Test',
//        status: PreferenceUtils.getString(Utils.Fringerprint_Sensor),
//      ),
//    ];
//  }
//
//
//  void mIntentTestAgain() {
//    Navigator.pushReplacement(
//      context,
//      MaterialPageRoute(
//          builder: (context) => VibrationTest(),
//          settings: RouteSettings(name: 'Vibration')),
//    );
//  }
//}
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: "Mon app",
//      home: Scaffold(
//        resizeToAvoidBottomPadding: false,
//        appBar: AppBar(title: Text("My app")),
//        body: Column(
//          mainAxisSize: MainAxisSize.max,
//          children: <Widget>[
////            Expanded(
////              child:
////            ),
//            Row(
//              children: <Widget>[
//                Expanded(
//                  child: TextField(
//                    decoration: InputDecoration(hintText: "What to do?"),
//                  ),
//                ),
//                IconButton(
//                  icon: Icon(Icons.send),
//                  onPressed: () {
//                    //do something
//                  },
//                )
//              ],
//            )
//          ],
//        ),
//      ),
//    );
//  }
//}
