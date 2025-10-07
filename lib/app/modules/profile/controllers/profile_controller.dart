import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/constant.dart';
import '../../../../common/ui.dart';
import '../../../models/media_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/auth_service.dart';
import '../../global_widgets/phone_verification_bottom_sheet_widget.dart';

class TestUser {
  String a;
  String b;
  String c;

  TestUser(this.a, this.b, this.c);
}

class ProfileController extends GetxController {
  var user = new User().obs;
  var avatar = new Media().obs;
  final hidePassword = true.obs;
  final oldPassword = "".obs;
  final newPassword = "".obs;
  final confirmPassword = "".obs;
  final smsSent = "".obs;
  GlobalKey<FormState> profileForm;
  UserRepository _userRepository;
  final isPhoneVerificationNeeded = false.obs;
  final tempUser = User().obs;
  final tempOldPassword = "".obs;
  final tempNewPassword = "".obs;
  final tempConfirmPassword = "".obs;
  final phoneVerificationOnProgress = false.obs;
  final phoneOtpSendingStatus = "".obs;
  ProfileController() {
    _userRepository = new UserRepository();
  }

  @override
  void onInit() {
    user.value = Get.find<AuthService>().user.value;
    print("sjdnfjksa 1 in ProfileController() phoneNumber: ${Get.find<AuthService>().user.value.phoneNumber} countryCode ${Get.find<AuthService>().user.value.countryCode}");
    if (!(Get.find<AuthService>().user.value.countryCode != null && Get.find<AuthService>().user.value.countryCode.length >= 3)) {
      // Get.find<AuthService>().user.value.countryCode = selectedCountryCode.value;
      Get.find<AuthService>().user.value.countryCode = predefinedCountryCode;
    }
    tempUser.value = User(email: user.value.email, phoneNumber: user.value.phoneNumber, countryCode: user.value.countryCode);
    tempOldPassword.value = oldPassword.value;
    avatar.value = new Media(thumb: user.value.avatar.thumb);
    super.onInit();
  }

  Future refreshProfile({bool showMessage}) async {
    await getUser();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of faqs refreshed successfully".tr));
    }
  }

  void saveProfileForm() async {
    Get.focusScope.unfocus();
    if (profileForm.currentState.validate()) {
      try {
        profileForm.currentState.save();
        user.value.deviceToken = null;
        user.value.password = newPassword.value == confirmPassword.value ? newPassword.value : null;
        user.value.avatar.id = avatar.value.id;
        // await _userRepository.sendCodeToPhone();
        // Get.bottomSheet(
        //   PhoneVerificationBottomSheetWidget(),
        //   isScrollControlled: false,
        // );
        print("sjdnfjksa isPhoneVerificationNeeded.value: ${isPhoneVerificationNeeded.value}");
        if (isPhoneVerificationNeeded.value) {
          try {
            phoneVerificationOnProgress.value = true;
            await _userRepository.sendCodeToPhone().then((value) {
              print("sjdnfjksa value: ${value}");
              if (value == "success") {
                Get.bottomSheet(
                  PhoneVerificationBottomSheetWidget(),
                  isScrollControlled: false,
                );

              }
              // else if (value == "Timeout Occurred") {
              //   Get.bottomSheet(
              //     PhoneVerificationBottomSheetWidget(),
              //     isScrollControlled: false,
              //   );
              //   Get.showSnackbar(Ui.ErrorSnackBar(message: value));
              // }
              else {
                Get.showSnackbar(Ui.ErrorSnackBar(message: value));
              }
            });
          } catch (e) {
            Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
          }
        } else {
          await updateUserProfileData();
        }
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }

    phoneVerificationOnProgress.value = false;
  }

  Future<void> verifyPhone() async {
    try {
      await _userRepository.verifyPhone(smsSent.value);
      // user.value = await _userRepository.update(user.value);
      // Get.find<AuthService>().user.value = user.value;
      // Get.back();
      // Get.showSnackbar(Ui.SuccessSnackBar(message: "Profile saved successfully".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void resetProfileForm() {
    avatar.value = new Media(thumb: user.value.avatar.thumb);
    profileForm.currentState.reset();
  }

  Future getUser() async {
    try {
      user.value = await _userRepository.getCurrentUser();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> updateUserProfileData() async {
    user.value = await _userRepository.update(user.value);
    print("sdkdjsjds user.value.bio: ${user.value.bio} user.value.address: ${user.value.address}");
    Get.find<AuthService>().user.value = user.value;
    Get.back();
    Get.showSnackbar(Ui.SuccessSnackBar(message: "Profile saved successfully".tr));
  }
}
