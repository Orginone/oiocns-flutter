import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';
import 'package:webview_flutter/webview_flutter.dart' hide WebViewController;

import 'logic.dart';
import 'state.dart';

class WebViewPage extends BaseGetView<WebViewController, WebViewState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleWidget: Obx(() {
        return Text(
          state.title.value,
          style: const TextStyle(color: Colors.black),
        );
      }),
      body: WebViewWidget(
        controller: state.webViewController,
      ),
    );
  }
}
