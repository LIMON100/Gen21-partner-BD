// import 'dart:isolate';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../common/TestPreference.dart';
// import '../../common/log_data.dart';
// import '../modules/root/controllers/root_controller.dart';
// import '../modules/root/views/root_view.dart';
// import '../modules/service_request/views/test_view.dart';
// import '../routes/app_routes.dart';
//
// // class Application extends StatefulWidget {
// //   final Widget child;
// //   Application({this.child});
// //   @override
// //   State createState() => _Application();
// // }
//
// // The callback function should always be a top-level function.
// void startCallback() {
//   // The setTaskHandler function must be called to handle the task in the background.
//   FlutterForegroundTask.setTaskHandler(MyTaskHandler());
// }
//
// class MyTaskHandler extends TaskHandler {
//   SendPort _sendPort;
//   int _eventCount = 0;
//
//   // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   //   // If you're going to use other Firebase services in the background, such as Firestore,
//   //   // make sure you call `initializeApp` before using other Firebase services.
//   //   await Firebase.initializeApp();
//   //   print("falsfdsla Handling a background message.messageId: ${message.messageId}");
//   //   printWrapped("falsfdsla Handling a background message.notification.body.toString(): ${message.notification.body.toString()}");
//   //
//   // }
//
//   @override
//   Future<void> onStart(DateTime timestamp, SendPort sendPort) async {
//     _sendPort = sendPort;
//
//     // You can use the getData function to get the stored data.
//     final customData = await FlutterForegroundTask.getData<String>(key: 'customData');
//     print('customData: $customData');
//
//     // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }
//
//   @override
//   Future<void> onEvent(DateTime timestamp, SendPort sendPort) async {
//     await FlutterForegroundTask.getData<String>(key: 'test').then((value) {
//       print("falsfdsla FlutterForegroundTask.getData: $value");
//       FlutterForegroundTask.updateService(notificationTitle: 'MyTaskHandler', notificationText: 'eventCount: $_eventCount');
//       // Send data to the main isolate.
//       sendPort?.send(value);
//       FlutterForegroundTask.removeData(key: "test").then((value) {
//         print("falsfdsla isRemoved: $value");
//       });
//       _eventCount++;
//     });
//   }
//
//   @override
//   Future<void> onDestroy(DateTime timestamp, SendPort sendPort) async {
//     // You can use the clearAllData function to clear all the stored data.
//     await FlutterForegroundTask.clearAllData();
//   }
//
//   @override
//   void onButtonPressed(String id) {
//     // Called when the notification button on the Android platform is pressed.
//     print('onButtonPressed >> $id');
//   }
//
//   @override
//   void onNotificationPressed() {
//     // Called when the notification itself on the Android platform is pressed.
//     //
//     // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
//     // this function to be called.
//
//     // Note that the app will only route to "/resume-route" when it is exited so
//     // it will usually be necessary to send a message through the send port to
//     // signal it to restore state when the app is already started.
//     FlutterForegroundTask.launchApp("/resume-route");
//     _sendPort?.send('onNotificationPressed');
//   }
// }
//
// // class ExampleApp extends StatelessWidget with WidgetsBindingObserver{
// //   const ExampleApp({Key key}) : super(key: key);
// //
// //   // final Widget child;
// //   // ExampleApp({this.child});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       initialRoute: '/',
// //       routes: {
// //         '/': (context) => ExamplePage(),
// //         // '/resume-route': (context) => const ResumeRoutePage(),
// //       },
// //     );
// //   }
// // }
//
// class ExampleAppBackup extends GetView<RootController> with WidgetsBindingObserver {
//   ReceivePort _receivePort;
//   bool isDialogOpened = false;
//   Future<void> _initForegroundTask() async {
//     await FlutterForegroundTask.init(
//       androidNotificationOptions: AndroidNotificationOptions(
//         channelId: 'notification_channel_id',
//         channelName: 'Foreground Notification',
//         channelDescription: 'This notification appears when the foreground service is running.',
//         channelImportance: NotificationChannelImportance.LOW,
//         priority: NotificationPriority.LOW,
//         iconData: const NotificationIconData(
//           resType: ResourceType.mipmap,
//           resPrefix: ResourcePrefix.ic,
//           name: 'launcher',
//           backgroundColor: Colors.orange,
//         ),
//         buttons: [
//           const NotificationButton(id: 'sendButton', text: 'Send'),
//           const NotificationButton(id: 'testButton', text: 'Test'),
//         ],
//       ),
//       iosNotificationOptions: const IOSNotificationOptions(
//         showNotification: true,
//         playSound: false,
//       ),
//       foregroundTaskOptions: const ForegroundTaskOptions(
//         interval: 10000,
//         autoRunOnBoot: true,
//         allowWifiLock: true,
//       ),
//       printDevLog: true,
//     );
//   }
//
//   Future<bool> _startForegroundTask() async {
//     // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
//     // onNotificationPressed function to be called.
//     //
//     // When the notification is pressed while permission is denied,
//     // the onNotificationPressed function is not called and the app opens.
//     //
//     // If you do not use the onNotificationPressed or launchApp function,
//     // you do not need to write this code.
//     if (!await FlutterForegroundTask.canDrawOverlays && !isDialogOpened) {
//       isDialogOpened = true;
//       _showPermissionDialog(Get.context);
//     }
//
//     // You can save data using the saveData function.
//     await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');
//
//     bool reqResult;
//     if (await FlutterForegroundTask.isRunningService) {
//       reqResult = await FlutterForegroundTask.restartService();
//     } else {
//       reqResult = await FlutterForegroundTask.startService(
//         notificationTitle: 'Foreground Service is running',
//         notificationText: 'Tap to return to the app',
//         callback: startCallback,
//       );
//     }
//
//     ReceivePort receivePort;
//     if (reqResult) {
//       receivePort = await FlutterForegroundTask.receivePort;
//     }
//
//     return _registerReceivePort(receivePort);
//   }
//
//   Future<bool> _stopForegroundTask() async {
//     return await FlutterForegroundTask.stopService();
//   }
//
//   _registerReceivePort(ReceivePort receivePort) {
//     _closeReceivePort();
//
//     if (receivePort != null) {
//       _receivePort = receivePort;
//       _receivePort?.listen((message) async {
//         print("falsfdsla message: $message}");
//         await FlutterForegroundTask.getData<String>(key: 'test').then((value) {
//           print("falsfdsla FlutterForegroundTask.getData in _registerReceivePort: $value}");
//         });
//
//         if (message is int) {
//           print('eventCount: $message');
//         } else if (message is String) {
//           if (message.contains('pusher_channel_name')) {
//             // Navigator.of(context).pushNamed('/resume-route');
//             // Get.toNamed(Routes.SERVICE_REQUESTS, arguments: {"push_notification_data": data});
//             // TestPreference.saveData("");
//             // prefs.clear();
//
//             // _receivePort.val("valueKey");
//
//           }
//         } else if (message is DateTime) {
//           print('timestamp: ${message.toString()}');
//         }
//       });
//
//       return true;
//     }
//
//     return false;
//   }
//
//   void _showPermissionDialog(BuildContext context) {
//
//     showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             "Display over other apps permission!".tr,
//             style: TextStyle(color: Colors.redAccent),
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 Text("Allow this permission to get visual service request call.".tr, style: Get.textTheme.bodyText1),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text("Cancel".tr, style: Get.textTheme.bodyText1),
//               onPressed: () {
//                 Get.back();
//               },
//             ),
//             TextButton(
//               child: Text(
//                 "Okay".tr,
//                 style: TextStyle(color: Colors.redAccent),
//               ),
//               onPressed: () async {
//                 final isGranted = await FlutterForegroundTask.openSystemAlertWindowSettings();
//                 if (!isGranted) {
//                   print('SYSTEM_ALERT_WINDOW permission denied!');
//                   return false;
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _closeReceivePort() {
//     _receivePort?.close();
//     _receivePort = null;
//   }
//
//   T _ambiguate<T>(T value) => value;
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _initForegroundTask();
//   //   _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
//   //     // You can get the previous ReceivePort without restarting the service.
//   //     if (await FlutterForegroundTask.isRunningService) {
//   //       final newReceivePort = await FlutterForegroundTask.receivePort;
//   //       _registerReceivePort(newReceivePort);
//   //     }
//   //   });
//   // }
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _initForegroundTask();
//   //   _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
//   //     // You can get the previous ReceivePort without restarting the service.
//   //     if (await FlutterForegroundTask.isRunningService) {
//   //       final newReceivePort = await FlutterForegroundTask.receivePort;
//   //       _registerReceivePort(newReceivePort);
//   //     }
//   //   });
//   // }
//
//   // @override
//   // void dispose() {
//   //   _closeReceivePort();
//   //   super.dispose();
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     // A widget that prevents the app from closing when the foreground service is running.
//     // This widget must be declared above the [Scaffold] widget.
//     // bool isServiceRunning =  FlutterForegroundTask.isRunningService
//     _initForegroundTask();
//     _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
//       // You can get the previous ReceivePort without restarting the service.
//       if (await FlutterForegroundTask.isRunningService) {
//         final newReceivePort = await FlutterForegroundTask.receivePort;
//         _registerReceivePort(newReceivePort);
//       }
//     });
//
//     FlutterForegroundTask.isRunningService.then((value) {
//       print("sjdhfjsa value: $value");
//       _startForegroundTask();
//     });
//
//
//
//     return WithForegroundTask(
//       child: Stack(
//         children: [
//           RootView(),
//           // Obx(() {
//           //   return !controller.isServiceRunning.value
//           //       ? Positioned(
//           //           top: 60,
//           //           left: 0,
//           //           right: 0,
//           //           child:
//           //           // Column(
//           //             // children: [
//           //             //   Padding(
//           //             //     padding: const EdgeInsets.all(8.0),
//           //             //     child: Text("Please Start service to get service request properly"),
//           //             //   ),
//           //               _buildContentView(),
//           //           //   ],
//           //           // )
//           //   )
//           //       : Positioned(top: 60, left: 0, right: 0, child: _buildStopServiceView());
//           // })
//           // Obx(() {
//           //   return controller.isServiceRunning.value
//           //       ? Positioned(
//           //           top: 60,
//           //           left: 0,
//           //           right: 0,
//           //           child:
//           //               _buildStopServiceView(),
//           //
//           //   )
//           //       : Positioned(top: 60, left: 0, right: 0, child: _buildStopServiceView());
//           // })
//
//         ],
//       ),
//       // Scaffold(
//       //   appBar: AppBar(
//       //     title: const Text('Flutter Foreground Task'),
//       //     centerTitle: true,
//       //   ),
//       //   body: RootView(),
//       //   // _buildContentView(),
//       // ),
//     );
//   }
//
//   Widget _buildContentView() {
//     buttonBuilder(String text, {VoidCallback onPressed}) {
//       return ElevatedButton(
//         child: Text(text),
//         onPressed: onPressed,
//       );
//     }
//
//     textBuilder(String text, {VoidCallback onPressed}) {
//       // return ElevatedButton(
//       //   child: Text(text),
//       //   onPressed: onPressed,
//       // );
//       return TextButton(
//         child: Text("Press below button"),
//       );
//     }
//
//     // return SingleChildScrollView(
//     //   child:  RootView(),
//     // );
//     //   Center(
//     //   child:
//     return Container(
//       color: Colors.grey,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Column(
//             children: [
//               // Padding(
//               //   padding: const EdgeInsets.all(8.0),
//               //   child: Text("Please Start service to get service request properly"),
//               // ),
//               // Padding(
//               //   padding: const EdgeInsets.all(8.0),
//               //   child: Text("Please Start service to get service request properly"),
//               // ),
//               // Text("request properly", style: TextStyle(fontSize: 16),),
//               textBuilder("jbhfbhds"),
//               buttonBuilder('Start Service', onPressed: _startForegroundTask),
//             ],
//           ),
//           // SizedBox(width: 10,),
//           // buttonBuilder('Stop Service', onPressed: _stopForegroundTask),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStopServiceView() {
//     buttonBuilder(String text, {VoidCallback onPressed}) {
//       return ElevatedButton(
//         child: Text(text),
//         onPressed: onPressed,
//       );
//     }
//
//     // return SingleChildScrollView(
//     //   child:  RootView(),
//     // );
//     //   Center(
//     //   child:
//     return Container(
//       color: Colors.white,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // buttonBuilder('Start Service', onPressed: _startForegroundTask),
//           // SizedBox(width: 10,),
//           buttonBuilder('Stop Service', onPressed: _stopForegroundTask),
//         ],
//       ),
//     );
//   }
// }
//
// // class ExamplePage extends StatefulWidget {
// //    ExamplePage({ Key key}) : super(key: key);
// //
// //   @override
// //   State<StatefulWidget> createState() => _ExamplePageState();
// // }
// // class ResumeRoutePage extends StatelessWidget {
// //   const ResumeRoutePage({Key key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Resume Route'),
// //         centerTitle: true,
// //       ),
// //       body: Center(
// //         child: ElevatedButton(
// //           onPressed: () {
// //             // Navigate back to first route when tapped.
// //             Navigator.of(context).pop();
// //           },
// //           child: const Text('Go back!'),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// // class _ExamplePageState extends State<ExamplePage> {
// //   ReceivePort _receivePort;
// //
// //   Future<void> _initForegroundTask() async {
// //     await FlutterForegroundTask.init(
// //       androidNotificationOptions: AndroidNotificationOptions(
// //         channelId: 'notification_channel_id',
// //         channelName: 'Foreground Notification',
// //         channelDescription:
// //         'This notification appears when the foreground service is running.',
// //         channelImportance: NotificationChannelImportance.LOW,
// //         priority: NotificationPriority.LOW,
// //         iconData: const NotificationIconData(
// //           resType: ResourceType.mipmap,
// //           resPrefix: ResourcePrefix.ic,
// //           name: 'launcher',
// //           backgroundColor: Colors.orange,
// //         ),
// //         buttons: [
// //           const NotificationButton(id: 'sendButton', text: 'Send'),
// //           const NotificationButton(id: 'testButton', text: 'Test'),
// //         ],
// //       ),
// //       iosNotificationOptions: const IOSNotificationOptions(
// //         showNotification: true,
// //         playSound: false,
// //       ),
// //       foregroundTaskOptions: const ForegroundTaskOptions(
// //         interval: 5000,
// //         autoRunOnBoot: true,
// //         allowWifiLock: true,
// //       ),
// //       printDevLog: true,
// //     );
// //   }
// //
// //   Future<bool> _startForegroundTask() async {
// //     // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
// //     // onNotificationPressed function to be called.
// //     //
// //     // When the notification is pressed while permission is denied,
// //     // the onNotificationPressed function is not called and the app opens.
// //     //
// //     // If you do not use the onNotificationPressed or launchApp function,
// //     // you do not need to write this code.
// //     if (!await FlutterForegroundTask.canDrawOverlays) {
// //       final isGranted =
// //       await FlutterForegroundTask.openSystemAlertWindowSettings();
// //       if (!isGranted) {
// //         print('SYSTEM_ALERT_WINDOW permission denied!');
// //         return false;
// //       }
// //     }
// //
// //     // You can save data using the saveData function.
// //     await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');
// //
// //     bool reqResult;
// //     if (await FlutterForegroundTask.isRunningService) {
// //       reqResult = await FlutterForegroundTask.restartService();
// //     } else {
// //       reqResult = await FlutterForegroundTask.startService(
// //         notificationTitle: 'Foreground Service is running',
// //         notificationText: 'Tap to return to the app',
// //         callback: startCallback,
// //       );
// //     }
// //
// //     ReceivePort receivePort;
// //     if (reqResult) {
// //       receivePort = await FlutterForegroundTask.receivePort;
// //     }
// //
// //     return _registerReceivePort(receivePort);
// //   }
// //
// //   Future<bool> _stopForegroundTask() async {
// //     return await FlutterForegroundTask.stopService();
// //   }
// //
// //   bool _registerReceivePort(ReceivePort receivePort) {
// //     _closeReceivePort();
// //
// //     if (receivePort != null) {
// //       _receivePort = receivePort;
// //       _receivePort?.listen((message) {
// //         print("sfsfalnfsna message: $message}");
// //
// //         if (message is int) {
// //           print('eventCount: $message');
// //         } else if (message is String) {
// //           if (message.contains('pusher_channel_name')) {
// //             // Navigator.of(context).pushNamed('/resume-route');
// //             Navigator.of(context).pushNamed('/resume-route');
// //           }
// //         } else if (message is DateTime) {
// //           print('timestamp: ${message.toString()}');
// //         }
// //       });
// //
// //       return true;
// //     }
// //
// //     return false;
// //   }
// //
// //   void _closeReceivePort() {
// //     _receivePort?.close();
// //     _receivePort = null;
// //   }
// //
// //   T _ambiguate<T>(T value) => value;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initForegroundTask();
// //     _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
// //       // You can get the previous ReceivePort without restarting the service.
// //       if (await FlutterForegroundTask.isRunningService) {
// //         final newReceivePort = await FlutterForegroundTask.receivePort;
// //         _registerReceivePort(newReceivePort);
// //       }
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _closeReceivePort();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // A widget that prevents the app from closing when the foreground service is running.
// //     // This widget must be declared above the [Scaffold] widget.
// //
// //     return WithForegroundTask(
// //       child: Stack(
// //         children: [
// //           RootView(),
// //           Positioned(bottom: 0, left: 0, right: 0, child: _buildContentView()),
// //
// //         ],
// //       ),
// //       // Scaffold(
// //       //   appBar: AppBar(
// //       //     title: const Text('Flutter Foreground Task'),
// //       //     centerTitle: true,
// //       //   ),
// //       //   body: RootView(),
// //       //   // _buildContentView(),
// //       // ),
// //     );
// //   }
// //
// //   Widget _buildContentView() {
// //     buttonBuilder(String text, {VoidCallback onPressed}) {
// //       return ElevatedButton(
// //         child: Text(text),
// //         onPressed: onPressed,
// //       );
// //     }
// //
// //     // return SingleChildScrollView(
// //     //   child:  RootView(),
// //     // );
// //     //   Center(
// //     //   child:
// //      return Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           buttonBuilder('start', onPressed: _startForegroundTask),
// //           buttonBuilder('stop', onPressed: _stopForegroundTask),
// //         ],
// //
// //     );
// //   }
// // }
