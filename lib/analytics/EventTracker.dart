import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class EventTracker {
  static final FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

//  navigatorObservers: <NavigatorObserver>[EventTracker.observer]
//use with MaterialPageRoute in order to find out the screen views
//  settings: RouteSettings(name: 'IntroScreen')
//This will be used to LOG events
//  EventTracker.analytics.logEvent(name: "SPLASH_EEVENT",
//   parameters: <String, dynamic>{'string': '$mNumber'});)

  static logEvent(String eventName) {
    analytics.logEvent(
        name: eventName, parameters: <String, dynamic>{'string': eventName});
  }

  static logEventWithParams(String eventName, String param) {
    analytics.logEvent(
        name: eventName, parameters: <String, dynamic>{'string': param});
  }
}
