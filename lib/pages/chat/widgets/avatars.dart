import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/widget/widgets/team_avatar.dart';

double avatarWidth = 76.w;

class Avatars extends StatelessWidget {
  final List<XTarget> persons;
  final int? showCount;
  final EdgeInsets? padding;
  final bool hasAdd;
  final Function? addCallback;

  const Avatars({
    required this.persons,
    this.showCount,
    this.padding,
    this.hasAdd = false,
    this.addCallback,
    Key? key,
  }) : super(key: key);

  SettingController get controller => Get.find();

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
  Widget _avatarItem(XTarget person) {
    var name = person.name;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TeamAvatar(info: TeamTypeInfo(userId: person.id)),
        Padding(padding: EdgeInsets.only(top: 10.w)),
        Text(
          name,
          style: XFonts.size18Black6,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}
