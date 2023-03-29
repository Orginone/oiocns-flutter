import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';

import 'logic.dart';
import 'state.dart';
import 'item.dart';


class StartPage extends BaseGetListPageView<StartController,StartState>{

  final ISpeciesItem species;

  StartPage(this.species);

  @override
  Widget buildView() {
    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.only(top: 10.h),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context,index){
            return Item(define: state.dataList[index],);
          },
          itemCount: state.dataList.length,
        ),
      ),
    );
  }

  @override
  StartController getController() {
   return StartController(species);
  }

  @override
  String tag() {
    // TODO: implement tag
    return this.toString();
  }
}