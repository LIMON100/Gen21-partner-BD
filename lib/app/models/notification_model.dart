
import 'package:get/get.dart';

import 'parents/model.dart';

class Notification extends Model {
  String id;
  String type;
  Map<String, dynamic> data;
  bool read;
  DateTime createdAt;

  Notification();

  Notification.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    type = stringFromJson(json, 'type');
    data = mapFromJson(json, 'data');
    read = boolFromJson(json, 'read_at');
    createdAt = dateFromJson(json, 'created_at', defaultValue: DateTime.now().toLocal());
  }

  Map markReadMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["read_at"] = !read;
    return map;
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  String getMessage() {
    if (type == 'App\\Notifications\\NewMessage') {
      return data['from'] + ' ' + type.tr;
    } else {
      return type.tr;
    }
  }
}

// import 'package:get/get.dart';
// import 'parents/model.dart';
//
// class Notification extends Model {
//   String id;
//   String type;
//   // Map<String, dynamic> data;
//   NotiData data;
//   bool read;
//   DateTime createdAt;
//
//   Notification();
//
//   Notification.fromJson(Map<String, dynamic> json) {
//     super.fromJson(json);
//     type = stringFromJson(json, 'type');
//     // data = mapFromJson(json, 'data');
//     data = objectFromJson(json, 'data', (v) => NotiData.fromJson(v));
//     read = boolFromJson(json, 'read_at');
//     createdAt = dateFromJson(json, 'created_at', defaultValue: DateTime.now().toLocal());
//   }
//
//   Map markReadMap() {
//     var map = new Map<String, dynamic>();
//     map["id"] = id;
//     map["read_at"] = !read;
//     return map;
//   }
//
//   @override
//   Map<String, dynamic> toJson() {
//     throw UnimplementedError();
//   }
//
//   String getMessage() {
//     if (type == 'App\\Notifications\\NewMessage') {
//       return data.from + ' ' + type.tr;
//     } else {
//       return type.tr;
//     }
//   }
// }
// class NotiData {
//   int booking_id;
//   String from;
//   String message_id;
//   // NotiData(this.booking_id, this.from, this.message_id);
//   // Name.fromJson(Map<String, dynamic> json) {
//   //   en = json['en'];
//   // }
//
//   NotiData({this.booking_id, this.from, this.message_id});
//
//
//   @override
//   String toString() {
//     return 'NotiData{booking_id: $booking_id, from: $from, message_id: $message_id}';
//   }
//
//   NotiData.fromJson(Map<String, dynamic> json) {
//     booking_id = json['booking_id'];
//     from = json['from'];
//     message_id = json['message_id'];
//   }
//
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['booking_id'] = this.booking_id;
//     data['from'] = this.from;
//     data['message_id'] = this.message_id;
//     return data;
//   }
//
// // Map toJson({int booking_id, String from, String message_id}) {
// //   return {
// //     'booking_id': booking_id,
// //     'from': from,
// //     'message_id': message_id,
// //   };
// // }
//
//
// }
//
//
//
