import 'package:get/get.dart';
import 'package:home_service/app/models/parents/model.dart';
import 'address_model.dart';

class OrderRequestResponse {
  String message;
  String channelName;
  EventData eventData;
  var status = "accept_request".obs;



  @override
  String toString() {
    return 'OrderRequestResponse{message: $message, channelName: $channelName, eventData: $eventData}';
  }

  OrderRequestResponse({this.message, this.channelName, this.eventData});

  OrderRequestResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    channelName = json['channel_name'];
    eventData = json['eventData'] != null ? new EventData.fromJson(json['eventData']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['channel_name'] = this.channelName;
    if (this.eventData != null) {
      data['eventData'] = this.eventData.toJson();
    }
    return data;
  }
}

class EventData {
  String couponCode;
  String note;
  Address address;
  List<Service> service;
  String apiToken;
  int orderId;
  CouponData coupon_data;


  @override
  String toString() {
    return 'EventData{couponCode: $couponCode, note: $note, address: $address, service: $service, apiToken: $apiToken, orderId: $orderId, couponData: $coupon_data}';
  }

  EventData({this.couponCode, this.note, this.address, this.service, this.apiToken, this.orderId, this.coupon_data});

  EventData.fromJson(Map<String, dynamic> json) {
    couponCode = json['coupon_code'];
    note = json['note'];
    address = json['address'] != null ? new Address.fromJson(json['address']) : null;
    if (json['service'] != null) {
      service = new List<Service>();
      json['service'].forEach((v) {
        service.add(new Service.fromJson(v));
      });
    }
    apiToken = json['api_token'];
    orderId = json['order_id'];
    // coupon_data = json['coupon_data'];
    coupon_data = json['coupon_data'] != null ? new CouponData.fromJson(json['coupon_data']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coupon_code'] = this.couponCode;
    data['note'] = this.note;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.service != null) {
      data['service'] = this.service.map((v) => v.toJson()).toList();
    }
    data['api_token'] = this.apiToken;
    data['order_id'] = this.orderId;
    data['coupon_data'] = this.coupon_data;
    return data;
  }
}


class Service extends Model{
  String id;
  String serviceType;
  String serviceName;
  String eServiceId;
  String name;
  String imageUrl;
  String price;
  String minimumUnit;
  String addedUnit;
  DateTime bookingAt;
  int eventId;
  String status;


  @override
  String toString() {
    return 'Service{id: $id, serviceType: $serviceType, serviceName: $serviceName, eServiceId: $eServiceId, name: $name, imageUrl: $imageUrl, price: $price, minimumUnit: $minimumUnit, addedUnit: $addedUnit, bookingAt: $bookingAt, eventId: $eventId, status: $status}';
  }

  Service({this.id, this.serviceType, this.serviceName, this.eServiceId, this.name, this.imageUrl, this.price, this.minimumUnit, this.addedUnit, this.bookingAt, this.eventId, this.status});

  Service.fromJson(Map<String, dynamic> json) {
    id = stringFromJson(json, ('id'));
    serviceType = json['service_type'];
    serviceName = json['service_name'];
    eServiceId = json['e_service_id'];
    name = json['name'];
    imageUrl = json['image_url'];
    price = json['price'];
    minimumUnit = json['minimum_unit'];
    addedUnit = json['added_unit'];
    bookingAt = dateFromJson(json, 'booking_at');
    eventId = json['event_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_type'] = this.serviceType;
    data['service_name'] = this.serviceName;
    data['e_service_id'] = this.eServiceId;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    data['price'] = this.price;
    data['minimum_unit'] = this.minimumUnit;
    data['added_unit'] = this.addedUnit;
    data['booking_at'] = this.bookingAt;
    data['event_id'] = this.eventId;
    return data;
  }

}

class CouponData extends Model{
  String code;
  String expiresAt;
  String updatedAt;
  double discount;
  Description description;
  String createdAt;
  String id;
  String discountType;
  bool enabled;
  CouponData(
      {this.code,
        this.expiresAt,
        this.updatedAt,
        this.discount,
        this.description,
        this.createdAt,
        this.id,
        this.discountType,
        this.enabled});


  @override
  String toString() {
    return 'nkjfsajfknaj CouponData{code: $code, expiresAt: $expiresAt, updatedAt: $updatedAt, discount: $discount, description: $description, createdAt: $createdAt, id: $id, discountType: $discountType, enabled: $enabled}';
  }

  CouponData.fromJson(Map<String, dynamic> json) {
    print("nkjfsajfknaj json ${json.toString()}");
    print("nkjfsajfknaj json['code'] ${json['code']}");

    code = json['code'];
    print("jdfnjkasn ${json['code']}");

    expiresAt = json['expires_at'];
    updatedAt = json['updated_at'];
    discount = doubleFromJson(json, 'discount');
    description = json['description'] != null
        ? new Description.fromJson(json['description'])
        : null;
    createdAt = json['created_at'];
    id = stringFromJson(json, 'id');
    discountType = json['discount_type'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['expires_at'] = this.expiresAt;
    data['updated_at'] = this.updatedAt;
    data['discount'] = this.discount;
    if (this.description != null) {
      data['description'] = this.description.toJson();
    }
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['discount_type'] = this.discountType;
    data['enabled'] = this.enabled;
    return data;
  }
}

class Description {
  String en;
  Description({this.en});
  Description.fromJson(Map<String, dynamic> json) {
    en = json['en'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    return data;
  }
}
