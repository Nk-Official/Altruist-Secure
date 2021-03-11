import 'package:meta/meta.dart';

class resultBean {
  int id;
  String imageUrl;
  String testName;
  String displayName;
  String status;

  resultBean({
    @required this.id,
    @required this.imageUrl,
    @required this.testName,
    @required this.displayName,
    @required this.status,
  });
}
