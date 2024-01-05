import 'package:flutter/material.dart';
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
      body: ListView.builder(
        itemCount: state.versionlist.length,
        itemBuilder: (context, int index) {
          var item = state.versionlist[index];
          var versionItem = VersionItem(
            title: item['title'] ?? '',
            version: item['version'] ?? '',
            date: item['date'] ?? '',
            content: item['content'] ?? '',
          );
          return GestureDetector(
            onTap: () {
              // showDetail(item);
              controller.showDiaLog(context, versionItem);
            },
            child: versionItem,
          );
        },
      ),
    );
  }
}
