import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as mime;

class ApisClient {
  // static const baseUrl_ = 'https://ins.liveabuzz.com/api/';
  static const baseUrl = 'https://api1.altruistsecure.com/api/';
  static const QrCode = baseUrl + 'qrcode/v1/qrcode';
  static const sendOtp = baseUrl + 'account/v1/login/pin/push';
  static const sendOtpV10 = baseUrl + 'account/v10/login/pin/push';
  static const verifyOtp = baseUrl + 'account/v1/login/pin/verify';
  static const verifyOtpV10 = baseUrl + 'account/v10/login/pin/verify';
  static const register = baseUrl + 'account/v1/register';
  static const registerV10 = baseUrl + 'account/v10/register';
  static const diagnosticList = baseUrl + 'diagnostics/v1/list';
  static const diagnosticListV10 = baseUrl + 'diagnostics/v10/list';
  static const getuseinfo = baseUrl + 'profile/v1/user';
  static const getuseinfoV10 = baseUrl + 'profile/v10/user';
  static const userupdateinfo = baseUrl + 'profile/v1/update';
  static const userupdateinfoV10 = baseUrl + 'profile/v10/update';
  static const saveDiagnosticList = baseUrl + 'diagnostics/v1/results/save';
  static const saveDiagnosticListV10 = baseUrl + 'diagnostics/v10/results/save';
  static const showProducts = baseUrl + 'subscription/v1/products';
  static const customeInfo = baseUrl + 'statusinfo/v1/status';
  static const customeInfoV10 = baseUrl + 'statusinfo/v10/status';
  static const subscriptionOtp = baseUrl + 'subscription/v1/pin/push';
  static const verifySubscriptionOtp = baseUrl + 'subscription/v1/pin/verify';
  static const getHE = baseUrl + 'he/v1/configs';
  static const saveUpdateUserDeviceInfo = baseUrl + 'device-details/v1/save';

  static const saveUpdateUserDeviceInfoV10 = baseUrl + 'device-details/v10/save';
  static const helpCenterContactDetails = baseUrl + 'help-center/v1/find';
  static const customerCallbackRequest = baseUrl + 'customer-callback/v1/save';
  static const uploadInvoiceDetails = baseUrl + 'device-details/v1/upload/invoice';
  static const uploadInvoiceDetailsV10 = baseUrl + 'device-details/v10/upload/invoice';
  static const uploadIDProofs = baseUrl + 'device-details/v2/upload/idproof';
  static const uploadIDProofsV10 = baseUrl + 'device-details/v10/upload/idproof';

  static const uploadBackIDProofs = baseUrl + 'device-details/v1/upload/idproof/back';
  static const uploadBackIDProofsV10 = baseUrl + 'device-details/v10/upload/idproof/back';

  static const damageScreen = baseUrl + 'device-details/v1/upload/damagescreen';
  static const damageScreenV10 = baseUrl + 'device-details/v10/upload/damagescreen';
  static const uploadVideoFile = baseUrl + 'device-details/v1/upload/video';
  static const currencyInfo = baseUrl + 'telco-info/v1/configs/devicemodel';
  static const fetchClaimList = baseUrl + 'claim/v1/list';
  static const raiseClaim = baseUrl + 'claim/v1/request';
  static const updateSplash = baseUrl + 'home/v1/spalsh';
  static const qrCodeScanSatus = baseUrl + 'qrcode/v1/qrcode/status';
  static const paymentSatus = baseUrl + 'user/payment/v2/status';
  static const CoupenVerify = baseUrl + 'coupen/v10/verify';
  static const agreeValueUrl = baseUrl + 'device-details/v1/agreedValue';
  final http.Client httpClient;

  ApisClient({@required this.httpClient}) : assert(httpClient != null);

  Future<http.Response> getRequest(String url) async {
    final response = await http.get(url);
    print(response.body);
    return response;
  }

  Future<http.Response> getRequestForUnsbscribe(String url,String jwtToken) async {
   // print(url);
    final response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      "jwtToken": jwtToken,
    }, );
    return response;
  }



  Future<http.Response> postRequest(String url, {Map body}) async {
//    final response = await http.post(url, body: body);
//    print(response.body);
//    return response;

    var finalBody = json.encode(body);
    debugPrint(url);
    debugPrint(finalBody);
    final response = await http.post(url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: finalBody);
    debugPrint(response.body);
    return response;
  }

  Future<http.Response> postRequestWithHeader(String url, String jwtToken,
      {Map body}) async {
    var finalBody = json.encode(body);
    print(url);
    print(jwtToken);
    print(finalBody);
    final response = await http.post(url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
//          HttpHeaders.requestHeaders: jwtToken
          "jwtToken": jwtToken,
        },
        body: finalBody);
    print(response.body);
    return response;
  }

  Future<http.StreamedResponse> multipartRequestInvoice(String url,
      String jwtToken,
      File file,
      String fileName,
      String userId,
      String source) async {
    print(url);
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      "jwtToken": jwtToken
    };
    var multipartImage = http.MultipartFile(
        'invoiceFile', file.readAsBytes().asStream(), file.lengthSync(),
        filename: fileName, contentType: mime.MediaType('image', 'jpg'));

    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..fields['userId'] = userId
      ..fields['source'] = source
      ..files.add(await multipartImage);
//    ..files.add(await http.MultipartFile.fromPath(fileName, filePath,
//          contentType: mime.MediaType('image', 'png')));
    var response = await request.send();
//    var responseData = await response.stream.toBytes();
//    var responseString = String.fromCharCodes(responseData);
//    print(responseString);
    if (response.statusCode == 200) print('Uploaded!');
    return response;
  }

  Future<http.StreamedResponse> multipartRequestVideoUpload(String url,
      String jwtToken,
      File videoFile,
      String fileName,
      String userId,
      String source) async {
    print(url);
    print("api " + videoFile.path);
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      "jwtToken": jwtToken
    };
    var multipartVideoFile = http.MultipartFile(
        'videoFile', videoFile.readAsBytes().asStream(), videoFile.lengthSync(),
        filename: fileName, contentType: mime.MediaType('video', 'mp4'));

    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..fields['userId'] = userId
      ..fields['source'] = source
      ..files.add(await multipartVideoFile);

    var response = await request.send();
    if (response.statusCode == 200) print('Uploaded!');
    return response;
  }

  Future<http.StreamedResponse> multipartRequestIDProofs(String url,
      String jwtToken,
      File file,
      File fileBack,
      String fileName,
      String fileNameBack,
      String userId,
      String source) async {
    print(url);
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      "jwtToken": jwtToken
    };
    List<http.MultipartFile> imagesList = [];

    if (fileBack != null) {
      var multipartImage = await http.MultipartFile(
          'idProof', file.readAsBytes().asStream(), file.lengthSync(),
          filename: fileName, contentType: mime.MediaType('image', 'jpg'));
      var multipartImageBack = await http.MultipartFile('idProofBack',
          fileBack.readAsBytes().asStream(), fileBack.lengthSync(),
          filename: fileNameBack, contentType: mime.MediaType('image', 'jpg'));
      imagesList.add(multipartImage);
      imagesList.add(multipartImageBack);
    } else {
      var multipartImage = await http.MultipartFile(
          'idProof', file.readAsBytes().asStream(), file.lengthSync(),
          filename: fileName, contentType: mime.MediaType('image', 'jpg'));
      imagesList.add(multipartImage);
    }

//    var multipartImage = http.MultipartFile(
//        'idProof', file.readAsBytes().asStream(), file.lengthSync(),
//        filename: fileName, contentType: mime.MediaType('image', 'jpg'));

//    var multipartImageBack = http.MultipartFile(
//        'idProofBack', fileBack.readAsBytes().asStream(), fileBack.lengthSync(),
//        filename: fileNameBack, contentType: mime.MediaType('image', 'jpg'));

    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..fields['userId'] = userId
      ..fields['source'] = source
      ..files.addAll(imagesList);
//    ..files.add(await http.MultipartFile.fromPath(fileName, filePath,
//          contentType: mime.MediaType('image', 'png')));
    var response = await request.send();
//    var responseData = await response.stream.toBytes();
//    var responseString = String.fromCharCodes(responseData);
//    print(responseString);
    if (response.statusCode == 200) print('Uploaded!');
    return response;
  }

  Future<http.StreamedResponse> multipartRequestBackIDProofs(String url,
      String jwtToken,
      File fileBack,
      String fileName,
      String fileNameBack,
      String userId,
      String source) async {
    print(url);
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      "jwtToken": jwtToken
    };
    List<http.MultipartFile> imagesList = [];
    var multipartImageBack = await http.MultipartFile(
        'idProofBack', fileBack.readAsBytes().asStream(), fileBack.lengthSync(),
        filename: fileNameBack, contentType: mime.MediaType('image', 'jpg'));
    imagesList.add(multipartImageBack);
    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..fields['userId'] = userId
      ..fields['source'] = source
      ..files.addAll(imagesList);
//    ..files.add(await http.MultipartFile.fromPath(fileName, filePath,
//          contentType: mime.MediaType('image', 'png')));
    var response = await request.send();
//    var responseData = await response.stream.toBytes();
//    var responseString = String.fromCharCodes(responseData);
//    print(responseString);
    if (response.statusCode == 200) print('Uploaded!');
    return response;
  }

  Future<http.StreamedResponse> multipartRequestDamage(String url,
      String jwtToken,
      File damagedScreen,
      String fileName,
      String userId,
      String source) async {
    print(url);
    print("File Name $fileName ");
    print("userId $userId ");
    print("File damagedScreen $damagedScreen ");
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      "jwtToken": jwtToken
    };
    List<http.MultipartFile> imagesList = [];
    var multipartImageBack = await http.MultipartFile('damagedScreen',
        damagedScreen.readAsBytes().asStream(), damagedScreen.lengthSync(),
        filename: fileName, contentType: mime.MediaType('image', 'jpeg'));
    imagesList.add(multipartImageBack);
    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..fields['userId'] = userId
      ..fields['source'] = source
      ..files.addAll(imagesList);
//    ..files.add(await http.MultipartFile.fromPath(fileName, filePath,
//          contentType: mime.MediaType('image', 'png')));
    var response = await request.send();
//    var responseData = await response.stream.toBytes();
//    var responseString = String.fromCharCodes(responseData);
//    print(responseString);
    if (response.statusCode == 200) print('Uploaded!');
    return response;
  }

  Future<http.StreamedResponse> multipartRequestRaiseClaim(String url,
      String jwtToken,
      File docFile,
      String docFileName,
      String userId,
      String source,
      String claimTypeId,
      String customerRemarks,
      String postalCode) async {
    print(url);
    print("api " + docFile.path);
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      "jwtToken": jwtToken
    };
    var multipartVideoFile = http.MultipartFile(
        'docFile', docFile.readAsBytes().asStream(), docFile.lengthSync(),
        filename: docFileName);

    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..fields['userId'] = userId
      ..fields['source'] = source
      ..fields['claimTypeId'] = claimTypeId
      ..fields['customerRemarks'] = customerRemarks
      ..fields['postalCode'] = postalCode
      ..files.add(await multipartVideoFile);

    var response = await request.send();
    if (response.statusCode == 200) print('Uploaded!');
    return response;
  }
}
