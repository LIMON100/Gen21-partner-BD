import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_service/app/modules/service_request/widgets/service_request_list_item_widget.dart';

import '../../global_widgets/circular_loading_widget.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/widgets/bookings_list_item_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/RequestController.dart';

class ServiceRequestsListWidget extends GetView<RequestController> {
  // final RequestController _requestController = Get.put(RequestController());

  ServiceRequestsListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print("ksdnfjsna in ServiceRequestsListWidget build");
      print(controller.orderRequestResponse.value);

      print("ksdnfjsna data: ${controller.orderRequestResponse.value.toString()}");
      if (controller.orderRequestResponse.value == null) {
        return CircularLoadingWidget(height: 300);
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.orderedServiceList.length,
          itemBuilder: ((_, index) {
            var _service = controller.orderedServiceList.elementAt(index);
            return ServiceRequestListItemWidget(service: _service, orderRequestPush: controller.orderRequestResponse.value);
          }),
        );
      }
    });
  }
}
