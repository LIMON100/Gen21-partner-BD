import 'dart:convert';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';

import '../../common/constant.dart';
import '../../common/navigetion_service.dart';
import '../../common/service_locator.dart';
import '../../common/ui.dart';
import '../models/booking_model.dart';
import '../models/booking_new_model.dart';
import '../models/message_model.dart';
import '../models/order_request_push_model.dart';
import '../modules/bookings/controllers/booking_controller.dart';
import '../modules/bookings/controllers/booking_controller_new.dart';
import '../modules/bookings/controllers/bookings_controllerNew.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/messages/controllers/messages_controller.dart';
import '../modules/reviews/controllers/review_controller.dart';
import '../modules/reviews/controllers/reviews_controller.dart';
import '../modules/root/controllers/root_controller.dart';
import '../modules/service_request/views/test_view.dart';
import '../modules/service_request/widgets/bottomsheet_widget.dart';
import '../routes/app_routes.dart';
import 'auth_service.dart';

class FireBaseMessagingService extends GetxService {
  Future<FireBaseMessagingService> init() async {
    // print("sdnfaaaaaaag init() ${context.toString()}");
    FirebaseMessaging.instance.requestPermission(sound: false, badge: true, alert: false);
    await fcmOnLaunchListeners();
    await fcmOnResumeListeners();
    await fcmOnMessageListeners();
    // await fcmOnBackgroundListener();
    return this;
  }

  // Future fcmOnBackgroundListener() async{
  //   await Firebase.initializeApp();
  //   FirebaseMessaging.onBackgroundMessage((message) => test(message.notification.body));
  // }

  // test(String data){
  //   printWrapped("snjfnsdnf $data");
  //   _showOrderRequest(data);
  // }

  Future fcmOnMessageListeners() async {

    final authService = Get.find<AuthService>();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("INSIDEFBPUSH");
      FlutterRingtonePlayer.playNotification();
      // AwesomeNotifications().createNotification(
      //     content: NotificationContent(
      //         id: 10,
      //         channelKey: 'basic_channel',
      //         title: 'Simple Notification',
      //         body: 'Simple body'
      //     )
      // );

      // printWrapped("jwnfasf sending Data3: ${message.notification.body.toString()}");
      //
      // print("sdnfaaaaaaag ${message.toString()}");
      RemoteNotification notification = message.notification;
      // print("sdnfaaaaaaag 2: ${notification.toString()}");
      printWrapped("jnfdjkasfd provider app fcmOnMessageListeners() id: ${authService.user.value.id} 3: ${notification.body}");
      printWrapped("jnfdjkasfd provider app fcmOnMessageListeners() data: ${message.data.toString()}");

      if(message.data.toString().contains("pusher_channel_name") &&  Get.isRegistered<RootController>()) {
        print("gen21 provider app _showOrderRequest() calling");
        _showOrderRequest(message.data, true);
      }else{
        if (Get.isRegistered<RootController>()) {
          Get.find<RootController>().getNotificationsCount();
        }
        if (message.data['id'] == "App\\Notifications\\NewMessage") {
          _newMessageNotification(message);
        } else {
          _bookingNotification(message);
        }
      }
    });

  }

  Future fcmOnLaunchListeners() async {
    print("dsjfnsaaa provider app fcmOnLaunchListeners called");
    RemoteMessage message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _notificationsBackground(message);
    }
  }

  Future fcmOnResumeListeners() async {
    print("jnfdjkasfd provider app fcmOnResumeListeners called");

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("falsfdsla provider app FirebaseMessaging.onMessageOpenedApp.listen ${message.notification.body}");

      _notificationsBackground(message);
    });
  }

  void _notificationsBackground(RemoteMessage message) {
    print("dsjfnsaaa provider app _notificationsBackground message.toString() ${message.toString()}");
    print("dsjfnsaaa provider app _notificationsBackground essage.notification.toString() ${message.notification.toString()}");
    print("dsjfnsaaa provider app _notificationsBackground message.data.toString() ${message.data.toString()}");
    // _showOrderRequest(message.notification.body);
    // RemoteNotification notification = message.notification;
    // printWrapped("dsjfnsaaa provider app _notificationsBackground() 3: ${notification.body}");

    if(message.data.toString().contains("pusher_channel_name") &&  Get.isRegistered<RootController>()) {
      print("dsjfnsaaa provider app _showOrderRequest() calling");

      _showOrderRequest(message.data, false);
    }
    else if (message.data['id'] == "App\\Notifications\\NewMessage") {
      print("dsjfnsaaa in 1");
      _newMessageNotificationBackground(message);
    } else {
      print("dsjfnsaaa in 2");
      _newBookingNotificationBackground(message);
    }

  }

  void _newBookingNotificationBackground(message) {
    print("dsjfnsaaa in 3");
    // print("jnfdjkasfd provider app _newBookingNotificationBackground ${message.notification.body}");
    // print("jnfdjkasfd provider app _newBookingNotificationBackground ${message.notification.body}");

    // if (Get.isRegistered<RootController>()) {
    //   Get.toNamed(Routes.BOOKING, arguments: new Booking(id: message.data['bookingId']));
    // }

    // if (Get.isRegistered<RootController>()) {
    //   Get.toNamed(Routes.BOOKING, arguments: new Booking(id: message.data['bookingId']));
    // }

    if (Get.isRegistered<RootController>()) {
      print("dsjfnsaaa 4 user app _newBookingNotificationBackground() bookingId: ${message.data['bookingId']}");

      if(message.data['id'] == "App\\Notifications\\ProviderReview"){
        print("dsjfnsaaa in 5");
        Get.find<ReviewsController>().refreshReviews();
        Get.find<RootController>().changePageOutRoot(1);
      }else {
        print("dsjfnsaaa in 6");
        Get.toNamed(Routes.BOOKING_DETAILS, arguments: new BookingNew(id: message.data['bookingId']));
      }
    }


  }

  void _newMessageNotificationBackground(RemoteMessage message) {
    print("jnfdjkasfd provider app _newMessageNotificationBackground ${message.notification.body}");

    if (message.data['messageId'] != null) {
      Get.toNamed(Routes.CHAT, arguments: new Message([], id: message.data['messageId']));
    }
  }

  Future<void> setDeviceToken() async {
    print("jnfdjkasfd provider app setDeviceToken");
    Get.find<AuthService>().user.value.deviceToken = await FirebaseMessaging.instance.getToken();
  }

  void _bookingNotification(RemoteMessage message) {
    print("jnfdjkasfd provider app _bookingNotification ${message.notification.body}");

    if (Get.currentRoute == Routes.ROOT) {
      Get.find<HomeController>().refreshHome();
    }

    print("jsdnjfnsa user app 2  _bookingNotification()");
    if (Get.currentRoute == Routes.BOOKINGS_NEW) {
      Get.find<BookingsControllerNew>().refreshBookings();
    }
    if (Get.currentRoute == Routes.BOOKING_DETAILS) {
      print("jsdnjfnsa user app 3 _bookingNotification()");
      Get.find<BookingControllerNew>().refreshBooking(showProgressView: true);
    }

    // if (Get.currentRoute == Routes.BOOKING) {
    //   Get.find<BookingController>().refreshBooking();
    // }
    RemoteNotification notification = message.notification;
    Get.showSnackbar(Ui.notificationSnackBar(
      title: notification.title,
      message: notification.body,
      mainButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        width: 52,
        height: 52,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: CachedNetworkImage(
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl: message.data != null ? message.data['icon'] : "",
            placeholder: (context, url) => Image.asset(
              'assets/img/loading.gif',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error_outline),
          ),
        ),
      ),
      onTap: (getBar) async {
        if (message.data['bookingId'] != null) {
          await Get.back();
          // Get.toNamed(Routes.BOOKING, arguments: new Booking(id: message.data['bookingId']));
          if (Get.isRegistered<RootController>()) {
            print("ksdmflnsaue user app _newBookingNotificationBackground() bookingId: ${message.data['bookingId']}");

            if(message.data['id'] == "App\\Notifications\\ProviderReview"){
              Get.find<ReviewsController>().refreshReviews();
              Get.find<RootController>().changePageOutRoot(1);
            }else {
              Get.toNamed(Routes.BOOKING_DETAILS, arguments: new BookingNew(id: message.data['bookingId']));
            }
          }
        }
      },
    ));
  }

  void _newMessageNotification(RemoteMessage message) {
    print("jnfdjkasfd provider app _newMessageNotification ${message.notification.body}");

    RemoteNotification notification = message.notification;
    if (Get.find<MessagesController>().initialized) {
      Get.find<MessagesController>().refreshMessages();
    }
    if (Get.currentRoute != Routes.CHAT) {
      Get.showSnackbar(Ui.notificationSnackBar(
        title: notification.title,
        message: notification.body,
        mainButton: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: 42,
          height: 42,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(42)),
            child: CachedNetworkImage(
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl: message.data != null ? message.data['icon'] : "",
              placeholder: (context, url) => Image.asset(
                'assets/img/loading.gif',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error_outline),
            ),
          ),
        ),
        onTap: (getBar) async {
          if (message.data['messageId'] != null) {
            await Get.back();
            Get.toNamed(Routes.CHAT, arguments: new Message([], id: message.data['messageId']));
          }
        },
      ));
    }
  }

  void _showOrderRequest(dynamic pushBody, bool isHaveToRing) {

    print("jnfdjkasfd provider app _showOrderRequest() called");
    // if (Get.currentRoute == Routes.ROOT) {

      // Map<String, dynamic> map = jsonDecode(orderBody);
     // print("jnfabhkio ${map['pusher_channel_name']}");
      Get.find<RootController>().redirectToServiceRequestView(pushBody, isHaveToRing);
      // Get.find<HomeController>().acceptRequestBody = map['pusher_channel_name'];

    // }
    // if (Get.currentRoute == Routes.BOOKING) {
    //   Get.find<BookingController>().refreshBooking();
    // }

    // Get.to(TestView());
    // RemoteNotification notification = message.notification;
    // Get.showSnackbar(Ui.notificationSnackBar(
    //   title: notification.title,
    //   message: notification.body,
    //   mainButton: Container(
    //     margin: const EdgeInsets.symmetric(horizontal: 8.0),
    //     width: 52,
    //     height: 52,
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.all(Radius.circular(5)),
    //       child: CachedNetworkImage(
    //         width: double.infinity,
    //         fit: BoxFit.cover,
    //         imageUrl: message.data != null ? message.data['icon'] : "",
    //         placeholder: (context, url) => Image.asset(
    //           'assets/img/loading.gif',
    //           fit: BoxFit.cover,
    //           width: double.infinity,
    //         ),
    //         errorWidget: (context, url, error) => Icon(Icons.error_outline),
    //       ),
    //     ),
    //   ),
    //   onTap: (getBar) async {
    //     if (message.data['bookingId'] != null) {
    //       await Get.back();
    //       Get.toNamed(Routes.BOOKING, arguments: new Booking(id: message.data['bookingId']));
    //     }
    //   },
    // ));
  }

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

}
