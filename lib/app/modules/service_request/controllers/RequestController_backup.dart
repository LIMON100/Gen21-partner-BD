import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
//todo unhide pusher
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/log_data.dart';
import '../../../models/order_request_push_model.dart';
import '../../../models/order_update_pusher_event.dart';
import '../../../repositories/request_repository.dart';
import '../../../services/auth_service.dart';

import '../../home/controllers/home_controller.dart';
import 'package:flutter/foundation.dart';

class RequestController extends GetxController {
  // ProviderRepository _providerRepository;
  RequestRepository _requestRepository;
  final HomeController homeController = Get.put(HomeController());

  //todo unhide pusher
  // PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();


  var orderRequestPush = OrderRequestPush().obs;
  var orderedServiceList = <Service>[].obs;
  final authService = Get.find<AuthService>();
  dynamic pushNotificationData;

  var isLoading = false.obs;
  bool isHaveToRing = false;

  var pusherEvents = OrderUpdatePusherEvent().obs;

  RequestController() {
    // _providerRepository = new ProviderRepository();
    _requestRepository = new RequestRepository();
    // noteEditingController = new TextEditingController();
    // couponEditingController = new TextEditingController();
  }

  //todo unhide pusher
  // @override
  // void onInit() async {
  //   var arguments = Get.arguments as Map<String, dynamic>;
  //   print("KYToitojuu argmnts ServiceController ${arguments.toString()}");
  //   pushNotificationData = arguments['push_notification_data'];
  //   isHaveToRing = arguments['isHaveToRing'] as bool;
  //   printWrapped("KYToitojuusds data in request_controller: ${pushNotificationData} isHaveToRing $isHaveToRing");
  //   if(isHaveToRing) {
  //     FlutterRingtonePlayer.play(
  //         fromAsset: "assets/sounds/service_request.wav",
  //         // will be the sound on Android
  //         ios: IosSounds.electronic,
  //         volume: 1.0,
  //         asAlarm: true,
  //         looping: true // will be the sound on iOS
  //     );
  //   }
  //   pusherInit();
  //   connectToPusher(pushNotificationData);
  //
  //   super.onInit();
  // }

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

    // getProviders();
    if (showMessage) {
      // Get.showSnackbar(Ui.SuccessSnackBar(message: eService.value.name + " " + "page refreshed successfully".tr));
    }
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
    // OrderUpdatePusherEvent pusherEvents = OrderUpdatePusherEvent.fromJson(jsonDecode("event.data"));
    try {
      // AcceptRequestBody acceptRequestBody = new AcceptRequestBody(e_service: "${service.eServiceId}", event_id: "${service.id}", booking_status_id: "4", quantity: service.addedUnit, coupon_id: "1", order_id: "${"service."}", address_id: "1");
      // printWrapped("jnjsndfa sending Data: ${body.toJson()}");
      try {
        FlutterRingtonePlayer.stop();
      } catch (e) {}

      isLoading.value = true;
      printWrapped("iujhdadh acceptBookingRequest sending Data in provider APP: ${body.toJson()}");
      var responseData = await _requestRepository.acceptBookingRequest(data: body.toJson());
      removeBookingItem(serviceId, serviceType);
      isLoading.value = false;

      print("sndfnjkj ${responseData.toString()}");
    } catch (e) {
      print("jsnfnanj e: ${e.toString()}");
    }
  }

  declineBookingRequest(String serviceId, String serviceType) {
    print("jsnfnanj serviceId: ${serviceId} serviceType: $serviceType");
    printWrapped("orderRequestPush.value.data.service: ${orderRequestPush.value.data.service.toString()}");
    // orderRequestPush.value.data.service.removeWhere((element) => element.eServiceId == serviceId && element.serviceType == serviceType);
    removeBookingItem(serviceId, serviceType);
    try {
      FlutterRingtonePlayer.stop();
    } catch (e) {}

    printWrapped("orderRequestPush.value.data.service: ${orderRequestPush.value.data.service.toString()}");
  }

  removeBookingItem(String serviceId, String serviceType) {
    int index = orderedServiceList.indexWhere((element) => element.eServiceId == serviceId && element.serviceType == serviceType);
    orderedServiceList.removeAt(index);
    update();
  }

  //todo unhide pusher
  // void pusherInit() async {
  //   print("jnfabhkio pusherInit() called");
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
  //     print("jnfabhkio error: $e");
  //   }
  // }

  //todo unhide pusher
  // void onEvent(PusherEvent event) {
  //   printWrapped("kfmklsalflsa provider app onEvent: $event");
  //   handleEvent(event);
  //   // connectToPusher("");
  //   print("uioljHH test01");
  // }

  //todo unhide pusher
  // void handleEvent(PusherEvent event) async {
    // printWrapped("kfmklsalflsa in provider app, event.data: ${event.data}");
    // print("uioljHH provider app id: ${authService.userId}");
    // pusherEvents.value = OrderUpdatePusherEvent.fromJson(jsonDecode(event.data));
    // // OrderUpdatePusherEvent pusherEvents = OrderUpdatePusherEvent.fromJson(jsonDecode("event.data"));
    // print("uioljHH provider app id: ${authService.userId}");
    // printWrapped("uioljHH provider app pusherEvents: ${pusherEvents.value.eventData.toString()}");
    //
    // print("msdnfjknsja in provider app, order status: ${pusherEvents.value.status}");
    // orderRequestPush.value.status.value = pusherEvents.value.status;
    // pusherEvents.value.eventData.forEach((element) {
    //   print("uioljHH in: id: ${element.id} status:${element.status}");
    //   if (element.status.toString() == "accept") {
    //     print("jnfabhkio in 2 accepted");
    //     orderedServiceList.forEach((service) {
    //       print("jhsdjfa  serviceId= ${element.eServiceId} : ${service.eServiceId} serviceType= ${element.serviceType} : ${service.serviceType} providerId: ${authService.userId} : ${element.acceptEProviderUserId}");
    //       if ("${element.eServiceId}" == "${service.eServiceId}" && "${element.serviceType}" == "${service.serviceType}" && "${authService.userId}" == "${element.acceptEProviderUserId}") {
    //         print("jnfabhkio element.eServiceId: ${element.eServiceId} accepted by me");
    //         Get.snackbar("Thanks for receiving the order", "");
    //         try {
    //           FlutterRingtonePlayer.stop();
    //         } catch (e) {}
    //         removeBookingItem("${element.eServiceId}", "${element.serviceType}");
    //       } else {
    //         print("jnfabhkio element.eServiceId: ${element.eServiceId} accepted by others");
    //       }
    //     });
    //     try {
    //       FlutterRingtonePlayer.stop();
    //     } catch (e) {}
    //   }
    // });
    //
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

//todo unhide pusher
// connectToPusher(dynamic pushBody) async {
  //   print("hhfasjfhbdjas connectToPusher called");
  //   print("jdnjksfajkf pushBody ${pushBody}");
  //   OrderRequestPush orderRequestPushData = OrderRequestPush.fromJson(pushBody);
  //   print("hhfasjfhbdjas adding orderRequestPush: ${orderRequestPushData.toString()}");
  //   this.orderRequestPush.value = orderRequestPushData;
  //   this.orderedServiceList.value = orderRequestPushData.data.service;
  //   print("hhfasjfhbdjas getting orderRequestPush: ${this.orderRequestPush.value.toString()}");
  //   if (pusher.connectionState.capitalize == "CONNECTED") {
  //     print("fhsahdsa in 1");
  //     await pusher.subscribe(channelName: "${orderRequestPushData.pusherChanelName}");
  //     await pusher.connect();
  //   } else {
  //     print("fhsahdsa in 2");
  //     print("skfjdsann not connected: ${pusher.connectionState.toString()}");
  //     await pusher.subscribe(channelName: "${orderRequestPushData.pusherChanelName}");
  //     await pusher.connect();
  //   }
  // }

}

class AcceptRequestBody {
  String e_service;
  String event_id;
  String booking_status_id;
  String quantity;
  String coupon_id;
  String order_id;
  String address_id;
  String booking_at;


  AcceptRequestBody({String e_service, String event_id, String booking_status_id, String quantity, String coupon_id, String order_id, String address_id, booking_at}) {
    this.e_service = e_service;
    this.event_id = event_id;
    this.booking_status_id = booking_status_id;
    this.quantity = quantity;
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
    data['coupon_id'] = this.coupon_id;
    data['order_id'] = this.order_id;
    data['address_id'] = this.address_id;
    data['booking_at'] = this.booking_at;
    return data;
  }
}
