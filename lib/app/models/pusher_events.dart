class PusherEvents {
  int channelName;
  String eventName;
  Data data;
  String userId;

  PusherEvents({this.channelName, this.eventName, this.data, this.userId});

  PusherEvents.fromJson(Map<String, dynamic> json) {
    channelName = json['channelName'];
    eventName = json['eventName'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channelName'] = this.channelName;
    data['eventName'] = this.eventName;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['userId'] = this.userId;
    return data;
  }
}

class Data {
  String message;
  String channelName;
  List<EventData> eventData;

  Data({this.message, this.channelName, this.eventData});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    channelName = json['channel_name'];
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
    data['channel_name'] = this.channelName;
    if (this.eventData != null) {
      data['eventData'] = this.eventData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventData {
  int id;
  String serviceType;
  String userId;
  String eServiceId;
  String orderId;
  String status;
  String createdAt;
  String updatedAt;

  EventData(
      {this.id,
        this.serviceType,
        this.userId,
        this.eServiceId,
        this.orderId,
        this.status,
        this.createdAt,
        this.updatedAt});

  EventData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceType = json['service_type'];
    userId = json['user_id'];
    eServiceId = json['e_service_id'];
    orderId = json['order_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_type'] = this.serviceType;
    data['user_id'] = this.userId;
    data['e_service_id'] = this.eServiceId;
    data['order_id'] = this.orderId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}