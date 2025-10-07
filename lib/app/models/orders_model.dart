import 'coupon_model.dart';
import 'parents/model.dart';

class Orders extends Model {
  bool success;
  List<Data> data;
  String message;

  Orders({this.success, this.data, this.message});

  Orders.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data extends Model {
  String id;
  int userId;
  String couponId;
  Address address;
  String note;
  DateTime createdAt;
  String updatedAt;
  int totalItem;
  int totalAcceptItem;
  int totalPrice;
  User user;
  List<CustomerRequest> customerRequest;
  Coupon coupon;

  Data({
    this.id,
    this.userId,
    this.couponId,
    this.address,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.totalItem,
    this.totalAcceptItem,
    this.totalPrice,
    this.user,
    this.customerRequest,
    this.coupon,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = stringFromJson(json, 'id');
    userId = json['user_id'];
    // couponId = json['coupon_id'];
    couponId = stringFromJson(json, 'coupon_id');
    address = json['address'] != null ? new Address.fromJson(json['address']) : null;
    note = json['note'];
    createdAt = dateFromJson(json, 'created_at');
    updatedAt = json['updated_at'];
    totalItem = json['total_item'];
    totalAcceptItem = json['total_accept_item'];
    totalPrice = json['total_price'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['customer_request'] != null) {
      customerRequest = new List<CustomerRequest>();
      json['customer_request'].forEach((v) {
        customerRequest.add(new CustomerRequest.fromJson(v));
      });
    }
    coupon = json['coupon'] != null ? new Coupon.fromJson(json['coupon']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['coupon_id'] = this.couponId;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    data['note'] = this.note;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['total_item'] = this.totalItem;
    data['total_accept_item'] = this.totalAcceptItem;
    data['total_price'] = this.totalPrice;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.customerRequest != null) {
      data['customer_request'] = this.customerRequest.map((v) => v.toJson()).toList();
    }
    if (this.coupon != null) {
      data['coupon'] = this.coupon.toJson();
    }
    return data;
  }
}

class Address extends Model {
  String id;
  String description;
  String address;
  double latitude;
  double longitude;
  String userId;

  Address({this.id, this.description, this.address, this.latitude, this.longitude, this.userId});

  Address.fromJson(Map<String, dynamic> json) {
    id = stringFromJson(json, 'id');
    description = stringFromJson(json, 'description');
    address = stringFromJson(json, 'address');
    latitude = doubleFromJson(json, 'latitude');
    longitude = doubleFromJson(json, 'longitude');
    userId = stringFromJson(json, 'user_id');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['user_id'] = this.userId;
    return data;
  }
}

class User {
  int id;
  String name;
  String email;
  String phoneNumber;
  String phoneVerifiedAt;
  String emailVerifiedAt;
  String apiToken;
  String deviceToken;
  String stripeId;
  String cardBrand;
  String cardLastFour;
  String trialEndsAt;
  String paypalEmail;
  String createdAt;
  String updatedAt;
  CustomFields customFields;
  bool hasMedia;

  // List<Null> media;

  User({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.phoneVerifiedAt,
    this.emailVerifiedAt,
    this.apiToken,
    this.deviceToken,
    this.stripeId,
    this.cardBrand,
    this.cardLastFour,
    this.trialEndsAt,
    this.paypalEmail,
    this.createdAt,
    this.updatedAt,
    this.customFields,
    this.hasMedia,
    // this.media
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    phoneVerifiedAt = json['phone_verified_at'];
    emailVerifiedAt = json['email_verified_at'];
    apiToken = json['api_token'];
    deviceToken = json['device_token'];
    stripeId = json['stripe_id'];
    cardBrand = json['card_brand'];
    cardLastFour = json['card_last_four'];
    trialEndsAt = json['trial_ends_at'];
    paypalEmail = json['paypal_email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customFields = json['custom_fields'] != null ? new CustomFields.fromJson(json['custom_fields']) : null;
    hasMedia = json['has_media'];
    // if (json['media'] != null) {
    //   media = new List<Null>();
    //   json['media'].forEach((v) {
    //     media.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['phone_verified_at'] = this.phoneVerifiedAt;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['api_token'] = this.apiToken;
    data['device_token'] = this.deviceToken;
    data['stripe_id'] = this.stripeId;
    data['card_brand'] = this.cardBrand;
    data['card_last_four'] = this.cardLastFour;
    data['trial_ends_at'] = this.trialEndsAt;
    data['paypal_email'] = this.paypalEmail;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.customFields != null) {
      data['custom_fields'] = this.customFields.toJson();
    }
    data['has_media'] = this.hasMedia;
    // if (this.media != null) {
    //   data['media'] = this.media.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class CustomFields {
  Bio bio;
  Bio address;

  CustomFields({this.bio, this.address});

  CustomFields.fromJson(Map<String, dynamic> json) {
    bio = json['bio'] != null ? new Bio.fromJson(json['bio']) : null;
    address = json['address'] != null ? new Bio.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bio != null) {
      data['bio'] = this.bio.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    return data;
  }
}

class Bio {
  String value;
  String view;
  String name;

  Bio({this.value, this.view, this.name});

  Bio.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    view = json['view'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['view'] = this.view;
    data['name'] = this.name;
    return data;
  }
}

class CustomerRequest extends Model {
  String id;
  String serviceType;
  int userId;
  int eServiceId;
  int quantity;
  int orderId;
  int eProviderUserId;
  int acceptEProviderUserId;
  String status;
  String createdAt;
  String updatedAt;
  String customer_name;
  String eServiceName;
  String eSubServiceName;
  double orderAmmount;
  int discountAmount;
  int cupon;

  CustomerRequest({this.id, this.serviceType, this.userId, this.eServiceId, this.quantity, this.orderId, this.eProviderUserId, this.acceptEProviderUserId, this.status, this.createdAt, this.updatedAt, this.customer_name, this.eServiceName, this.eSubServiceName, this.orderAmmount, this.discountAmount, this.cupon});

  CustomerRequest.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
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
    customer_name = json['customer_name'];
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
    data['customer_name'] = this.customer_name;
    data['e_service_name'] = this.eServiceName;
    data['e_sub_service_name'] = this.eSubServiceName;
    data['order_ammount'] = this.orderAmmount;
    data['discount_amount'] = this.discountAmount;
    data['cupon'] = this.cupon;
    return data;
  }
}
