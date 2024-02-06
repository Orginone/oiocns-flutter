import 'package:flutter/material.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/widgets/common/text/text_tag.dart';
import 'package:orginone/components/widgets/list_item_widget/index.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/utils/load_image.dart';
import 'package:badges/badges.dart' as badges;

class ListWidget<T> extends StatefulWidget {
  List<T>? initDatas;
  // 列表数据
  List<T> Function([T? data]) getDatas;

  // 获得标题
  Widget Function(T data)? getTitle;

  // 获得标签
  List<String>? Function(T data)? getLabels;

  // 获得描述
  Widget? Function(T data)? getDesc;

  // 获得头像
  Widget? Function(T data)? getAvatar;

  // 获得角标
  int? Function(T data)? getBadge;

  // 获得内容菜单
  Widget? Function(T data)? getAction;

  // 点击事件
  void Function(T data, List<T> children)? onTap;

  ListWidget(
      {super.key,
      required this.getDatas,
      this.getTitle,
      this.initDatas,
      this.getLabels,
      this.getDesc,
      this.getAvatar,
      this.getAction,
      this.getBadge,
      this.onTap}) {
    this.getTitle ??= (dynamic data) =>
        Text(data is IEntity || data is XEntity ? data.name : "");
    this.getDesc ??= (dynamic data) =>
        Text(data is IEntity || data is XEntity ? data.remark : "");
    this.getAvatar ??= (dynamic data) {
      print(
          '>>>>>>======${data.runtimeType} ${data is XEntity} ${data is IEntity} ${data.runtimeType is XEntity} ${TargetType.getType(data.typeName)?.icon}');
      return XImage.entityIcon(data, width: 40);
      //     null != TargetType.getType(data.typeName)
      // ? XImage.localImage(TargetType.getType(data.typeName)!.icon,
      //     size: const Size(35, 35), color: XColors.selectedColor)
      // :
      // data is IEntity
      // ? TeamAvatar(size: 35, info: TeamTypeInfo(share: data.share))
      // :
    };
    this.getLabels ??=
        (dynamic data) => data is IEntity ? data.groupTags : null;
  }

  @override
  _ListWidgetState createState() => _ListWidgetState<T>();
}

class _ListWidgetState<T> extends State<ListWidget> {
  late dynamic datas;

  _ListWidgetState();

  @override
  void initState() {
    super.initState();
    datas = widget.initDatas ?? [];
  }

  @override
  void didUpdateWidget(ListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (datas.hashCode != widget.initDatas.hashCode) {
      datas = widget.initDatas ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (datas.isEmpty) {
      datas = widget.getDatas();
    }
    return Container(
      color: Colors.white,
      child: ListView.separated(
          itemCount: datas.length,
          padding: const EdgeInsets.only(top: 5),
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemBuilder: (BuildContext context, int index) {
            T item = datas[index];
            return ListItemWidget(
                leading: _buildAvatar(item),
                title: _buildTitle(item),
                subtitle: getSubtitle(item),
                trailing: widget.getAction?.call(item),
                onTap: () {
                  widget.onTap?.call(item, widget.getDatas(item));
                });
          }),
    );
  }

  Widget? _buildTitle(item) {
    List<String>? labels = widget.getLabels?.call(item);
    List<Widget> labelList = getLableWidget(item, labels);
    Widget? titleWidget = widget.getTitle?.call(item);
    if (null != titleWidget) {
      titleWidget = Row(mainAxisSize: MainAxisSize.max, children: [
        Flexible(
          flex: _getTitleFlex(item, labels),
          child: DefaultTextStyle(
              style: TextStyle(
                color: XColors.black,
                // fontWeight: FontWeight.w500,
                fontSize: 24.sp,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
              child: titleWidget),
        ),
        if (item is! IDirectory && labelList.isNotEmpty)
          Expanded(
              child: SafeArea(
                  child: Row(
            children: [labelList.last],
          ))),
      ]);
    }
    return titleWidget;
  }

  Widget? _buildAvatar(T item) {
    Widget? child = widget.getAvatar?.call(item);
    int noRead = widget.getBadge?.call(item) ?? 0;
    if (noRead > 0) {
      child = badges.Badge(
        ignorePointer: false,
        position: badges.BadgePosition.topEnd(top: -6, end: -8),
        badgeContent: Text(
          '$noRead',
          // "${noRead > 99 ? "99+" : noRead}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            letterSpacing: 1,
            wordSpacing: 2,
            height: 1,
          ),
        ),
        child: child,
      );
    }

    return child;
  }

  Widget? getSubtitle(dynamic item) {
    final ListTileThemeData tileTheme = ListTileTheme.of(context);
    Widget? descWdget = widget.getDesc?.call(item);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (labelWidgetList.isNotEmpty)
        //   Row(
        //     children: labelWidgetList,
        //   ),
        if (null != descWdget)
          DefaultTextStyle(
              style: tileTheme.subtitleTextStyle ??
                  const TextStyle(
                    color: XColors.chatHintColors,
                    fontWeight: FontWeight.w500,
                    // fontSize: 20.sp,
                    overflow: TextOverflow.ellipsis,
                  ),
              maxLines: 1,
              child: descWdget)
      ],
    );
  }

  List<Widget> getLableWidget(dynamic item, List<String>? labels) {
    List<Widget> labelWidgets = [];

    labels?.forEach((label) {
      if (label.isNotEmpty) {
        bool isTop = label == "置顶";

        Widget labelWidget;

        var style = TextStyle(
          color: isTop ? XColors.fontErrorColor : XColors.designBlue,
          fontSize: 14.sp,
        );
        // if (adapter.isUserLabel) {
        // labelWidget = Container(
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: const BorderRadius.all(Radius.circular(10)),
        //     border: Border.all(color: XColors.tinyBlue),
        //   ),
        //   padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        //   child: TargetText(userId: label, style: style),
        // );
        // } else {
        labelWidget = Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: TextTag(
            label,
            bgColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
            textStyle: style,
            borderColor: isTop ? XColors.fontErrorColor : XColors.tinyBlue,
          ),
        );
        // }
        labelWidgets.add(labelWidget);
      }
    });
    return labelWidgets;
  }

  int _getTitleFlex(dynamic item, List<String>? labels) {
    int flex = 1;
    if (item is IEntity &&
        item.name.isNotEmpty &&
        null != labels &&
        labels.isNotEmpty) {
      if (item.name.length > labels.last.length && labels.last.length < 4) {
        flex = 5;
      }
    }
    return flex;
  }
}
