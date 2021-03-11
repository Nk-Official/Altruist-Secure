//import 'package:altruist_secure_flutter/FrontScreen/Adapter/frontItemAdapter.dart';
//import 'package:altruist_secure_flutter/FrontScreen/Model/frontIconModel.dart';
//import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
//import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'dart:io' show Platform;
//
//class FrontScreen extends StatefulWidget {
//  FrontScreenSatate createState() => FrontScreenSatate();
//}
//
//class FrontScreenSatate extends State<FrontScreen> {
//  List<frontIconstBean> itemList;
//  bool mNonBored = true;
//  bool mBordered = true;
//
//  @override
//  void initState() {
//    itemList = _itemList();
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final title = 'Result';
//
//    return Scaffold(
//      resizeToAvoidBottomPadding: false,
//      appBar: AppBar(
//        title: Text(
//          title,
//          textAlign: TextAlign.center,
//          style: new TextStyle(
//              fontSize: 17, color: Colors.white, fontFamily: 'OpenSans'),
//        ),
//      ),
//      body: Column(
//        children: <Widget>[
//          SizedBox(height: 5),
//          Container(height: 80, child: _myListView()),
//          // Expanded(child: _gridView()),
//          SizedBox(height: 5),
//        ],
//      ),
//    );
//  }
//
//  //          Row(
////            mainAxisAlignment: MainAxisAlignment.end,
////            crossAxisAlignment: CrossAxisAlignment.end,
////            children: <Widget>[
////              Text("Test Result",
////                maxLines: 1,
////                style: TextStyle(
////                  fontSize: 15.0,
////                  color: Colors.lightBlueAccent,
////                  fontWeight: FontWeight.bold,
////                ),
////                textAlign: TextAlign.end,
////              ),
////
////              TextField(
////                maxLines: 1,
////                controller: _textController,
////                style: TextStyle(
////                  fontSize: 15.0,
////                  color: Colors.grey,
////                  fontWeight: FontWeight.bold,
////                ),
////                textAlign: TextAlign.end,
////              ),
////            ],
////          ),
//  Widget _gridView() {
//    return ListView(
//      scrollDirection: Axis.horizontal,
//      children: itemList
//          .map(
//            (Item) => FrontIconAdapter(item: Item),
//          )
//          .toList(),
//    );
//  }
//
//  Widget _myListView() {
//    new Expanded(
//        child: new ListView.builder(
//            itemCount: itemList.length,
//            itemBuilder: (BuildContext ctxt, int Index) {
//              return InkWell(
//                child: Column(
//                  children: <Widget>[
//                    Visibility(
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Padding(
//                            padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
//                            child: Container(
//                              width: 60.0,
//                              height: 60.0,
//                              child: Image.asset(
//                                'assets/progresstrue.png',
//                                height: 40,
//                                width: 40,
//                              ),
//                              decoration: new BoxDecoration(
//                                borderRadius: new BorderRadius.all(
//                                    new Radius.circular(70.0)),
//                                border: new Border.all(
//                                  color: Colors.lightBlueAccent,
//                                  width: 2.0,
//                                ),
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
////
////                    Visibility(
////                      child: Column(
////                        crossAxisAlignment: CrossAxisAlignment.center,
////                        children: <Widget>[
////                          Padding(
////                            padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
////                            child: Container(
////                              width: 60.0,
////                              height: 60.0,
////                              child: Image.asset(
////                                _setImaege(Index),
////                                height: 40,
////                                width: 40,
////                              ),
////                              decoration: new BoxDecoration(
////                                borderRadius:
////                                new BorderRadius.all(new Radius.circular(70.0)),
////                                border: new Border.all(
////                                  color: Colors.lightBlueAccent,
////                                  width: 2.0,
////                                ),
////                              ),
////                            ),
////                          ),
////                        ],
////                      ),
////                    ),
//                  ],
//                ),
//              );
//              ;
//            }));
//
////    ListView.builder(
////      itemCount: itemList.length,
////      itemBuilder: (context, position) {
////        return InkWell(
////          onTap: () {
////            Navigator.push(
////              context,
////              MaterialPageRoute(
////                //  builder: (context) => GridItemDetails(this.item),
////              ),
////            );
////          },
////          child: Column(
////            children: <Widget>[
////              Visibility(
////                child: Column(
////                  crossAxisAlignment: CrossAxisAlignment.center,
////                  children: <Widget>[
////                    Padding(
////                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
////                      child: Container(
////                        width: 60.0,
////                        height: 60.0,
////                        child: Image.asset(
////                          _setImaege(),
////                          height: 40,
////                          width: 40,
////                        ),
////                        decoration: new BoxDecoration(
////                          borderRadius:
////                          new BorderRadius.all(new Radius.circular(70.0)),
////                          border: new Border.all(
////                            color: Colors.lightBlueAccent,
////                            width: 2.0,
////                          ),
////                        ),
////                      ),
////                    ),
////                  ],
////                ),
////              ),
////
////              Visibility(
////                child: Column(
////                  crossAxisAlignment: CrossAxisAlignment.center,
////                  children: <Widget>[
////                    Padding(
////                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
////                      child: Container(
////                        width: 60.0,
////                        height: 60.0,
////                        child: Image.asset(
////                          _setImaege(),
////                          height: 40,
////                          width: 40,
////                        ),
////                        decoration: new BoxDecoration(
////                          borderRadius:
////                          new BorderRadius.all(new Radius.circular(70.0)),
////                          border: new Border.all(
////                            color: Colors.lightBlueAccent,
////                            width: 2.0,
////                          ),
////                        ),
////                      ),
////                    ),
////                  ],
////                ),
////              ),
////            ],
////          ),
////        );
////      },
////
////    );
//  }
//
//  Widget mLayout(int position, String titile) {}
//
//  String _setImaege(int position) {
//    String image;
//    if (itemList[position].status == 1) {
//      setState(() {
//        mBordered = true;
//      });
//      var image = itemList[position].imageUrl = 'assets/progresstrue.png';
//    } else {
//      mNonBored = true;
//      image = itemList[position].imageUrl;
//    }
//    print(image);
//    return image;
//  }
//
//  List<frontIconstBean> _itemList() {
//    return [
//      frontIconstBean(
//        id: 1,
//        imageUrl: 'assets/mobile_phone_vibrating_blue.png',
//        testName: 'Display Test ',
//        status: PreferenceUtils.getString(Utils.Display_),
//      ),
//      frontIconstBean(
//        id: 0,
//        imageUrl: 'assets/mobile_phone_vibrating_blue.png',
//        testName: 'Vibration Test ',
//        status: PreferenceUtils.getString(Utils.vibration),
//      ),
//      frontIconstBean(
//        id: 0,
//        imageUrl: 'assets/sim_card_blue.png',
//        testName: 'Sim Test',
//        status: PreferenceUtils.getString(Utils.sim),
//      ),
//      frontIconstBean(
//        id: 0,
//        imageUrl: 'assets/speaker_blue.png',
//        testName: 'Speaker Test',
//        status: PreferenceUtils.getString(Utils.Speaker),
//      ),
//      frontIconstBean(
//        id: 0,
//        imageUrl: 'assets/headphones_blue.png',
//        testName: 'HeadPhone Test',
//        status: PreferenceUtils.getString(Utils.Headphone),
//      ),
//      frontIconstBean(
//        id: 0,
//        imageUrl: 'assets/flash_blue.png',
//        testName: 'Flash Test',
//        status: PreferenceUtils.getString(Utils.Flash),
//      ),
//      frontIconstBean(
//        id: 0,
//        imageUrl: 'assets/camera_blue.png',
//        testName: 'Camera Test',
//        status: PreferenceUtils.getString(Utils.Camera),
//      ),
//      frontIconstBean(
//        id: 0,
//        imageUrl: 'assets/camera_blue.png',
//        testName: 'Front Camera Test',
//        status: PreferenceUtils.getString(Utils.Front_Camera),
//      ),
//      frontIconstBean(
//        id: 0,
//        imageUrl: 'assets/wifi_blue.png',
//        testName: 'Wifi Test',
//        status: PreferenceUtils.getString(Utils.Wifi),
//      ),
//      frontIconstBean(
//        id: 0,
//        imageUrl: 'assets/bluetooth_blue.png',
//        testName: 'Bluetooth Test',
//        status: PreferenceUtils.getString(Utils.Bluetooth),
//      ),
//      frontIconstBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Light Sensor Test',
//        status: PreferenceUtils.getString(Utils.Light_Sensor),
//      ),
//      frontIconstBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Battery Test',
//        status: PreferenceUtils.getString(Utils.Battery_Sensor),
//      ),
//      frontIconstBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Proximity Sensor Test',
//        status: PreferenceUtils.getString(Utils.Proximity_Sensor),
//      ),
//      frontIconstBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Gravity Sensor Test',
//        status: PreferenceUtils.getString(Utils.Gravity_Sensor),
//      ),
//      frontIconstBean(
//        id: 0,
//        imageUrl: 'assets/altruist_logo.png',
//        testName: 'Magnetic Sensor Test',
//        status: PreferenceUtils.getString(Utils.Magnetic_Sensor),
//      ),
//    ];
//  }
//}
