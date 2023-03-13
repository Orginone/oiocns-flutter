import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/shine_widget.dart';

import '../../add_asset/item.dart';
import 'logic.dart';
import 'state.dart';

class CreateDisposePage
    extends BaseGetView<CreateDisposeController, CreateDisposeState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "${state.isEdit ? "提交" : "创建"}处置",
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                basicInfo(),
                disposeInfo(),
                CommonWidget.commonAddDetailedWidget(
                    text: "选择资产",
                    onTap: () {
                      controller.jumpAddAsset();
                    })
              ],
            ),
          )),
          CommonWidget.commonCreateSubmitWidget(draft: () {
            controller.draft();
          }, submit: () {
            controller.submit();
          }),
        ],
      ),
    );
  }

  Widget basicInfo() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidget.commonHeadInfoWidget(state.config.config![0].title??""),
          ...state.config.config![0].fields!.map((e){
            e.function = (){
              controller.functionAlloc(e);
            };
            Widget child = testShine[e.type??""]!(e,isEdit: state.isEdit,assetsType: AssetsType.dispose);
            return child;
          }),
        ],
      ),
    );
  }

  Widget disposeInfo() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidget.commonHeadInfoWidget("处置明细",
              action: GestureDetector(
                child: const Text(
                  "批量删除",
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  controller.jumpBulkRemovalAsset();
                },
              )),
          Obx(() {
            return ListView.builder(
              itemBuilder: (context, index) {
                return Item(
                  assets: state.selectAssetList[index],
                  openInfo: () {
                    controller.openInfo(index);
                  },
                  supportSideslip: true,
                  delete: () {
                    controller.removeItem(index);
                  },
                );
              },
              itemCount: state.selectAssetList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            );
          })
        ],
      ),
    );
  }
}
