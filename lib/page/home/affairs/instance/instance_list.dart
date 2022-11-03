import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/api_resp/task_entity.dart';
import '../../../../api_resp/instance_task_entity.dart';
import '../../../../component/a_font.dart';
import '../../../../component/unified_colors.dart';
import '../../../../component/unified_text_style.dart';
import '../../../../public/loading/load_status.dart';
import '../../../../public/view/base_list_view.dart';
import '../../../../routers.dart';
import '../../../../util/date_util.dart';
import '../affairs_type_enum.dart';
import '../base/detail_arguments.dart';
import 'instance_controller.dart';
class AffairsInstanceWidget extends StatefulWidget {
  const AffairsInstanceWidget({Key? key}) : super(key: key);

  @override
  State<AffairsInstanceWidget> createState() => _AffairsInstanceWidgetState();
}

class _AffairsInstanceWidgetState extends State<AffairsInstanceWidget> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InstanceWidget();
  }

  @override
  bool get wantKeepAlive => true;
}

class InstanceWidget extends BaseListView<InstanceController> {


  InstanceWidget({Key? key}) : super(key: key){
    Get.lazyPut(() => InstanceController());
  }

  @override
  LoadStatusX initStatus() {
    return LoadStatusX.loading;
  }

  @override
  bool isUseScaffold() {
    return false;
  }

  @override
  ListView listWidget() {
    return ListView.builder(
        itemCount: controller.dataList.length,
        itemBuilder: (context, index) {
          return itemInit(context, index, controller.dataList[index]);
        });
  }

  Widget itemInit(BuildContext context, int index, InstanceTaskEntity item) {
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
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Archive',
          ),
          SlidableAction(
            onPressed: _doNothing,
            backgroundColor: const Color(0xFF0392CF),
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
                  item.title,
                  style: AFont.instance.size22Black3W500),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 5.h),
              child: Text(item.flowRelation?.functionCode ?? "",
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
                Row(
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
                          Get.toNamed(Routers.affairsDetail,
                              arguments: DetailArguments(
                                  AffairsTypeEnum.instance, index,
                                  instanceEntity: item));
                        },
                        color: UnifiedColors.themeColor,
                        text: "审批",
                        textStyle: AFont.instance.size18White,
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
  }

  void _doNothing(BuildContext context) {}
}
