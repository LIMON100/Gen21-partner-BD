import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../../home/controllers/home_controller.dart';
import '../orders_controller/orders_controller.dart';
import '../widgets/orders_list_widget.dart';

class OrdersView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    controller.initScrollController();
    return OrdersListWidget();
  }
}
