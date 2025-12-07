// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../common/helper.dart';
// import '../../../../common/ui.dart';
// import '../../../models/setting_model.dart';
// import '../../../routes/app_routes.dart';
// import '../../../services/settings_service.dart';
// import '../../global_widgets/block_button_widget.dart';
// import '../../global_widgets/circular_loading_widget.dart';
// import '../../global_widgets/phone_number_field_with_country_code_widget.dart';
// import '../../global_widgets/text_field_widget.dart';
// import '../controllers/auth_controller.dart';
//
// class RegisterView extends GetView<AuthController> {
//   final Setting _settings = Get.find<SettingsService>().setting.value;
//
//   @override
//   Widget build(BuildContext context) {
//     controller.registerFormKey = new GlobalKey<FormState>();
//     return WillPopScope(
//       onWillPop: Helper().onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "Register".tr,
//             style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
//           ),
//           centerTitle: true,
//           backgroundColor: Get.theme.colorScheme.secondary,
//           automaticallyImplyLeading: false,
//           elevation: 0,
//           leading: new IconButton(
//             icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
//             // onPressed: () => {Get.find<RootController>().changePageOutRoot(0)},
//             onPressed: () => {Get.offAllNamed(Routes.LOGIN)},
//           ),
//         ),
//         body: Form(
//           key: controller.registerFormKey,
//           child: ListView(
//             primary: true,
//             children: [
//               Stack(
//                 alignment: AlignmentDirectional.bottomCenter,
//                 children: [
//                   Container(
//                     height: 160,
//                     width: Get.width,
//                     decoration: BoxDecoration(
//                       color: Get.theme.colorScheme.secondary,
//                       borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
//                       boxShadow: [
//                         BoxShadow(color: Get.theme.focusColor.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 5)),
//                       ],
//                     ),
//                     margin: EdgeInsets.only(bottom: 50),
//                     child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         children: [
//                           Text(
//                             "Service Partner",
//                             // _settings.providerAppName,
//                             style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor, fontSize: 24)),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             "Welcome to the best service provider system!".tr,
//                             style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor)),
//                             textAlign: TextAlign.center,
//                           ),
//                           // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
//                         ],
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: (){
//                       print("sjdnfuiuui called");
//                       // Get.toNamed(Routes.updateProviderInfo);
//                     },
//                     child: Container(
//                       decoration: Ui.getBoxDecoration(
//                         radius: 14,
//                         border: Border.all(width: 5, color: Get.theme.primaryColor),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.all(Radius.circular(10)),
//                         child: Image.asset(
//                           'assets/icon/icon.png',
//                           fit: BoxFit.cover,
//                           width: 100,
//                           height: 100,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Obx(() {
//                 if (controller.loading.isTrue) {
//                   return CircularLoadingWidget(height: 300);
//                 } else {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       TextFieldWidget(
//                         labelText: "Full Name".tr,
//                         hintText: "John Doe".tr,
//                         initialValue: controller.currentUser?.value?.name,
//                         onSaved: (input) => controller.currentUser.value.name = input,
//                         validator: (input) => input.length < 3 ? "Should be more than 3 characters".tr : null,
//                         iconData: Icons.person_outline,
//                         isFirst: true,
//                         isLast: false,
//                       ),
//                       TextFieldWidget(
//                         labelText: "Email Address".tr,
//                         hintText: "johndoe@gmail.com".tr,
//                         initialValue: controller.currentUser?.value?.email,
//                         onSaved: (input) => controller.currentUser.value.email = input,
//                         validator: (input) => !input.contains('@') ? "Should be a valid email".tr : null,
//                         iconData: Icons.alternate_email,
//                         isFirst: false,
//                         isLast: false,
//                       ),
//                       PhoneNumberFieldWithCountryCodeWidget(
//                         labelText: "Phone Number".tr,
//                         hintText: "0123456789".tr,
//                         initialValue: controller.currentUser?.value?.phoneNumber,
//                         onSaved: (input) {
//                           // if (input.startsWith("00")) {
//                           //   input = "+" + input.substring(2);
//                           // }
//                           return controller.currentUser.value.phoneNumber = input;
//                         },
//                         validator: (input) {
//                           return input.length < 7 ? "Please enter valid phone number".tr : null;
//                           // return !input.startsWith('\+') && !input.startsWith('00') ? "Should be valid mobile number with country code" : null;
//                         },
//                         iconData: Icons.phone_android_outlined,
//                         isLast: false,
//                         isFirst: false,
//                       ),
//                       Obx(() {
//                         return TextFieldWidget(
//                           labelText: "Password".tr,
//                           hintText: "••••••••••••".tr,
//                           initialValue: controller.currentUser?.value?.password,
//                           onSaved: (input) => controller.currentUser.value.password = input,
//                           validator: (input) => input.length < 3 ? "Should be more than 3 characters".tr : null,
//                           obscureText: controller.hidePassword.value,
//                           iconData: Icons.lock_outline,
//                           keyboardType: TextInputType.visiblePassword,
//                           isLast: true,
//                           isFirst: false,
//                           suffixIcon: IconButton(
//                             onPressed: () {
//                               controller.hidePassword.value = !controller.hidePassword.value;
//                             },
//                             color: Theme.of(context).focusColor,
//                             icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
//                           ),
//                         );
//                       }),
//                     ],
//                   );
//                 }
//               })
//             ],
//           ),
//         ),
//         bottomNavigationBar: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Wrap(
//               crossAxisAlignment: WrapCrossAlignment.center,
//               direction: Axis.vertical,
//               children: [
//                 SizedBox(
//                   width: Get.width,
//                   child: BlockButtonWidget(
//                     onPressed: () {
//                       controller.register();
//                       //Get.offAllNamed(Routes.PHONE_VERIFICATION);
//                     },
//                     color: Get.theme.colorScheme.secondary,
//                     text: Text(
//                       "Register".tr,
//                       style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
//                     ),
//                   ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Get.toNamed(Routes.LOGIN);
//                   },
//                   child: Text("You already have an account?".tr),
//                 ).paddingOnly(bottom: 10),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:html/parser.dart';
// import '../../../../common/ui.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../../../../common/helper.dart';
// import '../../../models/setting_model.dart';
// import '../../../routes/app_routes.dart';
// import '../../../services/settings_service.dart';
// import '../../global_widgets/block_button_widget.dart';
// import '../../global_widgets/circular_loading_widget.dart';
// import '../../global_widgets/phone_number_field_with_country_code_widget.dart';
// import '../../global_widgets/text_field_widget.dart';
// import '../controllers/auth_controller.dart';
// import 'package:html_unescape/html_unescape.dart'; // Import for entity decoding
//
//
// class RegisterView extends GetView<AuthController> {
//   final Setting _settings = Get.find<SettingsService>().setting.value;
//   final RxBool _privacyPolicyAccepted = false.obs;
//   final RxBool _loadingPolicy = true.obs;
//   final RxString _privacyPolicyContent = "".obs;
//
//
//   @override
//   Widget build(BuildContext context) {
//     controller.registerFormKey = GlobalKey<FormState>();
//     // Load privacy policy content on build
//     if (_privacyPolicyContent.value.isEmpty) {
//       _fetchPrivacyPolicy();
//     }
//
//     return Obx(() => _loadingPolicy.value
//         ? Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     )
//         : _privacyPolicyAccepted.isFalse
//         ? _buildPrivacyPolicyPopup(context) // Show popup if not accepted
//         : WillPopScope(
//       onWillPop: Helper().onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "Register".tr,
//             style: Get.textTheme.headline6
//                 ?.merge(TextStyle(color: context.theme.primaryColor)),
//           ),
//           centerTitle: true,
//           backgroundColor: Get.theme.colorScheme.secondary,
//           automaticallyImplyLeading: false,
//           elevation: 0,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back_ios,
//                 color: Get.theme.primaryColor),
//             onPressed: () => Get.offAllNamed(Routes.LOGIN),
//           ),
//         ),
//         body: Form(
//           key: controller.registerFormKey,
//           child: ListView(
//             primary: true,
//             children: [
//               Stack(
//                 alignment: AlignmentDirectional.bottomCenter,
//                 children: [
//                   Container(
//                     height: 160,
//                     width: Get.width,
//                     decoration: BoxDecoration(
//                       color: Get.theme.colorScheme.secondary,
//                       borderRadius: BorderRadius.vertical(
//                           bottom: Radius.circular(10)),
//                       boxShadow: [
//                         BoxShadow(
//                             color:
//                             Get.theme.focusColor.withOpacity(0.2),
//                             blurRadius: 10,
//                             offset: Offset(0, 5)),
//                       ],
//                     ),
//                     margin: EdgeInsets.only(bottom: 50),
//                     child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         children: [
//                           Text(
//                             "Service Partner",
//                             style: Get.textTheme.headline6?.merge(
//                                 TextStyle(
//                                     color: Get.theme.primaryColor,
//                                     fontSize: 24)),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             "Welcome to the best service provider system!"
//                                 .tr,
//                             style: Get.textTheme.caption?.merge(
//                                 TextStyle(
//                                     color: Get.theme.primaryColor)),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       print("sjdnfuiuui called");
//                       // Get.toNamed(Routes.updateProviderInfo);
//                     },
//                     child: Container(
//                       decoration: Ui.getBoxDecoration(
//                         radius: 14,
//                         border: Border.all(
//                             width: 5, color: Get.theme.primaryColor),
//                       ),
//                       child: ClipRRect(
//                         borderRadius:
//                         BorderRadius.all(Radius.circular(10)),
//                         child: Image.asset(
//                           'assets/icon/icon.png',
//                           fit: BoxFit.cover,
//                           width: 100,
//                           height: 100,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Obx(() {
//                 if (controller.loading.isTrue) {
//                   return CircularLoadingWidget(height: 300);
//                 } else {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       TextFieldWidget(
//                         labelText: "Full Name".tr,
//                         hintText: "John Doe".tr,
//                         initialValue:
//                         controller.currentUser?.value?.name,
//                         onSaved: (input) =>
//                         controller.currentUser.value.name = input,
//                         validator: (input) => input.length < 3
//                             ? "Should be more than 3 characters".tr
//                             : null,
//                         iconData: Icons.person_outline,
//                         isFirst: true,
//                         isLast: false,
//                       ),
//                       TextFieldWidget(
//                         labelText: "Email Address".tr,
//                         hintText: "johndoe@gmail.com".tr,
//                         initialValue:
//                         controller.currentUser?.value?.email,
//                         onSaved: (input) =>
//                         controller.currentUser.value.email = input,
//                         validator: (input) => !input.contains('@')
//                             ? "Should be a valid email".tr
//                             : null,
//                         iconData: Icons.alternate_email,
//                         isFirst: false,
//                         isLast: false,
//                       ),
//                       PhoneNumberFieldWithCountryCodeWidget(
//                         labelText: "Phone Number".tr,
//                         hintText: "0123456789".tr,
//                         initialValue:
//                         controller.currentUser?.value?.phoneNumber,
//                         onSaved: (input) {
//                           return controller.currentUser.value
//                               .phoneNumber = input;
//                         },
//                         validator: (input) {
//                           return input.length < 7
//                               ? "Please enter valid phone number".tr
//                               : null;
//                         },
//                         iconData: Icons.phone_android_outlined,
//                         isLast: false,
//                         isFirst: false,
//                       ),
//                       Obx(() {
//                         return TextFieldWidget(
//                           labelText: "Password".tr,
//                           hintText: "••••••••••••".tr,
//                           initialValue:
//                           controller.currentUser?.value?.password,
//                           onSaved: (input) =>
//                           controller.currentUser.value.password =
//                               input,
//                           validator: (input) => input.length < 3
//                               ? "Should be more than 3 characters".tr
//                               : null,
//                           obscureText: controller.hidePassword.value,
//                           iconData: Icons.lock_outline,
//                           keyboardType:
//                           TextInputType.visiblePassword,
//                           isLast: true,
//                           isFirst: false,
//                           suffixIcon: IconButton(
//                             onPressed: () {
//                               controller.hidePassword.value =
//                               !controller.hidePassword.value;
//                             },
//                             color: Theme.of(context).focusColor,
//                             icon: Icon(controller.hidePassword.value
//                                 ? Icons.visibility_outlined
//                                 : Icons.visibility_off_outlined),
//                           ),
//                         );
//                       }),
//                     ],
//                   );
//                 }
//               })
//             ],
//           ),
//         ),
//         bottomNavigationBar: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Wrap(
//               crossAxisAlignment: WrapCrossAlignment.center,
//               direction: Axis.vertical,
//               children: [
//                 SizedBox(
//                   width: Get.width,
//                   child: BlockButtonWidget(
//                     onPressed: () {
//                       controller.register();
//                     },
//                     color: Get.theme.colorScheme.secondary,
//                     text: Text(
//                       "Register".tr,
//                       style: Get.textTheme.headline6?.merge(
//                           TextStyle(color: Get.theme.primaryColor)),
//                     ),
//                   ).paddingOnly(
//                       top: 15, bottom: 5, right: 20, left: 20),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Get.toNamed(Routes.LOGIN);
//                   },
//                   child: Text("You already have an account?".tr),
//                 ).paddingOnly(bottom: 10),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
//
//
//   // Function to build the privacy policy pop-up
//   Widget _buildPrivacyPolicyPopup(BuildContext context) {
//     return Scaffold(
//       body: AlertDialog(
//         title: Text('Privacy Policy & Agreement'.tr),
//         content: Container(
//           height: Get.height * 0.6, // Limit the height
//           width: Get.width * 0.9,
//           child: LayoutBuilder(
//             builder: (BuildContext context, BoxConstraints constraints) {
//               return SingleChildScrollView(
//                   child:  Ui.applyHtml(_privacyPolicyContent.value)
//               );
//             },
//           ),
//         ),
//         actions: <Widget>[
//           Padding( // Add some padding around the action
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row( // Use Row for better control
//               mainAxisAlignment: MainAxisAlignment.start, // Or center
//               children: [
//                 Obx(() => Checkbox(
//                   value: _privacyPolicyAccepted.value,
//                   onChanged: (bool value) { // Use bool?
//                     if (value != null) {
//                       _privacyPolicyAccepted.value = value;
//                     }
//                   },
//                 )),
//                 // Allow text to take remaining space
//                 Expanded(
//                   child: Text(
//                     'I read & understand the privacy policy'.tr,
//                     // overflow: TextOverflow.visible, // visible can overflow bounds
//                     softWrap: true, // Allow wrapping
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Add your confirmation button here if needed
//           TextButton(
//             onPressed: _privacyPolicyAccepted.value ? () {
//               // Handle acceptance confirmation
//               Navigator.of(context).pop(true); // Example: pop dialog returning true
//             } : null, // Disable button if not accepted
//             child: Text('ACCEPT'.tr),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _fetchPrivacyPolicy() async {
//     try {
//       final response = await http.get(
//         Uri.parse('https://app.gen21.com.au/api/custom_pages/1'),
//         headers: {'Content-Type': 'application/json'},
//       );
//       if (response.statusCode == 200) {
//         var jsonResponse = json.decode(response.body);
//         String content = jsonResponse['data']['content']['en'];
//
//         var unescape = HtmlUnescape();
//         String decodedString = unescape.convert(content);
//
//         _privacyPolicyContent.value = decodedString;
//
//         _loadingPolicy.value = false;
//       } else {
//         _loadingPolicy.value = false;
//         // Handle error
//         print("Error fetching privacy policy: ${response.statusCode}");
//         _privacyPolicyContent.value = 'Error fetching policy';
//         Get.showSnackbar(
//             Ui.ErrorSnackBar(message: "Error fetching policy".tr));
//       }
//     } catch (e) {
//       _loadingPolicy.value = false;
//       print("Exception during policy fetch: $e");
//       _privacyPolicyContent.value = 'Error fetching policy';
//       Get.showSnackbar(Ui.ErrorSnackBar(message: "Error fetching policy".tr));
//     }
//   }
// }







import 'dart:convert';
import 'package:flutter/gestures.dart'; // Import for TapGestureRecognizer
import 'package:html/parser.dart';
import '../../../../common/ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../common/helper.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/phone_number_field_with_country_code_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';
import 'package:html_unescape/html_unescape.dart'; // Import for entity decoding
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher


import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;

class RegisterView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;
  final RxBool _privacyPolicyAccepted = false.obs;
  final RxBool _loadingPolicy = true.obs; // Start as true
  final RxString _privacyPolicyContent = "".obs;
  final RxBool _policyFetchInitiated = false.obs; // Flag to prevent multiple fetches
  final RxString _policyError = "".obs; // To store specific error messages
  final RxBool _agreementAccepted = false.obs;

  // --- Moved Dialog Showing Logic Here ---
  void _showPrivacyPolicyDialogIfNeeded(BuildContext context) {
    // Check conditions again just before showing
    if (!_loadingPolicy.value &&
        _policyError.isEmpty && // Only show if no fetch error
        _privacyPolicyContent.isNotEmpty &&
        !_privacyPolicyAccepted.value &&
        !(Get.isDialogOpen ?? false)) { // Check if dialog isn't already open

      print("Attempting to show Privacy Policy Dialog...");

      Get.dialog(
        _buildPrivacyPolicyPopup(context),
        barrierDismissible: false, // Prevent dismissing by tapping outside
      ).then((accepted) {
        print("Privacy Policy Dialog closed with result: $accepted");
        if (accepted == true) {
          _privacyPolicyAccepted.value = true;
          // Obx should rebuild automatically after this state change
        } else {
          // User dismissed or didn't accept - Navigate back to login
          print("Policy not accepted or dialog dismissed. Navigating to Login.");
          Get.offAllNamed(Routes.LOGIN);
        }
      }).catchError((error) {
        // Catch errors specifically from the Get.dialog future if any
        print("Error after Get.dialog: $error");
        // Decide how to handle this - maybe navigate back?
        Get.offAllNamed(Routes.LOGIN);
      });
    } else {
      print("Skipping dialog show. Conditions: loading=${_loadingPolicy.value}, error=${_policyError.value}, contentEmpty=${_privacyPolicyContent.isEmpty}, accepted=${_privacyPolicyAccepted.value}, isDialogOpen=${Get.isDialogOpen}");
    }
  }
  // --- End Moved Dialog Showing Logic ---


  @override
  Widget build(BuildContext context) {
    controller.registerFormKey = GlobalKey<FormState>();

    // --- Safer Fetch Initiation ---
    // Use Obx's context or WidgetsBinding to ensure context is available
    // Trigger fetch only ONCE when the view builds and fetch hasn't started
    if (!_policyFetchInitiated.value) {
      _policyFetchInitiated.value = true; // Mark as initiated
      print("Build: Initiating policy fetch.");
      // Use addPostFrameCallback to ensure fetch starts after initial build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Double check inside callback if needed, though flag should suffice
        if (_loadingPolicy.value && _privacyPolicyContent.isEmpty){ // Only fetch if still in initial loading state
          _fetchPrivacyPolicy();
        }
      });
    }
    // --- End Fetch Initiation ---

    return Obx(() {
      print("Obx Rebuild: loadingPolicy=${_loadingPolicy.value}, policyAccepted=${_privacyPolicyAccepted.value}, contentEmpty=${_privacyPolicyContent.value.isEmpty}, error='${_policyError.value}'");

      // --- State 1: Loading Policy ---
      if (_loadingPolicy.value) {
        print("Obx State: Loading Policy");
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      // --- State 2: Policy Fetch Error ---
      else if (_policyError.isNotEmpty) {
        print("Obx State: Policy Fetch Error");
        return Scaffold(
          appBar: AppBar(
            title: Text("Error".tr),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
              onPressed: () => Get.offAllNamed(Routes.LOGIN), // Go back to login on error
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Failed to load Privacy Policy.".tr, textAlign: TextAlign.center),
                  SizedBox(height: 10),
                  Text(_policyError.value, style: Get.textTheme.caption, textAlign: TextAlign.center),
                  SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () {
                        // Reset state and retry
                        _policyError.value = "";
                        _privacyPolicyContent.value = "";
                        _loadingPolicy.value = true;
                        _policyFetchInitiated.value = false; // Allow fetch initiation again
                        // Rebuild will trigger fetch logic again
                        Get.appUpdate(); // Force UI update if needed, though state change should work
                      },
                      child: Text("Retry".tr)
                  ),
                  TextButton(
                      onPressed: () => Get.offAllNamed(Routes.LOGIN),
                      child: Text("Back to Login".tr)
                  )
                ],
              ),
            ),
          ),
        );
      }
      // --- State 3: Policy Loaded, Not Accepted -> Show Dialog ---
      else if (_privacyPolicyContent.isNotEmpty && !_privacyPolicyAccepted.value) {
        print("Obx State: Policy Loaded, Not Accepted");
        // Schedule dialog show *after* this build frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showPrivacyPolicyDialogIfNeeded(context);
        });
        // Return a placeholder while the dialog is being prepared/shown
        // This placeholder IS temporary. If the dialog shows correctly,
        // the state will change upon closing it (_privacyPolicyAccepted or navigate away)
        // causing another Obx rebuild.
        print("Obx State: Returning temporary placeholder while scheduling/showing dialog.");
        return Scaffold(
          body: Center(
            // You can show loading, or just a blank container
            child: CircularProgressIndicator(),
            // child: Container(color: Get.theme.scaffoldBackgroundColor), // Or Blank
          ),
        );
      }
      // --- State 4: Policy Accepted -> Show Registration Form ---
      else if (_privacyPolicyAccepted.value) {
        print("Obx State: Policy Accepted, Showing Registration Form");
        return _buildRegistrationScaffold(context);
      }
      // --- Fallback State (Shouldn't be reached if logic is correct) ---
      else {
        print("Obx State: Fallback (Unexpected State!)");
        // This might happen if fetch finished, no error, content is empty (API bug?), and not accepted.
        return Scaffold(
          body: Center(child: Text("An unexpected error occurred.".tr)),
          appBar: AppBar(title: Text("Error".tr), leading: IconButton(
              icon: Icon(Icons.arrow_back_ios), onPressed: () => Get.offAllNamed(Routes.LOGIN))),
        );
      }
    });
  }


  // Function to build the registration scaffold (Keep unchanged)
  Widget _buildRegistrationScaffold(BuildContext context) {
    // ... (Your existing _buildRegistrationScaffold code) ...
    // Make sure it uses controller.currentUser.value correctly
    // and has the form validation logic inside the onPressed of the register button
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Register".tr,
            style: Get.textTheme.headline6
                ?.merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Get.theme.primaryColor),
            onPressed: () => Get.offAllNamed(Routes.LOGIN),
          ),
        ),
        body: Form(
          key: controller.registerFormKey,
          child: ListView(
            primary: true,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    height: 160,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.secondary,
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color:
                            Get.theme.focusColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 5)),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 50),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            _settings.providerAppName, // Use setting from service
                            style: Get.textTheme.headline6?.merge(
                                TextStyle(
                                    color: Get.theme.primaryColor,
                                    fontSize: 24)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Welcome to the best service provider system!"
                                .tr,
                            style: Get.textTheme.caption?.merge(
                                TextStyle(
                                    color: Get.theme.primaryColor)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container( // Removed InkWell as it wasn't doing anything
                    decoration: Ui.getBoxDecoration(
                      radius: 14,
                      border: Border.all(
                          width: 5, color: Get.theme.primaryColor),
                    ),
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.all(Radius.circular(10)),
                      child: Image.asset(
                        'assets/icon/icon.png',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ],
              ),
              Obx(() {
                // Note: controller.loading refers to registration loading,
                // _loadingPolicy refers to policy fetching.
                if (controller.loading.isTrue) {
                  return CircularLoadingWidget(height: 300);
                } else {
                  return Padding( // Added padding around form fields
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFieldWidget(
                          labelText: "Full Name".tr,
                          hintText: "John Doe".tr,
                          initialValue:
                          controller.currentUser.value.name, // Simplified access
                          onSaved: (input) =>
                          controller.currentUser.value.name = input,
                          validator: (input) => input == null || input.length < 3
                              ? "Should be more than 3 characters".tr
                              : null,
                          iconData: Icons.person_outline,
                          isFirst: true,
                          isLast: false,
                        ),
                        TextFieldWidget(
                          labelText: "Email Address".tr,
                          hintText: "johndoe@gmail.com".tr,
                          initialValue:
                          controller.currentUser.value.email, // Simplified access
                          onSaved: (input) =>
                          controller.currentUser.value.email = input,
                          validator: (input) => input == null || !input.contains('@')
                              ? "Should be a valid email".tr
                              : null,
                          iconData: Icons.alternate_email,
                          isFirst: false,
                          isLast: false,
                        ),
                        PhoneNumberFieldWithCountryCodeWidget(
                          labelText: "Phone Number".tr,
                          hintText: "0123456789".tr,
                          initialValue:
                          controller.currentUser.value.phoneNumber, // Simplified access
                          onSaved: (input) {
                            // Input from this widget includes country code
                            controller.currentUser.value.phoneNumber = input;
                          },
                          validator: (input) {
                            // Basic validation, might need more robust check depending on format
                            return input == null || input.length < 7
                                ? "Please enter valid phone number".tr
                                : null;
                          },
                          iconData: Icons.phone_android_outlined,
                          isLast: false,
                          isFirst: false,
                        ),
                        Obx(() {
                          return TextFieldWidget(
                            labelText: "Password".tr,
                            hintText: "••••••••••••".tr,
                            initialValue:
                            controller.currentUser.value.password, // Simplified access
                            onSaved: (input) =>
                            controller.currentUser.value.password = input,
                            validator: (input) => input == null || input.length < 3
                                ? "Should be more than 3 characters".tr
                                : null,
                            obscureText: controller.hidePassword.value,
                            iconData: Icons.lock_outline,
                            keyboardType:
                            TextInputType.visiblePassword,
                            isLast: true,
                            isFirst: false,
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.hidePassword.value =
                                !controller.hidePassword.value;
                              },
                              color: Theme.of(context).focusColor,
                              icon: Icon(controller.hidePassword.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }
              })
            ],
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.vertical,
              children: [
                SizedBox(
                  width: Get.width,
                  child: BlockButtonWidget(
                    onPressed: () {
                      // Add form validation check before registering
                      if (controller.registerFormKey.currentState?.validate() ?? false) {
                        controller.registerFormKey.currentState?.save();
                        print("Register Button Pressed: Form Valid. Calling controller.register()");
                        controller.register();
                      } else {
                        print("Register Button Pressed: Form Invalid.");
                        Get.showSnackbar(Ui.ErrorSnackBar(message: "Please fix errors in the form".tr));
                      }
                    },
                    color: Get.theme.colorScheme.secondary,
                    text: Text(
                      "Register".tr,
                      style: Get.textTheme.headline6?.merge(
                          TextStyle(color: Get.theme.primaryColor)),
                    ),
                  ).paddingOnly(
                      top: 15, bottom: 5, right: 20, left: 20),
                ),
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.LOGIN); // Use offAllNamed to clear stack
                  },
                  child: Text("You already have an account?".tr),
                ).paddingOnly(bottom: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildPrivacyPolicyPopup(BuildContext context) {
  //   final Uri agreementUrl = Uri.parse('https://gen21.com.au/constractors-agreement');
  //
  //   // Function to convert HTML to plain text
  //   String _parseHtmlToText(String htmlContent) {
  //     final document = html_parser.parse(htmlContent);
  //     return document.body?.text ?? ''; // Extract plain text from HTML
  //   }
  //
  //   return AlertDialog(
  //     title: Text('Privacy Policy & Agreement'.tr),
  //     content: Container(
  //       child: SingleChildScrollView(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Display the parsed plain text
  //             Obx(() => Text(
  //               _parseHtmlToText(_privacyPolicyContent.value),
  //               style: Get.textTheme.bodyText1?.merge(TextStyle(fontSize: 11)) ?? TextStyle(fontSize: 11),
  //               softWrap: true,
  //             )),
  //
  //             SizedBox(height: 15),
  //
  //             // "Please Read the Agreement" link as a separate RichText widget
  //             RichText(
  //               text: TextSpan(
  //                 style: Get.textTheme.bodyText2 ?? TextStyle(color: Colors.black),
  //                 children: <TextSpan>[
  //                   TextSpan(
  //                     text: 'Please Read the Agreement'.tr,
  //                     style: TextStyle(
  //                       color: Colors.blue,
  //                       decoration: TextDecoration.underline,
  //                     ),
  //                     recognizer: TapGestureRecognizer()
  //                       ..onTap = () {
  //                         print("Agreement link clicked.");
  //                         _launchUrl(agreementUrl);
  //                       },
  //                   ),
  //                 ],
  //               ),
  //               softWrap: true,
  //             ),
  //
  //             SizedBox(height: 10), // Add spacing between the link and checkbox
  //
  //             // Checkbox and its text
  //             Row(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Obx(() => Checkbox(
  //                   value: _privacyPolicyAccepted.value,
  //                   onChanged: (bool value) {
  //                     if (value != null) {
  //                       print("Checkbox toggled: $value");
  //                       _privacyPolicyAccepted.value = value;
  //                     }
  //                   },
  //                   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                   visualDensity: VisualDensity.compact,
  //                 )),
  //                 Expanded(
  //                   child: Text(
  //                     'I read & understand the privacy policy'.tr,
  //                     style: Get.textTheme.bodyText2 ?? TextStyle(color: Colors.black),
  //                     softWrap: true,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //     actions: <Widget>[
  //       Obx(() => TextButton(
  //         onPressed: _privacyPolicyAccepted.value
  //             ? () {
  //           print("ACCEPT button pressed (enabled).");
  //           Get.back(result: true);
  //         }
  //             : null,
  //         child: Text('ACCEPT'.tr),
  //       )),
  //     ],
  //     contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
  //     actionsPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //   );
  // }


  Widget _buildPrivacyPolicyPopup(BuildContext context) {
    final Uri agreementUrl = Uri.parse('https://gen21.com.au/constractors-agreement');

    // Function to convert HTML to plain text (keep as is)
    String _parseHtmlToText(String htmlContent) {
      final document = html_parser.parse(htmlContent);
      // Consider trimming the result
      return document.body?.text.trim() ?? '';
    }

    // --- Define the Agreement Text Block (WITHOUT the "Agreement" heading) ---
    final String agreementPointsText = """
1. *Independent Contractor Status:*  
   Contractors are engaged as independent businesses, not employees of Gen21. They maintain full control over how services are performed and are solely responsible for their own operations, equipment, and legal compliance.

2. *Registration and Platform Use:*  
   Contractors must register through the Gen21 App and agree to all Gen21 terms, privacy policies, and service conditions. They must keep their information accurate and updated.

3. *Scope of Work and Service Standards:*  
   Contractors have the freedom to accept or reject service requests. Once accepted, services must be performed according to platform guidelines, customer expectations, and applicable laws.

4. *Payment Terms:*  
   Contractors are paid according to Gen21’s public pay model, and they retain 100% of any customer-provided tips. Contractors are responsible for reporting their own taxes; Gen21 does not withhold taxes.

5. *Confidentiality and Data Privacy:*  
   Contractors must protect all confidential company and customer information and comply with privacy laws. Personal information must not be disclosed, misused, or retained beyond the service period.

6. *Insurance Requirements:*  
   Contractors must maintain appropriate insurance (such as vehicle and occupational insurance) at their own expense. Proof of insurance must be provided upon request.

7. *Termination and Dispute Resolution:*  
   Either party can terminate the agreement with proper written notice. In case of disputes, Contractors must notify Gen21 first to allow for resolution before taking legal action.

8. *Non-Disclosure and Non-Interference:*  
   Contractors must not disclose confidential business information or interfere with Gen21’s customer or contractor relationships during and after the agreement period.
""";
    // --- End Agreement Text Block ---


    return AlertDialog(
      title: Text('Privacy Policy & Agreement'.tr, style: TextStyle(fontWeight: FontWeight.bold)), // Make title bold too
      content: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Display the parsed plain text policy
              Obx(() => Text(
                _parseHtmlToText(_privacyPolicyContent.value),
                style: Get.textTheme.bodyMedium?.copyWith(fontSize: 12) ?? TextStyle(fontSize: 12),
                softWrap: true,
              )),

              SizedBox(height: 20), // Spacing after policy

              // 2. Display the "Agreement" heading in RED and BOLD
              // Text(
              //   "Agreement".tr, // Just the heading word
              //   style: Get.textTheme.titleMedium?.copyWith( // Use a slightly larger style for heading
              //     color: Colors.red, // <<<--- SET COLOR TO RED
              //     fontWeight: FontWeight.bold,
              //   ) ?? TextStyle(
              //       fontSize: 14, // Example fallback size
              //       color: Colors.red, // <<<--- SET COLOR TO RED
              //       fontWeight: FontWeight.bold
              //   ),
              // ),
              //
              // SizedBox(height: 8), // Add a small space below the heading
              //
              // // 3. Display the Agreement Points Text (already bold from previous step)
              // Text(
              //   agreementPointsText.tr, // The points without the heading
              //   style: Get.textTheme.bodyMedium?.copyWith(
              //       fontSize: 12,
              //       fontWeight: FontWeight.bold // Keep points bold
              //   ) ?? TextStyle(
              //       fontSize: 12,
              //       color: Colors.black87,
              //       fontWeight: FontWeight.bold // Keep points bold
              //   ),
              //   softWrap: true,
              // ),

              SizedBox(height: 20), // Spacing after agreement points

              // 4. "Please Read the Agreement" Link
              RichText(
                text: TextSpan(
                  text: 'Please Read the Agreement'.tr,
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: Get.textTheme.bodyMedium?.fontSize ?? 14,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      print("Agreement link clicked.");
                      _launchUrl(agreementUrl);
                    },
                ),
              ),

              SizedBox(height: 15), // Increased spacing before checkboxes

              // 5. FIRST Checkbox: Privacy Policy
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() => Checkbox(
                    value: _privacyPolicyAccepted.value,
                    onChanged: (bool value) {
                      if (value != null) {
                        print("Privacy Policy Checkbox toggled: $value");
                        _privacyPolicyAccepted.value = value;
                      }
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  )),
                  Expanded(
                    child: Text(
                      'I read & understand the privacy policy'.tr,
                      style: Get.textTheme.bodyMedium?.copyWith(fontSize: 12) ?? TextStyle(fontSize: 12),
                      softWrap: true,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 5), // Small spacing between checkboxes

              // 6. SECOND Checkbox: Agreement
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() => Checkbox(
                    value: _agreementAccepted.value, // <-- Use the new state variable
                    onChanged: (bool value) {
                      if (value != null) {
                        print("Agreement Checkbox toggled: $value");
                        _agreementAccepted.value = value; // <-- Update the new state variable
                      }
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  )),
                  Expanded(
                    child: Text(
                      'I read & understand agreement'.tr, // <-- New text
                      style: Get.textTheme.bodyMedium?.copyWith(fontSize: 12) ?? TextStyle(fontSize: 12),
                      softWrap: true,
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
      actions: <Widget>[
        // --- UPDATE ACCEPT BUTTON CONDITION ---
        Obx(() => TextButton(
          // Enable only if BOTH checkboxes are true
          onPressed: (_privacyPolicyAccepted.value && _agreementAccepted.value)
              ? () {
            print("ACCEPT button pressed (BOTH accepted).");
            Get.back(result: true); // Close dialog, indicate success
          }
              : null, // Disable button if either checkbox is false
          child: Text('ACCEPT'.tr),
        )),
      ],
      // Adjust padding if needed
      contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
      actionsPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    );
  }


  // Helper function to launch URLs (Keep unchanged)
  Future<void> _launchUrl(Uri url) async {
    // ... (Your existing _launchUrl code) ...
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        final message = 'Could not launch $url'.tr;
        print(message);
        Get.showSnackbar(Ui.ErrorSnackBar(message: message));
      }
    } catch(e) {
      final message = 'Error launching $url: $e'.tr;
      print(message);
      Get.showSnackbar(Ui.ErrorSnackBar(message: message));
    }
  }


  // Function to fetch privacy policy content (Add error state setting)
  Future<void> _fetchPrivacyPolicy() async {
    print("Executing _fetchPrivacyPolicy...");
    // Reset error state before fetch
    _policyError.value = "";
    try {
      final response = await http.get(
        Uri.parse('https://app.gen21.com.au/api/custom_pages/slug/privacy-policy?version=2'),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15)); // Add a timeout

      print("Policy Fetch Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['data']['content']['en'] != null) {
          String content = jsonResponse['data']['content']['en'];
          var unescape = HtmlUnescape();
          String decodedString = unescape.convert(content);
          _privacyPolicyContent.value = decodedString;
          print("Policy content fetched successfully.");
        } else {
          throw Exception("Unexpected JSON structure in policy response.");
        }
      } else {
        throw Exception("Error fetching policy: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Exception during policy fetch: $e");
      print("Stack trace: $stackTrace");
      // Set the specific error message
      _policyError.value = "Network or server error during policy fetch: $e".tr;
      _privacyPolicyContent.value = ''; // Clear content on error
      // Show snackbar immediately if desired, but Obx will handle showing the error screen
      // Get.showSnackbar(Ui.ErrorSnackBar(message: "Error fetching policy".tr));
    } finally {
      // Ensure loading state is turned off *after* potential state updates
      _loadingPolicy.value = false;
      print("Policy fetch finished. loadingPolicy set to false.");
    }
  }
}