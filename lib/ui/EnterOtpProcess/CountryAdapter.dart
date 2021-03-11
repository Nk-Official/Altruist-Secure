import 'package:altruist_secure_flutter/TestList/Model/Item.dart';
import 'package:altruist_secure_flutter/models/responses/cuntryinfo/CuntryResponseModel.dart';
import 'package:altruist_secure_flutter/ui/EnterOtpProcess/CountryModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class CountryAdapter extends StatelessWidget {
  final CountryModel item;
  const CountryAdapter({@required this.item});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("Click Working on Item");
      },
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                child:  new Padding(
                  padding: EdgeInsets.all(2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        item.countryCode,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 9.0,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),


//                  Text(item.testName,
//                      maxLines: 1,
//                      style: TextStyle(
//                        fontSize: 10.0,
//                        color: Colors.black,
//                        fontWeight: FontWeight.bold,
//                      ),
//                      textAlign: TextAlign.end,
//                      softWrap: true),


                    ],
                  ),
                ),
                alignment: Alignment(0.0, 0.0),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
