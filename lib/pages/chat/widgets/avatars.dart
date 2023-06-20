import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/widget/widgets/team_avatar.dart';

double avatarWidth = 76.w;

class Avatars extends StatefulWidget {
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

  @override
  State<Avatars> createState() => _AvatarsState();
}

class _AvatarsState extends State<Avatars> {
  late List<XTarget> persons;
  int? showCount;
  EdgeInsets? padding;
  late bool hasAdd;
  Function? addCallback;

  late bool showMore;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    persons = widget.persons;
    showCount = widget.showCount;
    padding = widget.padding;
    hasAdd = widget.hasAdd;
    addCallback = widget.addCallback;
    showMore = showCount != null && persons.length > showCount!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
         border: Border(bottom: BorderSide(color: Colors.grey.shade300,width: 0.5)),
      ),
      child: Column(
        children: [
          _avatarGroup,
          _showMore,
        ],
      ),
    );
  }

  /// 头像组
  get _avatarGroup {
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


  get _showMore{
    if(!showMore){
      return const SizedBox();
    }
    return GestureDetector(
      onTap: (){
        Get.toNamed(Routers.personListPage,arguments: {'persons':persons});
      },
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 10.h),
        child: Text('查看全部群成员(${persons.length})>',style: TextStyle(color: Colors.grey.shade500,),),
      ),
    );
  }

  /// 头像子项
  Widget _avatarItem(XTarget person) {
    var name = person.name!;
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
