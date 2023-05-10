import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/work/work_start/create_work/state.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/load_state_widget.dart';
import 'package:orginone/widget/mapping_components.dart';
import 'package:orginone/pages/other/choice_thing/item.dart';
import 'logic.dart';

class CreateWorkPage
    extends BaseGetView<CreateWorkController, CreateWorkState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "创建办事",
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future:controller.init(),
              builder: (context, snapshot) {
                if(snapshot.connectionState != ConnectionState.done){
                  return LoadStateWidget(isLoading: true,isSuccess: false,);
                }
                if(snapshot.hasError){
                  return Container();
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ...state.node.forms!.map((e) {
                        return Container();
                        // return Column(
                        //   children: [
                        //     CommonWidget.commonHeadInfoWidget(e.name ?? ""),
                        //     ...e.items!.map((e) {
                        //       if(e
                        //           .fields!
                        //           .type == null){
                        //         return Container();
                        //       }
                        //       Widget child =
                        //       testMappingComponents[e
                        //           .fields!
                        //           .type ?? ""]!(
                        //           e.fields!);
                        //       return child;
                        //     }).toList()
                        //   ],
                        // );
                      }).toList(),
                      entityInfo(),
                    ],
                  ),
                );
              }
            ),
          ),
          CommonWidget.commonSubmitWidget(
              submit: () {
                controller.submit();
              },
              text: "提交"),
        ],
      ),
    );
  }

  Widget entityInfo() {
    if(state.define.isCreate??false){
      return Container();
    }
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidget.commonHeadInfoWidget("实体明细",
              action: GestureDetector(
                child: const Text(
                  "",
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  // controller.jumpBulkRemovalAsset();
                },
              )),
          Obx(() {
            return ListView.builder(
              itemBuilder: (context, index) {
                var item = state.selectedThings[index];
                return Item(item: item,showSelectButton: false,showDelete: true,delete: (){
                  controller.delete(index);
                },);
              },
              itemCount:state.selectedThings.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            );
          }),
          CommonWidget.commonAddDetailedWidget(
              text: "选择实体",
              onTap: () {
                controller.jumpEntity();
              }),
        ],
      ),
    );
  }
}
