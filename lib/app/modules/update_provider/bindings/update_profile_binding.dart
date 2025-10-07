import 'package:get/get.dart';

import '../controllers/update_provider_conteroller.dart';

class UpdateProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateProviderController>(
      () => UpdateProviderController(),
    );

  }
}
