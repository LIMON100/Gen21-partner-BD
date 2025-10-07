// import 'package:app_to_foreground/app_to_foreground.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_ios/shared_preferences_ios.dart';

import 'app/modules/root/controllers/root_controller.dart';
import 'app/providers/firebase_provider.dart';
import 'app/providers/laravel_provider.dart';
import 'app/routes/app_routes.dart';
import 'app/routes/theme1_app_pages.dart';
import 'app/services/auth_service.dart';
import 'app/services/firebase_messaging_service.dart';
import 'app/services/global_service.dart';
import 'app/services/settings_service.dart';
import 'app/services/translation_service.dart';
import 'common/TestPreference.dart';
import 'common/log_data.dart';
import'dart:io' show Platform;

// @dart=2.9


void initServices() async {
  Get.log('starting services ...');
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await GetStorage.init();
  await Get.putAsync(() => TranslationService().init());
  await Get.putAsync(() => GlobalService().init());
  await Firebase.initializeApp();
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => LaravelApiClient().init());
  await Get.putAsync(() => FirebaseProvider().init());
  await Get.putAsync(() => SettingsService().init());
  // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
  //   if (!isAllowed) {
  //     // This is just a basic example. For real apps, you must show some
  //     // friendly dialog box before call the request method.
  //     // This is very important to not harm the user experience
  //     AwesomeNotifications().requestPermissionToSendNotifications();
  //   }
  // });
  try {
    bool _permissionPrompted = false;
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    // printWrapped("gen21 6766 messaging.getAPNSToken() ${await messaging.getAPNSToken()} essaging.getToken:${await messaging.getToken()}");
    // printWrapped("gen21 6766 token:${await messaging.getToken()}");


    if (!_permissionPrompted) {
      // if (messaging.authorizationStatus != AuthorizationStatus.authorized) {
      messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: false,
      );
      // }

      _permissionPrompted = true;
    }
  }catch(e){
    Get.log('gen21 log push notification permission error ...${e.toString()}');
  }
  Get.log('All services started...');
}


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  FlutterRingtonePlayer.playNotification();
  RemoteNotification notification = message.notification;

  print("jnfdjkasfd provider app Handling a background message.messageId: ${message.messageId}");
  printWrapped("jnfdjkasfd provider app Handling a background message.messageId: ${message.notification.toMap().toString()}");
  printWrapped("jnfdjkasfd provider app Handling a background message.messageId: ${message.notification.title}");
  printWrapped("jnfdjkasfd provider app Handling a background message.notification.body: ${message.notification.body}");
  printWrapped("jnfdjkasfd provider app Handling a background message.data.toString(): ${message.data}");

  // printWrapped("falsfdsla Handling a background message.messageId: ${jsonDecode(message.data.toString())}");
  // printWrapped("falsfdsla Handling a background message.notification.data.toString(): ${message.notification.body.toString()}");


  // AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //         id: 10,
  //         channelKey: 'basic_channel',
  //         title: 'Simple Notification',
  //         body: 'Simple body'
  //     )
  // );


  // final preference = await SharedPreferences.getInstance();

  if (message.data.toString().contains("pusher_channel_name")) {
    print("jfnjsadhjdsdhs _setting push_data");
    // _showOrderRequest(notification.body);
    // await preference.setString("push_data", notification.body);
    // Get.find<RootController>().redirectToServiceRequestView(notification.body);
    // await Hive.initFlutter();
    var dir = (await SharedPreferences.getInstance()).getString("keyForDir");
    await Hive.initFlutter(dir);
    // await Hive.init(dir);
    var box = await Hive.openBox('myBox');
    box.put('push_data', message.data);
    box.close();

    // FlutterForegroundTask.launchApp();
  }
}


void main() async {
  print("lksdnfjsn main()");

  // SharedPreferences.setMockInitialValues({});
  WidgetsFlutterBinding.ensureInitialized();
  bool result = await InternetConnectionChecker().hasConnection;
  print("fklkaslkld $result");
  if (result) {
    await initServices();
    print("fklkaslkld 1");
    if (Platform.isAndroid) {
      SharedPreferencesAndroid.registerWith();
    } else if (Platform.isIOS) {
      SharedPreferencesIOS.registerWith();
    }
    var dir = (await SharedPreferences.getInstance()).getString("keyForDir");
    await Hive.initFlutter(dir);
    // await Hive.init(dir);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } else {
    print("fklkaslkld 2");
  }

  runApp(
    result
        ?  GetMaterialApp(
      title: Get
          .find<SettingsService>()
          .setting
          .value
          .providerAppName,
      initialRoute: Routes.ROOT,
      // initialRoute: Theme1AppPages.INITIAL,
      // initialRoute: Theme1AppPages.INITIAL2,
      onReady: () async {
        print("lksdnfjsn onReady()");
        await Get.putAsync(() => FireBaseMessagingService().init());
        try {
          var access_token = await FirebaseMessaging.instance.getToken();
          print("lksdnfjsn $access_token");
        } catch (e) {
          print("lksdnfjsn $e");
        }
      },
      getPages: Theme1AppPages.routes,
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: Get.find<TranslationService>().supportedLocales(),
      translationsKeys: Get
          .find<TranslationService>()
          .translations,
      locale: Get.find<SettingsService>().getLocale(),
      fallbackLocale: Get
          .find<TranslationService>()
          .fallbackLocale,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      themeMode: Get.find<SettingsService>().getThemeMode(),
      theme: Get.find<SettingsService>().getLightTheme(),
      darkTheme: Get.find<SettingsService>().getDarkTheme(),
    )
        : GetMaterialApp(
      title: "No Internet Connection",
      initialRoute: Theme1AppPages.NO_INTERNET,
      getPages: Theme1AppPages.routes,
      // localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      // supportedLocales: Get.find<TranslationService>().supportedLocales(),
      // translationsKeys: Get.find<TranslationService>().translations,
      // locale: Get.find<SettingsService>().getLocale(),
      // fallbackLocale: Get.find<TranslationService>().fallbackLocale,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      // themeMode: Get.find<SettingsService>().getThemeMode(),
      // theme: Get.find<SettingsService>().getLightTheme(),
      // darkTheme: Get.find<SettingsService>().getDarkTheme(),
    ),
  );
}