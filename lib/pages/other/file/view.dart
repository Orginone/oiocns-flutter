import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class FilePage
    extends BaseBreadcrumbNavMultiplexPage<FileController, FileState> {
  @override
  Widget body() {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            return ListView.builder(
              itemBuilder: (context, index) {
                var item = state.model.value!.children[index];
                return Item(
                  item: item,
                  onNext: (){
                    controller.onNextLv(item);
                  },
                  onSelected: (selected){
                    controller.onSelected(item,selected);
                  },
                );
              },
              itemCount: state.model.value!.children.length,
            );
          }),
        )
      ],
    );
  }

  @override
  FileController getController() {
    return FileController();
  }
}
