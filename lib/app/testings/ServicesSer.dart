// import 'package:firebase_core/firebase_core.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/bindings_interface.dart';
// import 'package:get/get_utils/src/platform/platform.dart';
// import 'package:get_storage/get_storage.dart';
//
// import '../modules/home/controllers/home_controller.dart';
// import '../modules/notifications/controllers/notifications_controller.dart';
// import 'FirebaseMessageSer.dart';
// import 'test_controller.dart';
//
// class ServicesSer extends Bindings {
//   @override
//   Future<void> dependencies() async {
//     // if (GetPlatform.isWeb) {
//     //   FacebookAuth.instance.webInitialize(
//     //     appId: "...",
//     //     cookie: true,
//     //     xfbml: true,
//     //     version: "v9.0",
//     //   );
//     // }
//
//     //storageCtrl user preferences
//     // await Get.putAsync<HomeController>(() async {
//     //   await GetStorage.init();
//     //   final storageCtrl = HomeController();
//     //   // await storageCtrl.storageCtrlInit();
//     //   return storageCtrl;
//     // }, permanent: true);
//
//     //notifications custom ctrl to handle the incoming pending notifications
//     await Get.putAsync<TestController>(() async {
//       final notificationsCtrl = TestController();
//       // await notificationsCtrl.notificationsInit();
//       return notificationsCtrl;
//     }, permanent: true);
//
//     //firebase messaging init <--- here
//     await Get.putAsync<FirebaseMessageSer>(() async {
//       await Firebase.initializeApp();
//       final firebaseMessengerSer = FirebaseMessageSer();
//       await firebaseMessengerSer.firebaseMessageSerInit();
//       return firebaseMessengerSer;
//     }, permanent: true);
//
//     //user preferences
//     await GetStorage.init();
//
//     /// other services
//     // ....
//     print('ServicesSer has finished');
//   }
// }
