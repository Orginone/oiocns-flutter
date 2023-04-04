import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/routers.dart';

import '../../../dart/core/thing/species.dart';
import 'item.dart';

class DictDefinition extends StatelessWidget {
  final List<XDict> dict;
  const DictDefinition({Key? key, required this.dict}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10.h),
      itemBuilder: (context, index) {
        var item = dict[index];
        return Item(
          dict: item,
          onTap: () {
            Get.toNamed(Routers.dictDetails,arguments: {"dict":item});
          },
          onSelected: (str){

          },
        );
      },
      itemCount: dict.length,
    );
  }
}
