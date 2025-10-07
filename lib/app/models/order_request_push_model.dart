import 'dart:convert';

import 'package:get/get.dart';

import '../../common/log_data.dart';
import 'parents/model.dart';

class OrderRequestPush {
  String pusherChanelName;
  var status = "accept_request".obs;
  Data data;

  OrderRequestPush({this.pusherChanelName, this.data});

  OrderRequestPush.fromJson(Map<dynamic, dynamic> json) {
    pusherChanelName = json['pusher_channel_name'];
    print("hyuu6oiYY $pusherChanelName");
    print("hyuu6oiYY ${json['data']}");
    // String testData = json['data'];
    data = json['data'] != null ? new Data.fromJson(jsonDecode(json['data'])) : null;
    // data = json['data'] != null ? new Data.fromJson(testData) : null;

  }


  @override
  String toString() {
    return 'hyuu6oiYY OrderRequestPush{pusherChanelName: $pusherChanelName, data: $data}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pusher_channel_name'] = this.pusherChanelName;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String note;
  String couponCode;
  Address address;
  List<Service> service;
  CouponData coupon_data;
  int orderId;

  Data({this.note, this.couponCode, this.address, this.service, this.coupon_data, this.orderId});


  @override
  String toString() {
    return 'hyuu6oiYY Data{note: $note, couponCode: $couponCode, address: $address, service: $service, coupon_data: $coupon_data, orderId: $orderId}';
  }

  Data.fromJson(Map<String, dynamic> json) {
    printWrapped("nkjfsajfknaj json.toString() ${json.toString()}");
    note = json['note'];
    couponCode = json['coupon_code'];
    address = json['address'] != null ? new Address.fromJson(json['address']) : null;
    if (json['service'] != null) {
      service = new List<Service>();
      json['service'].forEach((v) {
        service.add(new Service.fromJson(v));
      });
    }
    print("hyuu6oiYY json['coupon_data'] ${json['coupon_data']}");

    coupon_data = json['coupon_data'] != null ? new CouponData.fromJson(json['coupon_data']) : null;

    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['note'] = this.note;
    data['coupon_code'] = this.couponCode;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.service != null) {
      data['service'] = this.service.map((v) => v.toJson()).toList();
    }
    data['order_id'] = this.orderId;
    return data;
  }
}

class Address extends Model{
  String address;
  String userId;
  double latitude;
  String description;
  String id;
  double longitude;

  Address(
      {this.address,
        this.userId,
        this.latitude,
        this.description,
        this.id,
        this.longitude});

  Address.fromJson(Map<String, dynamic> json) {
    address = stringFromJson(json, 'address');
    userId = stringFromJson(json, 'user_id');
    latitude = doubleFromJson(json, 'latitude');
    description = stringFromJson(json, 'description');
    id = stringFromJson(json, 'id');
    longitude = doubleFromJson(json, 'longitude');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['user_id'] = this.userId;
    data['latitude'] = this.latitude;
    data['description'] = this.description;
    data['id'] = this.id;
    data['longitude'] = this.longitude;
    return data;
  }
}
class Service extends Model{
  String serviceType;
  String addedUnit;
  String eventId;
  String serviceName;
  String imageUrl;
  String price;
  String name;
  String eServiceId;
  String id;
  String minimumUnit;
  DateTime booking_at;


  Service(
      {this.serviceType,
        this.addedUnit,
        this.eventId,
        this.serviceName,
        this.imageUrl,
        this.price,
        this.name,
        this.eServiceId,
        this.id,
        this.minimumUnit, this.booking_at});

  Service.fromJson(Map<String, dynamic> json) {
    serviceType = json['service_type'];
    addedUnit = json['added_unit'];
    eventId = stringFromJson(json, 'event_id');
    serviceName = json['service_name'];
    imageUrl = json['image_url'];
    price = json['price'];
    name = json['name'];
    eServiceId = json['e_service_id'];
    id = stringFromJson(json, 'id');
    minimumUnit = json['minimum_unit'];
    booking_at = dateFromJson(json, 'booking_at');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_type'] = this.serviceType;
    data['added_unit'] = this.addedUnit;
    data['service_name'] = this.serviceName;
    data['image_url'] = this.imageUrl;
    data['price'] = this.price;
    data['name'] = this.name;
    data['e_service_id'] = this.eServiceId;
    data['id'] = this.id;
    data['minimum_unit'] = this.minimumUnit;
    data['booking_at'] = this.booking_at;
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
    return 'hyuu6oiYY CouponData{code: $code, expiresAt: $expiresAt, updatedAt: $updatedAt, discount: $discount, description: $description, createdAt: $createdAt, id: $id, discountType: $discountType, enabled: $enabled}';
  }

  CouponData.fromJson(Map<String, dynamic> json) {
    print("hyuu6oiYY json ${json.toString()}");
    print("hyuu6oiYY json['code'] ${json['code']}");

    code = json['code'];
    print("hyuu6oiYY ${json['code']}");

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

