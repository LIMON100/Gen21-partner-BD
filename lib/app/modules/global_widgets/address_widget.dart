import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/place_picker_dialog.dart';
import '../../routes/app_routes.dart';
import '../../services/settings_service.dart';

class AddressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.place_outlined),
          SizedBox(width: 10),
          Expanded(
            child: Obx(() {
              if (Get.find<SettingsService>().address.value?.isUnknown() ?? true) {
                return Text("Please choose your address".tr, style: Get.textTheme.bodyText1);
              }
              return Text(Get.find<SettingsService>().address.value.address, style: Get.textTheme.bodyText1);
            }),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.gps_fixed),
            onPressed: () async {
              // Get.toNamed(Routes.SETTINGS_ADDRESS_PICKER);
              // showPlacePicker();
              if(Platform.isAndroid) {
                Get.dialog(Dialog(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Location Permission".tr,
                            style: TextStyle(color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            '"Live location" needs background location permission , for using Google map for live direction to reach to the location where event is being organised for the person who booked the service from our app.'
                                .tr,
                            style: TextStyle(color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  color: Colors.grey.shade300,
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Cancel".tr,
                                    style: TextStyle(color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                  showPlacePicker();
                                },
                                child: Container(
                                  height: 50,
                                  color: Get.theme.colorScheme.secondary,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Okay".tr,
                                    style: TextStyle(color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                ));
              }else{
                showPlacePicker();
              }
            },
          )
        ],
      ),
    );
  }
}
