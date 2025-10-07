/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/extentions.dart';
import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_new_model.dart';
import '../../../routes/app_routes.dart';
import '../controllers/bookings_controllerNew.dart';

class BookingsListItemWidgetNew extends StatelessWidget {
  const BookingsListItemWidgetNew({
    Key key,
    @required BookingNew booking, String orderId
  })  : _booking = booking,
        _orderId = orderId,
        super(key: key);

  final BookingNew _booking;
  final String _orderId;

  @override
  Widget build(BuildContext context) {
    Color _color = _booking.cancel ? Get.theme.focusColor : Get.theme.colorScheme.secondary;
    return GestureDetector(
      onTap: () {
        // Get.toNamed(Routes.BOOKING, arguments: _booking);
        // Get.toNamed(Routes.BOOKING_DETAILS, arguments:{ 'booking': _booking, 'orderId': _orderId });
        Get.toNamed(Routes.BOOKING_DETAILS, arguments:_booking);
      },
      child:
      Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: Ui.getBoxDecoration(),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      child: CachedNetworkImage(
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        imageUrl: _booking.eService.firstImageThumb,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 80,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error_outline),
                      ),
                    ),
                    if (_booking.payment != null)
                      Container(
                        width: 80,
                        child: Text(_booking.payment.paymentStatus?.status ?? '',
                            style: Get.textTheme.caption.merge(
                              TextStyle(fontSize: 10),
                            ),
                            maxLines: 1,
                            softWrap: false,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade),
                        decoration: BoxDecoration(
                          color: Get.theme.focusColor.withOpacity(0.2),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                      ),
                    Container(
                      width: 80,
                      child: Column(
                        children: [
                          Text(
                            _booking.bookingAt != null? DateFormat('HH:mm', Get.locale.toString()).format(_booking.bookingAt): "N/A",
                              maxLines: 1,
                              style: Get.textTheme.bodyText2.merge(
                                TextStyle(color: Get.theme.primaryColor, height: 1.4),
                              ),
                              softWrap: false,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade),
                          Text( _booking.bookingAt != null? DateFormat('dd', Get.locale.toString()).format(_booking.bookingAt): "N/A",
                              maxLines: 1,
                              style: Get.textTheme.headline3.merge(
                                TextStyle(color: Get.theme.primaryColor, height: 1),
                              ),
                              softWrap: false,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade),
                          Text(_booking.bookingAt != null? DateFormat('MMM', Get.locale.toString()).format(_booking.bookingAt): "N/A",
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
                SizedBox(width: 12),
                Expanded(
                  child: Opacity(
                    opacity: _booking.cancel ? 0.3 : 1,
                    child: Wrap(
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  color: "${Get.find<BookingsControllerNew>().getBookingStatusById(_booking.booking_status_id).backgroundColor}".toColor(),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Text("${Get.find<BookingsControllerNew>().getBookingStatusById(_booking.booking_status_id).status}", style: TextStyle(color: "${Get.find<BookingsControllerNew>().getBookingStatusById(_booking.booking_status_id).textColor}".toColor()),))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _booking.eService?.name ?? '',
                                style: Get.textTheme.bodyText2,
                                maxLines: 3,
                                // textAlign: TextAlign.end,
                              ),
                            ),
                            // BookingOptionsPopupMenuWidget(booking: _booking),
                          ],
                        ),
                        if(_booking.options != null)
                        Text("${_booking.options.name.en}", style: TextStyle(color: Colors.grey),),
                        Divider(height: 8, thickness: 1),
                        Row(
                          children: [
                            Icon(
                              Icons.build_circle_outlined,
                              size: 18,
                              color: Get.theme.focusColor,
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                _booking.eProvider.name,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Get.textTheme.bodyText1,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.place_outlined,
                              size: 18,
                              color: Get.theme.focusColor,
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(
                               _booking.address != null?
                                _booking.address.address: "N/A",
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Get.textTheme.bodyText1,
                              ),
                            ),
                          ],
                        ),
                        // Divider(height: 8, thickness: 1),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Expanded(
                        //       flex: 1,
                        //       child: Text(
                        //         "Total".tr,
                        //         maxLines: 1,
                        //         overflow: TextOverflow.fade,
                        //         softWrap: false,
                        //         style: Get.textTheme.bodyText1,
                        //       ),
                        //     ),
                        //     // Expanded(
                        //     //   flex: 1,
                        //     //   child: Align(
                        //     //     alignment: AlignmentDirectional.centerEnd,
                        //     //     child: Ui.getPrice(
                        //     //       _booking.getTotal(),
                        //     //       style: Get.textTheme.headline6.merge(TextStyle(color: _color)),
                        //     //     ),
                        //     //   ),
                        //     // ),
                        //   ],
                        // ),

                        if( _booking.coupon != null &&  _booking.coupon.code != null)
                        Row(
                            children: [
                              Icon(
                                Icons.discount_outlined,
                                size: 18,
                                color: Get.theme.focusColor,
                              ),
                              SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  _booking.coupon.code,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: Get.textTheme.bodyText1,
                                ),
                              ),
                            ],
                          ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 8, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Total".tr,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: Get.textTheme.bodyText1,
                  ),
                ),
                // Expanded(
                //   flex: 1,
                //   child: Align(
                //     alignment: AlignmentDirectional.centerEnd,
                //     child: Ui.getPrice(
                //       _booking.getTotal(),
                //       style: Get.textTheme.headline6.merge(TextStyle(color: _color)),
                //     ),
                //   ),
                // ),
                Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_booking.total_amount > _booking.total_payable_amount)
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Ui.getPrice(
                              _booking.total_amount,
                              style: Get.textTheme.headline6.merge(TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              )),
                            ),
                          ),
                        SizedBox(
                          width: 5,
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Ui.getPrice(
                            _booking.total_payable_amount,
                            style: Get.textTheme.headline6.merge(TextStyle(color: _color)),
                          ),
                        ),
                      ],
                    )),
              ],
            ),

            // Showing TIPS
            if(_booking.tips.toDouble() > 0.0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Tips".tr,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Get.textTheme.bodyText1,
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Text(_booking.tips.toDouble().toString()+"\$",style: Get.textTheme.headline6.merge(TextStyle(color: _color))),
                        ],
                      )),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
