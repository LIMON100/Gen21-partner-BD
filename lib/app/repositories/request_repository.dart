import 'package:get/get.dart';

import '../models/receive_booking_response.dart';
import '../providers/laravel_provider.dart';

class RequestRepository {
  LaravelApiClient _laravelApiClient;

  RequestRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<ReceiveBooking> acceptBookingRequest({var data}) {
    return _laravelApiClient.acceptBookingRequest(data: data);
  }

  Future getBookingRequestedServices({String orderId}) {
    return _laravelApiClient.getBookingRequestedServices(orderId);
  }

}
