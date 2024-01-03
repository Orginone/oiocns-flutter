import 'package:flutter/material.dart' hide Form;
import 'package:get/get.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'form.dart';
import 'property.dart';
import 'species.dart';
import 'state.dart';
import 'work.dart';

class ClassificationInfoController
    extends BaseController<ClassificationInfoState>
    with GetTickerProviderStateMixin {
  @override
  final ClassificationInfoState state = ClassificationInfoState();

  ClassificationInfoController() {
    state.tabController =
        TabController(length: state.tabTitle.length, vsync: this);
  }

  void changeIndex(int index) {
    if (index != state.currentIndex.value) {
      state.currentIndex.value = index;
    }
  }

  void create(ClassificationEnum classificationEnum) {
    switch (classificationEnum) {
      case ClassificationEnum.form:
        var controller = Get.find<FormController>(tag: "form");
        // controller.createForm();
        break;
      case ClassificationEnum.work:
        var controller = Get.find<WorkController>(tag: "work");
        controller.createWork();
        break;
      case ClassificationEnum.property:
        var controller = Get.find<PropertyController>(tag: "property");
        controller.createProperty();
        break;
      case ClassificationEnum.species:
        var controller = Get.find<SpeciesController>(tag: "species");
        controller.createSpecies();
        break;
      default:
    }
  }
}
