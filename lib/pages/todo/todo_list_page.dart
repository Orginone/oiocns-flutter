import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/components/widgets/loading_widget.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/pages/todo/work_page.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_util.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    return TodoList();
  }

  @override
  bool get wantKeepAlive => true;
}

class TodoList extends GetView<WorkController> {

  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return LoadingWidget(
        currStatus: controller.todoLoadStatus.value,
        builder: (context) {
          return RefreshIndicator(
            onRefresh: () async{
              controller.getTodoList(true);
            },
            child: ListView.builder(
                itemCount: controller.todoList.length,
                itemBuilder: (context, index) {
                  return itemInit(context, index, controller.todoList[index]);
                }),
          );
        },
      );
    });
  }

  Widget itemInit(BuildContext context, int index, XRelation item) {
    return Container(
      color: XColors.bgColor,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 0),
      child: Slidable(
        enabled: true,
        key: const ValueKey(0),
        endActionPane: ActionPane(
          extentRatio: 0.27,
          openThreshold: 0.1,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              // An action can be bigger than the others.
              flex: 3,
              onPressed: _doNothing,
              backgroundColor: XColors.orange,
              foregroundColor: Colors.white,
              label: '标为已读',
              padding: const EdgeInsets.all(0),
            ),
            SlidableAction(
              flex: 2,
              onPressed: _doNothing,
              backgroundColor: const Color(0xFFED464B),
              foregroundColor: Colors.white,
              label: '删除',
              padding: const EdgeInsets.all(0),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: (){
            Get.toNamed(Routers.todoDetail,
                // arguments: DetailArguments(
                //     AffairsTypeEnum.task, index,
                //     taskEntity: item)
            );
          },
          child: Container(
            width: 512.w,
            padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 10.h),
            decoration: BoxDecoration(
                color: XColors.white,
                border: Border.all(color: XColors.cardBorder, width: 0.1.w),
                borderRadius: const BorderRadius.all(Radius.circular(0)),
                ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      '李二黑',
                      style: AFont.instance.size22Black3W500),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5.h),
                  child: Text( "李二黑",
                      style: AFont.instance.size18Black9),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
                      decoration: BoxDecoration(
                          color: XColors.white,
                          border: Border.all(
                              color: XColors.cardBorder, width: 0.1.w),
                          borderRadius: const BorderRadius.all(Radius.circular(0))),
                      child: Text(
                        CustomDateUtil.getDetailTime(
                            DateTime.parse("1677832041")),
                        style: AFont.instance.size14Black9,
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: Row(
                        children: [
                          Visibility(
                            visible: false,
                            child: SizedBox(
                              width: 106.w,
                              height: 42.h,
                              child: GFButton(
                                onPressed: () {},
                                color: XColors.backColor,
                                text: "退回",
                                textColor: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          SizedBox(
                            width: 106.w,
                            height: 42.h,
                            child: GFButton(
                              onPressed: () {
                                Get.toNamed(Routers.todoDetail,
                                    // arguments: DetailArguments(
                                    //     AffairsTypeEnum.task, index,
                                    //     taskEntity: item)
                                );
                              },
                              color: XColors.themeColor,
                              text: "审批",
                              textStyle: AFont.instance.size18White,
                              textColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _doNothing(BuildContext context) {}

}

