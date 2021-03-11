import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class IntroScreen extends StatelessWidget {
  List<Widget> listWid;
  List<Slide> slideList;
  Function goToTab;
  final GestureTapCallback onDoneClick;

  IntroScreen(
      {Key key, this.listWid, this.slideList, this.goToTab, this.onDoneClick})
      : super(key: key);

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Colors.black,
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Text(
      "Done",
      style: TextStyle(fontSize: 18, color: Colors.black),
    );

//      Icon(
//      Icons.done,
//      color: Colors.lightBlueAccent,
//    );
  }

  Widget renderSkipBtn() {
    return Text(
      "Skip",
      style: TextStyle(fontSize: 18, color: Colors.black),
    );

//      Icon(
//      Icons.skip_next,
//      color: Colors.lightBlueAccent,
//    );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // List slides
      slides: slideList,

      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Colors.white,
      highlightColorSkipBtn: ColorConstant.ActiveDotsColor,

      // Next button
      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: onDoneClick,
      colorDoneBtn: Colors.white,
      highlightColorDoneBtn: Colors.black,

      // Dot indicator
      colorDot: Colors.grey,
      colorActiveDot: ColorConstant.ActiveDotsColor,
      sizeDot: 13.0,
      //   typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

      // Tabs
      listCustomTabs: listWid,
      backgroundColorAllSlides: Colors.white,
      refFuncGoToTab: (refFunc) {
        this.goToTab = refFunc;
      },

      // Show or hide status bar
      shouldHideStatusBar: true,

      // On tab change completed
      onTabChangeCompleted: this.onTabChangeCompleted,
    );
  }
}
