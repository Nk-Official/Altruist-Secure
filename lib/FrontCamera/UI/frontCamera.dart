import 'dart:async';
import 'package:altruist_secure_flutter/BluetoothTest/UI/bluetooth_test.dart';
import 'package:altruist_secure_flutter/CameraCaptureScreen/DeviceDetailsCode.dart';
import 'package:altruist_secure_flutter/ScreenGlassTest/screenglasstest.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/WifiTest/UI/wifi_test.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class FrontCameraScreen__ extends StatefulWidget {
  @override
  FrontScreenState createState() => FrontScreenState();
}

class FrontScreenState extends State<FrontCameraScreen__> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool showCapturedPhoto = false;
  var ImagePath;
  ProgressDialog pr;
  bool visible = false;
  bool true_status = false;
  bool false_status = false;
  bool resultText_status = false;
  var mTextStatus = TextEditingController();

  @override
  void initState() {
    pr = ProgressDialog(context);
    PreferenceUtils.init();
    loadProgress();
    _initializeCamera();
    Future.delayed(const Duration(milliseconds: 1000), () {
      mCaptureImage();
    });
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    // _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(cameras[1], ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller != null
          ? _initializeControllerFuture = _controller.initialize()
          : null; //on pause camera is disposed, so we need to call again "issue is only for android"
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    var title = "Front Camera Test";
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
//            SizedBox(height: 15),
//            Text(
//              "Front Camera Test",
//              textAlign: TextAlign.center,
//              style: new TextStyle(
//                  fontSize: 18, color: Colors.black, fontFamily: 'Raleway'),
//            ),
            SizedBox(height: 70),
            new Stack(children: [
              Container(
                child: new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // If the Future is complete, display the preview.
                        Transform.scale(
                            scale: _controller.value.aspectRatio / deviceRatio,
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child:
                                    CameraPreview(_controller), //cameraPreview
                              ),
                            ));
                        return Transform.scale(
                            scale: _controller.value.aspectRatio / deviceRatio,
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  color: Colors.black,
                                ), //cameraPreview
                              ),
                            ));
                      } else {
                        return Center(); // Otherwise, display a loading indicator.
                      }
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Visibility(
                        maintainAnimation: true,
                        maintainState: true,
                        visible: visible,
                        child: Container(
                          margin: EdgeInsets.only(top: 50, bottom: 30),
                          child: SizedBox(
                            child: CircularProgressIndicator(),
                            height: 50.0,
                            width: 50.0,
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                        visible: true_status,
                        maintainState: true,
                        child: Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: Image.asset(
                            'assets/progresstrue.png',
                            height: 60,
                            width: 60,
                          ),
                        )),
                    Visibility(
                        visible: false_status,
                        maintainState: true,
                        child: Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: Image.asset(
                            'assets/progressfalse.png',
                            height: 60,
                            width: 60,
                          ),
                        )),
                    Visibility(
                      visible: resultText_status,
                      maintainState: true,
                      child: new Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 0, bottom: 10),
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontFamily: 'OpenSans'),
                            decoration: new InputDecoration.collapsed(
                              border: InputBorder.none,
                            ),
                            controller: mTextStatus,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  void mCaptureImage() async {
    var path;
    Future.delayed(const Duration(milliseconds: 2000), () async {
      try {
        await _initializeControllerFuture;
        path = join(
          (await getTemporaryDirectory()).path,
          '${DateTime.now()}.png',
        );
        await _controller.takePicture(path);
        print(path);
        true_status = true;
        mSuccessSharedPref();
      } catch (e) {
        false_status = true;
        mFailSharedPref();
        print(e);
      }
      loadProgress();
      if (path != null) {
      } else {}

      if (PreferenceUtils.getString(Utils.appPackageName) ==
          "com.app.mansardecure_secure") {
        Future.delayed(const Duration(milliseconds: 2000), () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ScreenGlassTest(),
                settings: RouteSettings(name: 'CameraScreen')),
          );
        });
      } else {
        if(PreferenceUtils.getString(Utils.COUNTRY_ID) == "88"){
          Future.delayed(const Duration(milliseconds: 2000), () async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BluetoothTest(),
                  settings: RouteSettings(name: 'BluetoothTest')),
            );
          });
        }else{
          Future.delayed(const Duration(milliseconds: 2000), () async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => WifiTest(),
                  settings: RouteSettings(name: 'WifiTest')),
            );
          });


        }


      }
    });
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  mShowProgrebar() async {
    await pr.show();
  }

  void mSuccessSharedPref() {
    PreferenceUtils.setString(Utils.Front_Camera, "true");
    EventTracker.logEvent("FRONT_CAMERA_VERIFIED");
  }

  void mFailSharedPref() {
    PreferenceUtils.setString(Utils.Front_Camera, "false");
    EventTracker.logEvent("FRONT_CAMERA_FAILED");
  }

  loadProgress() {
    if (visible == true) {
      setState(() {
        visible = false;
        resultText_status = true;
        if (true_status == true) {
          true_status = true;
          false_status = false;
          mTextStatus.text = Utils.TestSuccessfull;
        } else {
          false_status = true;
          true_status = false;
          mTextStatus.text = Utils.Testfailed;
        }
        //  false_status = false;
      });
    } else {
      setState(() {
        visible = true;
      });
    }
  }
}
