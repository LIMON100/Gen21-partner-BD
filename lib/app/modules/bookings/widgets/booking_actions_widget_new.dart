import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../services/global_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../controllers/booking_controller.dart';
import '../controllers/booking_controller_new.dart';

class BookingActionsWidgetNew extends GetView<BookingControllerNew> {
  const BookingActionsWidgetNew({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _booking = controller.booking;
    return Obx(() {
      if (_booking.value.status == null) {
        return SizedBox(height: 0);
      }
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Get.theme.focusColor.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -5)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
             Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _booking.value.payment != null &&
                              (_booking.value.payment.paymentStatus?.id ??
                                      '') ==
                                  '2'
                          ?Text(
                          "",
                          textAlign: TextAlign.center,
                          style: Get.textTheme.bodyText1,
                        )
                          : Text(
                              "".tr,
                              textAlign: TextAlign.center,
                              style: Get.textTheme.bodyText1,
                            ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        if (_booking.value.status.order ==
                            Get.find<GlobalService>().global.value.received)
                          Expanded(
                            child: BlockButtonWidget(
                                text: Stack(
                                  alignment: AlignmentDirectional.centerEnd,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        "Accept".tr,
                                        textAlign: TextAlign.center,
                                        style: Get.textTheme.headline6.merge(
                                          TextStyle(
                                              color: Get.theme.primaryColor),
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.check,
                                        color: Get.theme.primaryColor, size: 22)
                                  ],
                                ),
                                color: Get.theme.colorScheme.secondary,
                                onPressed: () {
                                  controller.acceptBookingServiceNew();
                                }),
                          ),
                        if (_booking.value.status.order ==
                            Get.find<GlobalService>().global.value.accepted)
                          Expanded(
                              child: BlockButtonWidget(
                                  text: Stack(
                                    alignment: AlignmentDirectional.centerEnd,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          "On the Way".tr,
                                          textAlign: TextAlign.center,
                                          style: Get.textTheme.headline6.merge(
                                            TextStyle(
                                                color: Get.theme.primaryColor),
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.airport_shuttle_outlined,
                                          color: Get.theme.primaryColor,
                                          size: 24)
                                    ],
                                  ),
                                  color: Get.theme.colorScheme.secondary,
                                  onPressed: () {
                                    controller.onTheWayBookingServiceNew();
                                  })),
                        if (_booking.value.status.order ==
                            Get.find<GlobalService>().global.value.onTheWay)
                          Expanded(
                            child: BlockButtonWidget(
                                text: Stack(
                                  alignment: AlignmentDirectional.centerEnd,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        "Ready".tr,
                                        textAlign: TextAlign.center,
                                        style: Get.textTheme.headline6.merge(
                                          TextStyle(
                                              color: Get.theme.primaryColor),
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.build_outlined,
                                        color: Get.theme.primaryColor, size: 24)
                                  ],
                                ),
                                color: Get.theme.hintColor,
                                onPressed: () {
                                  controller.readyBookingServiceNew();
                                }),
                          ),
                        if (_booking.value.status.order ==
                                Get.find<GlobalService>().global.value.ready ||
                            _booking.value.status.order ==
                                Get.find<GlobalService>()
                                    .global
                                    .value
                                    .inProgress)
                          Expanded(
                            child: Text(
                              "",
                              textAlign: TextAlign.center,
                              style: Get.textTheme.bodyText1,
                            ),
                          ),
                        if (_booking.value.booking_status_id == "7")
                          Expanded(
                            child: Text(
                              "Booking Canceled".tr,
                              textAlign: TextAlign.center,
                              style: Get.textTheme.bodyText1,
                            ),
                          ),

                        if (_booking.value.status.order >=
                                Get.find<GlobalService>().global.value.done &&
                            _booking.value.payment != null &&
                            (_booking.value.payment.paymentStatus?.id ?? '') ==
                                '1' &&
                            (_booking.value.payment.paymentMethod?.route ??
                                    '') ==
                                '/Cash')
                          Expanded(
                            child: BlockButtonWidget(
                                text: Stack(
                                  alignment: AlignmentDirectional.centerEnd,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        "Confirm Payment".tr,
                                        textAlign: TextAlign.center,
                                        style: Get.textTheme.headline6.merge(
                                          TextStyle(
                                              color: Get.theme.primaryColor),
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.money,
                                        color: Get.theme.primaryColor, size: 22)
                                  ],
                                ),
                                color: Get.theme.colorScheme.secondary,
                                onPressed: () {
                                  controller.confirmPaymentBookingServiceNew();
                                }),
                          ),
                        SizedBox(width: 10),

                      ]).paddingSymmetric(vertical: 10, horizontal: 20),
                    ],
                  )
              //   : Text(
              //       // "Waiting for Payment".tr,
              // _booking.value.payment.toString(),
              //       textAlign: TextAlign.center,
              //       style: Get.textTheme.bodyText1,
              //     ),
          ],
        ),
      );
    });
  }
}
