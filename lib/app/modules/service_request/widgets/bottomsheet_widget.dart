import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'service_request_list_widget.dart';

import '../../../routes/app_routes.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/RequestController.dart';

class TestBottomSheetWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    // final RequestController _requestController = Get.put(RequestController());
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
    );
  }
}
