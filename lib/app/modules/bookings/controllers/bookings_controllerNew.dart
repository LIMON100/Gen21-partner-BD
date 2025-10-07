import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_new_model.dart';
import '../../../models/booking_status_model.dart';
import '../../../models/orders_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../services/global_service.dart';

class BookingsControllerNew extends GetxController {
  BookingRepository _bookingsRepository;
  final bookings = <BookingNew>[].obs;
  // final order = Data().obs;
  final bookingStatuses = <BookingStatus>[].obs;
  // final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  final currentStatus = '1'.obs;
  String orderId = "";

  ScrollController scrollController;

  BookingsControllerNew() {
    _bookingsRepository = new BookingRepository();
  }

  @override
  Future<void> onInit() async {
    await getBookingStatuses();
    print("sdfbfdfkdj BookingsControllerNew() order.value ${Get.arguments.toString()}");
    currentStatus.value = getStatusByOrder(1).id;
    // order.value = Get.arguments as Data;
    orderId = Get.arguments['orderId'] as String;
    print("sdfbfdfkdj orderId: $orderId");
    // orderId = "291";
    refreshBookings();
    super.onInit();
  }

  Future refreshBookings({bool showMessage = false, String statusId}) async {
    changeTab(statusId);
    if (showMessage) {
      await getBookingStatuses();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Bookings page refreshed successfully".tr));
    }
  }

  // void initScrollController() {
  //   scrollController = ScrollController();
  //   scrollController.addListener(() {
  //     if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
  //       loadBookingsOfStatus(statusId: currentStatus.value);
  //     }
  //   });
  // }

  void changeTab(String statusId) async {
    this.bookings.clear();
    currentStatus.value = statusId ?? currentStatus.value;
    // page.value = 0;
    await loadBookingsOfStatus(statusId: currentStatus.value);
  }

  Future getBookingStatuses() async {
    try {
      bookingStatuses.assignAll(await _bookingsRepository.getStatuses());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  BookingStatus getStatusByOrder(int order) => bookingStatuses.firstWhere((s) => s.order == order, orElse: () {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Booking status not found".tr));
        return BookingStatus();
      });

  // Future loadBookingsOfStatus({String statusId}) async {
  //   print("hsbjkakjsj loadBookingsOfStatus() called ${orderId} ");
  //   try {
  //     isLoading.value = true;
  //     isDone.value = false;
  //     page.value++;
  //     List<BookingNew> _bookings = [];
  //     if (bookingStatuses.isNotEmpty) {
  //       _bookings = await _bookingsRepository.allNew(statusId, page: page.value, orderId : orderId);
  //     }
  //     if (_bookings.isNotEmpty) {
  //       bookings.addAll(_bookings);
  //     } else {
  //       isDone.value = true;
  //     }
  //   } catch (e) {
  //     isDone.value = true;
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future loadBookingsOfStatus({String statusId}) async {
    print("hsbjkakjsj loadBookingsOfStatus() called ${orderId} ");
    try {
      isLoading.value = true;
      // isDone.value = false;
      // page.value++;
      List<BookingNew> _bookings = [];
      if (bookingStatuses.isNotEmpty) {
        _bookings = await _bookingsRepository.allNew(statusId,  orderId : orderId);
      }
      // bookings.value.addAll(_bookings);
      bookings.value = _bookings;
      // if (_bookings.isNotEmpty) {
      //   bookings.addAll(_bookings);
      // } else {
      //   isDone.value = true;
      // }
    } catch (e) {
      // isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> cancelBookingService(BookingNew booking) async {
    try {
      if (booking.status.order < Get.find<GlobalService>().global.value.onTheWay) {
        final _status = getStatusByOrder(Get.find<GlobalService>().global.value.failed);
        final _booking = new BookingNew(id: booking.id, cancel: true, status: _status);
        await _bookingsRepository.update(_booking);
        bookings.removeWhere((element) => element.id == booking.id);
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  OrderStatusWithColor getBookingStatusById(String statusId) {
    // todo have to make this status check dynamic
    print("jsdnkja $statusId");
    print("jsdnkja et.find<GlobalService>().global.value ${Get.find<GlobalService>().global.value.received}");
    if (statusId == "1") {
      return OrderStatusWithColor("Received", "#cccccc", "#000000");

    } else if (statusId == '4') {
      return OrderStatusWithColor("Accepted",  "#cccccc", "#000000");;
    } else if (statusId == "3") {
      return OrderStatusWithColor("On The Way",  "#cccccc", "#000000");
    } else if (statusId == "2") {
      return OrderStatusWithColor("In Progress", "#cccccc", "#000000");

    } else if (statusId == "5") {
      return OrderStatusWithColor("Ready", "#cccccc", "#000000");

    } else if (statusId == "6") {
      return OrderStatusWithColor("Done", "#00FF00", "#ffffff");
    } else if (statusId == "7") {
      return OrderStatusWithColor("Canceled", "#ff0000", "#ffffff");

    }else{
      return OrderStatusWithColor("Undefined", "#ffff00", "#cccccc");

    }
  }
}

class OrderStatusWithColor{
  String status;
  String backgroundColor;
  String textColor;

  OrderStatusWithColor(this.status, this.backgroundColor, this.textColor);
}
