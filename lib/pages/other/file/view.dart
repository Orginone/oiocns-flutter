import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'item.dart';
import 'logic.dart';
import 'state.dart';

class FilePage extends BaseGetView<FileController, FileState> {
  @override
  Widget buildView() {
    return Obx(() {
      return GyScaffold(
        titleName: state.title.value,
        body: Column(
          children: [
            Obx(
                  () {
                return CommonWidget.commonBreadcrumbNavWidget(
                  firstTitle: state.file.value?.target?.name ?? "",
                  allTitle: state.selectedDir
                      .map((element) => element.target?.name ?? "")
                      .toList(),
                  onTapFirst: () {
                    controller.clearGroup();
                  },
                  onTapTitle: (index) {
                    controller.removeGroup(index);
                  },
                );
              },
            ),
            CommonWidget.commonSearchBarWidget(
                controller: state.searchController,
                onSubmitted: (str) {
                  controller.search(str);
                },
                hint: "请输入文件或文件夹名称"),
            Expanded(
              child: Obx(() {
                var list = state.file.value?.children;
                if(state.selectedDir.isNotEmpty){
                  list = state.selectedDir.last.children;
                }
                return ListView.builder(
                  itemBuilder: (context, index) {
                    var item = list![index];
                    return Item(file: item, onTap: () {
                      controller.selectFile(item);
                    },);
                  },
                  itemCount: list?.length ?? 0,
                );
              }),
            )
          ],
        ),
      );
    });
  }
}
