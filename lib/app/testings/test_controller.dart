import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../modules/service_request/views/test_view.dart';
// import '../../../models/notification_model.dart';
// import '../../../repositories/notification_repository.dart';
// import '../../root/controllers/root_controller.dart';

class TestController extends GetxController {
  final notifications = <TestController>[].obs;
  // NotificationRepository _notificationRepository;

  NotificationsController() {
    // _notificationRepository = new NotificationRepository();
  }

  @override
  void onInit() async {
    // await refreshNotifications();
    super.onInit();
  }

  // Future refreshNotifications({bool showMessage}) async {
  //   await getNotifications();
  //   Get.find<RootController>().getNotificationsCount();
  //   if (showMessage == true) {
  //     Get.showSnackbar(Ui.SuccessSnackBar(message: "List of notifications refreshed successfully".tr));
  //   }
  // }
  //
  // Future getNotifications() async {
  //   try {
  //     notifications.assignAll(await _notificationRepository.getAll());
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }
  //
  // Future removeNotification(Notification notification) async {
  //   try {
  //     await _notificationRepository.remove(notification);
  //     if (!notification.read) {
  //       --Get.find<RootController>().notificationsCount.value;
  //     }
  //     notifications.remove(notification);
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }
  //
  // Future markAsReadNotification(Notification notification) async {
  //   try {
  //     if (!notification.read) {
  //       await _notificationRepository.markAsRead(notification);
  //       notification.read = true;
  //       --Get.find<RootController>().notificationsCount.value;
  //       notifications.refresh();
  //     }
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }
  showNotification({String message}){
    print("kdjnjnjfa message: $message");
    Get.to(TestView());
  }
}
