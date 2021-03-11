import 'dart:async';
import 'dart:io';
import 'package:altruist_secure_flutter/FrontCamera/UI/frontCamera.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/ui/finalResultList/ResultListMain.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class TakePictureScreen__ extends StatefulWidget {
  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen__> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool showCapturedPhoto = false;
  var ImagePath;
  bool visible = false;
  bool true_status = false;
  bool false_status = false;
  bool resultText_status = false;
  var mTextStatus = TextEditingController();

  @override
  void initState() {
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
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(firstCamera, ResolutionPreset.high);
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
    var title = "Back Camera Test";
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor:ColorConstant.AppBarColor,

        title: Text(
          title,
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontSize: 17, color: ColorConstant.TextColor, fontFamily: 'OpenSans'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

//            Text(
//              "Back Camera Test",
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
//                        return Container(
//                          height: double.infinity,
//                          width: double.infinity,
//                          child: new Image.asset('splash_screen.png'),
//                        );
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
                            style:TextStyle(
                                fontSize: 17, color: Colors.white, fontFamily: 'OpenSans'),
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
        // Ensure that the camera is initialized.
        await _initializeControllerFuture;
        path = join(
          (await getTemporaryDirectory()).path,
          '${DateTime.now()}.png',
        );
        await _controller.takePicture(path);
        print(path);
        //  mToast("Camera Working Sucessfully");
        true_status = true;
        mSuccessSharedPref();
      } catch (e) {
        mFailSharedPref();
        false_status = true;
        //  mToast("Camera Error");
        print(e);
      }
      loadProgress();
      //  mToast(PreferenceUtils.getString(Utils.Camera));
      if (path != null) {
      } else {}

      Future.delayed(const Duration(milliseconds: 2000), () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => FrontCameraScreen__(),
              settings: RouteSettings(name: 'FrontCameraScreen')),
        );
      });
    });
  }

  void mSuccessSharedPref() {
    PreferenceUtils.setString(Utils.Camera, "true");
    EventTracker.logEvent("BACK_CAMERA_VERIFIED");
  }

  void mFailSharedPref() {
    PreferenceUtils.setString(Utils.Camera, "false");
    EventTracker.logEvent("BACK_CAMERA_FAILED");
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  loadProgress() {
    if (visible == true) {
      resultText_status =true;
      setState(() {
        visible = false;
        if (true_status == true) {
          mTextStatus.text = Utils.TestSuccessfull;
          true_status = true;
          false_status = false;
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
