import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'controllers/custom_webview_controller.dart';

class CustomWebView extends GetView<CustomWebViewController> {
  final _key = UniqueKey();
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( title: Text("${controller.title}")),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: controller.url.value))
          ],
        ));
  }
}
