import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/text_avatar.dart';
import 'package:orginone/util/string_util.dart';

double avatarWidth = 76.w;

class AvatarGroup extends StatelessWidget {
  final List<Target> persons;
  final int? showCount;
  final EdgeInsets? padding;
  final bool hasAdd;
  final Function? addCallback;

  const AvatarGroup({
    required this.persons,
    this.showCount,
    this.padding,
    this.hasAdd = false,
    this.addCallback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _avatarGroup;
  }

  /// 头像组
  get _avatarGroup {
    return Obx(() {
      var mappedPerson = persons.map((item) {
        return _avatarItem(item);
      }).toList();
      if (showCount != null && mappedPerson.length > showCount!) {
        mappedPerson = mappedPerson.sublist(0, showCount!);
      }
      if (hasAdd) {
        mappedPerson.add(_addItem);
      }
      return GridView.count(
        padding: padding,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        childAspectRatio: 60 / 80,
        children: mappedPerson,
      );
    });
  }

  /// 添加好友
  get _addItem {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (addCallback != null) {
              addCallback!();
            }
          },
          child: Container(
            width: avatarWidth,
            height: avatarWidth,
            color: Colors.white,
            child: const Icon(Icons.add),
          ),
        )
      ],
    );
  }

  /// 头像子项
  Widget _avatarItem(Target person) {
    var name = person.team?.name ?? "";
    var prefix = StringUtil.getPrefixChars(name, count: 2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextAvatar(avatarName: prefix, width: avatarWidth),
        Padding(padding: EdgeInsets.only(top: 10.w)),
        Text(
          name,
          style: AFont.instance.size18Black6,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}
