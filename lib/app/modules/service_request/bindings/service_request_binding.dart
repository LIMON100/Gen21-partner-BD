import 'package:get/get.dart';

import '../../account/controllers/account_controller.dart';
import '../../bookings/controllers/booking_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../reviews/controllers/review_controller.dart';
import '../../reviews/controllers/reviews_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../controllers/RequestController.dart';

class ServiceRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestController>(
      () => RequestController(),
    );
    // Get.put(HomeController(), permanent: true);
    // Get.lazyPut<BookingController>(
    //   () => BookingController(),
    // );
    // Get.lazyPut<ReviewsController>(
    //   () => ReviewsController(),
    // );
    // Get.lazyPut<ReviewController>(
    //   () => ReviewController(),
    // );
    // Get.lazyPut<MessagesController>(
    //   () => MessagesController(),
    //   fenix: true,
    // );
    // Get.lazyPut<AccountController>(
    //   () => AccountController(),
    // );
    // Get.lazyPut<SearchController>(
    //   () => SearchController(),
    // );
  }
}
