import 'package:get/get.dart';
import '../models/orders_model.dart';
import '../providers/laravel_provider.dart';

class OrderRepository {
  LaravelApiClient _laravelApiClient;

  OrderRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<Orders> getOrders() async{
    return await _laravelApiClient.getOrders();
  }
}
