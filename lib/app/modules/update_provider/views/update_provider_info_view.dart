import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/log_data.dart';
import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/address_widget.dart';
import '../../global_widgets/block_button_widget.dart';
import '../controllers/update_provider_conteroller.dart';

class UpdateProviderInfoView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UpdateProviderInfoViewState();
  }
}

class UpdateProviderInfoViewState extends State<UpdateProviderInfoView> {
  UpdateProviderController _updateProviderController =
      Get.find<UpdateProviderController>();
   User user;
   String apiKey;
  @override
  void initState() {
    printWrapped("shdbhbyy3_2 currentUser.value: ${Get.arguments.toString()}");
    if(Get.arguments != null){
      user = Get.arguments['user'] as User;
      apiKey = Get.arguments['api_key'] as String;
    }
    printWrapped("shdbhbyy3_2_3 currentUser.value: ${user.toString()}");

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // printWrapped("shdbhbyy3_1 currentUser.value: ${user.toString()}");
    // user = Get.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Complete Profile".tr,
          style: Get.textTheme.headline6
              .merge(TextStyle(color: context.theme.primaryColor)),
        ),
        centerTitle: true,
        backgroundColor: Get.theme.colorScheme.secondary,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
          // onPressed: () => {Get.find<RootController>().changePageOutRoot(0)},
          onPressed: () {
            printWrapped("gen_log onback() pressed");
            Get.back();
          },
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 10),
            AddressWidget(),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    // buildMobileNumberInputField(),
                    // SizedBox(height: 10),
                    availableRangeInputField(),
                    SizedBox(height: 20),
                    Obx((){
                      return _updateProviderController.isProfileUpdating.value? CircularProgressIndicator():
                      InkWell(
                        onTap: () {
                          printWrapped("gen_logn ${Get.find<SettingsService>().address.value}");
                          // if (Get.find<SettingsService>().address?.value?.latitude == null) {
                          //   Get.showSnackbar(Ui.ErrorSnackBar(
                          //       message: "Please set your location"));
                          //   return;
                          // }

                          // else if (_updateProviderController
                          //     .mobileEditingController.text ==
                          //     "") {
                          //   Get.showSnackbar(Ui.ErrorSnackBar(
                          //       message: "Please give Mobile Number"));
                          // }
                          if (_updateProviderController.availableRangeEditingController.text ==
                              "") {
                            Get.showSnackbar(Ui.ErrorSnackBar(
                                message: "Please give your available range"));
                          } else {

                            final requestBody = {
                              "name": "${user.name}",
                              // "phone_number": "${_updateProviderController.mobileEditingController.text}",
                              "phone_number": "${user.phoneNumber}",
                              "availability_range": "${_updateProviderController.availableRangeEditingController.text}",
                              "e_provider_type_id": "1",
                              "description": "",
                              "address": "${Get.find<SettingsService>().address.value.address}",
                              "latitude": "${Get.find<SettingsService>().address.value.latitude}",
                              "longitude": "${Get.find<SettingsService>().address.value.longitude}"
                              ,
                            };

                            _updateProviderController.updateProviderInfo(jsonEncode(requestBody), user.apiToken);
                          }
                          printWrapped("gen_logn ${Get.find<SettingsService>().address}");

                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 30, right: 30, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            color: Get.theme.colorScheme.secondary,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Text("Submit".tr,
                              style: (TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                        ),
                      );
                    })

                  ],
                )),
          ],
        ),
      ),
    );
  }

  // Widget buildMobileNumberInputField() {
  //   return Hero(
  //     tag: Get.arguments ?? '',
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
  //       decoration: BoxDecoration(
  //           border: Border.all(
  //             color: Get.theme.colorScheme.secondary.withOpacity(.50),
  //           ),
  //           borderRadius: BorderRadius.circular(4)),
  //       child: Container(
  //         child: Row(
  //           children: <Widget>[
  //             InkWell(
  //               onTap: () {
  //                 Get.back();
  //               },
  //               child: Padding(
  //                 padding: const EdgeInsets.only(right: 12, left: 0),
  //                 child: Icon(
  //                   Icons.phone_android,
  //                   color: Get.theme.colorScheme.secondary,
  //                   size: 28,
  //                 ),
  //               ),
  //             ),
  //             Expanded(
  //               // child: Material(
  //               child: TextField(
  //                 keyboardType: TextInputType.phone,
  //                 controller: _updateProviderController.mobileEditingController,
  //                 autofocus: false,
  //                 // onChanged:  controller.onChangeHandler,
  //                 // clipBehavior: HitTestBehavior.translucent,
  //                 style: Get.textTheme.bodyText2,
  //
  //                 onSubmitted: (value) {
  //                   // controller.searchEServices(keywords: value);
  //                 },
  //                 cursorColor: Get.theme.focusColor,
  //                 decoration: Ui.getInputDecoration(
  //                   hintText: "Mobile Number.".tr,
  //                 ),
  //               ),
  //               // ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget availableRangeInputField() {
    return Hero(
      tag: Get.arguments ?? '',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        decoration: BoxDecoration(
            border: Border.all(
              color: Get.theme.colorScheme.secondary.withOpacity(.50),
            ),
            borderRadius: BorderRadius.circular(4)),
        child: Container(
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 12, left: 0),
                child: Icon(
                  Icons.ac_unit_sharp,
                  color: Get.theme.colorScheme.secondary,
                  size: 28,
                ),
              ),
              Expanded(
                // child: Material(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller:
                      _updateProviderController.availableRangeEditingController,
                  autofocus: false,
                  // onChanged:  controller.onChangeHandler,
                  // clipBehavior: HitTestBehavior.translucent,
                  style: Get.textTheme.bodyText2,


                  onSubmitted: (value) {
                    // controller.searchEServices(keywords: value);
                  },
                  cursorColor: Get.theme.focusColor,
                  decoration: Ui.getInputDecoration(
                    hintText: "Available Range".tr,
                    suffix: Text("Km"),

                  ),
                ),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
