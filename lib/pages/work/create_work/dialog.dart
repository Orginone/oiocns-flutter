import 'package:flutter/material.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/standard/form.dart';
import 'package:orginone/main.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/mapping_components.dart';

Future<void> showCreateAuthDialog(
    BuildContext context, IForm form, ITarget target,
    {AnyThingModel? thing, Function(AnyThingModel model)? onSuceess}) async {
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
                      "${thing != null ? "编辑" : "新增"}${form.metadata.name}"),
                  ...form.fields.map((e) {
                        if (e.field.type == null) {
                          return Container();
                        }
                        if (thing != null) {
                          dynamic value = thing.otherInfo[e.code];
                          e.field.defaultData.value = value;
                        }
                        Widget child =
                            testMappingComponents[e.field.type ?? ""]!(
                                e.field, target);
                        return child;
                      }).toList() ??
                      [],
                  CommonWidget.commonMultipleSubmitWidget(onTap1: () {
                    Navigator.pop(context);
                  }, onTap2: () async {
                    late AnyThingModel newModel;
                    if (thing == null) {
                      var res =
                          await kernel.anystore.createThing('', target.id);
                      if (res.data != null) {
                        newModel = res.data!;
                      }
                    } else {
                      newModel = thing;
                    }

                    form.setThing(newModel);

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
