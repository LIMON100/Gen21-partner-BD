import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/log_data.dart';
import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_new_model.dart';
import '../../../models/booking_status_model.dart';
import '../../../models/order_request_push_model.dart';
import '../../../models/order_update_pusher_event.dart';
import '../../../models/orders_model.dart';
import '../../../models/statistic.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/order_repository.dart';
import '../../../repositories/statistic_repository.dart';
import '../../../services/auth_service.dart';
import '../../../services/global_service.dart';
import '../../root/controllers/root_controller.dart';
//todo unhide pusher
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../service_request/controllers/RequestController.dart';

class HomeController extends GetxController
    with WidgetsBindingObserver
    implements Disposable {
  StatisticRepository _statisticRepository;
  BookingRepository _bookingsRepository;

  final statistics = <Statistic>[].obs;
  final bookings = <BookingNew>[].obs;
  final bookingStatuses = <BookingStatus>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  final currentStatus = '1'.obs;

  ScrollController scrollController;
//todo unhide pusher
  // PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  AcceptRequestBody acceptRequestBody;

  var orderRequestPush = OrderRequestPush().obs;

  final authService = Get.find<AuthService>();

  OrderRepository _orderRepository;
  final orders = Orders().obs;

  var isServiceRunning = false.obs;

  HomeController() {
    _statisticRepository = new StatisticRepository();
    _bookingsRepository = new BookingRepository();
    _orderRepository = new OrderRepository();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    isServiceAlreadyRunning();
  }

  @override
  Future<void> onInit() async {
    await refreshHome();
    pusherInit();
    isServiceAlreadyRunning();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController?.dispose();
  }

  Future refreshHome({bool showMessage = false, String statusId}) async {
    await getBookingStatuses();
    await getStatistics();
    Get.find<RootController>().getNotificationsCount();
    // changeTab(statusId);
    await getOrders();
    if (showMessage) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Home page refreshed successfully".tr));
    }
  }

  void initScrollController() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isDone.value) {
        loadBookingsOfStatus(statusId: currentStatus.value);
      }
    });
  }

  void isServiceAlreadyRunning() async {
    // isServiceRunning.value = await FlutterForegroundTask.isRunningService;
    // print("jdsbfkaj isServiceRunning.value: ${isServiceRunning.value}");
  }

  void changeTab(String statusId) async {
    this.bookings.clear();
    currentStatus.value = statusId ?? currentStatus.value;
    page.value = 0;
    await loadBookingsOfStatus(statusId: currentStatus.value);
  }

  Future getStatistics() async {
    try {
      statistics.assignAll(await _statisticRepository.getHomeStatistics());
    } catch (e) {
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Wait for response"));
    }
  }

  Future getBookingStatuses() async {
    try {
      bookingStatuses.assignAll(await _bookingsRepository.getStatuses());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  BookingStatus getStatusByOrder(int order) =>
      bookingStatuses.firstWhere((s) => s.order == order, orElse: () {
        Get.showSnackbar(
            Ui.ErrorSnackBar(message: "Booking status not found".tr));
        return BookingStatus();
      });

  Future loadBookingsOfStatus({String statusId}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      page.value++;
      List<BookingNew> _bookings = [];
      if (bookingStatuses.isNotEmpty) {
        _bookings =
            await _bookingsRepository.allNew(statusId, page: page.value);
      }
      if (_bookings.isNotEmpty) {
        bookings.addAll(_bookings);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeBookingStatus(
      BookingNew booking, BookingStatus bookingStatus) async {
    try {
      final _booking = new BookingNew(id: booking.id, status: bookingStatus);
      await _bookingsRepository.update(_booking);
      bookings.removeWhere((element) => element.id == booking.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> acceptBookingService(BookingNew booking) async {
    print("BOOKINGACCEPTED");
    final _status = Get.find<HomeController>()
        .getStatusByOrder(Get.find<GlobalService>().global.value.accepted);
    await changeBookingStatus(booking, _status);
    Get.showSnackbar(Ui.SuccessSnackBar(
        title: "Status Changed".tr, message: "Booking has been accepted".tr));
  }

  Future<void> declineBookingService(BookingNew booking) async {
    print("BOOKINGCANCELED");
    try {
      if (booking.status.order <
          Get.find<GlobalService>().global.value.onTheWay) {
        final _status =
            getStatusByOrder(Get.find<GlobalService>().global.value.failed);
        final _booking =
            new BookingNew(id: booking.id, cancel: true, status: _status);
        await _bookingsRepository.update(_booking);
        bookings.removeWhere((element) => element.id == booking.id);
        Get.showSnackbar(Ui.defaultSnackBar(
            title: "Status Changed".tr,
            message: "Booking has been canceled".tr));
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void pusherInit() async {
    print("jnfabhkio pusherInit() called");
    try {
      //todo unhide pusher
      // await pusher.init(
      //   apiKey: "8dc6d2a858850abe4dbf",
      //   cluster: "mt1",
      //   onConnectionStateChange: onConnectionStateChange,
      //   onError: onError,
      //   onSubscriptionSucceeded: onSubscriptionSucceeded,
      //   onEvent: onEvent,
      //   // onSubscriptionError: onSubscriptionError,
      //   // onDecryptionFailure: onDecryptionFailure,
      //   // onMemberAdded: onMemberAdded,
      //   // onMemberRemoved: onMemberRemoved,
      //   // authEndpoint: "<Your Authendpoint>",
      //   // onAuthorizer: onAuthorizer
      // );
    } catch (e) {
      print("jnfabhkio error: $e");
    }
  }
//todo unhide pusher
  // void onEvent(PusherEvent event) {
  //   print("uioljHH provider app onEvent: $event");
  //   handleEvent(event);
  //   // connectToPusher("");
  //   print("uioljHH test01");
  // }

  //todo unhide pusher
  // void handleEvent(PusherEvent event) async {
  //   // try{
  //   // var data = null;
  //   // var int = double.parse(data);
  //   printWrapped("uioljHH: ${event.data}");
  //   print("uioljHH provider app id: ${authService.userId}");
  //   OrderUpdatePusherEvent pusherEvents =
  //       OrderUpdatePusherEvent.fromJson(jsonDecode(event.data));
  //   // OrderUpdatePusherEvent pusherEvents = OrderUpdatePusherEvent.fromJson(jsonDecode("event.data"));
  //   print("uioljHH provider app id: ${authService.userId}");
  //   printWrapped(
  //       "uioljHH provider app pusherEvents: ${pusherEvents.eventData.toString()}");
  //
  //   pusherEvents.eventData.forEach((element) {
  //     print("uioljHH in: id: ${element.id} status:${element.status}");
  //     if (element.status.toString() == "accept") {
  //       // print("jnfabhkio in 2 accepted");
  //       // if(element.serviceType == orderRequestPush.value.data.serviceType && element.eServiceId == orderRequestPush.value.data.eServiceId){
  //       //   print("jnfabhkio in 3 this service has been accepted");
  //       //
  //       //   if("${authService.userId}" == "${element.acceptEProviderUserId}"){
  //       //     print("jnfabhkio Accepted by me my id: ${ authService.userId } others id: ${element.acceptEProviderUserId}");
  //       //     Get.snackbar("my id: ${ authService.userId } others id: ${element.acceptEProviderUserId} Accepted by me!!", "Accepted by me!!!");
  //       //
  //       //   }else{
  //       //     print("jnfabhkio Accepted by others my id: ${ authService.userId } others id: ${element.acceptEProviderUserId}");
  //       //     Get.snackbar("my id: ${ authService.userId } others id: ${element.acceptEProviderUserId} Accepted by others!!", "Accepted by others!!!");
  //       //
  //       //   }
  //       // }else{
  //       //   print("jnfabhkio other service has been accepted");
  //       // }
  //     }
  //   });
  //
  //   // if(pusherEvents.eventData[0].status.toLowerCase() == "accepted"){
  //   //   _showAcceptedByOthersDialog(Get.context);
  //   // }
  //   // }catch(e){
  //   //   print("jnfabhkio e: ${e.toString()}");
  //   // }
  // }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    print("jnfabhkio onSubscriptionSucceeded: $channelName data: $data");
  }

  void onSubscriptionError(String message, dynamic e) {
    print("jnfabhkio onSubscriptionError: $message Exception: $e");
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("jnfabhkio Connection: $currentState");
  }

  void onError(String message, int code, dynamic e) {
    print("jnfabhkio onError: $message code: $code exception: $e");
  }

  // connectToPusher(String pushBody) async{
  //   print("jnfabhkio connectToPusher called");
  //   OrderRequestPush orderRequestPush = OrderRequestPush.fromJson(jsonDecode(pushBody));
  //   print("jsjnfa ${orderRequestPush.toString()}");
  //   this.orderRequestPush.value = orderRequestPush;
  //   if(pusher.connectionState.capitalize == "CONNECTED"){
  //     print("fhsahdsa in 1");
  //     await pusher.subscribe(channelName: "${orderRequestPush.pusherChanelName}");
  //     await pusher.connect();
  //   }else{
  //     print("fhsahdsa in 2");
  //     print("skfjdsann not connected: ${pusher.connectionState.toString()}");
  //     await pusher.subscribe(channelName: "${orderRequestPush.pusherChanelName}");
  //     await pusher.connect();
  //   }
  // }

  void getOrders() async {
    print("sjdnfab calling getOrders() ${orders.value}");
    isLoading.value = true;
    orders.value = null;
    orders.value = await _orderRepository.getOrders();
    print("sjdnfab orders.value ${orders.value}");
    isLoading.value = false;
  }

  void _showAcceptedByOthersDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "This service accepted by others".tr,
            style: TextStyle(color: Colors.redAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("This service will removed from your account".tr,
                    style: Get.textTheme.bodyText1),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel".tr, style: Get.textTheme.bodyText1),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                "Confirm".tr,
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Get.back();
                // controller.deleteEService(_eService);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  FutureOr onDispose() {
    printWrapped("onDispose() home conteroller");
  }

  void cleanData() {
    printWrapped("clean data called");
    statistics.clear();
    bookings.clear();
    bookingStatuses.clear();
    page.value = 0;
    isLoading.value = true;
    isDone.value = false;
    currentStatus.value = '1';
    orderRequestPush.value = null;
    orders.value = null;
  }
}
