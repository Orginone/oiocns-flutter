import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/dots_stepper.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class CreateBagPage extends BaseGetView<CreateBagController, CreateBagState> {


  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "创建钱包",
      leading: IconButton(
        icon: const Icon(Icons.close),
        color: Colors.black,
        tooltip: MaterialLocalizations
            .of(context)
            .backButtonTooltip,
        onPressed: () {
           Get.back();
           Routers.changeTransition();
        },
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          stepper(),
          Expanded(
            child: PageView.builder(
              itemBuilder: (context,index){
                return state.pages[index];
              },
              itemCount: state.pages.length,
              physics: const NeverScrollableScrollPhysics(),
              controller: state.pageController,
            ),
          ),
        ],
      ),
    );
  }

  Widget stepper() {
    return Center(
      child: Obx(() {
        return DotsStepper(
          dotsCount: state.stepsCount,
          position: state.currentStep.value.toDouble(),
          decorator: const DotsDecorator(
              color: Colors.black26,
              shape: RoundedRectangleBorder(),
              activeShape: RoundedRectangleBorder(),
              size: Size(30, 2),
              activeSize: Size(30, 2),
              spacing: EdgeInsets.all(2)),
          onTap: (index){

          },
        );
      }),
    );
  }
}