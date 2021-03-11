import 'dart:io';
import 'package:altruist_secure_flutter/PolicyWordingWebView/policyWording.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/blocs/login_process/bloc.dart';
import 'package:altruist_secure_flutter/blocs/login_process/otp_login_process_bloc.dart';
import 'package:altruist_secure_flutter/ui/homeNewScreen/NewHomeDashboard.dart';

import 'package:altruist_secure_flutter/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'package:flutter/cupertino.dart';
import 'dart:isolate';
import 'dart:ui';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as io;
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweetalert/sweetalert.dart';

class PolicyWordingProcess extends StatefulWidget {
  String viewCerticate;

  @override
  PolicyWordingProcessState createState() => PolicyWordingProcessState();
}

class PolicyWordingProcessState extends State<PolicyWordingProcess> {
  String viewCerticate, localPath;
  List<String> attachments = [];
  bool isHTML = false;
  bool _mDownloadoption = true;
  bool _mEmailoption = true;
  OtpLoginProcessBloc _bloc;
  GlobalKey<FormState> _formKey;
  var finalPath;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    _bloc = OtpLoginProcessBloc(apisRepository: ApisRepository());
    viewCerticate = PreferenceUtils.getString(Utils.POLICYWORDING);
    print("PolicyWordingUrl_ Url ===  $viewCerticate");
    if (Platform.isAndroid) {
    } else {
      // iOS-specific code
    }
    msavedDir();
    super.initState();
  }

  final _recipientController = TextEditingController(
    text: 'example@example.com',
  );

  final _subjectController = TextEditingController(text: 'The subject');

  final _bodyController = TextEditingController(
    text: 'Mail body.',
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [_recipientController.text],
      attachmentPaths: attachments,
      isHTML: isHTML,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  void _openImagePicker() async {
    File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      attachments.add(pick.path);
    });
  }

  void _requestDownload(String task) async {
    await FlutterDownloader.enqueue(
        url: task,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: localPath,
        showNotification: true,
        openFileFromNotification: true);
  }

  var isSweetAlertShowingPolicy = false;

  void msavedDir() async {
    print('Save Directiry Called');
//    WidgetsFlutterBinding.ensureInitialized();
//    FlutterDownloader.initialize(debug: true);
    FlutterDownloader.registerCallback(downloadCallback);
    var fileName = viewCerticate.split("/").last;
    String root = "";
    if (Platform.isIOS) {
      root = (await _localPath());
    } else {
      root = (await _findLocalPath());
    }
    localPath = root + Platform.pathSeparator + 'Download';
    finalPath = '$localPath/$fileName';
    print('localPath==== $localPath');
    print('finalPath === $finalPath');
    final savedDir = Directory(localPath);
    print('savedDir $savedDir');
    bool hasExisted = await savedDir.exists();
    mDownloadEmailoption(finalPath);
    print('hasExisted $hasExisted');
    if (!hasExisted) {
      savedDir.create();
    }
    // attachments.add(localPath);
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      print("progressSetState ${progress}");
      if (progress == 100) {
        if (!isSweetAlertShowingPolicy) {
          SweetAlert.show(context,
              title: "",
              subtitle: "File downloaded successfully",
              style: SweetAlertStyle.success);
          isSweetAlertShowingPolicy = true;
        }
      }
    });
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
//    if (true) {
//      print(
//          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
//    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
//    print(
//        'downloadCallback aree ====  id ($id) ======status  ($status) and process ($progress)');
//    if (progress == 100) {
//      //_progress();
//
////      PolicyWordingProcessState mobj = PolicyWordingProcessState();
////     final String path = finalPath;
////      mobj.mDownloadEmailoption(finalPath);
//
//    }
  }

  Future<String> _progress() {
    _mDownloadoption = true;
    _mEmailoption = true;
    mDialogSuccess("", "Downloaded successfully");
    setState(() {});
  }

  Future<String> _localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  Future<bool> _checkPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  void mDownloadEmailoption(String finalPath) async {
    File file = File(finalPath);
    bool fileHas = await file.exists();
    io.File(finalPath).exists();
    print(' fileHas === $fileHas');
    if (fileHas) {
      print('  io.File(finalPath) exists === True');
      _mDownloadoption = true;
      _mEmailoption = true;
    } else {
      print('  io.File(finalPath) exists === False');
      _mDownloadoption = true;
      _mEmailoption = true;
    }
    setState(() {});
  }

  void mDialogSuccess(String title, String Discription) {
    SweetAlert.show(context,
        title: title, subtitle: Discription, style: SweetAlertStyle.success);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewHomeDashBoard(""))),
        child: Scaffold(
      body: BlocListener(
        bloc: _bloc,
        listener: (BuildContext context, OtpLoginProcessState state) {
          if (state is EailInfoState) {
            if (state.isLoading == false && !state.isSuccess) {
              AppUtils.showSnackBar(context, state.message);
            } else if (state.isLoading == false && state.isSuccess) {
              // AppUtils.showSnackBar(context, state.message);
              mDialogSuccess("", "Email send successfully");
            }
          }
        },
        child: BlocBuilder(
          bloc: _bloc,
          builder: (context, OtpLoginProcessState state) {
            return ModalProgressHUD(
              color: Colors.black,
              inAsyncCall: state is EailInfoState && state.isLoading != null
                  ? state.isLoading
                  : false,
              child: PolicyWordingForm(
                key: _formKey,
                viewCerticate: viewCerticate,
                mEmailoption: _mEmailoption,
                mDownloadoption: _mDownloadoption,
                onDownloadClick: () {
                  isSweetAlertShowingPolicy = false;
                  _requestDownload(viewCerticate);
                },
                onEmailSendClick: () {
                  PreferenceUtils.setString(Utils.EmailFlag, "2");
                  _bloc.add(EmailEvent());
                },
                onBackPress: () {
                  try {
                    print("dispose policy wording called");
                    IsolateNameServer.removePortNameMapping(
                        'downloader_send_port');
                  } on PlatformException {
                    print("Exception removePort");
                  }

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewHomeDashBoard(""),
                      ));
                },
                //  operatorConfig: operatorConfig == null ? null : operatorConfig,
              ),
            );
          },
        ),
      ),
    ));
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }
}
