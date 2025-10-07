class ReceiveBooking {
  bool success;
  Data data;
  String message;

  ReceiveBooking({this.success, this.data, this.message});

  ReceiveBooking.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String message;
  String channelName;

  Data({this.message, this.channelName});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    channelName = json['channel_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['channel_name'] = this.channelName;
    return data;
  }
}
