import 'package:altruist_secure_flutter/TestList/Model/Item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class ItemList extends StatelessWidget {
  final Item item;
  const ItemList({@required this.item});
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
                      Image.asset(
                        item.imageUrl,
                        height: 40,
                        width: 40,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(

                        item.testName,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 9.0,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),

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
