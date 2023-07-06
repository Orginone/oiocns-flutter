import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/images.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/load_state_widget.dart';

import 'base_controller.dart';
import 'base_get_list_state.dart';
import 'base_get_state.dart';
import 'base_get_view.dart';
import 'base_list_controller.dart';

abstract class BaseGetListView<T extends BaseListController,S extends BaseGetListState> extends BaseGetView<T,S>{

  S get state => controller.state as S;
  BuildContext get context => controller.context;

  @override
  Widget build(BuildContext context) {
    this.controller.context = context;

    Widget body = NestedScrollView(
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
                  onRetry: () {
                    controller.loadData();
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
    if(showAppBar){
      body = GyScaffold(
        titleName: title,
        actions: actions(),
        body:body);
    }
    return body;
  }

  Widget noData(){
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      color: Colors.grey.shade200,
      child: Image.asset(Images.empty,width: 300.w,height: 400.w,),
    );
  }

  bool displayNoDataWidget()=>true;

  Widget buildView();

  late String title;

  List<Widget> actions(){
    return [];
  }

  Widget headWidget() {
    return Container();
  }

  Widget bottomWidget() {
    return Container();
  }

  bool showAppBar = true;
}