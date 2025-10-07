import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../modules/notifications/controllers/notifications_controller.dart';
import '../modules/service_request/views/test_view.dart';
import 'ServicesSer.dart';


class FirebaseMessageSer extends GetxService {
  Utils utils = Utils();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> firebaseMessageSerInit() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      print('getInitialMessage');
    });

    // FirebaseMessaging.onMessage.listen((message) async {
    //   print('onMessage');
    //   final notificationsCtrl = Get.find<NotificationsCtrl>();
    //   notificationsCtrl.showNotification(message: message);
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    //   print('onMessageOpenedApp');
    //   final notificationsCtrl = Get.find<NotificationsCtrl>();
    //   notificationsCtrl.showNotification(message: message);
    // });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    print(await FirebaseMessaging.instance.getToken());
  }
}

class Utils {
}
// here when app is closed completely and a message is trigger  this function will be called
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  await ServicesSer().dependencies(); //here i ensure all dependencies are up
  final notificationsCtrl = Get.find<NotificationsController>();
  notificationsCtrl.show(message: message.toString());
  Get.to(TestView());
}
