import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/constant.dart';
import '../../../../common/log_data.dart';
import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../root/controllers/root_controller.dart';

class AuthController extends GetxController {
  final Rx<User> currentUser = Get.find<AuthService>().user;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<FormState> registerFormKey;
  GlobalKey<FormState> forgotPasswordFormKey;
  final hidePassword = true.obs;
  final loading = false.obs;
  final smsSent = ''.obs;
  UserRepository _userRepository;

  // final phoneVerificationOnProgress = false.obs;
  final phoneOtpSendingStatus = "".obs;

  // final isTimeOut = false.obs;

  final secondsRemaining = 60.obs;
  final enableResend = false.obs;
  Timer timer;

  void initResendOtpTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        secondsRemaining.value--;
      } else {
        enableResend.value = true;
      }
    });
  }

  AuthController() {
    _userRepository = UserRepository();
    print(
        "sjdnfjksa 1 in AuthController() phoneNumber: ${Get.find<AuthService>().user.value.phoneNumber} countryCode ${Get.find<AuthService>().user.value.countryCode}");
    if (!(Get.find<AuthService>().user.value.countryCode != null &&
        Get.find<AuthService>().user.value.countryCode.length >= 3)) {
      // Get.find<AuthService>().user.value.countryCode = selectedCountryCode.value;
      Get.find<AuthService>().user.value.countryCode = predefinedCountryCode;
    }
    print(
        "sjdnfjksa 2 in AuthController() phoneNumber: ${Get.find<AuthService>().user.value.phoneNumber} countryCode ${Get.find<AuthService>().user.value.countryCode}");
  }

  void login() async {
    Get.focusScope.unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      loading.value = true;
      try {
        User tempUser ;
        await Get.find<FireBaseMessagingService>().setDeviceToken();
        tempUser = await _userRepository.login(currentUser.value);

        // await Get.toNamed(Routes.ROOT, arguments: 0);
        // await Get.offAllNamed(Routes.ROOT, arguments: 0);
        printWrapped("gen_log tempUser.value.eProviders.lenght ${tempUser.eProviders.length}");
        if(tempUser.eProviders.isEmpty){
          await Get.offAllNamed(Routes.updateProviderInfo,
              arguments: {"user":tempUser, "api_key":"${tempUser.apiToken}"});
        }else{
          try {
            currentUser.value = tempUser;
            await _userRepository.signInWithEmailAndPassword(
                currentUser.value.email, currentUser.value.apiToken);
          }catch(e){}
          final prefs = await SharedPreferences.getInstance();
          final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

          if (hasSeenOnboarding) {
            await Get.offAllNamed(Routes.ROOT, arguments: 0);
          } else {
            await Get.offAllNamed(Routes.ONBOARDING);
          }
          // await Get.offAllNamed(Routes.ROOT, arguments: 0);
        }
        loading.value = false;

      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }

  void register() async {
    Get.focusScope.unfocus();
    if (registerFormKey.currentState.validate()) {
      registerFormKey.currentState.save();
      loading.value = true;

      try {
        await _userRepository.sendCodeToPhone().then((value) {
          loading.value = false;
          //  Get.toNamed(Routes.PHONE_VERIFICATION);

          print("sjdnfjksa value: ${value}");
          if (value == "success") {
            Get.toNamed(Routes.PHONE_VERIFICATION);
            // isTimeOut.value = false;
            scheduleTimeout(45 * 1000);
          }
          // else if (value == "Timeout Occurred") {
          //   Get.showSnackbar(Ui.ErrorSnackBar(message: value));
          //   Get.toNamed(Routes.PHONE_VERIFICATION);
          // }
          else {
            Get.showSnackbar(Ui.ErrorSnackBar(message: value));
            // isTimeOut.value = true;
          }
        });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
        // isTimeOut.value = true;
        loading.value = false;
      } finally {
        loading.value = false;
        // isTimeOut.value = true;
      }
    }
  }

  Future<void> verifyPhone() async {
    try {
      loading.value = true;
      await _userRepository.verifyPhone(smsSent.value);
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      currentUser.value = await _userRepository.register(currentUser.value);
      printWrapped("shdbhbyy currentUser.value: ${currentUser.value}");
      await _userRepository.signUpWithEmailAndPassword(
          currentUser.value.email, currentUser.value.apiToken);
      var apiKey = currentUser.value.apiToken;
      printWrapped("shdbhbyy2 apiKey.value: ${apiKey}");

      Get.find<AuthService>().user.value.countryCode = predefinedCountryCode;
      // await Get.find<RootController>().changePage(0);
      loading.value = false;
      // Get.showSnackbar(Ui.SuccessSnackBar(message: "Registration Successful! Please check you email for complete your profile and wait for approval."));

      Get.showSnackbar(
        Ui.SuccessSnackBar(
          message: "Registration Successful! Please check your email for completing your profile and wait for approval.",
        ),
      );


      // await Get.toNamed(Routes.LOGIN);
      User tempUser = currentUser.value;
      printWrapped("shdbhbyy3_0 tempUser: ${tempUser.toString()}");
      await Get.find<AuthService>().removeCurrentUser();
      await Get.toNamed(Routes.updateProviderInfo,
          arguments: {"user":tempUser, "api_key":"$apiKey"});

      printWrapped("shdbhbyy3_0_0 : removeCurrentUser called${currentUser.value.toString()}");

    } catch (e) {
      loading.value = false;
      // Get.toNamed(Routes.REGISTER);
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }

  Future<void> resendOTPCode() async {
    try {
      loading.value = true;

      await _userRepository.sendCodeToPhone().then((value) {
        print("sjdnfjksa value in resendOTPCode: $value");
        if (value == "success") {
          Get.toNamed(Routes.PHONE_VERIFICATION);
          // isTimeOut.value = false;
          scheduleTimeout(45 * 1000);
        }
        // else if (value == "Timeout Occurred") {
        //   Get.showSnackbar(Ui.ErrorSnackBar(message: value));
        //   Get.toNamed(Routes.PHONE_VERIFICATION);
        // }
        else {
          Get.showSnackbar(Ui.ErrorSnackBar(message: value));
          // isTimeOut.value = true;
        }
        loading.value = false;
      });
    } catch (e) {
      // isTimeOut.value = true;
      loading.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
    // loading.value = false;
  }

  void sendResetLink() async {
    Get.focusScope.unfocus();
    if (forgotPasswordFormKey.currentState.validate()) {
      forgotPasswordFormKey.currentState.save();
      loading.value = true;
      try {
        await _userRepository.sendResetLinkEmail(currentUser.value);
        loading.value = false;
        Get.showSnackbar(Ui.SuccessSnackBar(
            message:
                "The Password reset link has been sent to your email: ".tr +
                    currentUser.value.email));
        Timer(Duration(seconds: 5), () {
          Get.offAndToNamed(Routes.LOGIN);
        });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }

  Timer scheduleTimeout(int milliseconds) {
    Timer(Duration(milliseconds: milliseconds), handleTimeout);
  }

  void handleTimeout() {
    // isTimeOut.value = true;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
