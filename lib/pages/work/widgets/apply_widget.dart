import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/base/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/work/widgets/approve_widget.dart';
import 'package:orginone/utils/icons.dart';
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
    return <Widget>[
      <Widget>[
        const TextWidget.body1('申  请  者：'),
        _imageWidget(target: todo!.targets.first),
        TextWidget.body1(
          '${todo?.targets.first.name}' ?? '',
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          color: AppColors.blue,
        ).paddingLeft(AppSpace.listItem).constrained(width: Get.width * 0.65),
      ].toRow(),
      <Widget>[
        const TextWidget.body1('申请加入：'),
        _imageWidget(target: todo!.targets.last),
        TextWidget.body1(
          todo?.targets.last.name ?? '',
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          color: AppColors.blue,
        ).paddingLeft(AppSpace.listItem).constrained(width: Get.width * 0.65),
      ].toRow(),
    ]
        .toColumn(mainAxisAlignment: MainAxisAlignment.start)
        .paddingVertical(AppSpace.listItem);
  }

  ///头像组件
  _imageWidget({XTarget? target, ShareIcon? shareIcon}) {
    ShareIcon? icon;
    if (target?.icon == null) {
      icon = shareIcon ??
          settingCtrl.provider.user?.findShareById(target?.id ?? '');
      if (icon != null && icon.name.isEmpty) {
        icon.name = (shareIcon == null
                ? target == null
                    ? ''
                    : target.name
                : shareIcon.typeName) ??
            '';
        icon.typeName = (shareIcon == null
                ? target == null
                    ? ''
                    : target.typeName
                : shareIcon.typeName) ??
            '';
      }
    } else {
      icon = ShareIcon(
          name: target?.name ?? '',
          typeName: target?.typeName ?? '',
          avatar: parseAvatar(target?.icon));
    }
    // LogUtil.d('_imageWidget');
    // LogUtil.d(target?.name);
    // LogUtil.d(icon?.name);
    // LogUtil.d(icon?.typeName);
    // LogUtil.d(icon?.avatar?.thumbnail);
    return icon?.avatar?.thumbnailUint8List == null
        ? XImageWidget.asset(
            IconsUtils.workDefaultAvatar(
                target?.typeName ?? shareIcon?.typeName ?? ''),
            // target!.defaultAvatar(),
            width: 20,
            height: 20,
            fit: BoxFit.fill,
          )
        : XImageWidget(
            data: icon?.avatar?.thumbnailUint8List,
            width: 20,
            height: 20,
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
    LogUtil.d('_buildApplyResultView');
    LogUtil.d(record?.toJson());
    LogUtil.d(todo?.taskdata.records?.first.createUser);
    int status = todo?.taskdata.status ?? 0;
    if (status < TaskStatus.approvalStart.status) return const SizedBox();
    var result = <Widget>[
      // Image.network('src'),
      _imageWidget(shareIcon: record),
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
