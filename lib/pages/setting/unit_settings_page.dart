import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logging/logging.dart';
import 'package:orginone/config/enum.dart';
import 'package:orginone/widget/template/base_view.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/event_bus.dart';

// 设置-单位设置
@immutable
class UintSettingsPage extends BaseView<UintSettingsController> {
  final Logger log = Logger("UintSettingsPage");

  LinkedHashMap map = LinkedHashMap();

  @override
  bool isUseScaffold() {
    return false;
  }

  @override
  LoadStatusX initStatus() {
    return LoadStatusX.success;
  }

  UintSettingsPage({Key? key}) : super(key: key) {
    map["单位设置11"] = [
      {
        "id": 0,
        "icon":
            "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.soutu123.com%2Felement_origin_min_pic%2F16%2F07%2F16%2F165789f1f5c750d.jpg%21%2Ffw%2F700%2Fquality%2F90%2Funsharp%2Ftrue%2Fcompress%2Ftrue&refer=http%3A%2F%2Fpic.soutu123.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1670660931&t=bd4182732ed268476fd12a0896003457",
        "cardName": "单位设置",
        "func": () {
          Get.toNamed(Routers.uintSettings);
        },
      },
      {
        "id": 1,
        "icon":
            "https://ss1.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/cf1b9d16fdfaaf51479c68b18c5494eef01f7a45.jpg",
        "cardName": "部门设置"
      },
      {
        "id": 2,
        "icon":
            "https://gimg2.baidu.com/image_search/src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171124%2F0189597375cf4bb7871d8a650ba7d4f6.png&refer=http%3A%2F%2F5b0988e595225.cdn.sohucs.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1670660931&t=5211110a607caf9ca51314307d0e4aca",
        "cardName": "集团设置"
      },
      {
        "id": 3,
        "icon":
            "https://img2.baidu.com/it/u=1920852871,2551387919&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=497",
        "cardName": "岗位设置"
      },
      {
        "id": 4,
        "icon":
            "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fbpic.51yuansu.com%2Fpic3%2Fcover%2F01%2F36%2F48%2F5926588abdc95_610.jpg&refer=http%3A%2F%2Fbpic.51yuansu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1670660931&t=ae5a7e5be37c1116d2bc91b7bf44ad60",
        "cardName": "帮助中心"
      },
    ];
    map["配置中心"] = [
      {"id": 0, "icon": "icon", "cardName": "单位设置"},
      {"id": 1, "icon": "icon", "cardName": "数据设置"},
      {"id": 2, "icon": "icon", "cardName": "应用设置"},
      {"id": 4, "icon": "icon", "cardName": "流程设置"},
      {"id": 5, "icon": "icon", "cardName": "标准设置"},
      {"id": 6, "icon": "icon", "cardName": "权限设置"},
      {"id": 6, "icon": "icon", "cardName": "权限设置"},
      {
        "id": 7,
        "icon": "icon",
        "cardName": "更新版本",
        "func": () {
          // Get.toNamed(Routers.version);
        }
      },
      {"id": 8, "icon": "icon", "cardName": "标准设置11"},
      {"id": 9, "icon": "icon", "cardName": "权限设置22"},
    ];
  }

  @override
  Widget builder(BuildContext context) {
    return Container(
      color: XColors.bgColor,
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: Container(),
    );
  }

  // @override
  // Widget builder(BuildContext context) {
  //   return Container(
  //     color: XColors.bgColor,
  //     padding: EdgeInsets.only(left: 12.w, right: 12.w),
  //     child: ListView(
  //       shrinkWrap: true,
  //       children: _getItems()
  //         ..add(Container(
  //           margin: EdgeInsets.only(left: 20.w, bottom: 10.h, right: 20.w),
  //           child: GFButton(
  //             onPressed: () async {
  //               Get.offAllNamed(Routers.main);
  //               XEventBus.instance.fire(SignOut());
  //             },
  //             color: Colors.redAccent,
  //             text: "注销",
  //             blockButton: true,
  //           ),
  //         )),
  //     ),
  //   );
  // }

  List<Widget> _getItems() {
    List<Widget> children = [];
    debugPrint("--->size:${map.length}");
    map.forEach((key, value) {
      children.add(CardChildWidget(key, value));
    });
    return children;
  }
}

class CardChildWidget extends StatelessWidget {
  String itemName;

  List value;

  CardChildWidget(this.itemName, this.value);

  @override
  Widget build(BuildContext context) {
    debugPrint("--->key:item$itemName | value :${value}");
    print("22222222222221111111");
    print("--->2222key:item$itemName | value :${value}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          itemName,
          style: XFonts.size24Black3W700,
        ),
        SizedBox(
          height: 12.h,
        ),
        Container(
          decoration: BoxDecoration(
              color: XColors.white, borderRadius: BorderRadius.circular(10)),
          child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
              shrinkWrap: true,
              itemCount: value.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    var func = value[index]["func"];
                    if (func != null) {
                      func();
                    }
                  },
                  child: Column(
                    children: [
                      // AImage.netImageRadius(AIcons.back_black,
                      //     size: Size(64.w, 64.w)),
                      Container(
                          width: 64.w,
                          height: 64.w,
                          color: XColors.navigatorBgColor),
                      // AImage.netImage(AIcons.placeholder,
                      //     url: value[index]['icon'], size: Size()),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        value[index]['cardName'],
                        style: XFonts.size18Black6,
                      ),
                    ],
                  ),
                );
              }),
        ),
        SizedBox(
          height: 24.h,
        ),
      ],
    );
  }
}

class UintSettingsController extends BaseController {}

class UintSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UintSettingsController());
  }
}
