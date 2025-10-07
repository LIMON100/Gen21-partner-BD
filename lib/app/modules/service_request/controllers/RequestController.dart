import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:home_service/app/routes/app_routes.dart';
//todo unhide pusher
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/log_data.dart';
import '../../../../common/ui.dart';
import '../../../models/booking_new_model.dart';
import '../../../models/order_push_model.dart';
import '../../../models/order_request_push_model.dart';
import '../../../models/order_request_response_model.dart' as OrderRequestResponseModelRef;
import '../../../models/order_update_pusher_event.dart';
import '../../../models/receive_booking_response.dart';
import '../../../providers/laravel_provider.dart';
import '../../../repositories/request_repository.dart';
import '../../../services/auth_service.dart';

import '../../bookings/controllers/booking_controller.dart';
import '../../bookings/views/booking_details_view.dart';
import '../../home/controllers/home_controller.dart';
import 'package:flutter/foundation.dart';

class RequestController extends GetxController {
  // ProviderRepository _providerRepository;
  RequestRepository _requestRepository;
  final HomeController homeController = Get.put(HomeController());


  //todo unhide pusher
  // PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  var orderRequestResponse = OrderRequestResponseModelRef.OrderRequestResponse().obs;
  var orderedServiceList = <OrderRequestResponseModelRef.EventData>[].obs;
  final authService = Get.find<AuthService>();
  dynamic pushNotificationData;

  var isLoading = false.obs;
  bool isHaveToRing = false;
  var isRequestedServiceLoading = false.obs;
  var pusherEvents = OrderUpdatePusherEvent().obs;
  OrderPush orderPush;

  RequestController() {
    // _providerRepository = new ProviderRepository();
    _requestRepository = new RequestRepository();
    // noteEditingController = new TextEditingController();
    // couponEditingController = new TextEditingController();
  }

  // @override
  // Future<void> onInit() async {
  //   this.selectedOrderTimeType.value = orderTimeType[0].value;
  //   this.selectedOrderRequestType.value = orderRequestType[0].value;
  //   super.onInit();
  // }

  @override
  void onInit() async {
    // final preference = await SharedPreferences.getInstance();
    // preference.reload();
    // var push_data = await preference.get("push_data");
    // printWrapped("fnjkanfdkjsa_RequestController sharedPrefData push_data:  $push_data");
    // await preference.setString("push_data", "");

    var arguments = Get.arguments as Map<String, dynamic>;
    print("jfnjsadhjdsdhs argmnts ServiceController ${arguments.toString()}");
    pushNotificationData = arguments['push_notification_data'];
    isHaveToRing = arguments['isHaveToRing'] as bool;

    printWrapped("jfnjsadhjdsdhs data in request_controller: ${pushNotificationData} isHaveToRing $isHaveToRing");

    orderPush = OrderPush.fromJson(pushNotificationData);
    print("jfnjsadhjdsdhs orderPush ${orderPush.toString()}");

    // _searchSuggestion = arguments['searchSuggestion'] as SearchSuggestion;
    // print("KYToitojuu _searchSuggestion ServiceController ${_searchSuggestion.toString()}");
    // this.selectedOrderTimeType.value = orderTimeType[0].value;
    // this.selectedOrderRequestType.value = orderRequestType[0].value;
    // pusherInit();
    if (isHaveToRing) {
      FlutterRingtonePlayer.play(
          fromAsset: "assets/sounds/service_request.wav",
          // will be the sound on Android
          ios: IosSounds.electronic,
          volume: 1.0,
          asAlarm: true,
          looping: true // will be the sound on iOS
          );
    }
    //todo unhide pusher
    // pusherInit();  //change_korlam

    super.onInit();
  }

  @override
  void onReady() async {
    print("fsjfsads0");
    await refreshEService();
    super.onReady();
  }

  @override
  void onClose() {
    FlutterRingtonePlayer.stop();
  }

  closeRingTone() {
    FlutterRingtonePlayer.stop();
  }

  Future refreshEService({bool showMessage = false}) async {
    print("fsjfsads1");

    // getService("1");
    OrderPush orderPush = OrderPush.fromJson(pushNotificationData);
    getBookingRequestedServices("${orderPush.data}");
    // getProviders();
    if (showMessage) {
      // Get.showSnackbar(Ui.SuccessSnackBar(message: eService.value.name + " " + "page refreshed successfully".tr));
    }
  }

  getBookingRequestedServices(String orderId) async {
    // try {
    isRequestedServiceLoading.value = true;
    orderRequestResponse.value = null;
    orderRequestResponse.value = await _requestRepository.getBookingRequestedServices(orderId: orderId);

    printWrapped("ksdnfjsna orderRequestResponse.toString(): ${orderRequestResponse.toString()}");

    this.orderedServiceList.value = orderRequestResponse.value.eventData;
    printWrapped("sdnfjsajd orderedServiceList.value.toString(): ${orderedServiceList.toString()}");
    isRequestedServiceLoading.value = false;

    update();
    // } catch (e) {
    //   print("jfnjsadhjdsdhs e: ${e.toString()}");
    // }
  }

  // Future getProviders() async {
  //   print("fsjfsads3");
  //
  //   try {
  //     // service.value =
  //     var provider = await _providerRepository.getProviders();
  //     print("fnanjdsa in getProviders() provider ${provider.toString()}");
  //     // providers = provider.data;
  //     for(int i = 0; i <provider.data.length; i++) {
  //       providers.add(provider.data[i]);
  //     }
  //
  //     print("fnanjdsa in getProviders() providers ${providers.toString()}");
  //
  //   } catch (e) {
  //     print("fnanjdsa  in getProviders ${e.toString()}");
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  //
  // }

  Future acceptBookingRequest(String serviceId, String serviceType, {var body}) async {
    print("INSIDEACCEPT");
    // OrderUpdatePusherEvent pusherEvents = OrderUpdatePusherEvent.fromJson(jsonDecode("event.data"));
    try {
      // AcceptRequestBody acceptRequestBody = new AcceptRequestBody(e_service: "${service.eServiceId}", event_id: "${service.id}", booking_status_id: "4", quantity: service.addedUnit, coupon_id: "1", order_id: "${"service."}", address_id: "1");
      // printWrapped("jnjsndfa sending Data: ${body.toJson()}");
      try {
        FlutterRingtonePlayer.stop();
      } catch (e) {}

      isLoading.value = true;
      printWrapped("shfbhabfdhs acceptBookingRequest sending Data in provider APP: ${body.toJson()}");
      ReceiveBooking responseData = await _requestRepository.acceptBookingRequest(data: body.toJson());

      if (responseData.data == null && responseData.message == "Already Received") {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Already received by another user"));
      }
      try {
        //todo have to remove this below statement
        removeBookingItem(serviceId, serviceType);
      } catch (e){
        print("error occured during item removing ${e.toString()}");
      }
      isLoading.value = false;

      // NAVIGATING BOOKING ACCEPTED PAGE
      // await Future.delayed(Duration(seconds: 1));
      LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>();
      Get.toNamed(Routes.BOOKING_DETAILS, arguments: new BookingNew(id: _laravelApiClient.newBkId.toString()));

      print("shfbhabfdhs ${responseData.toString()}");
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Something went wrong"));
      print("jsnfnanj e: ${e.toString()}");
    }
  }

  declineBookingRequest(String serviceId, String serviceType) {
    print("jsnfnanj serviceId: ${serviceId} serviceType: $serviceType");
    printWrapped("orderRequestResponse.value.eventData: ${orderRequestResponse.value.eventData.toString()}");
    // orderRequestPush.value.data.service.removeWhere((element) => element.eServiceId == serviceId && element.serviceType == serviceType);
    removeBookingItem(serviceId, serviceType);
    try {
      FlutterRingtonePlayer.stop();
    } catch (e) {}

    printWrapped("orderRequestPush.value.data.service: ${orderRequestResponse.value.eventData.toString()}");
  }

  removeBookingItem(String serviceId, String serviceType) {
    int index = orderedServiceList.indexWhere((element) => element.eServiceId == serviceId && element.serviceType == serviceType);
    orderedServiceList.removeAt(index);
    update();
  }

// Widget getContent() {
//   print("jsnfnanj getContent called");
//   return Column(
//     children: [
//       Text("Your content goes here widget"),
//       Text("Your content goes here widget"),
//       Text("Your content goes here widget"),
//       Text("Your content goes here widget"),
//     ],
//   );
// }

// void pusherInit() async {
//   try {
//     await pusher.init(
//       apiKey: "8dc6d2a858850abe4dbf",
//       cluster: "mt1",
//       onConnectionStateChange: onConnectionStateChange,
//       onError: onError,
//       onSubscriptionSucceeded: onSubscriptionSucceeded,
//       onEvent: onEvent,
//       // onSubscriptionError: onSubscriptionError,
//       // onDecryptionFailure: onDecryptionFailure,
//       // onMemberAdded: onMemberAdded,
//       // onMemberRemoved: onMemberRemoved,
//       // authEndpoint: "<Your Authendpoint>",
//       // onAuthorizer: onAuthorizer
//     );
//   } catch (e) {
//     print("skfjdsann error: $e");
//   }
// }
//
// void onEvent(PusherEvent event) {
//   print("skfjdsann onEvent: $event");
// }
//
// void onSubscriptionSucceeded(String channelName, dynamic data) {
//   print("skfjdsann onSubscriptionSucceeded: $channelName data: $data");
// }
//
// void onSubscriptionError(String message, dynamic e) {
//   print("skfjdsann onSubscriptionError: $message Exception: $e");
// }
//
// void onConnectionStateChange(dynamic currentState, dynamic previousState) {
//   print("skfjdsann Connection: $currentState");
// }
//
// void onError(String message, int code, dynamic e) {
//   print("skfjdsann onError: $message code: $code exception: $e");
// }
//
// connectToPusher() async {
//   print("skfjdsann connectToPusher called");
//   if (pusher.connectionState.capitalize == "CONNECTED") {
//     await pusher.subscribe(channelName: "${requestChannel.channelName}");
//     await pusher.connect();
//   } else {
//     print("skfjdsann not connected: ${pusher.connectionState.toString()}");
//     await pusher.subscribe(channelName: "${requestChannel.channelName}");
//     await pusher.connect();
//   }
// }

// Future getAddresses() async {
//   try {
//     if (Get.find<AuthService>().isAuth) {
//       addresses.assignAll(await _settingRepository.getAddresses());
//       if (!currentAddress.isUnknown()) {
//         addresses.remove(currentAddress);
//         addresses.insert(0, currentAddress);
//       }
//       if (Get.isRegistered<TabBarController>(tag: 'addresses')) {
//         Get.find<TabBarController>(tag: 'addresses').selectedId.value = addresses.elementAt(0).id;
//       }
//     }
//   } catch (e) {
//     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//   }
// }

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
  //   printWrapped("dbaOTHewhhj provider app onEvent: $event");
  //   handleEvent(event);
  //   // connectToPusher("");
  //   print("dbaOTHewhhj test01");
  // }
//todo unhide pusher
//   void handleEvent(PusherEvent event) async {
//     // try{
//     // var data = null;
//     // var int = double.parse(data);
//     printWrapped("dbaOTHewhhj in provider app, event.data: ${event.data}");
//     print("dbaOTHewhhj provider app id: ${authService.userId}");
//     pusherEvents.value = OrderUpdatePusherEvent.fromJson(jsonDecode(event.data));
//     // OrderUpdatePusherEvent pusherEvents = OrderUpdatePusherEvent.fromJson(jsonDecode("event.data"));
//     print("dbaOTHewhhj provider app id: ${authService.userId}");
//     printWrapped("dbaOTHewhhj provider app pusherEvents: ${pusherEvents.value.eventData.toString()}");
//
//     print("uewhjsdjfbafa in provider app handleEvent, changing order status: ${pusherEvents.value.status}");
//     orderRequestResponse.value.status.value = pusherEvents.value.status;
//     // update();
//     // refresh();
//
//     pusherEvents.value.eventData.forEach((element) {
//       print("dbaOTHewhhj in: id: ${element.id} status:${element.status}");
//       if (element.status.toString() == "accept") {
//         print("sfKKndsanfjds in 2 accepted");
//         orderedServiceList.forEach((service) {
//           print("sfKKndsanfjds  serviceId= ${element.eServiceId} : ${service.eServiceId} serviceType= ${element.serviceType} : ${service.serviceType} providerId: ${authService.userId} : ${element.acceptEProviderUserId}");
//           if ("${element.eServiceId}" == "${service.eServiceId}" && "${element.serviceType}" == "${service.serviceType}" && "${authService.userId}" == "${element.acceptEProviderUserId}") {
//             print("sfKKndsanfjds element.eServiceId: ${element.eServiceId} accepted by me");
//             Get.snackbar("Thanks for receiving the order", "");
//             try {
//               FlutterRingtonePlayer.stop();
//             } catch (e) {}
//             removeBookingItem("${element.eServiceId}", "${element.serviceType}");
//           } else if ("${element.eServiceId}" == "${service.eServiceId}" && "${element.serviceType}" == "${service.serviceType}") {
//             print("sfKKndsanfjds element.eServiceId: ${element.eServiceId} accepted by others");
//             removeBookingItem("${element.eServiceId}", "${element.serviceType}");
//           } else {
//             print("sfKKndsanfjds element.eServiceId: ${element.eServiceId} in else");
//           }
//         });
//         // if(element.serviceType == orderedServiceList. && element.eServiceId == orderRequestPush.value.data.eServiceId){
//         //   print("jnfabhkio in 3 this service has been accepted");
//         //
//         //   if("${authService.userId}" == "${element.acceptEProviderUserId}"){
//         //     print("jnfabhkio Accepted by me my id: ${ authService.userId } others id: ${element.acceptEProviderUserId}");
//         //     Get.snackbar("my id: ${ authService.userId } others id: ${element.acceptEProviderUserId} Accepted by me!!", "Accepted by me!!!");
//         //
//         //   }else{
//         //     print("jnfabhkio Accepted by others my id: ${ authService.userId } others id: ${element.acceptEProviderUserId}");
//         //     Get.snackbar("my id: ${ authService.userId } others id: ${element.acceptEProviderUserId} Accepted by others!!", "Accepted by others!!!");
//         //
//         //   }
//         // }else{
//         //   print("jnfabhkio other service has been accepted");
//         // }
//         try {
//           FlutterRingtonePlayer.stop();
//         } catch (e) {}
//       }
//     });
//
//     // if(pusherEvents.eventData[0].status.toLowerCase() == "accepted"){
//     //   _showAcceptedByOthersDialog(Get.context);
//     // }
//     // }catch(e){
//     //   print("jnfabhkio e: ${e.toString()}");
//     // }
//
//     // update();
//   }

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

//todo unhide pusher
  // connectToPusher(dynamic pushBody) async {
  //   print("jfnjsadhjdsdhs connectToPusher called");
  //
  //   // print("jdnjksfajkf pushBody ${pushBody}");
  //   // OrderRequestResponseModelRef.OrderRequestResponse orderRequestPushData = OrderRequestResponseModelRef.OrderRequestResponse.fromJson(pushBody);
  //   // print("hhfasjfhbdjas adding orderRequestPush: ${orderRequestPushData.toString()}");
  //   // this.orderRequestPush.value = orderRequestPushData;
  //   // print("hhfasjfhbdjas getting orderRequestPush: ${this.orderRequestPush.value.toString()}");
  //
  //   // OrderPush orderPush = OrderPush.fromJson(pushBody);
  //   print("jfnjsadhjdsdhs connectToPusher orderPush.pusherChanelName: ${orderPush.pusherChanelName} orderPush.data: ${orderPush.data}");
  //
  //   if (pusher.connectionState.capitalize == "CONNECTED") {
  //     print("jfnjsadhjdsdhs in 1");
  //     await pusher.subscribe(channelName: "${orderPush.pusherChanelName}");
  //     await pusher.connect();
  //   } else {
  //     print("jfnjsadhjdsdhs in 2");
  //     print("jfnjsadhjdsdhs not connected: ${pusher.connectionState.toString()}");
  //     await pusher.subscribe(channelName: "${orderPush.pusherChanelName}");
  //     await pusher.connect();
  //   }
  // }
}

class AcceptRequestBody {
  String e_service;
  String event_id;
  String booking_status_id;
  String quantity;
  // added_unit and quantity both are same here. Have to check in back end carefully to remove it quantity.
  String added_unit;
  String coupon_id;
  String order_id;
  String address_id;
  String booking_at;

  AcceptRequestBody({String e_service, String event_id, String booking_status_id, String quantity, String added_unit, String coupon_id, String order_id, String address_id, booking_at}) {
    this.e_service = e_service;
    this.event_id = event_id;
    this.booking_status_id = booking_status_id;
    this.quantity = quantity;
    this.added_unit = added_unit;
    this.coupon_id = coupon_id;
    this.order_id = order_id;
    this.address_id = address_id;
    this.booking_at = booking_at;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['e_service'] = this.e_service;
    data['event_id'] = this.event_id;
    data['booking_status_id'] = this.booking_status_id;
    data['quantity'] = this.quantity;
    data['added_unit'] = this.added_unit;
    data['coupon_id'] = this.coupon_id;
    data['order_id'] = this.order_id;
    data['address_id'] = this.address_id;
    data['booking_at'] = this.booking_at;
    return data;
  }
}
