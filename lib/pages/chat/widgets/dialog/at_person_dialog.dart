import 'package:azlistview/azlistview.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/config/color.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/widget/buttons.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/widget/widgets/team_avatar.dart';

class AtPersonDialog {
  static Future<List<XTarget>?> showDialog(
      BuildContext context, ISession chat) {
    // FocusScope.of(context).requestFocus(FocusNode());
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    // FocusManager.instance.primaryFocus?.unfocus();
    return showModalBottomSheet<List<XTarget>>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8),
            child: AtContactListPage(
              persons: chat.members,
            ),
          );
        }).then((value) {
      return value;
    });
  }
}

class PersonInfo extends ISuspensionBean {
  late XTarget person;
  String tagIndex = '';
  String namePinyin = '';
  bool selected;

  PersonInfo(this.person, {this.selected = false});

  @override
  String getSuspensionTag() {
    return tagIndex;
  }
}

class AtContactListPage extends StatefulWidget {
  const AtContactListPage({Key? key, required this.persons}) : super(key: key);
  final List<XTarget> persons;
  @override
  State<AtContactListPage> createState() => _AtContactListPageState();
}

class _AtContactListPageState extends State<AtContactListPage> {
  late List<PersonInfo> personInfo;
  List<XTarget> get persons => widget.persons;
  bool mutilSelected = false;
  List<PersonInfo> selectArr = [];
  List<XTarget> selectPsersonArr = [];
  @override
  void initState() {
    super.initState();

    personInfo =
        List.generate(persons.length, (index) => PersonInfo(persons[index]));
    initList(personInfo);
  }

  initList(List<PersonInfo> list) {
    if (list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyin(list[i].person.name!);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    SuspensionUtil.sortListBySuspensionTag(personInfo);
    SuspensionUtil.setShowSuspensionStatus(personInfo);
  }

  search(String key) {
    personInfo.clear();
    List res = matchContacts(key);
    personInfo = res.map((person) => PersonInfo(person)).toList();
    initList(personInfo);
    setState(() {});
  }

  ///通讯录关键词匹配
  ///支持拼音首字母匹配，全部拼音匹配，部分拼音匹配，全部中文匹配，部分中文匹配，不支持跨文字或拼音匹配
  ///例如zs能搜索到张三，zhangsan也能搜索到张三，zhang也能搜索到张三，张三也能搜索到张三，张也能搜索到张三
  List<XTarget> matchContacts(String query) {
    List<XTarget> matchResults = [];

    for (XTarget contact in persons) {
      if (contact.name!.contains(query) ||
          isPinyinMatch(contact.name!, query) ||
          isChineseMatch(contact.name!, query) ||
          isPartialPinyinMatch(contact.name!, query) ||
          isPartialChineseMatch(contact.name!, query)) {
        matchResults.add(contact);
      }
    }

    return matchResults;
  }

  ///全部拼音匹配
  bool isPinyinMatch(String name, String query) {
    String pinyin = PinyinHelper.getPinyin(name,
        separator: '', format: PinyinFormat.WITHOUT_TONE);
    return pinyin.toLowerCase().contains(query.toLowerCase());
  }

  ///全部中文匹配
  bool isChineseMatch(String name, String query) {
    return name.contains(query);
  }

  ///部分拼音匹配
  bool isPartialPinyinMatch(String name, String query) {
    String pinyin = PinyinHelper.getPinyin(name,
        separator: ' ', format: PinyinFormat.WITHOUT_TONE);
    List<String> pinyinList = pinyin.split(' ');
    for (String pinyinPart in pinyinList) {
      if (pinyinPart.toLowerCase().contains(query.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  ///部分中文匹配
  bool isPartialChineseMatch(String name, String query) {
    List<String> chineseCharacters = [];
    for (int i = 0; i < name.length; i++) {
      String character = name[i];
      if (character.runes.any((rune) => rune >= 0x4e00 && rune <= 0x9fff)) {
        chineseCharacters.add(character);
      }
    }
    String joinedCharacters = chineseCharacters.join('');
    return joinedCharacters.toLowerCase().contains(query.toLowerCase());
  }

  ///选择艾特的人
  void selectPersion(PersonInfo person, int index) {
    //单选
    if (!mutilSelected) {
      var item = persons[index];
      back([item]);
      return;
    }
//多选
    person.selected = !person.selected;
    setState(() {});
    if (person.selected) {
      //选中 添加到选中数组
      selectArr.add(person);

      selectPsersonArr.add(person.person);
    } else {
      ///取消选中 从数组中移除
      selectArr.remove(person);
      selectPsersonArr.remove(person.person);
    }
    LogUtil.d(selectArr);
  }

  back(List<XTarget> target) {
    Navigator.pop(context, target);
  }

  @override
  Widget build(BuildContext context) {
    return GyScaffold(
      backgroundColor: Colors.white,
      leading: _buildLeadingWidget(),
      actions: [_buildSelectWidget(title: mutilSelected ? '取消多选' : '多选')],
      titleName: "选择要提醒的人",
      body: _buildMainView(),
    );
  }

  Widget _buildSelectWidget({required String title}) {
    return TextButton(
      onPressed: () => setState(() {
        mutilSelected = !mutilSelected;
      }),
      child: Text(
        title,
        style: const TextStyle(color: GYColors.black_666),
      ),
    );
  }

  ///leading
  Widget _buildLeadingWidget() {
    return IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: GYColors.black_666,
        ));
  }

  ///主界面构建
  Widget _buildMainView() {
    return Column(
      children: [
        CommonWidget.commonSearchBarWidget(
            hint: "搜索",
            searchColor: const Color(0xFFF3F4F5),
            onChanged: search),
        AzListView(
          data: personInfo,
          itemCount: personInfo.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildListItem(personInfo[index], index);
          },
          susItemBuilder: (context, index) {
            return _buildSectionHeaderWidget(
                personInfo[index].getSuspensionTag());
          },
        ).expanded(),
        _buildBottomBar()
      ],
    );
  }

  ///底部bar
  Widget _buildBottomBar() {
    return mutilSelected
        ? <Widget>[
            <Widget>[
              Text('已选择(${selectArr.length}):').paddingLeft(10),
              ListView.builder(
                itemCount: selectArr.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  PersonInfo personInfo = selectArr[index];
                  return Container(
                    padding: const EdgeInsets.all(2),
                    child: TeamAvatar(
                      info: TeamTypeInfo(userId: personInfo.person.id),
                      // circular: true,
                    ),
                  ).constrained(width: 30, height: 30);
                },
              ).paddingVertical(8).paddingHorizontal(5).expanded(),
            ].toRow().expanded(),
            outlinedButton("确认",
                    onPressed: () => back(selectPsersonArr),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(XColors.blueTextColor),
                      side: MaterialStateProperty.all(BorderSide.none),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.w))),
                    ),
                    textStyle: TextStyle(fontSize: 18.sp, color: Colors.white),
                    height: 44.h)
                .paddingRight(10),
          ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .height(66.h)
            .border(top: 1, color: GYColors.lightGray)
        : const SizedBox();
  }

  //cell
  Widget _buildListItem(PersonInfo person, int index) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
      )),
      child: ListTile(
        leading: Row(
          children: [
            mutilSelected
                ? Transform.scale(
                    scale: 1.1,
                    child: Checkbox(
                        value: person.selected,
                        onChanged: (check) => selectPersion(person, index),
                        shape: const CircleBorder(),
                        visualDensity: const VisualDensity(
                            horizontal: 0, vertical: 0) //这里就是实现圆形的设置
                        ),
                  )
                : const SizedBox(),
            TeamAvatar(
              info: TeamTypeInfo(userId: person.person.id),
              size: 55.w,
            ),
          ],
        ).unconstrained(),
        title: Text(person.person.name!),
        subtitle: Text(
          person.person.remark ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ).onTap(() => selectPersion(person, index));
  }

  ///分区头
  Widget _buildSectionHeaderWidget(String susTag) {
    return Container(
      height: 45.h,
      width: Get.width,
      padding: EdgeInsets.only(left: 24.w),
      color: const Color(0xFFF3F4F5),
      alignment: Alignment.centerLeft,
      child: Text(
        susTag,
        softWrap: false,
        style: TextStyle(
          fontSize: 16.sp,
          color: const Color(0xFF666666),
        ),
      ),
    );
  }
}
