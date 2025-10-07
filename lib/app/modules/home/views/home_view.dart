import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../../common/log_data.dart';
import '../../../providers/laravel_provider.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../../orders/views/orders_view.dart';
import '../controllers/home_controller.dart';
import '../widgets/bookings_list_widget.dart';
import '../widgets/statistics_carousel_widget.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }

}

class HomeViewState extends State<HomeView>{
  HomeController controller = Get.find<HomeController>();

  @override
  void dispose() {
    printWrapped("jsndjs HomeViewState dispose()");
    // controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.initScrollController();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        body: RefreshIndicator(
            onRefresh: () async {
              Get.find<LaravelApiClient>().forceRefresh();
              controller.refreshHome(showMessage: true);
              Get.find<LaravelApiClient>().unForceRefresh();
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: controller.scrollController,
              shrinkWrap: false,
              slivers: <Widget>[
                Obx(() {
                  return SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 230,
                    elevation: 0.5,
                    floating: false,
                    iconTheme: IconThemeData(color: Get.theme.primaryColor),
                    title: Text(
                      Get.find<SettingsService>().setting.value.providerAppName,
                      style: Get.textTheme.headline6,
                    ),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                      icon: new Icon(Icons.sort, color: Colors.black87),
                      onPressed: () => {Scaffold.of(context).openDrawer()},
                    ),
                    actions: [NotificationsButtonWidget()],
                    // bottom: controller.bookingStatuses.isEmpty
                    //     ? TabBarLoadingWidget()
                    //     : TabBarWidget(
                    //         tag: 'home',
                    //         initialSelectedId: controller.bookingStatuses.elementAt(0).id,
                    //         tabs: List.generate(controller.bookingStatuses.length, (index) {
                    //           var _status = controller.bookingStatuses.elementAt(index);
                    //           return ChipWidget(
                    //             tag: 'home',
                    //             text: _status.status,
                    //             id: _status.id,
                    //             onSelected: (id) {
                    //               controller.changeTab(id);
                    //             },
                    //           );
                    //         }),
                    //       ),
                    flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background:
                        // Container(child: Text("Hi"),)
                        Container(
                          child: StatisticsCarouselWidget(
                            statisticsList: controller.statistics,
                          ).paddingOnly(top: 95),
                        )
                    ),
                  );
                }),

                SliverToBoxAdapter(
                  child:  Container( child: OrdersView()),
                  // Wrap(
                  //   children: [
                  //     // Text("data"),
                  //     OrdersView(),
                  //   ],
                  // ),

                ),
                // OrdersView(),
              ],
            )),
      ),
    );
  }
}
