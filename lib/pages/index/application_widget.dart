

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/application.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';


class ApplicationWidget extends StatelessWidget {
  String itemName;

  List<Map<IApplication,ITarget>> value;

  ApplicationWidget(this.itemName, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: XColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            itemName,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 12.h,
          ),
          GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
              shrinkWrap: true,
              itemCount: value.length,
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisExtent:110.h,
              ),
              itemBuilder: (context, index) {
                var item = value[index];
                var app = item.keys.first;


                late Widget icon;
                if(app.metadata.avatarThumbnail()!=null){
                  icon = ImageWidget(
                    app.metadata.avatarThumbnail(),
                    size: 64.w,
                    circular: true,
                  );
                }else{
                  icon = Icon(
                    Ionicons.apps,
                    color: const Color(0xFF9498df),
                    size: 50.w,
                  );
                }

                return GestureDetector(
                  onTap: () async{

                    var works =  await app.loadWorks();
                    var target = item.values.first;
                    Get.toNamed(Routers.workStart, arguments: {"works":works,'target':target});
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: XColors.navigatorBgColor,
                        ),
                        alignment: Alignment.center,
                        width: 65.w,
                        height: 65.w,
                        child: icon,
                      ),
                      Text(
                        app.metadata.name!,
                        style: XFonts.size18Black6,maxLines: 1,overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}