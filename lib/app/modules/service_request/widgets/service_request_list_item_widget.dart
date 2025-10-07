/*
 * Copyright (c) 2020 .
 */

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/order_request_push_model.dart';
import '../../../models/order_request_response_model.dart' as OrderRequestResponseModelRe;
import '../../../routes/app_routes.dart';
import '../../home/widgets/booking_options_popup_menu_widget.dart';
import '../controllers/RequestController.dart';


class ServiceRequestListItemWidget extends StatelessWidget {
  final RequestController _requestController = Get.put(RequestController());

  ServiceRequestListItemWidget({
    Key key,
    @required OrderRequestResponseModelRe.EventData service,
    OrderRequestResponseModelRe.OrderRequestResponse orderRequestPush,
  })  : _service = service,
        _orderRequestPush = orderRequestPush,
        super(key: key);

  final OrderRequestResponseModelRe.EventData _service;
  final OrderRequestResponseModelRe.OrderRequestResponse _orderRequestPush;
  var isLoading = false.obs;


  @override
  Widget build(BuildContext context) {
    Color _color = Get.theme.colorScheme.secondary;

    print("kjsdnfjkda ${_service.bookingAt}");

    double payableAmount = int.parse(_service.quantity) * (double.parse(_service.price));
    print("sdjnfkjsan payable amount before discount $payableAmount");
    if (_orderRequestPush.couponData != null) {
      if (_orderRequestPush.couponData.discountType.toString() == "percent") {
        _orderRequestPush.couponData.discountType.toString();
        payableAmount = payableAmount - payableAmount * (_orderRequestPush.couponData.discount / 100);
      } else {
        payableAmount = payableAmount - _orderRequestPush.couponData.discount;
      }
    }
    print("sdjnfkjsan payable amount after discount $payableAmount");

    return GestureDetector(
      onTap: () {
        // Get.toNamed(Routes.BOOKING, arguments: _service);
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: Ui.getBoxDecoration(),
          child: Row(
            children: [
              // Container(
              //   width: 80,
              //   child:
              //   Column(
              //     children: [
              //       Text(
              //           _service.bookingAt != null? DateFormat('HH:mm', Get.locale.toString()).format(_service.bookingAt): "N/A",
              //           maxLines: 1,
              //           style: Get.textTheme.bodyText2.merge(
              //             TextStyle(color: Get.theme.primaryColor, height: 1.4),
              //           ),
              //           softWrap: false,
              //           textAlign: TextAlign.center,
              //           overflow: TextOverflow.fade),
              //       Text( _service.bookingAt != null? DateFormat('dd', Get.locale.toString()).format(_service.bookingAt): "N/A",
              //           maxLines: 1,
              //           style: Get.textTheme.headline3.merge(
              //             TextStyle(color: Get.theme.primaryColor, height: 1),
              //           ),
              //           softWrap: false,
              //           textAlign: TextAlign.center,
              //           overflow: TextOverflow.fade),
              //       Text(_service.bookingAt != null? DateFormat('MMM', Get.locale.toString()).format(_service.bookingAt): "N/A",
              //           maxLines: 1,
              //           style: Get.textTheme.bodyText2.merge(
              //             TextStyle(color: Get.theme.primaryColor, height: 1),
              //           ),
              //           softWrap: false,
              //           textAlign: TextAlign.center,
              //           overflow: TextOverflow.fade),
              //     ],
              //   ),
              //   decoration: BoxDecoration(
              //     color: _color,
              //     borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
              //   ),
              //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              // ),
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      imageUrl: _service.eservice.has_media? _service.eservice.media[0].url : "",
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 80,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error_outline),
                    ),
                  ),
                  Container(
                    width: 80,
                    child: Column(
                      children: [
                        Text(_service.bookingAt != null ? DateFormat('HH:mm', Get.locale.toString()).format(_service.bookingAt) : "N/A",
                            maxLines: 1,
                            style: Get.textTheme.bodyText2.merge(
                              TextStyle(color: Get.theme.primaryColor, height: 1.4),
                            ),
                            softWrap: false,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade),
                        Text(_service.bookingAt != null ? DateFormat('dd', Get.locale.toString()).format(_service.bookingAt) : "N/A",
                            maxLines: 1,
                            style: Get.textTheme.headline3.merge(
                              TextStyle(color: Get.theme.primaryColor, height: 1),
                            ),
                            softWrap: false,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade),
                        Text(_service.bookingAt != null ? DateFormat('MMM', Get.locale.toString()).format(_service.bookingAt) : "N/A",
                            maxLines: 1,
                            style: Get.textTheme.bodyText2.merge(
                              TextStyle(color: Get.theme.primaryColor, height: 1),
                            ),
                            softWrap: false,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: _color,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                  ),
                ],
              ),

              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${_service.eService.name}", style: TextStyle(color: Colors.black, fontSize: 16)),
                    SizedBox(
                      height: 5,
                    ),
                    if(_service.eSubServiceName != null)
                      Text("${_service.eSubServiceName.en}", style: TextStyle(color: Colors.grey, fontSize: 16)),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text("Price:",
                            style: TextStyle(
                              color: Get.theme.colorScheme.secondary,
                              fontSize: 14,
                            )),
                        SizedBox(width: 5),
                        if (_orderRequestPush.couponData != null) Text("\$${int.parse(_service.quantity) * (double.parse(_service.price))}", style: TextStyle(color: Colors.grey, fontSize: 14, decoration: TextDecoration.lineThrough), maxLines: 4, overflow: TextOverflow.ellipsis, textDirection: TextDirection.rtl, textAlign: TextAlign.justify),
                        SizedBox(width: 5),
                        Text("\$$payableAmount", style: TextStyle(color: Get.theme.colorScheme.secondary, fontSize: 14), maxLines: 4, overflow: TextOverflow.ellipsis, textDirection: TextDirection.rtl, textAlign: TextAlign.justify),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 18,
                          color: Get.theme.focusColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child:
                          Text(
                            "${_service.address.address}",
                            maxLines: 3,
                            style: TextStyle(
                              color: Get.theme.focusColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                _requestController.declineBookingRequest(_service.eServiceId, _service.serviceType);
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Get.theme.focusColor),
                              )),
                          Obx((){

                            return GestureDetector(
                                onTap: () async {
                                  isLoading.value = true;
                                  // AcceptRequestBody acceptRequestBody = new AcceptRequestBody(e_service: "${_service.eServiceId}", event_id: "${_service.id}", booking_status_id: "1", quantity: "${_service.quantity}", coupon_id: "1", order_id: "${_service.orderId}", address_id: "${_orderRequestPush.eventData.address.id}", booking_at: "${_service.bookingAt}");
                                  AcceptRequestBody acceptRequestBody = new AcceptRequestBody(e_service: "${_service.eServiceId}", event_id: "${_service.id}", booking_status_id: "4", quantity: "${_service.quantity}", added_unit: "${_service.quantity}",  coupon_id: "1", order_id: "${_service.orderId}", address_id: "", booking_at: "${_service.bookingAt}");
                                  await _requestController.acceptBookingRequest(_service.eServiceId, _service.serviceType, body: acceptRequestBody);
                                  isLoading.value = false;
                                },
                                child: isLoading.value? Container(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2,)) : Text("Accept"));
                          })

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
