import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart' as wb;

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class WebViewController extends BaseController<WebViewState> {
  @override
  final WebViewState state = WebViewState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.webViewController = wb.WebViewController();
    state.webViewController.loadRequest(Uri.parse(state.url));
    state.webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    state.webViewController.setBackgroundColor(Colors.white);
    state.webViewController.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          if (progress == 100) {
            state.webViewController.getTitle().then((value) {
              state.title.value = value ?? "";
            });
          }
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
      ),
    );
  }
}
