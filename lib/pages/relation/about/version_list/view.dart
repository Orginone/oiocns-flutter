import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/relation/about/version_list/item.dart';
import 'package:orginone/pages/relation/about/version_list/logic.dart';
import 'package:orginone/pages/relation/about/version_list/state.dart';

class VersionListPage
    extends BaseGetView<VersionListController, VersionListState> {
  const VersionListPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
        titleName: '版本介绍',
        backgroundColor: Colors.white,
        body: Obx(() {
          return ListView.builder(
            itemCount: state.loadHistoryVersionInfo.length,
            itemBuilder: (context, int index) {
              var item = state.loadHistoryVersionInfo[index];
              var versionItem = VersionItem(
                title: item.content ?? '',
                version: item.version ?? '',
                date: item.updateTime ?? '',
                content: item.content ?? '',
              );
              return GestureDetector(
                onTap: () {
                  // showDetail(item);
                  controller.showDiaLog(context, versionItem);
                },
                child: versionItem,
              );
            },
          );
        }));
  }
}
