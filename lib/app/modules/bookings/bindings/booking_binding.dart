import 'package:get/get.dart';
import '../controllers/bookings_controllerNew.dart';
class BookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingsControllerNew>(
      () => BookingsControllerNew(),
    );
  }
}
