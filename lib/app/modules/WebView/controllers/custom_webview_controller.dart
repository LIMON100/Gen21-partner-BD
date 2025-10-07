import 'package:get/get.dart';

import '../../../../common/log_data.dart';
import '../../../../common/ui.dart';
import '../../../models/custom_page_model.dart';
import '../../../repositories/custom_page_repository.dart';

class CustomWebViewController extends GetxController {
  final url = "".obs;
  final title = "".obs;
  // CustomPageRepository _customPageRepository;

  CustomWebViewController() {
    // _customPageRepository = CustomPageRepository();
  }

  @override
  void onInit() {
    printWrapped("sjndjkfa arguments: ${Get.arguments}");
    url.value = Get.arguments["url"] as String;
    title.value = Get.arguments["title"] as String;
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}
}
