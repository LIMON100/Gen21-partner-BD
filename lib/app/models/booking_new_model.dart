import 'address_model.dart';
import 'booking_status_model.dart';
import 'coupon_model.dart';
import 'e_provider_model.dart';
import 'e_service_model.dart';
import 'parents/model.dart';
import 'payment_model.dart';
import 'tax_model.dart';
import 'user_model.dart';

class BookingNew extends Model {
  String id;
  String hint;
  bool cancel;
  double duration;
  int quantity;
  BookingStatus status;
  User user;
  EService eService;
  EProvider eProvider;
  Options options;
  List<Tax> taxes;
  Address address;
  Coupon coupon;
  DateTime bookingAt;
  DateTime startAt;
  DateTime endsAt;
  Payment payment;
  String booking_status_id;
  double total_amount;
  double total_payable_amount;
  int added_unit;
  String order_id;
  String acceptor_provider_id;
  int tips;


  BookingNew(
      {this.id,
        this.hint,
        this.cancel,
        this.duration,
        this.quantity,
        this.status,
        this.user,
        this.eService,
        this.eProvider,
        this.options,
        this.taxes,
        this.address,
        this.coupon,
        this.bookingAt,
        this.startAt,
        this.endsAt,
        this.payment,

        this.booking_status_id,
        this.total_amount,
        this.total_payable_amount,
        this.added_unit,
        this.order_id,
        this.acceptor_provider_id,
        this.tips,
      });

  BookingNew.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    hint = stringFromJson(json, 'hint');
    cancel = boolFromJson(json, 'cancel');
    duration = doubleFromJson(json, 'duration');
    quantity = intFromJson(json, 'quantity');
    status = objectFromJson(json, 'booking_status', (v) => BookingStatus.fromJson(v));
    user = objectFromJson(json, 'user', (v) => User.fromJson(v));
    eService = objectFromJson(json, 'e_service', (v) => EService.fromJson(v));
    eProvider = objectFromJson(json, 'e_provider', (v) => EProvider.fromJson(v));
    address = objectFromJson(json, 'address', (v) => Address.fromJson(v));
    coupon = objectFromJson(json, 'coupon_data', (v) => Coupon.fromJson(v));
    payment = objectFromJson(json, 'payment', (v) => Payment.fromJson(v));
    options = objectFromJson(json, 'options', (v) => Options.fromJson(v));
    taxes = listFromJson(json, 'taxes', (v) => Tax.fromJson(v));
    bookingAt = dateFromJson(json, 'booking_at', defaultValue: null);
    startAt = dateFromJson(json, 'start_at', defaultValue: null);
    endsAt = dateFromJson(json, 'ends_at', defaultValue: null);

    booking_status_id = stringFromJson(json, 'booking_status_id');
    total_amount = doubleFromJson(json, 'total_amount');
    total_payable_amount = doubleFromJson(json, 'total_payable_amount');
    added_unit = intFromJson(json, 'added_unit');
    order_id = stringFromJson(json, 'order_id');
    acceptor_provider_id = stringFromJson(json, 'acceptor_provider_id');

    tips = intFromJson(json, 'tips');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.id != null) {
      data['id'] = this.id;
    }
    if (this.hint != null) {
      data['hint'] = this.hint;
    }
    if (this.duration != null) {
      data['duration'] = this.duration;
    }
    if (this.quantity != null) {
      data['quantity'] = this.quantity;
    }
    if (this.cancel != null) {
      data['cancel'] = this.cancel;
    }
    if (this.status != null) {
      data['booking_status_id'] = this.status.id;
    }
    if (this.coupon != null && this.coupon.code != null) {
      data['coupon_data'] = this.coupon.toJson();
    }
    if (this.coupon != null && this.coupon.id != null) {
      data['coupon_id'] = this.coupon.id;
    }
    if (this.taxes != null) {
      data['taxes'] = this.taxes.map((e) => e.toJson()).toList();
    }
    if (this.options != null ) {
      data['options'] = this.options.toJson();
    }
    if (this.user != null) {
      data['user_id'] = this.user.id;
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.eService != null) {
      data['e_service'] = this.eService.id;
    }
    if (this.eProvider != null) {
      data['e_provider'] = this.eProvider.toJson();
    }
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    if (this.bookingAt != null) {
      data['booking_at'] = bookingAt.toUtc().toString();
    }
    if (this.startAt != null) {
      data['start_at'] = startAt.toUtc().toString();
    }
    if (this.endsAt != null) {
      data['ends_at'] = endsAt.toUtc().toString();
    }

    if (this.booking_status_id != null) {
      data['booking_status_id'] = booking_status_id;
    }
    if (this.total_amount != null) {
      data['total_amount'] = this.total_amount;
    }
    if (this.total_payable_amount != null) {
      data['total_payable_amount'] = this.total_payable_amount;
    }
    if (this.added_unit != null) {
      data['added_unit'] = this.added_unit;
    }

    if (this.tips != null) {
      data['tips'] = this.tips;
    }
    return data;
  }

  // double getTotal() {
  //   double total = getSubtotal();
  //   total += getTaxesValue();
  //   total += getCouponValue();
  //   return total;
  // }
  //
  // double getTaxesValue() {
  //   double total = getSubtotal();
  //   double taxValue = 0.0;
  //   taxes?.forEach((element) {
  //     if (element.type == 'percent') {
  //       taxValue += (total * element.value / 100);
  //     } else {
  //       taxValue += element.value;
  //     }
  //   });
  //   return taxValue;
  // }
  //
  // double getCouponValue() {
  //   double total = getSubtotal();
  //   if (coupon == null || !(coupon?.hasData ?? false)) {
  //     return 0;
  //   } else {
  //     if (coupon.discountType == 'percent') {
  //       return -(total * coupon.discount / 100);
  //     } else {
  //       return -coupon.discount;
  //     }
  //   }
  // }

  // double getSubtotal() {
  //   double total = 0.0;
  //   if (eService.priceUnit == 'fixed') {
  //     total = eService.getPrice * (quantity >= 1 ? quantity : 1);
  //     options?.forEach((element) {
  //       total += element.price * (quantity >= 1 ? quantity : 1);
  //     });
  //   } else {
  //     total = eService.getPrice * duration;
  //     options?.forEach((element) {
  //       total += element.price;
  //     });
  //   }
  //   return total;
  // }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is BookingNew &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              hint == other.hint &&
              cancel == other.cancel &&
              duration == other.duration &&
              quantity == other.quantity &&
              status == other.status &&
              user == other.user &&
              eService == other.eService &&
              eProvider == other.eProvider &&
              options == other.options &&
              taxes == other.taxes &&
              address == other.address &&
              coupon == other.coupon &&
              bookingAt == other.bookingAt &&
              startAt == other.startAt &&
              endsAt == other.endsAt &&
              payment == other.payment &&
              tips == other.tips;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      hint.hashCode ^
      cancel.hashCode ^
      duration.hashCode ^
      quantity.hashCode ^
      status.hashCode ^
      user.hashCode ^
      eService.hashCode ^
      eProvider.hashCode ^
      options.hashCode ^
      taxes.hashCode ^
      address.hashCode ^
      coupon.hashCode ^
      bookingAt.hashCode ^
      startAt.hashCode ^
      endsAt.hashCode ^
      payment.hashCode ^
      tips.hashCode;
}


// class Option {
//   Options options;
//
//   Option({this.options});
//
//   Option.fromJson(Map<String, dynamic> json) {
//     options =
//     json['options'] != null ? new Options.fromJson(json['options']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.options != null) {
//       data['options'] = this.options.toJson();
//     }
//     return data;
//   }
// }

class Options extends Model{
  String id;
  Name name;
  Name description;
  double price;
  int minimumUnit;
  int eServiceId;
  int optionGroupId;

  Options(
      {this.id,
        this.name,
        this.description,
        this.price,
        this.minimumUnit,
        this.eServiceId,
        this.optionGroupId});

  Options.fromJson(Map<String, dynamic> json) {
    id = stringFromJson(json, 'id');
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    description = json['description'] != null
        ? new Name.fromJson(json['description'])
        : null;
    price = doubleFromJson(json, 'price');
    minimumUnit = intFromJson(json, 'minimum_unit');
    eServiceId = intFromJson(json, 'e_service_id');
    optionGroupId = intFromJson(json, 'option_group_id');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description.toJson();
    }
    data['price'] = this.price;
    data['minimum_unit'] = this.minimumUnit;
    data['e_service_id'] = this.eServiceId;
    data['option_group_id'] = this.optionGroupId;
    return data;
  }
}

class Name {
  String en;

  Name({this.en});

  Name.fromJson(Map<String, dynamic> json) {
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    return data;
  }
}
