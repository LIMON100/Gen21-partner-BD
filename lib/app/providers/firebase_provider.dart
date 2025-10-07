import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../common/ui.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/profile/controllers/profile_controller.dart';
import '../services/auth_service.dart';

class FirebaseProvider extends GetxService {
  fba.FirebaseAuth _auth = fba.FirebaseAuth.instance;

  Future<FirebaseProvider> init() async {
    return this;
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      fba.UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return await signUpWithEmailAndPassword(email, password);
    }
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    fba.UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    if (result.user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> sendCodeToPhone() async {
    var completer = Completer<String>();

    Get.find<AuthService>().user.value.verificationId = '';
    final fba.PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) async{
      print("sjdnfjksa verId: ${verId}");
      // Get.showSnackbar(Ui.ErrorSnackBar(message: "Timeout Occurred".tr));
      // completer.complete();
      // updateOtpSendingStatusToUi("Timeout Occurred");
    };
    final fba.PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResent]) {
      Get.find<AuthService>().user.value.verificationId = verId;
      print("sjdnfjksa smsCodeSent");
      completer.complete("success");
      // updateOtpSendingStatusToUi("success");
    };
    final fba.PhoneVerificationCompleted _verifiedSuccess = (fba.AuthCredential auth) async {
      print("sjdnfjksa _verifiedSuccess ${auth.toString()}");
      // completer.complete("success");
      // updateOtpSendingStatusToUi("success");
      // await _auth.signInWithCredential(auth);
    };

    // final PhoneVerificationCompleted _verifiedSuccess = (AuthCredential auth) async {};

    final fba.PhoneVerificationFailed _verifyFailed = (fba.FirebaseAuthException e) async {
      print("sjdnfjksa FirebaseAuthException.code: ${e.code} message: {e.code}");
      if (e.code == "invalid-phone-number") {
        completer.complete("Invalid Phone Number");
        // updateOtpSendingStatusToUi("Invalid Phone Number");
      }else{
        completer.complete("Something went wrong: ${e.message}");
        // updateOtpSendingStatusToUi("Something went wrong");
      }
    };

    print("sjdnfjksa sms has been sent to ${Get.find<AuthService>().user.value.countryCode}${Get.find<AuthService>().user.value.phoneNumber}");
    await _auth.verifyPhoneNumber(
      // phoneNumber: Get.find<AuthService>().user.value.phoneNumber,
      phoneNumber: "${Get.find<AuthService>().user.value.countryCode}${Get.find<AuthService>().user.value.phoneNumber}",
      timeout: const Duration(seconds: 30),
      verificationCompleted: await _verifiedSuccess,
      verificationFailed: await _verifyFailed,
      codeSent: await smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
    return completer.future;
  }

  Future<void> verifyPhone(String smsCode) async {
    print("sjdnfjksa verifyPhone called");

    // try {
      // print("sjdnfjksa cred ${credential.toString()}");
      try {
        final AuthCredential credential = PhoneAuthProvider.credential(verificationId: Get.find<AuthService>().user.value.verificationId, smsCode: smsCode);

        // final fba.AuthCredential credential = fba.PhoneAuthProvider.credential(verificationId: Get.find<AuthService>().user.value.verificationId, smsCode: smsCode);
        // await fba.FirebaseAuth.instance.signInWithCredential(credential);
        // Get.find<AuthService>().user.value.verifiedPhone = true;
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        print("sjdnfjksa userCredential ${userCredential.toString()}");
        Get.find<AuthService>().user.value.verifiedPhone = true;
      } on FirebaseAuthException catch (e) {
        print("sjdnfjksa error: ${e.toString()} e.code: ${e.code}");
        String error = "Unknown error occurred!";
        if (e.code == 'invalid-verification-code') {
          error = "Please enter right otp";
        } else if (e.code == "session-expired") {
          error = "The sms code has expired. Please re-send the verification code to try again.";
        }
        Get.find<AuthService>().user.value.verifiedPhone = false;
        throw Exception(error);
      } finally{
        Get.find<AuthService>().user.value.verifiedPhone = false;

      }
    // } catch (e) {
    //   print("sjdnfjksa verifyPhone e: ${e.toString()}");
    //
    //   Get.find<AuthService>().user.value.verifiedPhone = false;
    //   throw Exception(e.toString());
    // }
  }



  // updateOtpSendingStatusToUi(String status){
  //   // Get.isRegistered<DbController>(tag: 'TagInPut');
  //   if(Get.isRegistered<AuthController>()){
  //     Get.find<AuthController>().phoneOtpSendingStatus.value = status;
  //   } else if(Get.isRegistered<ProfileController>()){
  //     Get.find<ProfileController>().phoneOtpSendingStatus.value = status;
  //   }
  // }

  Future signOut() async {
    return await _auth.signOut();
  }
}
