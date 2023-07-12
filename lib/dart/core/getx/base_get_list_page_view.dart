import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/images.dart';
import 'package:orginone/widget/load_state_widget.dart';

import 'base_get_list_state.dart';
import 'base_list_controller.dart';

abstract class BaseGetListPageView<T extends BaseListController, S extends BaseGetListState>
    extends StatelessWidget {

  late T controller;

  S get state => controller.state as S;

  BuildContext get context => controller.context;

  @override
  Widget build(BuildContext context) {
    controller = Get.put(getController(), tag: tag());
    controller.context = context;

    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: headWidget(),
          )
        ];
      },
      body: EasyRefresh(
        controller: state.refreshController,
        onRefresh: controller.onRefresh,
        onLoad: controller.onLoadMore,
        header: const MaterialHeader(),
        footer: const MaterialFooter(),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return LoadStateWidget(
                  isSuccess: state.isSuccess.value,
                  isLoading: state.isLoading.value,
                  onRetry: () async {
                    await controller.loadData();
                  },
                  child: Obx(() {
                    if (state.dataList.isEmpty && displayNoDataWidget()) {
                      return noData();
                    }
                    return buildView();
                  }),
                );
              }),
            ),
            bottomWidget(),
          ],
        ),
      ),
    );
  }

  Widget noData(){
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height.h,
        alignment: Alignment.center,
        color: Colors.grey.shade200,
        child: Image.asset(Images.empty,width: 300.w),
      ),
    );
  }

  Widget buildView();


  Widget headWidget() {
    return Container();
  }

  Widget bottomWidget() {
    return Container();
  }

  T getController();

  String tag() {
    return "";
  }

  bool displayNoDataWidget()=>true;
}