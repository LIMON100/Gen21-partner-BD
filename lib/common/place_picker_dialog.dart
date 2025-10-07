import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:home_service/common/ui.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import '../app/modules/root/controllers/root_controller.dart';
import '../app/modules/service_request/controllers/RequestController.dart';
import '../app/services/auth_service.dart';
import '../app/services/settings_service.dart';

void showPlacePicker() async {
  try {
  LocationResult _address = await Navigator.of(Get.context).push(
    MaterialPageRoute(
      builder: (context) => PlacePicker(Get.find<SettingsService>().setting.value.googleMapsKey, defaultLocation: LatLng(	-33.865143, 151.209900),),
    ),
  );
  // Handle the result in your way

    print("kfsjnfjksnan 1");

    Get.find<SettingsService>().address.update((val) {
      // val.description = _address.description;
      val.address = _address.formattedAddress;
      val.latitude =_address.latLng.latitude;
      val.longitude = _address.latLng.longitude;
      val.userId = Get.find<AuthService>().user.value.id;
    });
    print("hdshdsh ${Get.find<SettingsService>().address.toString()}");

  } catch (e) {
    // isAddingLocation.value = false;
    print("kfsjnfjksnan 9: ${e.toString()}");
    Get.showSnackbar(Ui.ErrorSnackBar(message: "Something went wrong!"));
  }

  print("kfsjnfjksnan 10");


  // Get.back();
}
