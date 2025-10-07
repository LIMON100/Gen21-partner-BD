import 'package:get/get.dart';
import 'package:home_service/app/models/parents/model.dart';

import '../../common/log_data.dart';
import 'address_model.dart';
import 'e_service_model.dart';
import 'media_model.dart';

class OrderRequestResponse extends Model{
  String message;
  RxString status = "request".obs;
  CouponData couponData;
  String channelName;
  List<EventData> eventData;

  OrderRequestResponse(
      {this.message,
        this.status,
        this.couponData,
        this.channelName,
        this.eventData});

  OrderRequestResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status.value = stringFromJson(json, 'status');
    couponData = json['coupon_data'] != null
        ? new CouponData.fromJson(json['coupon_data'])
        : null;
    channelName = stringFromJson(json, 'channel_name');
    if (json['eventData'] != null) {
      eventData = new List<EventData>();
      json['eventData'].forEach((v) {
        eventData.add(new EventData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.couponData != null) {
      data['coupon_data'] = this.couponData.toJson();
    }
    data['channel_name'] = this.channelName;
    if (this.eventData != null) {
      data['eventData'] = this.eventData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CouponData extends Model{
  String id;
  String code;
  int discount;
  String discountType;
  Description description;
  String expiresAt;
  bool enabled;
  String createdAt;
  String updatedAt;

  CouponData(
      {this.id,
        this.code,
        this.discount,
        this.discountType,
        this.description,
        this.expiresAt,
        this.enabled,
        this.createdAt,
        this.updatedAt,
      });

  CouponData.fromJson(Map<String, dynamic> json) {
    id = stringFromJson(json, 'id');
    code = stringFromJson(json, 'code');
    discount = json['discount'];
    discountType = json['discount_type'];
    description = json['description'] != null
        ? new Description.fromJson(json['description'])
        : null;
    expiresAt = json['expires_at'];
    enabled = json['enabled'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    if (this.description != null) {
      data['description'] = this.description.toJson();
    }
    data['expires_at'] = this.expiresAt;
    data['enabled'] = this.enabled;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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

class EventData extends Model{
  String id;
  String serviceType;
  String userId;
  String eServiceId;
  String quantity;
  String orderId;
  String eProviderUserId;
  String acceptEProviderUserId;
  String status;
  String createdAt;
  String updatedAt;
  String customerName;
  String eServiceName;
  SubService eSubServiceName;
  String price;
  String minimumUnit;
  String orderAmmount;
  String discountAmount;
  DateTime bookingAt;
  Address address;
  List<Media> media;
  EService eService;
  Eservice eservice;


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
        this.customerName,
        this.eServiceName,
        this.eSubServiceName,
        this.price,
        this.minimumUnit,
        this.orderAmmount,
        this.discountAmount,
        this.bookingAt,
      this.address, this.media,
        this.eService,
      this.eservice});

  EventData.fromJson(Map<String, dynamic> json) {
    id = stringFromJson(json, 'id');
    serviceType = json['service_type'];
    userId = stringFromJson(json, 'user_id');
    eServiceId = stringFromJson(json, 'e_service_id');
    quantity = stringFromJson(json, 'quantity');
    orderId = stringFromJson(json, 'order_id');
    eProviderUserId = stringFromJson(json, 'e_provider_user_id');
    acceptEProviderUserId = stringFromJson(json, 'accept_e_provider_user_id');
    status = stringFromJson(json, 'status');
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customerName = json['customer_name'];
    eServiceName = json['e_service_name'];
    // eSubServiceName = json['e_sub_service_name'] != null
    //     ? new SubService.fromJson(json['e_sub_service_name']): null;
    price = stringFromJson(json, 'price');
    minimumUnit = stringFromJson(json, 'minimum_unit');
    orderAmmount = stringFromJson(json, 'order_ammount');
    discountAmount =  stringFromJson(json, 'discount_amount');
    bookingAt = dateFromJson(json, 'booking_at', defaultValue: null);
    address = json['address'] != null
        ? new Address.fromJson(json['address'])
        : null;
    media = json['media'] != null
        ?  mediaListFromJson(json, 'media')
        : null;

    eService = json['e_service'] != null
        ? new EService.fromJson(json['e_service'])
        : null;

    eservice = json['e_service'] != null
        ? new Eservice.fromJson(json['e_service'])
        : null;

    printWrapped("slmkfmklmkl media: ${media.toString()} ");


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
    data['customer_name'] = this.customerName;
    data['e_service_name'] = this.eServiceName;
    data['e_sub_service_name'] = this.eSubServiceName;
    if (this.eSubServiceName != null) {
      data['e_sub_service_name'] = this.eSubServiceName.toJson();
    }
    data['price'] = this.price;
    data['minimum_unit'] = this.minimumUnit;
    data['order_ammount'] = this.orderAmmount;
    data['discount_amount'] = this.discountAmount;
    data['booking_at'] = this.bookingAt;
    data['address'] = this.address;
    data['e_Service'] = this.eService;
    data['e_service'] = this.eservice;

    data['media'] = this.media;
    return data;
  }
}

class Eservice extends Model{
  bool has_media;
  List<Media> media;
  @override
  String toString() {
    return 'Eservice{has_media: $has_media, media: $media}';
  }

  Eservice(this.has_media, this.media);

  Eservice.fromJson(Map<String, dynamic> json) {
    printWrapped("slmkfmklmkl has_media: ${has_media} ");

    has_media = boolFromJson(json ,'has_media');
    printWrapped("slmkfmklmkl has_media: ${has_media} ");

    media = json['media'] != null
        ?  mediaListFromJson(json, 'media')
        : null;
    printWrapped("slmkfmklmkl media: ${media.toString()} ");

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['has_media'] = this.has_media;
    data['media'] = this.media;
    return data;
  }

}

class SubService {
  String en;

  SubService({this.en});

  SubService.fromJson(Map<String, dynamic> json) {
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    return data;
  }
}


