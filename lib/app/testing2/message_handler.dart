import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../modules/service_request/views/test_view.dart';


class Application extends StatefulWidget {
  final Widget child;
  Application({this.child});
  @override
  State createState() => _Application();
}

class _Application extends State<Application> {
  BuildContext globalContext;
  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  print("fnjnaskds in main class providerId:Handling a background message.messageId: ${message.messageId}");
  print("fnjnaskds in main class providerId:  Handling a background message.notification.body.toString(): ${message.notification.body.toString()}");
  print("fnjnaskds  from _firebaseMessagingBackgroundHandler ${message.toString()}");
  Navigator.push(
    globalContext,
    MaterialPageRoute(builder: (context) =>  TestView()),
  );
}
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    // FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  }

  void _handleMessage(RemoteMessage message) {
    // Navigator.push(context, TestView(),
    // );
    print("fnjnaskds from handle Message ${message.notification.body}");
    Navigator.push(
      globalContext,
      MaterialPageRoute(builder: (context) =>  TestView()),
    );

    if (message.data['type'] == 'chat') {
      Navigator.pushNamed(context, '/chat',
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
  }


  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return widget.child;
  }
}