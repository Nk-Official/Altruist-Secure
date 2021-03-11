import 'package:altruist_secure_flutter/FrontScreen/Model/frontIconModel.dart';
import 'package:flutter/material.dart';

class FrontIconAdapter extends StatelessWidget {
  final frontIconstBean item;
  const FrontIconAdapter({@required this.item});


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              //  builder: (context) => GridItemDetails(this.item),
              ),
        );
      },
      child: Column(
        children: <Widget>[
          Visibility(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    child: Image.asset(
                      _setImaege(),
                      height: 40,
                      width: 40,
                    ),
                    decoration: new BoxDecoration(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(70.0)),
                      border: new Border.all(
                        color: Colors.lightBlueAccent,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Visibility(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    child: Image.asset(
                      _setImaege(),
                      height: 40,
                      width: 40,
                    ),
                    decoration: new BoxDecoration(
                      borderRadius:
                      new BorderRadius.all(new Radius.circular(70.0)),
                      border: new Border.all(
                        color: Colors.lightBlueAccent,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _setImaege() {
    String image;
    if (item.status == "true") {
      image = 'assets/tick.png';
    } else {
      image = 'assets/wrong.png';
    }
    print(image);
    return image;
  }
}
