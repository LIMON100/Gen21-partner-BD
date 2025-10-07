class OrderPush {
  String pusherChanelName;
  String data;

  OrderPush({this.pusherChanelName, this.data});

  OrderPush.fromJson(Map<dynamic, dynamic> json) {
    pusherChanelName = json['pusher_channel_name'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pusher_channel_name'] = this.pusherChanelName;
    data['data'] = this.data;
    return data;
  }
}