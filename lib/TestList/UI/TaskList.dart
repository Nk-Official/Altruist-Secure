import 'package:altruist_secure_flutter/Camera/UI/camera_test.dart';
import 'package:altruist_secure_flutter/CoupenPageScreen/VoucherScreenPresenter.dart';
import 'package:altruist_secure_flutter/FrontCamera/UI/frontCamera.dart';
import 'package:altruist_secure_flutter/ScreenGlassTest/screenglasstest.dart';
import 'package:altruist_secure_flutter/TestList/Model/Item.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/Vibration/UI/vibration_test.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ItemList.dart';
import 'package:permission_handler/permission_handler.dart';

class ListTest extends StatefulWidget {
  @override
  _ListTestState createState() => _ListTestState();
}

class _ListTestState extends State<ListTest> {
  var result;
  List<Item> itemList;
  PermissionStatus permission;
  PermissionStatus permission_;
  static const platform =
      const MethodChannel('samples.flutter.dev/battery/vibration_test');

  @override
  void initState() {
    super.initState();
    // _showMaterialDialog();
    getPermissionStatus();
    videoPermission();
    // _getSimtest();
//    if (result[PermissionGroup.contacts] == PermissionStatus.granted) {
//      // permission was granted
//    }else{
//      mPermissions();
//    }
    if (permission_ == PermissionStatus.granted) {
      print("Video Permission Granted");
    }
  }

  void getPermissionStatus() async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    if (permission == PermissionStatus.granted) {
      print("Camera Permission Granted");
      videoPermission();
    } // ideally you should specify another condition if permissions is denied
    else if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.disabled ||
        permission == PermissionStatus.restricted) {
      await PermissionHandler().requestPermissions([PermissionGroup.camera]);
      print("Camera Permission Denied");
      getPermissionStatus();
    }
  }

  void videoPermission() async {
    PermissionStatus permission_ = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.microphone);
    if (permission_ == PermissionStatus.granted) {
      print("Video Permission Granted");

      var PackageName = PreferenceUtils.getString(Utils.appPackageName);
      if (PackageName == "com.app.altruists_secure_bangla".trim() ||
          PackageName == "com.app.altruists-secure-bangla".trim()) {
      } else if (PackageName ==
              "com.insurance.atpl.altruist_secure_flutter".trim() ||
          PackageName == "com.insurance.altruistSecureFlutter".trim()) {
      } else {
        _getSimtest();
      }
    } // ideally you should specify another condition if permissions is denied
    else if (permission_ == PermissionStatus.denied ||
        permission_ == PermissionStatus.disabled ||
        permission_ == PermissionStatus.restricted) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.microphone]);
      print("Video Permission Denied");
      videoPermission();
    }
  }

  Future<void> _getSimtest() async {
    try {
      //  platform.setMethodCallHandler(_handleCallback);
      var result = await platform.invokeMethod('overlay_setting');
      // print(result);
    } on PlatformException catch (e) {}
  }

  Future<dynamic> _handleCallback(MethodCall call) async {
    switch (call.method) {
      case "overlay_setting":
        print(call.arguments);
    }
  }

  @override
  Widget build(BuildContext context) {
    itemList = _itemList();
    final title = 'Mobile Phone Health Check';
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
              fontFamily: 'OpenSans'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.all(15),
            child: _statusText(),
          ),
          SizedBox(
            height: 10,
          ),
          _mPoweredWidget(),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: new GestureDetector(
              child: Row(
                children: <Widget>[
                  // This makes the blue container full width.
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                    child: Text(
                      "We will check the following:",
                      textAlign: TextAlign.start,
                      style: new TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'OpenSans'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _gridView(),
          SizedBox(
            height: 25,
          ),
          mVoidWidget(),


        ],
      ),
      bottomNavigationBar: Container(
          height: 50,
          child: Column(
            children: <Widget>[
             Container(
                  child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: ColorConstant.ButtonColor,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VibrationTest(),
                              settings: RouteSettings(name: 'VibrationTest')),
                        );
                      },
                      child: Text(
                        "Continue",
                        style: new TextStyle(
                            fontSize: 16,
                            color: ColorConstant.TextColor,
                            fontFamily: 'Raleway'),
                      ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _mPoweredWidget() {
    if (PreferenceUtils.getString(Utils.appPackageName) ==
            "com.insurance.atpl.altruist_secure_flutter" ||
        PreferenceUtils.getString(Utils.appPackageName) ==
            "com.insurance.altruistSecureFlutter") {
      return Container(
        height: 35,
        width: double.infinity,
        child: Image.asset(
          'powered_by_image.png',
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _statusText() {
    //  print("Splash Status ====== $status");

    if (PreferenceUtils.getString(Utils.appPackageName) ==
            "com.insurance.atpl.altruist_secure_flutter" ||
        PreferenceUtils.getString(Utils.appPackageName) ==
            "com.insurance.altruistSecureFlutter") {
      return Text(
        "MTN Device Insurance can only be provided based on your mobile phone's current health. To verify your mobile phone's health, we will run a health check-up process now. Please follow the instructions to complete it.",
        style: TextStyle(
          fontFamily: 'OpenSans',
          color: Colors.black,
          fontSize: 14.0,
        ),
      );
//
    } else if (PreferenceUtils.getString(Utils.appPackageName) ==
            "com.r3factory" ||
        PreferenceUtils.getString(Utils.appPackageName) ==
            "com.insurance.altruistSecureR3") {
      return Text(
        "Altruist Secure R3-F can only be provided based on your mobile phone's current health. To verify your mobile phone's health, we will run a health check-up process now. Please follow the instructions to complete it.",
        style: TextStyle(
          fontFamily: 'OpenSans',
          color: Colors.black,
          fontSize: 14.0,
        ),
      );
    } else if (PreferenceUtils.getString(Utils.appPackageName) ==
            "com.app.noon_secure" ||
        PreferenceUtils.getString(Utils.appPackageName) ==
            "com.insurance.noonSecure") {
      return Text(
        "Noon Secure can only be provided based on your mobile phone's current health. To verify your mobile phone's health, we will run a health check-up process now. Please follow the instructions to complete it.",
        style: TextStyle(
          fontFamily: 'OpenSans',
          color: Colors.black,
          fontSize: 14.0,
        ),
      );
    } else if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.airtel_tigo_secure") {
      return Text(
        "Airteltigo Secure can only be provided based on your mobile phone's current health. To verify your mobile phone's health, we will run a health check-up process now. Please follow the instructions to complete it.",
        style: TextStyle(
          fontFamily: 'OpenSans',
          color: Colors.black,
          fontSize: 14.0,
        ),
      );
    } else if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      return Text(
        "Device Protection by AXA Mansard can only be provided based on your mobile phone's current health. To verify your mobile phone's health, we will run a health check-up process now. Please follow the instructions to complete it.",
        style: TextStyle(
          fontFamily: 'OpenSans',
          color: Colors.black,
          fontSize: 14.0,
        ),
      );
    } else if (PreferenceUtils.getString(Utils.appPackageName) ==
            "com.app.altruists_secure_bangla" ||
        PreferenceUtils.getString(Utils.appPackageName) ==
            "com.app.altruists-secure-bangla") {
      return Text(
        "Altruist Secure can only be provided based on your mobile phone's current health. To verify your mobile phone's health, we will run a health check-up process now. Please follow the instructions to complete it.",
        style: TextStyle(
          fontFamily: 'OpenSans',
          color: Colors.black,
          fontSize: 14.0,
        ),
      );
    }
  }

  mVoidWidget() {
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      return Container(
        margin: const EdgeInsets.all(15),
      );
    } else {
      return Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "Tip:",
                    style: new TextStyle(
                      fontFamily: 'OpenSans',
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Flexible(
                    child: Text(
                      " Keep your earphone handy for the test.",
                      style: new TextStyle(
                        fontFamily: 'OpenSans',
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Your mobile health should be atleast 85% or above to onboard successfully",
                style: new TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 15,
                  color: Colors.black,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ));
    }
  }

  Widget _gridView() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(2.0),
      children: itemList
          .map(
            (Item) => ItemList(item: Item),
          )
          .toList(),
    );
  }

  List<Item> _itemList() {
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      return [
        Item(
          id: 0,
          imageUrl: 'assets/camera_blue.png',
          testName: 'Front Camera',
        ),
        Item(
          id: 0,
          imageUrl: 'assets/camera_blue.png',
          testName: 'Back Camera',
        ),
        Item(
          id: 0,
          imageUrl: 'assets/display_test_blue.png',
          testName: 'Display',
        ),
        Item(
          id: 0,
          imageUrl: 'assets/display_test_blue.png',
          testName: 'Mirror Test',
        ),
      ];
    } else {
      return [
        Item(
          id: 0,
          imageUrl: 'assets/mobile_phone_vibrating_blue.png',
          testName: 'Vibration',
        ),
        Item(
          id: 0,
          imageUrl: 'assets/sim_card_blue.png',
          testName: 'SIM',
        ),
        Item(
          id: 0,
          imageUrl: 'assets/speaker_blue.png',
          testName: 'Speaker',
        ),
        Item(
          id: 0,
          imageUrl: 'assets/headphones_blue.png',
          testName: 'Earphone Jack ',
        ),
        Item(
          id: 0,
          imageUrl: 'assets/flash_blue.png',
          testName: 'Flash',
        ),
        Item(
          id: 0,
          imageUrl: 'assets/camera_blue.png',
          testName: 'Back Camera',
        ),
        Item(
          id: 0,
          imageUrl: 'assets/camera_blue.png',
          testName: 'Front Camera',
        ),
        Item(
          id: 0,
          imageUrl: 'assets/wifi_blue.png',
          testName: 'WiFi',
        ),
        Item(
          id: 0,
          imageUrl: 'assets/bluetooth_blue.png',
          testName: 'Bluetooth',
        ),
        Item(
          id: 0,
          imageUrl: 'assets/sansors_blue.png',
          testName: 'Sensors List',
        ),
        Item(
          id: 0,
          imageUrl: 'assets/display_test_blue.png',
          testName: 'Display',
        ),
      ];
    }
  }

  void mPermissions() async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    result =
        await _permissionHandler.requestPermissions([PermissionGroup.camera]);
  }

  _showMaterialDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(
                "Permission",
                style: new TextStyle(fontFamily: 'OpenSans'),
              ),
              content: new Text(
                "Please allow Camera and Video recoding permission required to move further ",
                style: new TextStyle(fontFamily: 'OpenSans'),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Ok',
                    style: new TextStyle(fontFamily: 'OpenSans'),
                  ),
                  onPressed: () {
                    //    Navigator.of(context, rootNavigator: true).pop('dialog');
                    Navigator.of(context).pop();
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      getPermissionStatus();
                    });
                  },
                ),
              ],
            ));
  }

  _showMaterialDialogVideo() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(
                "Permission",
                style: new TextStyle(fontFamily: 'OpenSans'),
              ),
              content: new Text(
                "Please allow Camera and Video recoding permission required to move further ",
                style: new TextStyle(fontFamily: 'OpenSans'),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Ok',
                    style: new TextStyle(fontFamily: 'OpenSans'),
                  ),
                  onPressed: () {
                    //    Navigator.of(context, rootNavigator: true).pop('dialog');
                    Navigator.of(context).pop();
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      videoPermission();
                    });
                  },
                ),
              ],
            ));
  }
}
