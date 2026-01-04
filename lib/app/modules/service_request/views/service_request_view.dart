import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:loading_gifs/loading_gifs.dart';
import '../../../../common/log_data.dart';
import '../../../models/order_update_pusher_event.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/RequestController.dart';
import '../widgets/service_request_list_widget.dart';

class ServiceRequestsView extends GetWidget<RequestController> {

  @override
  Widget build(BuildContext context) {
    // final RequestController _requestController = Get.put(RequestController());

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Requested Service".tr,
            style: context.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => Get.back(),
          ),
          elevation: 0,

        ),
        body: Obx(() {
          // return controller.orderRequestResponse.value.status.toString() == "accept_request"
          // print("uewhjsdjfbafa in provider app serviceRequestView Obx order status): ${controller.orderRequestResponse.value.status}");

          print("uewhjsdjfbafa in provider app serviceRequestView Obx order controller.orderRequestResponse.value.toString(): : ${controller.orderRequestResponse.value.toString()}");
          print("uewhjsdjfbafa controller.orderedServiceList.length: ${controller.orderedServiceList.length}");
          return
          controller.isRequestedServiceLoading.value?

          Center(child: CircularProgressIndicator()):
              controller.orderedServiceList != null  && controller.orderedServiceList.length <1?
                 Center(child: Text("No request left!"),) :
            controller.orderRequestResponse.value != null && controller.orderRequestResponse.value.status.value != "cancel"
              ?
            CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              // color: Colors.black,
                              child: Image.asset(
                                // 'assets/img/alarm.gif',
                                'assets/img/icon22.png',
                                // fit: BoxFit.cover,
                                height: 100,
                                // width: 65,
                              ),
                            ),
                            Obx(() {
                              return
                                controller.orderRequestResponse.value.couponData != null
                                  ? Container(
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                                        alignment: Alignment.center,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [Text("Applied Coupon: "), Text("${controller.orderRequestResponse.value.couponData.code}")],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [Text("Discount: "), controller.orderRequestResponse.value.couponData.discountType.toString() == "percent" ? Text("${controller.orderRequestResponse.value.couponData.discount}%") : Text("\৳${controller.orderRequestResponse.value.couponData.discount}")],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  :
                              Container();
                            }),

                            Container(
                              child:
                                  // Text("jsdnjkfa"),
                                  ServiceRequestsListWidget(),
                              // child: Container(),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : controller.orderRequestResponse.value != null && controller.orderRequestResponse.value.status == "cancel"
                  ? Container(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Image.asset('assets/img/opps.png'), Text("Customer has stopped this request.")],
                      ),
                    )
                  : Container();

        }));
  }
}
