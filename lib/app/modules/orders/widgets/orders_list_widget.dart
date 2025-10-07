
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/circular_loading_widget.dart';
import '../../home/controllers/home_controller.dart';
import '../orders_controller/orders_controller.dart';
import 'orders_list_item_widget.dart';

class OrdersListWidget extends GetView<HomeController> {
  OrdersListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print("sdbfhsajk ${controller.orders.value.toString()}");
      if (controller.isLoading.value == true) {
        return CircularLoadingWidget(height: 300);
      } else if(controller.isLoading.value == false && (controller.orders.value!= null && controller.orders.value.data != null && controller.orders.value.data.length > 0)){
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          //fahmid don't know why +1 is here in below syntax
          itemCount: controller.orders.value.data.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.orders.value.data.length) {
              return Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Center(
                    child: new Opacity(
                      opacity: controller.isLoading.value ? 1 : 0,
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                );
              });
            } else {
              var _order = controller.orders.value.data.elementAt(index);
              return OrderListItemWidget(order: _order);
            }
          }),
        );
      }else{
        var padding = MediaQuery.of(context).padding;
        return SizedBox(
          height: MediaQuery.of(context).size.height - 120 - padding.top - padding.bottom,
          child: Center(
            child: Text(
              "No Data Found".tr,
              maxLines: 1,
              style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.hintColor)),
            ),
          ),
        );
      }
    });
  }

}
