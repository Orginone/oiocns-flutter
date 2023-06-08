import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/market/model.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/model/thing_model.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/mapping_components.dart';

Future<void> showCreateAuthDialog(BuildContext context, XForm form,ITarget target,
    {ThingModel? thing,
    bool isAllChange = false,
    Function(ThingModel model)? onSuceess}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonWidget.commonHeadInfoWidget(
                      "${thing != null || isAllChange? "编辑" : "新增"}${form.name}"),
                  ...form.attributes?.map((e) {
                    if (e.fields?.type == null) {
                      return Container();
                    }
                    if(thing!=null){
                      dynamic value = thing.eidtInfo![e.id];
                      e.fields!.defaultData.value = value;
                    }
                    Widget child =
                    testMappingComponents[e.fields!.type ?? ""]!(
                        e.fields!,target);
                    return child;
                  }).toList() ??
                      [],
                  CommonWidget.commonMultipleSubmitWidget(onTap1: () {
                    Navigator.pop(context);
                  }, onTap2: () async {
                    SettingController setting = Get.find();
                    late ThingModel newModel;
                    if (thing == null && !isAllChange) {
                      var res =
                          await kernel.anystore.createThing(1, setting.user.id);
                      if (res.success) {
                        newModel = ThingModel.fromJson(res.data[0]);
                      }
                    } else if (thing != null) {
                      newModel = thing;
                    } else {
                      newModel = ThingModel();
                    }
                    for (var e in form.attributes!) {
                      newModel.eidtInfo[e.id!] = e.fields?.defaultData.value;
                    }

                    form.reset();
                    if (onSuceess != null) {
                      onSuceess(newModel);
                    }
                    Navigator.pop(context);
                  }),
                ],
              ),
            ),
          ));
    },
  );
}
