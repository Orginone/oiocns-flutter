
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/base_view.dart';
import 'package:orginone/components/loading_widget.dart';
import 'package:orginone/components/unified_colors.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/pages/todo/todo_page.dart';
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

class TodoList extends BaseView<TodoController> {

  TodoList({Key? key}) : super(key: key) {
    Get.lazyPut(() => TodoController());
  }

  @override
  LoadStatusX initStatus() {
    return controller.loadStatus.value;
  }

  @override
  bool isUseScaffold() {
    return false;
  }


  @override
  Widget builder(BuildContext context) {
    return ListView.builder(
        itemCount: controller.mDataList.length,
        itemBuilder: (context, index) {
          return itemInit(context, index, controller.mDataList[index]);
        });
  }


  Widget itemInit(BuildContext context, int index, dynamic item) {
    return Slidable(
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
            backgroundColor: UnifiedColors.orange,
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
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 10.h),
          margin: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 0),
          decoration: BoxDecoration(
              color: UnifiedColors.white,
              border: Border.all(color: UnifiedColors.cardBorder, width: 0.1.w),
              borderRadius: const BorderRadius.all(Radius.circular(0)),
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
                child: Text(
                    (item.flowInstance?.title)??'李二黑',
                    style: AFont.instance.size22Black3W500),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 5.h),
                child: Text(item.flowInstance?.flowRelation?.functionCode ?? "李二黑",
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
                        color: UnifiedColors.white,
                        border: Border.all(
                            color: UnifiedColors.cardBorder, width: 0.1.w),
                        borderRadius: const BorderRadius.all(Radius.circular(0))),
                    child: Text(
                      CustomDateUtil.getDetailTime(
                          DateTime.parse(item.createTime)),
                      style: AFont.instance.size14Black9,
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: Row(
                      children: [
                        Visibility(
                          visible: false,
                          child: SizedBox(
                            width: 106.w,
                            height: 42.h,
                            child: GFButton(
                              onPressed: () {},
                              color: UnifiedColors.backColor,
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
                            color: UnifiedColors.themeColor,
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
    );
  }

  void _doNothing(BuildContext context) {}

}
