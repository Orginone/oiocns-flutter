import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/work/widgets/approve_widget.dart';
import 'package:orginone/utils/index.dart';

//申请加入办事组件
class ApplyWidget extends StatelessWidget {
  const ApplyWidget({
    super.key,
    required this.todo,
  });

  final IWorkTask? todo;

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  _buildMainView() {
    return <Widget>[
      _buildApplyHeaderView(),
      _buildDateView('申请时间：${todo?.taskdata.createTime}'),
      _buildAyylyView(),
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingAll(AppSpace.page);
  }

  _buildAyylyView() {
    return <Widget>[_buildApplyResultView(), _buildApproveView()]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  _buildApplyHeaderView() {
    ShareIcon? create = settingCtrl.provider.user
        ?.findShareById(todo?.targets.first.createUser ?? '');
    ShareIcon? target =
        settingCtrl.provider.user?.findShareById(todo?.targets.last.id ?? '');

    return <Widget>[
      _imageWidget(create),
      TextWidget.body1(todo?.targets.first.name ?? '')
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
      TextWidget.body1(todo?.targets.last.name ?? '')
          .paddingLeft(AppSpace.listItem),
    ].toRow().paddingVertical(AppSpace.listItem);
  }

  ///头像组件
  _imageWidget(ShareIcon? target) {
    return target?.avatar?.thumbnailUint8List == null
        ? XImageWidget.asset(
            target?.avatar?.defaultAvatar ?? '',
            width: 30,
            height: 30,
          )
        : XImageWidget(
            data: target?.avatar?.thumbnailUint8List,
            width: 30,
            height: 30,
            type: ImageWidgetType.memory,
            url: '');
  }

  _buildApproveView() {
    int status = todo?.taskdata.status ?? 0;

    if (status > 1) return const SizedBox();
    return ApproveWidget(todo: todo);
  }

  _buildApplyResultView() {
    ShareIcon? record = settingCtrl.provider.user?.findShareById(
        todo?.taskdata.records == null
            ? ''
            : todo?.taskdata.records?.first.createUser ?? '');
    LogUtil.d(record);
    int status = todo?.taskdata.status ?? 0;
    if (status < TaskStatus.approvalStart.status) return const SizedBox();
    var result = <Widget>[
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
      TextWidget.body1(_statusToStr(status),
          color: status == TaskStatus.approvalStart.status
              ? AppColors.blue
              : AppColors.red),
    ].toRow().paddingVertical(AppSpace.listItem);

    return <Widget>[
      result,
      _buildDateView('审批时间：${todo?.taskdata.records?.first.createTime ?? ''}'),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  _buildDateView(String text) {
    return TextWidget(text: text);
  }

  _statusToStr(int status) {
    if (status == TaskStatus.approvalStart.status) {
      return '已同意';
    }
    if (status == TaskStatus.refuseStart.status) {
      return '已拒绝';
    }
    return '';
  }
}
