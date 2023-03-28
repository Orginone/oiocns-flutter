import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import './often_use_controller.dart';
import './oiocns_components/apply_button.dart';

class OftenUsePage extends StatelessWidget {
  const OftenUsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OftenUseController controller = Get.put(OftenUseController());
    return Obx(() {
      return GridView.builder(
          padding: EdgeInsets.fromLTRB(0.w, 10, 28.w, 0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, childAspectRatio: 1.25, mainAxisSpacing: 18.0),
          itemCount: controller.oftenUseList.length,
          itemBuilder: (context, index) {
            return ApplyButton(
              url: controller.oftenUseList[index].url,
              applyName: controller.oftenUseList[index].name,
              onTap: controller.oftenUseList[index].onTap,
            );
          });
    });
  }
}
