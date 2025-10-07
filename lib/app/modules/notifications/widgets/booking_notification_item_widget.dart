import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/booking_model.dart';
import '../../../models/booking_new_model.dart';
import '../../../models/notification_model.dart' as model;
import '../../../routes/app_routes.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/notifications_controller.dart';
import 'notification_item_widget.dart';

class BookingNotificationItemWidget extends GetView<NotificationsController> {
  BookingNotificationItemWidget({Key key, this.notification}) : super(key: key);
  final model.Notification notification;

  @override
  Widget build(BuildContext context) {
    print("ksmfklasfsl in build() notification.type: ${notification.type}");
    return NotificationItemWidget(
      notification: notification,
      onDismissed: (notification) {
        controller.removeNotification(notification);
      },
      icon: Icon(
        Icons.assignment_outlined,
        color: Get.theme.scaffoldBackgroundColor,
        size: 34,
      ),
      onTap: (notification) async {
        // Get.toNamed(Routes.BOOKING, arguments: new Booking(id: notification.data['booking_id'].toString()));
        // await controller.markAsReadNotification(notification);
        print("ksmfklasfsl in onTap() notification.type: ${notification.type}");
        if (Get.isRegistered<RootController>()) {
          // print("ksdmflnsaue user app _newBookingNotificationBackground() bookingId: ${message.data['bookingId']}");
          // Get.toNamed(Routes.BOOKING_DETAILS, arguments: new BookingNew(id: message.data['bookingId']));
          if(notification.type == "App\\Notifications\\NewReviewForProvider"){
            Get.find<RootController>().changePageOutRoot(1);

          }else {
            Get.toNamed(Routes.BOOKING_DETAILS, arguments: new BookingNew(id: notification.data['booking_id'].toString()));
          }

          await controller.markAsReadNotification(notification);


        }
      },
    );
  }
}
