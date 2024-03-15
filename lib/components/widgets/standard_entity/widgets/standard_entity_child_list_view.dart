import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/widgets/common/others/common_widget.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/public/consts.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/index.dart';
import 'package:orginone/utils/load_image.dart';

class StandardEntityChildListView<T> extends StatefulWidget {
  const StandardEntityChildListView({
    super.key,
    required this.data,
  });
  final T data;
  @override
  State<StandardEntityChildListView> createState() =>
      _StandardEntityChildListViewState();
}

class _StandardEntityChildListViewState
    extends State<StandardEntityChildListView> {
  get data => widget.data;
  get list => widget.data.speciesItems;
  @override
  Widget build(BuildContext context) {
    return _buildView();
  } //构建infoView

  _buildView() {
    LogUtil.d('StandardEntityChildListView');
    LogUtil.d(data.toJson());
    if (data == null || list == null || list.isEmpty) {
      return const SizedBox();
    }
    return <Widget>[
      CommonWidget.sectionHeaderView('${data.typeName ?? ''}项'),
      _buildListView()
    ].toColumn();
  }

  _buildListView() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (_, int index) {
          var item = list[index];
          return _item(item, index);
        });
  }

  _item(dynamic item, int index) {
    return <Widget>[
      itemWidget('名称', '${item.name ?? ''}', rowCount: 2, item: item.toJson()),
      itemWidget('编号', '${item.code ?? '--'}',
          rowCount: 2, item: item.toJson()),
      itemWidget('信息', '${item.info ?? ''}', rowCount: 1, item: item.toJson()),
      itemWidget('归属', '${item.name ?? ''}',
          rowCount: 1, userId: '${item.belongId ?? ''}', item: item.toJson()),
      itemWidget('创建人', '${item.name ?? ''}',
          rowCount: 1, userId: '${item.updateUser ?? ''}', item: item.toJson()),
      itemWidget('创建时间', '${item.createTime ?? ''}',
          rowCount: 1, item: item.toJson()),
      itemWidget('备注', '${item.remark ?? ''}',
          rowCount: 1, item: item.toJson()),
    ]
        .toWrap(runSpacing: AppSpace.listItem)
        .marginSymmetric(horizontal: AppSpace.page, vertical: AppSpace.page)
        .backgroundColor(AppColors.lightPrimary)
        .marginOnly(
            top: AppSpace.page, left: AppSpace.page, right: AppSpace.page)
        .borderRadius(all: 10)
        .clipRRect(all: 10, topLeft: 10);
  }

  itemWidget(String title, String value,
      {int rowCount = 2, ShareIcon? icon, Map? item, String? userId}) {
    bool hasIcon = icon != null || userId != null;
    ShareIcon share = shareIcon(userId ?? '');
    return <Widget>[
      <Widget>[
        TextWidget(
          text: '$title:',
          style: const TextStyle(color: AppColors.gray_66),
        ),
        userId == null
            ? const SizedBox()
            : XImage.entityIcon(userId, entityId: userId, height: 20)
                .paddingLeft(3),
        TextWidget.body1(
          hasIcon ? share.name : value,
          color: userId != null ? AppColors.primary : AppColors.gray_66,
          maxLines: 3,
          softWrap: true,
          overflow: TextOverflow.clip,
        ).paddingLeft(3).width((Get.width - AppSpace.page * 4) / rowCount -
            (hasIcon ? 18 + 6 : 0) -
            title.length * 18),
      ].toRow(crossAxisAlignment: CrossAxisAlignment.center),
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .width((Get.width - AppSpace.page * 4) / rowCount); //
  }

  ShareIcon shareIcon(String id) {
    if (ShareIdSet.containsKey(id)) {
      return ShareIdSet[id] ?? ShareIcon(name: "--", typeName: "未知类型");
    }

    return relationCtrl.user?.findShareById(id) ??
        ShareIcon(name: "--", typeName: "未知类型");
  }
}
