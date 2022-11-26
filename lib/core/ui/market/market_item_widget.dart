import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:orginone/api_resp/market_entity.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/choose_item.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/component/text_tag.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/util/string_util.dart';

class MarketItemWidget extends StatelessWidget {
  final MarketEntity marketEntity;
  final bool isSoft;
  final bool isUserSpace;
  final String userId;
  final String spaceId;
  final String belongName;
  final Function deleteCallback;
  final Function transferCallback;

  const MarketItemWidget({
    required this.marketEntity,
    required this.isSoft,
    required this.isUserSpace,
    required this.userId,
    required this.spaceId,
    required this.belongName,
    required this.deleteCallback,
    required this.transferCallback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _item(marketEntity);
  }

  Widget _item(MarketEntity market) {
    List<Widget> list = [];
    if (!isSoft) {
      if (market.public ?? false) {
        var tag = TextTag(
          "私有",
          padding: EdgeInsets.only(
            top: 6.w,
            bottom: 6.w,
            left: 10.w,
            right: 10.w,
          ),
        );
        list.add(tag);
        list.add(Padding(padding: EdgeInsets.only(bottom: 10.h)));
      }
      String name;
      if (isUserSpace) {
        name = userId == market.belongId ? "创建的" : "加入的";
      } else {
        name = spaceId == market.belongId ? "创建的" : "加入的";
      }
      var tag = TextTag(
        name,
        padding: EdgeInsets.only(
          top: 6.w,
          bottom: 6.w,
          left: 10.w,
          right: 10.w,
        ),
      );
      list.add(tag);
      list.add(Padding(padding: EdgeInsets.only(bottom: 10.h)));
    }
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) async {
              deleteCallback(market);
            },
            backgroundColor: UnifiedColors.backColor,
            icon: Icons.delete,
            label: '刪除',
          ),
        ],
      ),
      child: ChooseItem(
        bgColor: Colors.white,
        padding: EdgeInsets.all(20.w),
        header: TextAvatar(
          avatarName: StringUtil.getPrefixChars(market.name, count: 1),
          width: 64.w,
          radius: 20.w,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(market.name, style: AFont.instance.size16Black0W500),
                Padding(padding: EdgeInsets.only(left: 10.w)),
                Text("归属:$belongName", style: AFont.instance.size14Black6),
                Padding(padding: EdgeInsets.only(left: 10.w)),
                Text("编码:${market.code}", style: AFont.instance.size14Black6),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.h)),
            Text(
              market.remark,
              overflow: TextOverflow.ellipsis,
              style: AFont.instance.size12Black9,
              maxLines: 3,
            ),
          ],
        ),
        operate: Wrap(
          children: [
            Padding(padding: EdgeInsets.only(left: 10.w)),
            Column(children: list)
          ],
        ),
        func: () {
          transferCallback(market);
        },
      ),
    );
  }
}
