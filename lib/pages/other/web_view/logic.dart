import 'package:webview_flutter/src/webview.dart' as wb;

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class WebViewController extends BaseController<WebViewState> {
  final WebViewState state = WebViewState();

  void createWebViewController(wb.WebViewController ctr) {
    state.webViewController = ctr;
    state.webViewController.getTitle().then((title) {
      state.title.value = title ?? "";
    });
  }
}
