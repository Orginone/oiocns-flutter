import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/page/home/message/message_setting/message_setting_controller.dart';
import 'package:orginone/page/home/organization/cohorts/component/avatar_group.dart';

import '../../../../../component/a_font.dart';
import '../../../../../component/unified_colors.dart';
import '../../../../../util/widget_util.dart';

class MoreCohort extends GetView<MessageSettingController> {
  const MoreCohort({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("群组人员", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarElevation: 0,
      body: Container(
        color: UnifiedColors.bgColor,
        child: ListView(
          children: [
            AvatarGroup(padding: EdgeInsets.only(top: 30.h)),
            GetBuilder<MessageSettingController>(builder: (controller) {
              if (controller.hasReminder) {
                return _more;
              }
              return Container();
            })
          ],
        ),
      ),
    );
  }

  get _more {
    return GestureDetector(
      onTap: () => controller.morePersons(),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 40.h),
        child: Text(
          "查看更多",
          style: AFont.instance.size20themeColorW500,
        ),
      ),
    );
  }
}
