import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/page/home/affairs/affairs_type_enum.dart';
import 'package:orginone/public/loading/loading_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'affairs_list_controller.dart';
import 'affairs_page_controller.dart';

class AffairsList extends GetView<AffairsListController> {
  AffairsTypeEnum _affairsTypeEnum;
  late AffairsListController _controller;
  AffairsPageController parentController = Get.find() ;

  AffairsList(this._affairsTypeEnum, {Key? key}) : super(key: key){
    _affairsTypeEnum = _affairsTypeEnum;
    debugPrint("--->AffairsList:$_affairsTypeEnum");
    _controller = AffairsListController(_affairsTypeEnum);
    Get.put(_controller);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoadingWidget(
        controller: _controller,
        builder:(context) => SmartRefresher(
          controller: _controller.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: () => _controller.onRefresh(),
          onLoading: () => _controller.onLoadMore(),
          child: ListView.builder(
              itemCount: _controller.dataList.length,
              itemBuilder: (context, index) {
                debugPrint("--->index: $index");
                return Slidable(
                  enabled: false,
                  key: const ValueKey(0),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        // An action can be bigger than the others.
                        flex: 2,
                        onPressed: _doNothing,
                        backgroundColor: Color(0xFF7BC043),
                        foregroundColor: Colors.white,
                        icon: Icons.archive,
                        label: 'Archive',
                      ),
                      SlidableAction(
                        onPressed: _doNothing,
                        backgroundColor: Color(0xFF0392CF),
                        foregroundColor: Colors.white,
                        icon: Icons.save,
                        label: 'Save',
                      ),
                    ],
                  ),

                  // The child of the Slidable is what the user sees when the
                  // component is not dragged.
                  child: Container(
                    width: double.infinity,
                    padding:
                    EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 10.h),
                    margin:
                    EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 0),
                    decoration: BoxDecoration(
                        color: UnifiedColors.white,
                        border: Border.all(
                            color: UnifiedColors.cardBorder,
                            width: 0.1.w),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(0)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x297F7F7F),
                            offset: Offset(8, 8),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("“张三”想成为你的好友",
                              style: TextStyle(
                                  color: UnifiedColors.black3,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "你好，我是谢谢谢谢谢谢谢谢谢谢公司的张三，想成为你的好友",
                              style: text12Grey),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  10.w, 3.h, 10.w, 3.h),
                              decoration: BoxDecoration(
                                  color: UnifiedColors.white,
                                  border: Border.all(
                                      color:
                                      UnifiedColors.cardBorder,
                                      width: 0.1.w),
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(0))),
                              child: Text(
                                "时间：2022-02-23",
                                style: text14Grey,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 70.w,
                                  height: 30.h,
                                  child: GFButton(
                                    onPressed: () {},
                                    color: UnifiedColors.backColor,
                                    text: "退回",
                                    textColor: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                SizedBox(
                                  width: 70.w,
                                  height: 30.h,
                                  child: GFButton(
                                    onPressed: () {},
                                    color: UnifiedColors.agreeColor,
                                    text: "通过",
                                    textStyle: text14White,
                                    textColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  _doNothing(BuildContext ctx) {}
}
