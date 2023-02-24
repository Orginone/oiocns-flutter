// import 'dart:collection';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_swiper/flutter_swiper.dart';
// import 'package:get/get.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:logging/logging.dart';
// import 'package:orginone/components/template/base_view.dart';
// import 'package:orginone/components/unified.dart';
// import 'package:orginone/config/enum.dart';
// import 'package:orginone/util/event_bus.dart';

// // 首页
// // TODO 先完成界面设计，再完成功能，界面兼容性，最后整理代码
// @immutable
// class IndexPage extends BaseView<IndexController> {
//   final Logger log = Logger("UintSettingsPage");

//   LinkedHashMap map = LinkedHashMap();
//   @override
//   bool isUseScaffold() {
//     return false;
//   }

//   @override
//   LoadStatusX initStatus() {
//     return LoadStatusX.success;
//   }

//   IndexPage({Key? key}) : super(key: key) {
//     print("IndexPage 1111");
//     map["快捷入口"] = [
//       {
//         "id": 0,
//         "icon":
//             "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.soutu123.com%2Felement_origin_min_pic%2F16%2F07%2F16%2F165789f1f5c750d.jpg%21%2Ffw%2F700%2Fquality%2F90%2Funsharp%2Ftrue%2Fcompress%2Ftrue&refer=http%3A%2F%2Fpic.soutu123.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1670660931&t=bd4182732ed268476fd12a0896003457",
//         "cardName": "单位设置",
//         "func": () {
//           // Get.toNamed(Routers.uintSettings);
//         },
//       },
//       {
//         "id": 1,
//         "icon":
//             "https://ss1.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/cf1b9d16fdfaaf51479c68b18c5494eef01f7a45.jpg",
//         "cardName": "部门设置"
//       },
//       {
//         "id": 2,
//         "icon":
//             "https://gimg2.baidu.com/image_search/src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171124%2F0189597375cf4bb7871d8a650ba7d4f6.png&refer=http%3A%2F%2F5b0988e595225.cdn.sohucs.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1670660931&t=5211110a607caf9ca51314307d0e4aca",
//         "cardName": "集团设置"
//       },
//       {
//         "id": 3,
//         "icon":
//             "https://img2.baidu.com/it/u=1920852871,2551387919&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=497",
//         "cardName": "岗位设置"
//       },
//       {
//         "id": 4,
//         "icon":
//             "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fbpic.51yuansu.com%2Fpic3%2Fcover%2F01%2F36%2F48%2F5926588abdc95_610.jpg&refer=http%3A%2F%2Fbpic.51yuansu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1670660931&t=ae5a7e5be37c1116d2bc91b7bf44ad60",
//         "cardName": "帮助中心"
//       },
//     ];
//     map["常用应用"] = [
//       {"id": 0, "icon": "icon", "cardName": "加好友"},
//       {"id": 1, "icon": "icon", "cardName": "创单位"},
//       {"id": 2, "icon": "icon", "cardName": "邀成员"},
//       {"id": 4, "icon": "icon", "cardName": "流程设置"},
//       {"id": 5, "icon": "icon", "cardName": "标准设置"},
//       {"id": 6, "icon": "icon", "cardName": "权限设置"},
//       {"id": 6, "icon": "icon", "cardName": "权限设置"},
//       {
//         "id": 7,
//         "icon": "icon",
//         "cardName": "更新版本",
//         "func": () {
//           // Get.toNamed(Routers.version);
//         }
//       },
//       {"id": 8, "icon": "icon", "cardName": "标准设置11"},
//       {"id": 9, "icon": "icon", "cardName": "权限设置22"},
//     ];

//     // 轮播图片
//     List<String> imageList = [
//       "images/bg_center1.png",
//       "images/bg_center2.png",
//       "images/bg_center1.png",
//       "images/bg_center2.png",
//     ];

// // -----------------------
// // -----------------------
//   }
//   @override
//   Widget builder(BuildContext context) {
//     return Scaffold(
//         body: Column(children: <Widget>[
//       _topMemuRowButton(),
//       // _carousel(imageList),
//       // _expressEntrance(),
//       // _commonApplications(),
//       // _dataMonitoring()
//       // Container(
//       //   color: XColors.bgColor,
//       //   padding: EdgeInsets.only(left: 12.w, right: 12.w),
//       //   child: ListView(
//       //     shrinkWrap: true,
//       //     children: _getItems()
//       //       ..add(Container(
//       //         margin: EdgeInsets.only(left: 20.w, bottom: 10.h, right: 20.w),
//       //       )),
//       //   ),
//       // )
//     ]));
//   }

// // list widget start
//   List<Widget> _getItems() {
//     List<Widget> children = [];
//     debugPrint("--->size:${map.length}");
//     map.forEach((key, value) {
//       children.add(CardChildWidget(key, value));
//     });
//     return children;
//   }

// // list widget end

// // 封装widget start
//   /// _topMemuRowButton 顶部菜单行按钮（4个按钮：主页、搜索、添加、操作）
//   ///
//   ///  @param
//   ///
//   /// @returns Widget
//   Widget _topMemuRowButton() {
//     return Row(
//       children: <Widget>[
//         Container(
//           alignment: Alignment.bottomLeft,
//           height: 30,
//           width: 130,
//           child: OutlinedButton.icon(
//               onPressed: () {
//                 print("object");
//               },
//               icon: Icon(Icons.cabin_sharp),
//               label: Text("")),
//         ),
//         const SizedBox(
//           height: 30,
//           width: 80,
//         ),
//         Wrap(
//           spacing: 4,
//           children: [
//             OutlinedButton.icon(
//                 onPressed: () {
//                   print("object");
//                 },
//                 icon: Icon(Icons.search),
//                 label: Text("")),
//             OutlinedButton.icon(
//                 onPressed: () {
//                   print("object");
//                 },
//                 icon: Icon(Icons.add),
//                 label: Text("")),
//             OutlinedButton.icon(
//                 onPressed: () {
//                   print("object");
//                 },
//                 icon: Icon(Icons.format_line_spacing_outlined),
//                 label: Text("")),
//           ],
//         ),
//       ],
//     );
//   }

//   /// Carousel 轮播图
//   ///
//   ///  @param List<String> imageList
//   ///
//   ///  @returns Widget
//   // Widget _carousel(List<String> imageList) {
//   //   return GFCarousel(
//   //     //是否显示圆点
//   //     hasPagination: true,
//   //     // 宽高比，跑马灯郑哥区域的宽高比。设置高度后这个参数无效。默认16/9
//   //     aspectRatio: 6 / 2,
//   //     //选中的圆点颜色
//   //     activeIndicator: GFColors.WHITE,
//   //     // 自动播放
//   //     autoPlay: true,
//   //     items: imageList.map(
//   //       (img) {
//   //         return Container(
//   //           // margin: EdgeInsets.all(8.0),
//   //           child: ClipRRect(
//   //             borderRadius: BorderRadius.all(Radius.circular(5.0)),
//   //             child: Image.asset(img, fit: BoxFit.fill, width: 1000.0),
//   //           ),
//   //         );
//   //       },
//   //     ).toList(),
//   //     onPageChanged: (index) {
//   //       setState(() {
//   //         index;
//   //       });
//   //     },
//   //   );
//   // }

//   /// _expressEntrance 快捷入口
//   ///
//   ///  @param
//   ///
//   /// @returns Widget
//   Widget _expressEntrance() {
//     return Container(
//       // 快捷入口
//       child: Column(
//         children: [
//           Container(
//               padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
//               alignment: Alignment.topLeft,
//               child: const Text("快捷入口")),
//           Container(
//             padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
//             child: Row(
//               children: [
//                 Container(
//                   width: 60.0,
//                   height: 60.0,
//                   color: Colors.red,
//                 ),
//                 SizedBox(width: 20),
//                 Container(
//                   width: 60.0,
//                   height: 60.0,
//                   color: Colors.green,
//                 ),
//                 SizedBox(width: 20),
//                 Container(
//                   width: 60.0,
//                   height: 60.0,
//                   color: Colors.blue,
//                 ),
//                 SizedBox(width: 20),
//                 Container(
//                   width: 60.0,
//                   height: 60.0,
//                   color: Colors.green,
//                 ),
//                 SizedBox(width: 20),
//                 Container(
//                   width: 60.0,
//                   height: 60.0,
//                   color: Colors.blue,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// _commonApplications 常用应用
//   ///
//   ///  @param
//   ///
//   /// @returns Widget
//   Widget _commonApplications() {
//     return Container(
//         // 常用应用
//         child: Column(
//       children: [
//         Container(
//             padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
//             alignment: Alignment.topLeft,
//             child: Text("常用应用")),
//         Flow(
//           delegate: TestFlowDelegate(margin: EdgeInsets.all(10.0)),
//           children: <Widget>[
//             Container(
//               width: 60.0,
//               height: 60.0,
//               // color: Colors.red,
//               decoration: BoxDecoration(
//                   image: const DecorationImage(
//                       image: AssetImage("images/bg_center1.png"),
//                       fit: BoxFit.cover),
//                   borderRadius: BorderRadius.circular(1000)),
//               child: const Text(
//                 '资产监管平台',
//                 textDirection: TextDirection.ltr,
//                 textAlign: TextAlign.center, // 文本水平对齐方式
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             Container(
//               width: 60.0,
//               height: 60.0,
//               // color: Colors.blue,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage("images/bg_center1.png"),
//                       fit: BoxFit.cover),
//                   borderRadius: BorderRadius.circular(1000)),
//             ),
//             Container(
//               width: 60.0,
//               height: 60.0,
//               // color: Colors.blue,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage("images/bg_center1.png"),
//                       fit: BoxFit.cover),
//                   borderRadius: BorderRadius.circular(1000)),
//             ),
//             Container(
//               width: 60.0,
//               height: 60.0,
//               // color: Colors.yellow,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage("images/bg_center1.png"),
//                       fit: BoxFit.cover),
//                   borderRadius: BorderRadius.circular(1000)),
//             ),
//             Container(
//               width: 60.0,
//               height: 60.0,
//               // color: Colors.brown,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage("images/bg_center1.png"),
//                       fit: BoxFit.cover),
//                   borderRadius: BorderRadius.circular(1000)),
//             ),
//             Container(
//               width: 60.0,
//               height: 60.0,
//               // color: Colors.purple,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage("images/bg_center1.png"),
//                       fit: BoxFit.cover),
//                   borderRadius: BorderRadius.circular(1000)),
//             ),
//             Container(
//               width: 60.0,
//               height: 60.0,
//               // color: Colors.blue,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage("images/bg_center1.png"),
//                       fit: BoxFit.cover),
//                   borderRadius: BorderRadius.circular(1000)),
//             ),
//             Container(
//               width: 60.0,
//               height: 60.0,
//               // color: Colors.yellow,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage("images/bg_center1.png"),
//                       fit: BoxFit.cover),
//                   borderRadius: BorderRadius.circular(1000)),
//             ),
//             Container(
//               width: 60.0,
//               height: 60.0,
//               // color: Colors.brown,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage("images/bg_center1.png"),
//                       fit: BoxFit.cover),
//                   borderRadius: BorderRadius.circular(1000)),
//             ),
//             Container(
//               width: 60.0,
//               height: 60.0,
//               // color: Colors.purple,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage("images/bg_center1.png"),
//                       fit: BoxFit.cover),
//                   borderRadius: BorderRadius.circular(1000)),
//             ),
//           ],
//         ),
//       ],
//     ));
//   }

//   /// _dataMonitoring 数据检测
//   ///
//   ///  @param
//   ///
//   /// @returns Widget
//   Widget _dataMonitoring() {
//     return Container(
//         // 数据监测
//         child: Column(
//       children: [
//         Container(
//             padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
//             alignment: Alignment.topLeft,
//             child: Text("数据检测")),
//         Container(
//             child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   margin: EdgeInsets.all(13.0),
//                   width: 180.0,
//                   height: 90.0,
//                   color: Colors.red,
//                 ),
//                 Container(
//                   width: 11,
//                 ),
//                 Container(
//                   width: 180.0,
//                   height: 90.0,
//                   color: Colors.green,
//                 ),
//               ],
//             ),
//           ],
//         )),
//         Container(
//           height: 1,
//         ),
//         Container(
//             child: Column(
//           children: [
//             Row(
//               children: [
//                 Container(
//                   margin: EdgeInsets.all(13.0),
//                   width: 180.0,
//                   height: 90.0,
//                   color: Colors.red,
//                 ),
//                 Container(
//                   width: 11,
//                 ),
//                 Container(
//                   width: 180.0,
//                   height: 90.0,
//                   color: Colors.green,
//                 ),
//               ],
//             ),
//           ],
//         )),
//       ],
//     ));
//   }

// // 封装widget end
// }

// class CardChildWidget extends StatelessWidget {
//   String itemName;

//   List value;

//   CardChildWidget(this.itemName, this.value);

//   @override
//   Widget build(BuildContext context) {
//     debugPrint("--->key:item$itemName | value :${value}");
//     print("22222222222221111111");
//     print("--->2222key:item$itemName | value :${value}");
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           itemName,
//           style: XFonts.size24Black3W700,
//         ),
//         SizedBox(
//           height: 12.h,
//         ),
//         Container(
//           decoration: BoxDecoration(
//               color: XColors.white, borderRadius: BorderRadius.circular(10)),
//           child: GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
//               shrinkWrap: true,
//               itemCount: value.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 5,
//               ),
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     var func = value[index]["func"];
//                     if (func != null) {
//                       func();
//                     }
//                   },
//                   child: Column(
//                     children: [
//                       // AImage.netImageRadius(AIcons.back_black,
//                       //     size: Size(64.w, 64.w)),
//                       Container(
//                           width: 64.w,
//                           height: 64.w,
//                           color: XColors.navigatorBgColor),
//                       // AImage.netImage(AIcons.placeholder,
//                       //     url: value[index]['icon'], size: Size()),
//                       SizedBox(
//                         height: 10.h,
//                       ),
//                       Text(
//                         value[index]['cardName'],
//                         style: XFonts.size18Black6,
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//         ),
//         SizedBox(
//           height: 24.h,
//         ),
//       ],
//     );
//   }
// }

// class TestFlowDelegate extends FlowDelegate {
//   EdgeInsets margin;

//   TestFlowDelegate({this.margin = EdgeInsets.zero});

//   double width = 0;
//   double height = 0;

//   @override
//   void paintChildren(FlowPaintingContext context) {
//     var x = margin.left;
//     var y = margin.top;
//     //计算每一个子widget的位置
//     for (int i = 0; i < context.childCount; i++) {
//       var w = context.getChildSize(i)!.width + x + margin.right;
//       if (w < context.size.width) {
//         context.paintChild(i, transform: Matrix4.translationValues(x, y, 0.0));
//         x = w + margin.left;
//       } else {
//         x = margin.left;
//         y += context.getChildSize(i)!.height + margin.top + margin.bottom;
//         //绘制子widget(有优化)
//         context.paintChild(i, transform: Matrix4.translationValues(x, y, 0.0));
//         x += context.getChildSize(i)!.width + margin.left + margin.right;
//       }
//     }
//   }

//   @override
//   Size getSize(BoxConstraints constraints) {
//     // 指定Flow的大小，简单起见我们让宽度竟可能大，但高度指定为200，
//     // 实际开发中我们需要根据子元素所占用的具体宽高来设置Flow大小
//     return Size(double.infinity, 160.0);
//   }

//   @override
//   bool shouldRepaint(FlowDelegate oldDelegate) {
//     return oldDelegate != this;
//   }
// }

// class IndexController extends BaseController {}

// class IndexBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => IndexController());
//   }
// }
