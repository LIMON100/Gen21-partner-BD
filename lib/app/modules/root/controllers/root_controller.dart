/*
 * Copyright (c) 2020 .
 */

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
//todo unhide pusher
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../application.dart';
import '../../../../common/TestPreference.dart';
import '../../../../common/log_data.dart';
import '../../../models/custom_page_model.dart';
import '../../../models/order_request_push_model.dart';
import '../../../models/order_update_pusher_event.dart';
import '../../../repositories/custom_page_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../testing2/example_page.dart';
import '../../../testing2/message_handler.dart';
import '../../account/views/account_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home_view.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../messages/views/messages_view.dart';
import '../../reviews/views/reviews_view.dart';
import '../../service_request/views/test_view.dart';
import '../../service_request/widgets/bottomsheet_widget.dart';

class RootController extends GetxController with WidgetsBindingObserver {
  final currentIndex = 0.obs;
  final notificationsCount = 0.obs;
  final customPages = <CustomPage>[].obs;
  NotificationRepository _notificationRepository;
  CustomPageRepository _customPageRepository;

  var isServiceRunning = false.obs;
  HomeController _homeController = Get.find<HomeController>();


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    print("jksnkjf didChangeAppLifecycleState called");
    print("lksdnfjsn 4");

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.detached) return;

    final isBackground = state == AppLifecycleState.paused;

    // var push_data = preference.get("push_data");
    // print("kfksanfdjs sharedPrefData push_data:  $push_data");

    // GetStorage _box = new GetStorage();
    //  var boxData = await _box.read("_box_data");
    // print("kfksanfdjs boxData:  $boxData");
    print("lksdnfjsn 5");
    isServiceAlreadyRunning();
    print("lksdnfjsn 6");
    if (isBackground) {
      // TextPreferences.setText(controller.text);
      print("fnjkanfdkjsa in background");
      print("lksdnfjsn 7");
    } else {
      print("fnjkanfdkjsa in foreground");
      print("lksdnfjsn 8");

      // final preference = await SharedPreferences.getInstance();
      // preference.reload();
      // var push_data = await preference.get("push_data");
      // printWrapped("fnjkanfdkjsa_RootController sharedPrefData push_data:  $push_data");

      var box = await Hive.openBox('myBox');
      var hive_push_data = box.get('push_data');
      box.put('push_data', "");
      printWrapped("jdnjksfajkf_RootController hive_push_data:  $hive_push_data");
      box.close();

      // Future<void> loadCountryData({BuildContext context}) async {
      //   try {
      //     String data = await DefaultAssetBundle
      //         .of(context)
      //         .loadString("assets/data/countries.json");
      //     return json.decode(data);
      //   } catch(e) {
      //     print(e);
      //     return null; // imagine this exists
      //   }
      // }

      // Get.toNamed(Routes.SERVICE_REQUESTS, arguments: {"push_notification_data": hive_push_data});

      // print("jdnjksfajkf redirectToServiceRequestView jsonDecode(pushBody) ${jsonDecode(hive_push_data.toString())}");

      print("lksdnfjsn 9");

      if (hive_push_data.toString().contains("pusher_channel_name")) {
        // Get.toNamed(Routes.SERVICE_REQUESTS, arguments: {"push_notification_data": push_data});
        print("lksdnfjsn 10");
        redirectToServiceRequestView(hive_push_data, true);
        print("lksdnfjsn 11");
      } else {
        print("fnjkanfdkjsa else: $hive_push_data");
        print("lksdnfjsn 12");
      }
    }

    /* if (isBackground) {
      // service.stop();
    } else {
      // service.start();
    }*/
  }

  // Future<void> setupInteractedMessage() async {
  //   // Get any messages which caused the application to open from
  //   // a terminated state.
  //   RemoteMessage initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  //
  //   // If the message also contains a data property with a "type" of "chat",
  //   // navigate to a chat screen
  //   if (initialMessage != null) {
  //     _handleMessage(initialMessage);
  //   }
  //
  //   // Also handle any interaction when the app is in the background via a
  //   // Stream listener
  //   FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  // }

  // void _handleMessage(RemoteMessage message) {
  //   print("jsfhsbah 1: ${message.notification.body}");
  //   Get.to(TestView()
  //       // arguments: ChatArguments(message),
  //       );
  //   print("jsfhsbah 2: ${message.notification.body}");
  //
  //   Navigator.pushNamed(
  //     Get.context, Routes.HELP,
  //     // arguments: ChatArguments(message),
  //   );
  //   if (message.data['type'] == 'chat') {
  //     Navigator.pushNamed(
  //       Get.context, '/chat',
  //       // arguments: ChatArguments(message),
  //     );
  //   }
  //   print("jsfhsbah 3: ${message.notification.body}");
  // }

  RootController() {
    _notificationRepository = new NotificationRepository();
    _customPageRepository = new CustomPageRepository();
  }

  @override
  void onInit() async {
    // setupInteractedMessage();
    print("klsdfjsnaj onInit() called");
    print("lksdnfjsn 13");

    await getCustomPages();
    if (Get.arguments != null && Get.arguments is int) {
      print("lksdnfjsn 14");
      changePageInRoot(Get.arguments as int);
      print("lksdnfjsn 15");
    } else {
      print("lksdnfjsn 16");
      changePageInRoot(0);
      print("lksdnfjsn 17");

    }

    print("lksdnfjsn 18");
    isServiceAlreadyRunning();
    print("lksdnfjsn 19");
    WidgetsBinding.instance.addObserver(this);
    print("lksdnfjsn 20");
    var box = await Hive.openBox('myBox');
    var hive_push_data = box.get('push_data');
    box.put('push_data', "");
    printWrapped("jdnjksfajkf_RootController hive_push_data:  $hive_push_data");
    box.close();
    print("lksdnfjsn 21");
    if (hive_push_data.toString().contains("pusher_channel_name")) {
      redirectToServiceRequestView(hive_push_data, true);
    } else {
      print("fnjkanfdkjsa else: $hive_push_data");
    }

    print("lksdnfjsn 22");

    super.onInit();
  }

  void isServiceAlreadyRunning() async {
    print("lksdnfjsn 23");
    // isServiceRunning.value = await FlutterForegroundTask.isRunningService;
    // print("jdsbfkaj isServiceRunning.value: ${isServiceRunning.value}");
    print("lksdnfjsn 24");
  }

  @override
  void dispose() {
    print("lksdnfjsn 25");
    WidgetsBinding.instance.removeObserver(this);
    print("lksdnfjsn 26");
    super.dispose();
  }

  List<Widget> pages = [
    // ExampleApp(child:HomeView()),
    // ExampleApp(),
    HomeView(),
    ReviewsView(),
    MessagesView(),
    AccountView(),
  ];

  Widget get currentPage => pages[currentIndex.value];

  /**
   * change page in route
   * */
  void changePageInRoot(int _index) {
    currentIndex.value = _index;
  }

  void changePageOutRoot(int _index) {
    currentIndex.value = _index;
    Get.offNamedUntil(Routes.ROOT, (Route route) {
      if (route.settings.name == Routes.ROOT) {
        return true;
      }
      return false;
    }, arguments: _index);
  }

  Future<void> changePage(int _index) async {
    if (Get.currentRoute == Routes.ROOT) {
      changePageInRoot(_index);
    } else {
      changePageOutRoot(_index);
    }
    await refreshPage(_index);
  }

  Future<void> refreshPage(int _index) async {
    switch (_index) {
      case 0:
        {
          await Get.find<HomeController>().refreshHome();
          break;
        }
      case 2:
        {
          await Get.find<MessagesController>().refreshMessages();
          break;
        }
    }
  }

  void getNotificationsCount() async {
    notificationsCount.value = await _notificationRepository.getCount();
  }

  Future<void> getCustomPages() async {
    customPages.assignAll(await _customPageRepository.all());
  }

  redirectToServiceRequestView(dynamic data, bool isHaveToRing) {
    print("lksdnfjsn 27");
    printWrapped("jdnjksfajkf sending data to Routes.SERVICE_REQUESTS: ${data}");
    // print("jdnjksfajkf redirectToServiceRequestView jsonDecode(pushBody) ${jsonDecode(data)}");
    // Get.toNamed(Routes.SERVICE_REQUESTS, arguments: {"push_notification_data": data, "isHaveToRing": isHaveToRing});
    Get.toNamed(Routes.SERVICE_REQUESTS, arguments: {"push_notification_data": data, "isHaveToRing": false});
    print("lksdnfjsn 28");
  }
}
