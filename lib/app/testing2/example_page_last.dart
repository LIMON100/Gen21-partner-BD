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
// // The callback function should always be a top-level function.
// void startCallback() {
//   // The setTaskHandler function must be called to handle the task in the background.
//   FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
// }
//
// class FirstTaskHandler extends TaskHandler {
//   SendPort _sendPort;
//
//   @override
//   Future<void> onStart(DateTime timestamp, SendPort sendPort) async {
//     _sendPort = sendPort;
//
//     // You can use the getData function to get the stored data.
//     final customData =
//     await FlutterForegroundTask.getData<String>(key: 'customData');
//     print('customData: $customData');
//   }
//
//   @override
//   Future<void> onEvent(DateTime timestamp, SendPort sendPort) async {
//     // Send data to the main isolate.
//     sendPort.send(timestamp);
//   }
//
//   @override
//   Future<void> onDestroy(DateTime timestamp, SendPort sendPort) async {
//     // You can use the clearAllData function to clear all the stored data.
//     await FlutterForegroundTask.clearAllData();
//   }
//
//   @override
//   Future<void> onButtonPressed(String id) async {
//     // Called when the notification button on the Android platform is pressed.
//     print('onButtonPressed >> $id');
//     if(id == "stop_button"){
//       await FlutterForegroundTask.stopService();
//     }
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
//     // FlutterForegroundTask.launchApp("/resume-route");
//     // _sendPort?.send('onNotificationPressed');
//     print("lksdnfjsn onNotificationPressed()");
//     FlutterForegroundTask.launchApp();
//   }
//
//   @override
//   void onRepeatEvent(DateTime timestamp, SendPort sendPort) {
//     // TODO: implement onRepeatEvent
//   }
// }
//
// class ExampleApp extends GetView<RootController> {
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
//           const NotificationButton(id: 'stop_button', text: 'Stop'),
//           // const NotificationButton(id: 'testButton', text: 'Test'),
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
//       // printDevLog: true,
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
//
//   @override
//   Widget build(BuildContext context) {
//     print("lksdnfjsn ExampleApp build()");
//     // A widget that prevents the app from closing when the foreground service is running.
//     // This widget must be declared above the [Scaffold] widget.
//     // bool isServiceRunning =  FlutterForegroundTask.isRunningService
//
//     _initForegroundTask();
//
//     print("lksdnfjsn 1");
//
//     _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
//       // You can get the previous ReceivePort without restarting the service.
//       if (await FlutterForegroundTask.isRunningService) {
//         final newReceivePort = await FlutterForegroundTask.receivePort;
//         _registerReceivePort(newReceivePort);
//       }
//     });
//
//     print("lksdnfjsn 2");
//     FlutterForegroundTask.isRunningService.then((value) {
//       print("sjdhfjsa value: $value");
//       if(value == false) {
//         // _startForegroundTask();
//       }
//     });
//     print("lksdnfjsn 3");
//
//     return WithForegroundTask(
//       child: Stack(
//         children: [
//           RootView(),
//         ],
//       ),
//
//     );
//   }
//
// }
//
//
