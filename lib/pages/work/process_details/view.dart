import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/base/model.dart' hide Column;
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/main.dart';
import 'package:orginone/utils/log/log_util.dart';
import 'logic.dart';
import 'process_info/view.dart';
import 'state.dart';
import 'use_traces/view.dart';

///办事 详情
class ProcessDetailsPage
    extends BaseGetView<ProcessDetailsController, ProcessDetailsState> {
  const ProcessDetailsPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
        titleName: state.todo?.taskdata.title, body: _buildMainView());
  }

  _buildMainView() {
    if (state.todo?.instance != null) {
      //返回流程视图
      return _buildInstanceView();
    }
    return _buildApplyView();
  }

  Widget tabBar() {
    return Container(
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: state.tabController,
        tabs: tabTitle.map((e) {
          return Tab(
            text: e,
            height: 60.h,
          );
        }).toList(),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: XColors.themeColor,
        unselectedLabelColor: Colors.grey,
        unselectedLabelStyle: TextStyle(fontSize: 22.sp),
        labelColor: XColors.themeColor,
        labelStyle: TextStyle(fontSize: 24.sp),
        isScrollable: true,
      ),
    );
  }

  _buildInstanceView() {
    return Column(
      children: [
        tabBar(),
        Expanded(
          child: TabBarView(
            controller: state.tabController,
            children: [
              ProcessInfoPage(),
              UseTracesPage(),
            ],
          ),
        )
      ],
    );
  }

  _buildApplyView() {
    return <Widget>[
      _buildApplyHeaderView(),
      _buildDateView('申请时间：${state.todo?.taskdata.createTime}'),
      _buildApplyResultView(),
      _buildDateView('审批时间：${state.todo?.taskdata.records?.first.createTime}'),
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingAll(AppSpace.page);
  }

  _buildApplyHeaderView() {
    ShareIcon? create = settingCtrl.provider.user
        ?.findShareById(state.todo?.targets[0].createUser ?? '');
    ShareIcon? target = settingCtrl.provider.user
        ?.findShareById(state.todo?.targets[1].id ?? '');

    return <Widget>[
      _imageWidget(create),
      TextWidget.body1(state.todo?.targets[0].name ?? '')
          .paddingLeft(AppSpace.listItem),

      const SizedBox(
          height: 20,
          child: VerticalDivider(
            color: Colors.grey,
            width: 4,
          )).paddingLeft(AppSpace.listItem),
      // const SizedBox(height: 20, child: VerticalDivider(color: Colors.grey)),

      const TextWidget.body1('申请加入').paddingHorizontal(AppSpace.listItem),

      const SizedBox(
          height: 20,
          child: VerticalDivider(
            color: Colors.grey,
            width: 4,
          )).paddingRight(AppSpace.listItem),
      _imageWidget(target),
      TextWidget.body1(state.todo?.targets[1].name ?? '')
          .paddingLeft(AppSpace.listItem),
    ].toRow().paddingVertical(AppSpace.listItem);
  }

  ///头像组件
  _imageWidget(ShareIcon? target) {
    return target?.avatar?.thumbnailUint8List == null
        ? ImageWidget.asset(
            target?.avatar?.defaultAvatar ?? '',
            width: 30,
            height: 30,
          )
        : ImageWidget(
            data: target?.avatar?.thumbnailUint8List,
            width: 30,
            height: 30,
            type: ImageWidgetType.memory,
            url: '');
  }

  _buildApplyResultView() {
    ShareIcon? record = settingCtrl.provider.user
        ?.findShareById(state.todo?.taskdata.records?.first.createUser ?? '');
    LogUtil.d(record);
    int status = state.todo?.taskdata.status ?? 0;
    return <Widget>[
      // Image.network('src'),
      _imageWidget(record),
      TextWidget.body1(record?.name ?? '').paddingLeft(AppSpace.listItem),
      const SizedBox(
              height: 20, width: 4, child: VerticalDivider(color: Colors.grey))
          .paddingLeft(AppSpace.listItem),
      const TextWidget.body1('审批意见：').paddingLeft(AppSpace.listItem),
      const SizedBox(
              height: 20, width: 4, child: VerticalDivider(color: Colors.grey))
          .paddingHorizontal(AppSpace.listItem),
      TextWidget.body1(
          status == TaskStatus.approvalStart.status ? '已同意' : '已拒绝',
          color: status == TaskStatus.approvalStart.status
              ? AppColors.blue
              : AppColors.red),
    ].toRow().paddingVertical(AppSpace.listItem);
  }

  _buildDateView(String text) {
    return TextWidget(text: text);
  }
}
