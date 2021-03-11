import 'dart:io';
import 'dart:math';
import 'package:altruist_secure_flutter/CertificateWebView/UI/certificateProcess.dart';
import 'package:altruist_secure_flutter/IDUpload/IDUploadPresenter.dart';
import 'package:altruist_secure_flutter/PaymentStatusScreen/PaymentScreenPresenter.dart';
import 'package:altruist_secure_flutter/PolicyWordingWebView/policyWordingProcess.dart';
import 'package:altruist_secure_flutter/ProfileManagement/profileManagementProcess.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/custome_info_bloc.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/custome_info_event.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/custome_info_state.dart';
import 'package:altruist_secure_flutter/models/requests/callbackrequest/CallbackRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/customer_info/CustomerInfoRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/helpcenter/HelpCenterRequestModel.dart';
import 'package:altruist_secure_flutter/models/responses/helpcenter/HelpCenterResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/invoiceUpload/InvoiceResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/uploadIDProofs/IDProofsResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/uploadVideo/UploadVideoResponseModel.dart';
import 'package:altruist_secure_flutter/ui/homeNewScreen/NewHomeDashBoardForm.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:altruist_secure_flutter/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:date_format/date_format.dart';
import 'package:package_info/package_info.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:altruist_secure_flutter/DisplayImage/displayOption.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:altruist_secure_flutter/RaiseAClaimWebView/raiseClaimWebview.dart';

class NewHomeDashBoard extends StatefulWidget {
  String imageTag;

  NewHomeDashBoard(this.imageTag);

  @override
  _HomeDashBoardState createState() => _HomeDashBoardState(imageTag);
}

class _HomeDashBoardState extends State<NewHomeDashBoard> {
  CustomeInfoBloc _bloc;
  String imageTag;
  String customerName;
  String customerDeviceName;
  List<HelpLine> helpLines;
  File _pickedImage;
  File _frontIDImage;
  File _backIDImage;
  File _videofile;
  DeviceDetail deviceDetail;
  DeviceDetailsIDProofs deviceDetailsIDProofs;
  DeviceDetailsUploadVideo deviceDetailsUploadVideo;
  bool isLoadingProgress = false;
  String ViewCerticate,
      InvoiceImageUrl,
      recordVideoUrl,
      idproofScanCopyHttpURL,
      idproofScanCopyBackHttpURL;
  String subscibedProductName;
  String subscibedProductNameNew;
  String subscribedPackageExpiry;
  String _versionCode = "";
  bool InvoiceHintFlag = true;
  bool InvoiceFlag = true;
  bool IDHintFlag = true;
  bool IDFlag = true;
  bool mPaymetVisibelFlag_ = true;
  bool mPackageVisibelFlag_ = true;
  bool mRaiseClaimVisibelFlag_ = true;
  bool mRequestCallBackVisibelFlag_ = true;
  bool policyCertificateVisibelFlag_ = true;
  bool policyWordingVisibelFlag_ = true;
  bool mHelpVisibelFlag_ = false;
  static const double padding = 20;
  static const double avatarRadius = 45;

  _HomeDashBoardState(this.imageTag);

  void _pickImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file != null) {
        setState(() {
          _pickedImage = file;
          print(_pickedImage.path);
          _bloc.add(UploadInvoiceEvent(
              userId: PreferenceUtils.getString(Utils.USER_ID),
              source: StringConstants.SOURCE,
              invoiceFile: _pickedImage));
        });
      }
    }
  }

  void _pickIdProofs() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file != null) {
        setState(() {
          if (_frontIDImage == null) {
            _frontIDImage = file;
            _bloc.add(UploadIDProofsEvent(
                userId: PreferenceUtils.getString(Utils.USER_ID),
                source: StringConstants.SOURCE,
                idProof: _frontIDImage == null ? null : _frontIDImage,
                idProofBack: _backIDImage == null ? null : _backIDImage));
          } else {
            _backIDImage = file;
          }
          print(file.path);
//          _bloc.add(UploadInvoiceEvent(
//              userId: PreferenceUtils.getString(Utils.USER_ID),
//              source: StringConstants.SOURCE,
//              invoiceFile: _pickedImage));
        });
      }
    }
  }

  void _pickVideoFile() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Select the video source"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imageSource != null) {
      final file = await ImagePicker.pickVideo(source: imageSource);
      print(await file.length());
//      print(AppUtils.formatBytes(await file.length(),2));
      if (file != null) {
        setState(() {
          _videofile = file;
          print(_videofile.path);
          _bloc.add(UploadVideoEvent(
              userId: PreferenceUtils.getString(Utils.USER_ID),
              source: StringConstants.SOURCE,
              videoFile: _videofile));
        });
      }
    }
  }

  BuildContext _buildContext;

  @override
  void initState() {
    super.initState();
    PreferenceUtils.init();
    _initPackageInfo();
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      mPaymetVisibelFlag_ = false;
      mPackageVisibelFlag_ = true;
      mRaiseClaimVisibelFlag_ = true;
      mRequestCallBackVisibelFlag_ = false;
      mHelpVisibelFlag_ = true;
    } else {
      mRaiseClaimVisibelFlag_ = true;
      mRequestCallBackVisibelFlag_ = true;
      mHelpVisibelFlag_ = false;
    }

    _bloc = CustomeInfoBloc(apisRepository: ApisRepository());
    var customerInfoRequestModel = CustomerInfoRequestModel(
        source: StringConstants.SOURCE,
        userId: PreferenceUtils.getString(Utils.USER_ID));
    _bloc.add(FetchCustomeInfoEvent(
        customerInfoRequestModel: customerInfoRequestModel));
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      /// The build number. `CFBundleVersion` on iOS, `versionCode` on Android.
      _versionCode = info.buildNumber;
    });
//    print(_versionCode);
//    print(PreferenceUtils.getString(Utils.APP_VERSION));
    if (PreferenceUtils.getString(Utils.APP_VERSION).isNotEmpty &&
        (int.parse(PreferenceUtils.getString(Utils.APP_VERSION)) >
            int.parse(_versionCode))) {
      _buildContext = context;
      showAppUpdateDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: BlocListener(
          bloc: _bloc,
          listener: (BuildContext context, CustomeInfoState state) {
            if (state is InitialCustomeInfoState) {
              if (state.isLoading == false && !state.isSuccess) {
                //  AppUtils.showSnackBar(context, state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                // AppUtils.showSnackBar(context, state.message);
                if (state.customerInfoResponseModel.deviceDetails != null) {
                  customerName = state.customerInfoResponseModel.deviceDetails
                      .customerFirstName;
                  customerDeviceName = state
                          .customerInfoResponseModel.deviceDetails.deviceName +
                      " - " +
                      state.customerInfoResponseModel.deviceDetails.deviceModel;

                  PreferenceUtils.setString(
                      Utils.USERNAME,
                      state.customerInfoResponseModel.deviceDetails
                              .customerFirstName +
                          " " +
                          state.customerInfoResponseModel.deviceDetails
                              .customerLastName);
                  PreferenceUtils.setString(
                      Utils.MOBILENUMBER,
                      state.customerInfoResponseModel.deviceDetails
                          .mobileNumber);
                  PreferenceUtils.setString(Utils.DEVICENAME,
                      state.customerInfoResponseModel.deviceDetails.deviceName);
                  PreferenceUtils.setString(
                      Utils.DEVICEMODEL,
                      state
                          .customerInfoResponseModel.deviceDetails.deviceModel);
                  PreferenceUtils.setString(Utils.DEVICEIMEI,
                      state.customerInfoResponseModel.deviceDetails.imieNumber);
                  PreferenceUtils.setString(
                      Utils.DEVICEAMMOUNT,
                      state.customerInfoResponseModel.deviceDetails
                          .invoiceAmount);
                  PreferenceUtils.setString(
                      Utils.INVOICEDATE,
                      state
                          .customerInfoResponseModel.deviceDetails.invoiceDate);
                  PreferenceUtils.setString(
                      Utils.INVOICEAMOUNT,
                      state.customerInfoResponseModel.deviceDetails
                          .invoiceAmount);
                  PreferenceUtils.setString(Utils.USEREMAIL,
                      state.customerInfoResponseModel.deviceDetails.email);
                  //  PreferenceUtils.setString(Utils.USERNAMTIONALID, state.deviceDetails.invoiceAmount);

                  InvoiceImageUrl = state.customerInfoResponseModel
                      .deviceDetails.invoiceScanCopyHttpUrl;
                  recordVideoUrl = state.customerInfoResponseModel.deviceDetails
                      .recordedVideoHttpUrl;
                  idproofScanCopyHttpURL = state.customerInfoResponseModel
                      .deviceDetails.idproofScanCopyHttpUrl;
                  idproofScanCopyBackHttpURL = state.customerInfoResponseModel
                      .deviceDetails.idproofScanCopyBackHttpUrl;
                  print("InvoiceImageUrl ====  $InvoiceImageUrl");
                  print("recordVideoUrl ====  $recordVideoUrl");
                  print("idproofScanCopyHttpURL ====  $idproofScanCopyHttpURL");
                  print(
                      "idproofScanCopyBackHttpURL ====  $idproofScanCopyBackHttpURL");

                  if (InvoiceImageUrl != null) {
                    InvoiceHintFlag = false;
                    InvoiceFlag = true;
                  } else {
                    InvoiceHintFlag = true;
                    InvoiceFlag = false;
                  }
                  if (PreferenceUtils.getString(Utils.appPackageName) ==
                      "com.app.mansardecure_secure") {
                    mPaymetVisibelFlag_ = false;
                    mPackageVisibelFlag_ = true;
                    mRaiseClaimVisibelFlag_ = true;
                    mRequestCallBackVisibelFlag_ = false;
                    mHelpVisibelFlag_ = true;
                  } else {

                    if(PreferenceUtils.getString(Utils.appPackageName) == "com.app.altruists_secure_bangla" || PreferenceUtils.getString(Utils.appPackageName) == "com.app.altruists-secure-bangla") {
                      mRaiseClaimVisibelFlag_ = false;
                      policyCertificateVisibelFlag_ = true;
                      policyWordingVisibelFlag_ = true;
                    }else{
                      if (state.customerInfoResponseModel.subscriptions[0].status == "5") {
                        mRaiseClaimVisibelFlag_ = false;
                        policyCertificateVisibelFlag_ = false;
                        policyWordingVisibelFlag_ = false;
                      } else {
                        mRaiseClaimVisibelFlag_ = true;
                        policyCertificateVisibelFlag_ = true;
                        policyWordingVisibelFlag_ = true;
                      }
                    }






                  }


                  if (idproofScanCopyHttpURL != null &&
                      idproofScanCopyBackHttpURL != null) {
                    IDHintFlag = false;
                    IDFlag = true;
                  } else {
                    IDHintFlag = true;
                    IDFlag = false;
                  }
                  if (state
                          .customerInfoResponseModel.deviceDetails.fatherName !=
                      null) {
                    PreferenceUtils.setString(
                        Utils.USERFATHERNAME,
                        state.customerInfoResponseModel.deviceDetails
                            .fatherName);
                  }
                  if (state
                          .customerInfoResponseModel.deviceDetails.nationalId !=
                      null) {
                    PreferenceUtils.setString(
                        Utils.USERNAMTIONALID,
                        state.customerInfoResponseModel.deviceDetails
                            .nationalId);
                  }
                  PreferenceUtils.setString(
                      Utils.FrontIDProof, idproofScanCopyHttpURL);
                  PreferenceUtils.setString(
                      Utils.BackIDProof, idproofScanCopyBackHttpURL);
                  if (InvoiceImageUrl != null && imageTag == "invoice_edit") {
                    _pickImage();
                  } else if (idproofScanCopyHttpURL != null &&
                      imageTag == "uploadid_edit") {
                    _pickIdProofs();
                  }
                }
                if (state.customerInfoResponseModel.subscriptions != null &&
                    state.customerInfoResponseModel.subscriptions.length > 0) {
                  subscibedProductName = state.customerInfoResponseModel.subscriptions[0].productName;

                  if (PreferenceUtils.getString(Utils.appPackageName) ==
                      "com.app.mansardecure_secure"){
                    try {

                      if(state.customerInfoResponseModel
                          .subscriptions[0].policyIssueDateTime
                          .toString()!=null){
                        String pDate = state.customerInfoResponseModel
                            .subscriptions[0].policyIssueDateTime
                            .toString();
                        pDate = pDate.substring(0, pDate.length - 3);
                        DateTime todayDate = DateTime.fromMillisecondsSinceEpoch(
                            int.parse(pDate) * 1000);
                        subscibedProductNameNew = "Issue Date - " + formatDate(todayDate, [dd, '-', mm, '-', yyyy]);
                      }else{
                        subscibedProductNameNew = "";
                      }
                      print("subscibedProductNameNew ===  ${subscibedProductNameNew}");
                    } on Exception {
                      print(e.toString());
                    }
                  }else{
                    subscibedProductNameNew =   "Package Name "+ subscibedProductName;
                  }

                  try {
                    String pDate = state.customerInfoResponseModel
                        .subscriptions[0].policyExpiryDateTime
                        .toString();
                    pDate = pDate.substring(0, pDate.length - 3);
                    DateTime todayDate = DateTime.fromMillisecondsSinceEpoch(
                        int.parse(pDate) * 1000);
                    subscribedPackageExpiry =
                        formatDate(todayDate, [dd, '-', mm, '-', yyyy]);
                    print(subscribedPackageExpiry);
                  } on Exception {
                    print(e.toString());
                  }
                  ViewCerticate = state.customerInfoResponseModel
                      .subscriptions[0].policyDocReference;
                } else {
//                AppUtils.showSnackBar(context, state.message);
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) => Home(),
//                  ),
//                );
                }
              }
            }
            else if (state is InitialCallbackRequestState) {
              if (state.isLoading == false && !state.isSuccess) {
                //  AppUtils.showSnackBar(context, state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                // AppUtils.showSnackBar(context, state.message);
                mDialogSuccess("", "Request submitted successfully");
              }
            }
            else if (state is InitialHelpCenterState) {
              if (state.isLoading == false && !state.isSuccess) {
                //    AppUtils.showSnackBar(context, state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                // AppUtils.showSnackBar(context, state.message);
                helpLines = state.helpLines;
              }
            }
            else if (state is InitialInvoiceUploadeState) {
              if (state.isLoading == false && !state.isSuccess) {
                //  AppUtils.showSnackBar(context, state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                _pickedImage = null;
                // AppUtils.showSnackBar(context, state.message);
                deviceDetail = state.deviceDetails;
                InvoiceImageUrl = state.deviceDetails.invoiceScanCopyHttpUrl;
                print("InvoiceImageUrl ====  $InvoiceImageUrl");
                mDialogSuccess("", "Invoice uploaded successfully");
                EventTracker.logEvent("INVOICE_UPLOAD_SUCCESS");
              }
            }
            else if (state is InitialuploadIDProofState) {
              if (state.isLoading == false && !state.isSuccess) {
                //  AppUtils.showSnackBar(context, state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                _frontIDImage = null;
                _backIDImage = null;
                //  AppUtils.showSnackBar(context, state.message);
                deviceDetailsIDProofs = state.deviceDetails;
                idproofScanCopyHttpURL =
                    state.deviceDetails.idproofScanCopyHttpUrl;
                print("idproofScanCopyHttpURL in api $idproofScanCopyHttpURL");
                mDialogSuccess("", "ID proof uploaded successfully");
                EventTracker.logEvent("UPLOAD_ID_PROOF_SUCCESS");
              }
            }
            else if (state is InitialuploadVideoState) {
              if (state.isLoading == false && !state.isSuccess) {
                //  AppUtils.showSnackBar(context, state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                //   AppUtils.showSnackBar(context, state.message);
                deviceDetailsUploadVideo = state.deviceDetails;
                mDialogSuccess("", "Video uploaded successfully");
                EventTracker.logEvent("UPLOAD_VIDEO_SUCCESS");
              }
            }
          },
          child: BlocBuilder(
            bloc: _bloc,
            builder: (context, CustomeInfoState state) {
              if (state is InitialCustomeInfoState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              } else if (state is InitialCallbackRequestState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              } else if (state is InitialHelpCenterState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              } else if (state is InitialInvoiceUploadeState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              } else if (state is InitialuploadIDProofState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              } else if (state is InitialuploadVideoState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              }
              return ModalProgressHUD(
                color: Colors.black,
                inAsyncCall: isLoadingProgress,
                child: NewHomeDashBoardForm(
                  subscribedProductName:
                      subscibedProductNameNew == null ? "" : subscibedProductNameNew,
                  subscribedProductExpiry: subscribedPackageExpiry == null ? "" : subscribedPackageExpiry,
                  customerName: customerName,
                  customerDeviceName: customerDeviceName,
                  onHelpineClick: () {
                    EventTracker.logEvent("HELPLINE_CLICK");
                    var helpCenterRequestModel = HelpCenterRequestModel(
                        userId: PreferenceUtils.getString(Utils.USER_ID),
                        source: StringConstants.SOURCE,
                        countryId: PreferenceUtils.getString(Utils.COUNTRY_ID),
                        operatorCode: PreferenceUtils.getString(Utils.OPERATORCODE));
                    _bloc.add(HelpCenterEvent(
                        helpCenterRequestModel: helpCenterRequestModel));
                  },
                  onCallBackRequestClick: () {
                    EventTracker.logEvent("CALLBACK_REQUEST_CLICK");
                    var callbackRequestModel = CallbackRequestModel(
                        source: StringConstants.SOURCE,
                        userId: PreferenceUtils.getString(Utils.USER_ID),
                        mobile: PreferenceUtils.getString(Utils.MSISDN));
                    _bloc.add(CustomerCallbackRequestEvent(
                        callbackRequestModel: callbackRequestModel));
                  },
                  onSubscriptionPackClick: () {
                    //  _bloc.add(UploadIDProofsEvent(
//                      userId: PreferenceUtils.getString(Utils.USER_ID),
//                      source: StringConstants.SOURCE,
//                      idProof: _frontIDImage == null ? null : _frontIDImage,
//                      idProofBack: _backIDImage == null ? null : _backIDImage));
                  },
                  onUploadIdProofClick: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IDUploadPresenter(),
                      ),
                    );
                    //                  EventTracker.logEvent("UPLOAD_ID_PROOF_CLICK");
//                  if(idproofScanCopyHttpURL !=null ){
//                     print('Id Upload  image $idproofScanCopyHttpURL');
//                      Navigator.pushReplacement(
//                        context,
//                        MaterialPageRoute(
//                          builder: (context) => DisplayUploadIDImageImage(idproofScanCopyHttpURL),
//                        ),
//                      );
//                    }else{
//                      _pickIdProofs();
//                    }
                  },
                  onUploadInvoiceClick: () {
                    print("InvoiceImageUrl on click $InvoiceImageUrl");
                    if (InvoiceImageUrl != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisplayImage(InvoiceImageUrl),
                        ),
                      );
                    } else {
                      EventTracker.logEvent("UPLOAD_INVOICE_CLICK");
                      _pickImage();
                    }
                  },
                  onUploadVideoClick: () {
                    EventTracker.logEvent("UPLOAD_VIDEO_CLICK");

                    _pickVideoFile();
                  },
                  onRaiseClaimClick: () {
                    //   UrlLauncher.launch('tel:${"*#06#"}');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RaiseAClaimWebView(),
                      ),
                    );
                  },
                  profileClick: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileMain(),
                      ),
                    );
                  },
                  onVerificationCertificateClick: () {
                    print('ViewCerticate OnClick: $ViewCerticate');
                    EventTracker.logEvent("VIEW_CERTIFICATE_CLICK");
                    if (ViewCerticate != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CertificateProcess(ViewCerticate),
                        ),
                      );
                    } else {
                      AppUtils.showSnackBar(context, "Ceriticate Not Found");
                    }
                  },
                  policyWordingClick: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PolicyWordingProcess(),
                      ),
                    );
                  },
                  mInvoicehintFlag: InvoiceHintFlag,
                  mInvoiceFlag: InvoiceFlag,
                  mIDhintFlag: IDHintFlag,
                  mIDuploadFlag: IDFlag,
                  mStatusFlag: false,
                  mPaymetVisibelFlag: mPaymetVisibelFlag_,
                  mPackageVisibelFlag: mPackageVisibelFlag_,
                  mRaiseClaimVisibelFlag: mRaiseClaimVisibelFlag_,
                  mRequestCallBackVisibelFlag: mRequestCallBackVisibelFlag_,
                  mHelpVisibelFlag: mHelpVisibelFlag_,
                  policyCertificateVisibelFlag: policyCertificateVisibelFlag_,
                  policyWordingVisibelFlag: policyWordingVisibelFlag_,
                  onHelpClick: () {
                    print("Help Click Working");
                    _showDialog();
                  },
                  onPaymentStatusClick: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreenPresenter(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
    ));
  }

  void showAppUpdateDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {},
          child: Platform.isIOS
              ? new CupertinoAlertDialog(
                  title: Text(StringConstants.ALERT),
                  content: Text(StringConstants.APP_UPDATE_MESSAGE),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(StringConstants.UPDATE),
                      onPressed: () {
                        _launchURL();
                      },
                    ),
                  ],
                )
              : AlertDialog(
                  title: Text(StringConstants.ALERT,
                      style: TextStyle(color: Colors.black)),
                  content: Text(StringConstants.APP_UPDATE_MESSAGE,
                      style: TextStyle(color: Colors.black)),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        StringConstants.UPDATE,
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                      onPressed: () {
                        _launchURL();
                      },
                    ),
                  ],
                ),
        );
      },
    );
  }

  _launchURL() async {
//    Navigator.of(context).pop();
    Navigator.of(_buildContext, rootNavigator: true).pop();
    try {
      StoreRedirect.redirect();
    } on Exception {
      print("Exception in Store redirect");
    }
  }

  void mDialogSuccess(String title, String Discription) {
    SweetAlert.show(context,
        title: title, subtitle: Discription, style: SweetAlertStyle.success);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  /////// Custom Dialog///////
  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(Utils.helpEmail),
            SizedBox(
              height: 20,
            ),
            new Text(Utils.helpNumber),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}
