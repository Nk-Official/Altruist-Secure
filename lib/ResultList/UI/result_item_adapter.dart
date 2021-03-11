import 'package:altruist_secure_flutter/ResultList/Model/resultModel.dart';
import 'package:altruist_secure_flutter/TestList/Model/Item.dart';
import 'package:flutter/material.dart';
class ResultAdapter extends StatelessWidget {
  final resultBean item;
  const ResultAdapter({@required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
//      onTap: () {
////        Navigator.pushReplacement(
////          context,
////          MaterialPageRoute(
////            //  builder: (context) => GridItemDetails(this.item),
////          ),
////        );
//      },
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.fromLTRB(20.0, 3.0, 20.0, 3.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(item.testName,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                          fontFamily: 'OpenSans',
                      ),
                      textAlign: TextAlign.end,
                      softWrap: true),
//                  Text(item.id.toString(),
//                      maxLines: 1,
//                      style: TextStyle(
//                        fontSize: 14.0,
//                        color: Colors.black,
//                        fontFamily: 'OpenSans',
//                      ),
//                      textAlign: TextAlign.end,
//                      ),
                  Image.asset(
                   _setImaege(),
                    height: 15,
                    width: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _setImaege() {
    String image;
    if(item.status == "true"){
      image ='assets/tick.png';
    }else{
      image ='assets/wrong.png';
    }
    print(image);
   return image;
  }



}
