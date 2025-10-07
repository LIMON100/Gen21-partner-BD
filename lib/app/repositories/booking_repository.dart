import 'package:get/get.dart';

import '../models/booking_model.dart';
import '../models/booking_new_model.dart';
import '../models/booking_status_model.dart';
import '../providers/laravel_provider.dart';

class BookingRepository {
  LaravelApiClient _laravelApiClient;

  BookingRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<BookingNew>> all(String statusId, {int page}) {
    return _laravelApiClient.getBookings(statusId, page);
  }

  Future<List<BookingNew>> allNew(String statusId, {int page, orderId}) {
    return _laravelApiClient.getBookingsNew(statusId, page, orderId);
  }

  Future<List<BookingStatus>> getStatuses() {
    return _laravelApiClient.getBookingStatuses();
  }

  Future<BookingNew> get(String bookingId) {
    return _laravelApiClient.getBooking(bookingId);
  }
  Future<BookingNew> getBookingDetails(String bookingId) {
    return _laravelApiClient.getBookingDetails(bookingId);
  }

  Future<BookingNew> update(BookingNew booking) {
    return _laravelApiClient.updateBooking(booking);
  }
  Future<BookingNew> updateBookingNew(BookingNew booking, String orderId) {
    return _laravelApiClient.updateBookingNew(booking, orderId);
  }
}
