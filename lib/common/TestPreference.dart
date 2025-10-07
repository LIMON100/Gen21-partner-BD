// import 'package:shared_preferences/shared_preferences.dart';
//
// class TestPreference {
//   static final prefsInstance = SharedPreferences.getInstance();
//
//   static saveData(String data) {
//     prefsInstance.then((value) {
//       value.setString("push_noti_data", data);
//       value.reload();
//     });
//   }
//
//   static String getData(){
//     prefsInstance.then((value) {
//       String data = value.get("push_noti_data");
//       value.reload();
//       return data;
//     });
//
//
//   }
// }