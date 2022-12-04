import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphic/graphic.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/config/field_config.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/controller/target/target_controller.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/page/home/center/center_controller.dart';

import '../../../component/unified_colors.dart';
import '../../../component/unified_text_style.dart';
import '../../../routers.dart';

enum Functions {
  addFriends("加好友", Routers.friendAdd),
  createUnits("创单位", Routers.unitCreate),
  inviteMembers("邀成员", Routers.unitCreate),
  createApplication("建应用", Routers.unitCreate),
  scanShop("逛商店", Routers.unitCreate);

  final String funcName;
  final String router;

  const Functions(this.funcName, this.router);
}

const adjustData = [
  {"type": "Email", "index": 0, "value": 120},
  {"type": "Email", "index": 1, "value": 132},
  {"type": "Email", "index": 2, "value": 101},
  {"type": "Email", "index": 3, "value": 134},
  {"type": "Email", "index": 4, "value": 90},
  {"type": "Email", "index": 5, "value": 230},
  {"type": "Email", "index": 6, "value": 210},
  {"type": "Affiliate", "index": 0, "value": 220},
  {"type": "Affiliate", "index": 1, "value": 182},
  {"type": "Affiliate", "index": 2, "value": 191},
  {"type": "Affiliate", "index": 3, "value": 234},
  {"type": "Affiliate", "index": 4, "value": 290},
  {"type": "Affiliate", "index": 5, "value": 330},
  {"type": "Affiliate", "index": 6, "value": 310},
  {"type": "Video", "index": 0, "value": 150},
  {"type": "Video", "index": 1, "value": 232},
  {"type": "Video", "index": 2, "value": 201},
  {"type": "Video", "index": 3, "value": 154},
  {"type": "Video", "index": 4, "value": 190},
  {"type": "Video", "index": 5, "value": 330},
  {"type": "Video", "index": 6, "value": 410},
  {"type": "Direct", "index": 0, "value": 320},
  {"type": "Direct", "index": 1, "value": 332},
  {"type": "Direct", "index": 2, "value": 301},
  {"type": "Direct", "index": 3, "value": 334},
  {"type": "Direct", "index": 4, "value": 390},
  {"type": "Direct", "index": 5, "value": 330},
  {"type": "Direct", "index": 6, "value": 320},
  {"type": "Search", "index": 0, "value": 320},
  {"type": "Search", "index": 1, "value": 432},
  {"type": "Search", "index": 2, "value": 401},
  {"type": "Search", "index": 3, "value": 434},
  {"type": "Search", "index": 4, "value": 390},
  {"type": "Search", "index": 5, "value": 430},
  {"type": "Search", "index": 6, "value": 420},
];

const roseData = [
  {'value': 20, 'name': 'rose 1'},
  {'value': 10, 'name': 'rose 2'},
  {'value': 24, 'name': 'rose 3'},
  {'value': 12, 'name': 'rose 4'},
  {'value': 20, 'name': 'rose 5'},
  {'value': 15, 'name': 'rose 6'},
  {'value': 22, 'name': 'rose 7'},
  {'value': 29, 'name': 'rose 8'},
];

class CenterPage extends GetView<CenterController> {
  const CenterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: UnifiedColors.designLightBlue,
      child: ListView(
        children: [
          Column(
            children: [
              _swiper,
              Container(margin: EdgeInsets.only(top: 16.h)),
              Container(
                margin: EdgeInsets.only(left: 25.w, right: 25.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("快捷入口", style: AFont.instance.size22Black3W500),
                    Padding(padding: EdgeInsets.only(top: 16.h)),
                    SizedBox(
                      height: 100.w,
                      child: ListView.builder(
                        itemCount: Functions.values.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Row(children: [
                            _fastEntry(Functions.values[index]),
                            Padding(padding: EdgeInsets.only(right: 8.w))
                          ]);
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 16.h)),
                    Text("常用应用", style: AFont.instance.size22Black3W500),
                    Padding(padding: EdgeInsets.only(top: 16.h)),
                    GridView.count(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 5,
                      childAspectRatio: 80 / 100,
                      children: [
                        _applicationEntry("资产应用"),
                        _applicationEntry("资产应用"),
                        _applicationEntry("资产应用"),
                        _applicationEntry("资产应用"),
                        _applicationEntry("资产应用"),
                        _applicationEntry("资产应用"),
                        _applicationEntry("资产应用"),
                        _applicationEntry("资产应用"),
                        _applicationEntry("资产应用"),
                        _applicationEntry("更多", iconData: Icons.add)
                      ],
                    ),
                    Container(height: 8.h),
                    Text("数据监测", style: AFont.instance.size22Black3W500),
                    GridView.count(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 2,
                      children: [_charts(), _roseCharts()],
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // 轮播图
  get _swiper => SizedBox(
        height: 176.h,
        child: Swiper(
          autoplay: true,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return const Image(
              image: AssetImage("assets/home_bg.png"),
              fit: BoxFit.cover,
            );
          },
        ),
      );

  // 快速入口
  Widget _fastEntry(Functions func) {
    return GestureDetector(
      onTap: () async {
        switch (func) {
          case Functions.createUnits:
            Get.toNamed(
              Routers.maintain,
              arguments: CreateCompany((value) {
                if (Get.isRegistered<TargetController>()) {
                  var targetCtrl = Get.find<TargetController>();
                  targetCtrl.createCompany(value).then((value) => Get.back());
                }
              }),
            );
            break;
          case Functions.addFriends:
            Get.toNamed(Routers.friendAdd);
            break;
          default:
            break;
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: 100.w,
        height: 100.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
        ),
        child: Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: UnifiedColors.designBlue,
              size: 30.w,
            ),
            Text(
              func.funcName,
              style: TextStyle(
                color: UnifiedColors.designBlue,
                fontSize: 14.sp,
              ),
            )
          ],
        ),
      ),
    );
  }

  // 应用入口
  Widget _applicationEntry(String keyWord, {IconData? iconData}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40.w)),
            color: Colors.white,
          ),
          child: iconData != null
              ? Icon(iconData, color: Colors.grey)
              : const Icon(Icons.transform, color: Colors.black),
        ),
        Container(
          margin: EdgeInsets.only(top: 6.5.w),
          child: Text(keyWord, style: text12GreyBold),
        ),
      ],
    );
  }

  /// 图标
  Widget _charts() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 144.w,
      height: 120.w,
      child: Chart(
        data: adjustData,
        variables: {
          'index': Variable(
            accessor: (Map map) => map['index'].toString(),
          ),
          'type': Variable(
            accessor: (Map map) => map['type'] as String,
          ),
          'value': Variable(
            accessor: (Map map) => map['value'] as num,
            scale: LinearScale(min: 0, max: 1800),
          ),
        },
        elements: [
          IntervalElement(
            position: Varset('index') * Varset('value') / Varset('type'),
            color: ColorAttr(variable: 'type', values: Defaults.colors10),
            modifiers: [StackModifier()],
          )
        ],
        coord: PolarCoord(),
        axes: [
          Defaults.circularAxis,
          Defaults.radialAxis..label = null,
        ],
        selections: {
          'tap': PointSelection(
            variable: 'index',
          )
        },
        tooltip: TooltipGuide(
          multiTuples: true,
          anchor: (_) => Offset.zero,
          align: Alignment.bottomRight,
        ),
      ),
    );
  }

  /// charts
  Widget _roseCharts() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 350,
      height: 300,
      child: Chart(
        data: roseData,
        variables: {
          'name': Variable(
            accessor: (Map map) => map['name'] as String,
          ),
          'value': Variable(
            accessor: (Map map) => map['value'] as num,
            scale: LinearScale(min: 0, marginMax: 0.1),
          ),
        },
        elements: [
          IntervalElement(
            label:
                LabelAttr(encoder: (tuple) => Label(tuple['name'].toString())),
            shape: ShapeAttr(
                value: RectShape(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            )),
            color: ColorAttr(variable: 'name', values: Defaults.colors10),
            elevation: ElevationAttr(value: 5),
          )
        ],
        coord: PolarCoord(startRadius: 0.15),
      ),
    );
  }
}
