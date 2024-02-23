import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/dart/base/schema.dart';

class PersonInfo extends ISuspensionBean {
  late XTarget person;
  String tagIndex = '';
  String namePinyin = '';

  PersonInfo(this.person);

  @override
  String getSuspensionTag() {
    return tagIndex;
  }
}

class PersonListPage extends StatefulWidget {
  const PersonListPage({Key? key}) : super(key: key);

  @override
  State<PersonListPage> createState() => _PersonListPageState();
}

class _PersonListPageState extends State<PersonListPage> {
  late List<PersonInfo> personInfo;

  late List<XTarget> persons;

  @override
  void initState() {
    //
    super.initState();
    persons = Get.arguments['persons'];
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
    for (var person in persons) {
      if (person.name!.contains(key)) {
        personInfo.add(PersonInfo(person));
      }
    }
    initList(personInfo);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GyScaffold(
      backgroundColor: Colors.white,
      titleName: "群成员",
      body: Column(
        children: [
          CommonWidget.commonSearchBarWidget(
              hint: "搜索",
              searchColor: const Color(0xFFF3F4F5),
              onChanged: search),
          Expanded(
            child: AzListView(
              data: personInfo,
              itemCount: personInfo.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildListItem(personInfo[index]);
              },
              susItemBuilder: (context, index) {
                return _buildSusWidget(personInfo[index].getSuspensionTag());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(PersonInfo person) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
      )),
      child: ListTile(
        leading: TeamAvatar(
          info: TeamTypeInfo(userId: person.person.id),
          size: 55.w,
        ),
        title: Text(person.person.name!),
        subtitle: Text(
          person.person.remark ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildSusWidget(String susTag) {
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
