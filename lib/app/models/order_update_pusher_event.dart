import 'parents/model.dart';

class OrderUpdatePusherEvent {
  String message;
  String status;
  String channelName;
  List<EventData> eventData;

  OrderUpdatePusherEvent({this.message, this.status, this.channelName, this.eventData});

  OrderUpdatePusherEvent.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    channelName = json['channel_name'];
    if (json['eventData'] != null) {
      eventData = <EventData>[];
      json['eventData'].forEach((v) {
        eventData.add(new EventData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['channel_name'] = this.channelName;
    if (this.eventData != null) {
      data['eventData'] = this.eventData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventData extends Model{
  String id;
  String serviceType;
  int userId;
  int eServiceId;
  int quantity;
  int orderId;
  Null eProviderUserId;
  int acceptEProviderUserId;
  String status;
  String createdAt;
  String updatedAt;
  String eServiceName;
  String eSubServiceName;
  double orderAmmount;
  int discountAmount;
  String cupon;

  EventData(
      {this.id,
        this.serviceType,
        this.userId,
        this.eServiceId,
        this.quantity,
        this.orderId,
        this.eProviderUserId,
        this.acceptEProviderUserId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.eServiceName,
        this.eSubServiceName,
        this.orderAmmount,
        this.discountAmount,
        this.cupon});

  EventData.fromJson(Map<String, dynamic> json) {
    id = stringFromJson(json, 'id');
    serviceType = json['service_type'];
    userId = json['user_id'];
    eServiceId = json['e_service_id'];
    quantity = json['quantity'];
    orderId = json['order_id'];
    eProviderUserId = json['e_provider_user_id'];
    acceptEProviderUserId = json['accept_e_provider_user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    eServiceName = json['e_service_name'];
    eSubServiceName = json['e_sub_service_name'];
    orderAmmount = doubleFromJson(json, 'order_ammount');
    discountAmount = json['discount_amount'];
    cupon = json['cupon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_type'] = this.serviceType;
    data['user_id'] = this.userId;
    data['e_service_id'] = this.eServiceId;
    data['quantity'] = this.quantity;
    data['order_id'] = this.orderId;
    data['e_provider_user_id'] = this.eProviderUserId;
    data['accept_e_provider_user_id'] = this.acceptEProviderUserId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['e_service_name'] = this.eServiceName;
    data['e_sub_service_name'] = this.eSubServiceName;
    data['order_ammount'] = this.orderAmmount;
    data['discount_amount'] = this.discountAmount;
    data['cupon'] = this.cupon;
    return data;
  }
}