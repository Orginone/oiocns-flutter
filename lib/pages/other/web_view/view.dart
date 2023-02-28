import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:webview_flutter/webview_flutter.dart' hide WebViewController;

import 'logic.dart';
import 'state.dart';

class WebViewPage extends BaseGetView<WebViewController, WebViewState> {

  @override
  Widget buildView() {
    return Scaffold(
        appBar: AppBar(
          title: Obx(() {
            return Text(state.title.value);
          }),
        ),
      body: WebView(
        onWebViewCreated: (ctr){
          controller.createWebViewController(ctr);
        },
        initialUrl: state.url,
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: {
          JavascriptChannel(name: '', onMessageReceived: (JavascriptMessage message) {

          }),
        },
        allowsInlineMediaPlayback: true,
        initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
        navigationDelegate: (NavigationRequest navigation){
          return NavigationDecision.prevent;
        },
      ),
    );
  }
}