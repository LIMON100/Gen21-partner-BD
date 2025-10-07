import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';

class UpdateProviderController extends GetxController {
  UserRepository _userRepository;
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController mobileEditingController = TextEditingController();
  TextEditingController availableRangeEditingController =
      TextEditingController();
  var isProfileUpdating = false.obs;

  Future updateProviderInfo(var body, apiKey) async {
    try {
      isProfileUpdating.value = true;
      _userRepository = UserRepository();
      // todo unhide below code after testing
      await _userRepository.updateProviderInfo(body, apiKey);
      isProfileUpdating.value = false;
      // Get.showSnackbar(Ui.SuccessSnackBar(message: "Profile updated. Please check your email for completing your profile and wait for approval"));
      Get.showSnackbar(
        Ui.SuccessSnackBar(
          message: "Profile updated. Please check your email for completing your profile and wait for approval",
           // add this line
        ),
      );
      await Get.toNamed(Routes.LOGIN);

    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Something went wrong"));
    }
  }
}

// class UpdateProviderController extends GetxController {
//   BuildContext context;
//   UserRepository _userRepository;
//   TextEditingController nameEditingController = TextEditingController();
//   TextEditingController mobileEditingController = TextEditingController();
//   TextEditingController availableRangeEditingController =
//   TextEditingController();
//   var isProfileUpdating = false.obs;
//
//   Future<void> updateProviderInfo(var body, apiKey) async {
//     try {
//       isProfileUpdating.value = true;
//       _userRepository = UserRepository();
//       // todo unhide below code after testing
//       await _userRepository.updateProviderInfo(body, apiKey);
//       isProfileUpdating.value = false;
//       // Get.showSnackbar(Ui.SuccessSnackBar(message: "Profile updated. Please check your email for completing your profile and wait for approval"));
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Payment successful..................'),
//           duration: Duration(seconds: 5),
//           backgroundColor: Colors.green, // set the background color to green
//         ),
//       );
//       await Get.toNamed(Routes.LOGIN);
//
//     } catch (e) {
//       Get.showSnackbar(Ui.ErrorSnackBar(message: "Something went wrong"));
//     }
//   }
// }
