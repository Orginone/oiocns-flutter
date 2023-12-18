import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/utils/index.dart';

import 'index.dart';

class ErrorPage extends GetView<ErrorPageController> {
  const ErrorPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    List errorArray = [];
    var json = Storage.getString('work_page_error');
    if (json != '') {
      errorArray = jsonDecode(json);
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        var data = errorArray[index];

        return ListTile(
            title: TextWidget.title3(data['t']),
            subtitle: TextWidget.body1(
              data['errorText'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ) //Text(data['errorText']),
            ).height(60).onTap(() {
          Get.to(ErrorSubPage(index));
        });
      },
      itemCount: errorArray.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ErrorPageController>(
      init: ErrorPageController(),
      id: "error_page",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("办事页面错误日志"), actions: [
            ButtonWidget.text(
              '清除日志',
              onTap: () {
                Storage.remove('work_page_error');
                controller.update(['error_page']);
              },
            )
          ]),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}

class ErrorSubPage extends GetView<ErrorPageController> {
  const ErrorSubPage(this.index, {Key? key}) : super(key: key);
  final int index;

  get item => jsonDecode(Storage.getString('work_page_error'))[index];
  // 主视图
  Widget _buildView() {
    return <Widget>[Text(item['errorText'])].toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ErrorPageController>(
      init: ErrorPageController(),
      id: "error_sub_page",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text(item['t'] ?? ''),
            actions: [
              ButtonWidget.text(
                '复制',
                onTap: () => SystemUtils.copyToClipboard(item['errorText']),
              )
            ],
          ),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
