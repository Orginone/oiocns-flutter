import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/application.dart';
import 'package:orginone/pages/other/general_bread_crumbs/state.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';

class ApplicationItem extends StatelessWidget {
  final IApplication application;

  final ITarget target;

  const ApplicationItem(
      {super.key, required this.application, required this.target});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 0.4))
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 11.h),
      child: Row(
        children: [
          application.metadata.avatarThumbnail() == null
              ? Icon(
                  Ionicons.apps,
                  color: Color(0xFF9498df),
                  size: 60.w,
                )
              : ImageWidget(
                  application.metadata.avatarThumbnail(),
                  size: 60.w,
                  fit: BoxFit.fill,
            radius: 16.w,
                ),
          SizedBox(
            width: 15.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  application.metadata.name ?? "",
                  style: TextStyle(fontSize: 19.sp),
                ),
                SizedBox(height: 10.h,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: XColors.tinyBlue),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  child: Text(
                      target.metadata.name ?? "",
                      style: TextStyle(fontSize: 12.sp, color: XColors.designBlue)),
                ),
              ],
            ),
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.w),
                border: Border.all(color: Colors.grey.shade400, width: 0.5),
              ),
              child: Text(
                "打开",
                style: XFonts.size20Black0,
              ),
            ),
            onTap: () async {
              var works = await application.loadWorks();
              var nav = GeneralBreadcrumbNav(
                  id: application.metadata.id??"",
                  name: application.metadata.name ?? "",
                  source: application,
                  spaceEnum: SpaceEnum.applications,
                  space: target,
                  children: [
                    ...works.map((e) {
                      return GeneralBreadcrumbNav(
                        id: e.metadata.id??"",
                        name: e.metadata.name??"",
                        spaceEnum: SpaceEnum.work,
                        space: target,
                        source: e, children: [],
                      );
                    }).toList(),
                    ...loadNav(application.children,target),
                  ]);
              Get.toNamed(Routers.generalBreadCrumbs,
                  arguments: {"data": nav});
            },
          ),
        ],
      ),
    );
  }

  List<GeneralBreadcrumbNav> loadNav(List<IApplication> app, ITarget target) {
    List<GeneralBreadcrumbNav> navs = [];
    for (var value in app) {
      navs.add(GeneralBreadcrumbNav(
          id: value.metadata.id??"",
          name: value.metadata.name ?? "",
          source: value,
          spaceEnum: SpaceEnum.module,
          space: target,
          onNext: (item) async {
            var works = await value.loadWorks();
            List<GeneralBreadcrumbNav> data = [
              ...works.map((e) {
                return GeneralBreadcrumbNav(
                  id: e.metadata.id??"",
                  name: e.metadata.name??"",
                  spaceEnum: SpaceEnum.work,
                  source: e,
                  space: target, children: [],
                );
              }),
              ...loadNav(value.children, target),
            ];
            item.children = data;
          }, children: []));
    }
    return navs;
  }
}
