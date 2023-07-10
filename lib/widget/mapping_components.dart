
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/innerTeam/department.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/model/asset_creation_config.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/widget/bottom_sheet_dialog.dart';
import 'package:orginone/widget/common_widget.dart';

import 'loading_dialog.dart';

typedef MappingComponentsCallback = Widget Function(Fields data, ITarget target);

Map<String, MappingComponentsCallback> testMappingComponents = {
  "text": mappingTextWidget,
  "input": mappingInputWidget,
  "select": mappingSelectBoxWidget,
  "selectTime": mappingSelectTimeBoxWidget,
  "selectTimeRange": mappingSelectTimeRangeBoxWidget,
  "selectDate": mappingSelectDateBoxWidget,
  "selectDateRange": mappingSelectDateRangeBoxWidget,
  "selectPerson": mappingSelectPersonBoxWidget,
  "selectDepartment": mappingSelectDepartmentBoxWidget,
  "selectGroup": mappingSelectGroupBoxWidget,
  "switch": mappingSwitchWidget,
  "router": mappingRouteWidget,
  "upload": mappingUploadWidget,
};


MappingComponentsCallback mappingTextWidget = (Fields data, ITarget target) {
  if(data.hidden??false){
    return Container();
  }
  return Obx(() {
    return Container(
      margin: EdgeInsets.only(
          left: (data.marginLeft ?? 0).h,
          right: (data.marginRight ?? 0).h,
          top: (data.marginTop ?? 0).h,
          bottom: (data.marginBottom ?? 0).h),
      child: CommonWidget.commonTextTile(
          data.title ?? "", data.defaultData.value ?? "",
          required: data.required ?? false,enabled: !(data.readOnly??false),showLine: true),);
  });
};

MappingComponentsCallback mappingInputWidget = (Fields data, ITarget target) {
  List<TextInputFormatter>? inputFormatters;
  if (data.regx != null) {
    inputFormatters = [
      FilteringTextInputFormatter.allow(RegExp(data.regx!)),
    ];
  }
  if(data.hidden??false){
    return Container();
  }
  return Container(
    margin: EdgeInsets.only(
        left: (data.marginLeft ?? 0).h,
        right: (data.marginRight ?? 0).h,
        top: (data.marginTop ?? 0).h,
        bottom: (data.marginBottom ?? 0).h),
    child: CommonWidget.commonTextTile(data.title ?? "", "",
        hint: data.hint??"请输入",
        maxLine: data.maxLine,
        controller: data.controller,
        onChanged: (str){
          // data.defaultData.value = str;
        },
        required: data.required ?? false,
        inputFormatters: inputFormatters,enabled: !(data.readOnly??false),showLine: true),
  );
};

MappingComponentsCallback mappingSelectBoxWidget = (Fields data,ITarget target) {
  if(data.hidden??false){
    return Container();
  }
  return Obx(() {
    String content = "";
    if(data.defaultData.value!=null){
      if(data.defaultData.value is String){
        content = data.defaultData.value;
      }else{
        content = data.defaultData.value?.values?.first.toString()??"";
      }
    }
    return Container(
      margin: EdgeInsets.only(
          left: (data.marginLeft ?? 0).h,
          right: (data.marginRight ?? 0).h,
          top: (data.marginTop ?? 0).h,
          bottom: (data.marginBottom ?? 0).h),
      child: CommonWidget.commonChoiceTile(
          data.title ?? "",content,
          onTap: (){
            if(!(data.readOnly??false)){
              PickerUtils.showListStringPicker(Get.context!, titles: data.select!.values.toList(),
                  callback: (str) {
                    int index = data.select!.values.toList().indexOf(str);
                    dynamic key = data.select!.keys.toList()[index];
                    data.defaultData.value = {key: str};
                  });
            }
          },
          showLine: true,
          required: data.required ?? false),
    );
  });
};

MappingComponentsCallback mappingSelectTimeBoxWidget =
    (Fields data, ITarget target) {
  if (data.hidden ?? false) {
    return Container();
  }
  return Obx(() {
    String content = '';
    content = data.defaultData.value ?? "";
    return Container(
      margin: EdgeInsets.only(
          left: (data.marginLeft ?? 0).h,
          right: (data.marginRight ?? 0).h,
          top: (data.marginTop ?? 0).h,
          bottom: (data.marginBottom ?? 0).h),
      child:
          CommonWidget.commonChoiceTile(data.title ?? "", content, onTap: () {
        if (!(data.readOnly ?? false)) {
          DatePicker.showDateTimePicker(Get.context!,
              currentTime: DateTime.now(),
              locale: LocaleType.zh, onConfirm: (date) {
            data.defaultData.value = date.format(format: "yyyy-MM-dd HH:mm");
          });
        }
      }, showLine: true, required: data.required ?? false),
    );
  });
};

MappingComponentsCallback mappingSelectTimeRangeBoxWidget =
    (Fields data, ITarget target) {
  if (data.hidden ?? false) {
    return Container();
  }
  return Obx(() {
    String content = '';
    content = data.defaultData.value?.join('至') ?? "";
    return Container(
      margin: EdgeInsets.only(
          left: (data.marginLeft ?? 0).h,
          right: (data.marginRight ?? 0).h,
          top: (data.marginTop ?? 0).h,
          bottom: (data.marginBottom ?? 0).h),
      child: CommonWidget.commonChoiceTile(data.title ?? "", content,
          onTap: () async {
        if (!(data.readOnly ?? false)) {
          List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
              context: Get.context!, type: OmniDateTimePickerType.dateAndTime);
          if (dateTimeList != null) {
            dateTimeList.sort((a,b)=>a.compareTo(b));
            data.defaultData.value = dateTimeList.map((e) => e.format(format: "yyyy-MM-dd HH:mm"))
                .toList();
          }
        }
      }, showLine: true, required: data.required ?? false),
    );
  });
};

MappingComponentsCallback mappingSelectDateBoxWidget =
    (Fields data, ITarget target) {
  if (data.hidden ?? false) {
    return Container();
  }
  return Obx(() {
    String content = '';
    content = data.defaultData.value ?? "";
    return Container(
      margin: EdgeInsets.only(
          left: (data.marginLeft ?? 0).h,
          right: (data.marginRight ?? 0).h,
          top: (data.marginTop ?? 0).h,
          bottom: (data.marginBottom ?? 0).h),
      child:
          CommonWidget.commonChoiceTile(data.title ?? "", content, onTap: () {
        if (!(data.readOnly ?? false)) {
          DatePicker.showDatePicker(Get.context!,
              currentTime: DateTime.now(),
              locale: LocaleType.zh, onConfirm: (date) {
            data.defaultData.value = date.format(format: "yyyy-MM-dd");
          });
        }
      }, showLine: true, required: data.required ?? false),
    );
  });
};

MappingComponentsCallback mappingSelectDateRangeBoxWidget =
    (Fields data, ITarget target) {
  if (data.hidden ?? false) {
    return Container();
  }
  return Obx(() {
    String content = '';
    content = data.defaultData.value?.join('至') ?? "";
    return Container(
      margin: EdgeInsets.only(
          left: (data.marginLeft ?? 0).h,
          right: (data.marginRight ?? 0).h,
          top: (data.marginTop ?? 0).h,
          bottom: (data.marginBottom ?? 0).h),
      child: CommonWidget.commonChoiceTile(data.title ?? "", content,
          onTap: () async {
        if (!(data.readOnly ?? false)) {
          List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
              context: Get.context!, type: OmniDateTimePickerType.date);
          if (dateTimeList != null) {
            dateTimeList.sort((a,b)=>a.compareTo(b));
            data.defaultData.value = dateTimeList
                .map((e) => e.format(format: "yyyy-MM-dd"))
                .toList();
          }
        }
      }, showLine: true, required: data.required ?? false),
    );
  });
};

MappingComponentsCallback mappingSelectPersonBoxWidget =
    (Fields data, ITarget target) {
  if (data.hidden ?? false) {
    return Container();
  }
  return Obx(() {
    String content = '';
    content = data.defaultData.value?.name ?? "";
    return Container(
      margin: EdgeInsets.only(
          left: (data.marginLeft ?? 0).h,
          right: (data.marginRight ?? 0).h,
          top: (data.marginTop ?? 0).h,
          bottom: (data.marginBottom ?? 0).h),
      child:
          CommonWidget.commonChoiceTile(data.title ?? "", content, onTap: () {
        if (!(data.readOnly ?? false)) {
          var users =  target.members;
              PickerUtils.showListStringPicker(Get.context!, titles: users.map((e) => e.name!).toList(),
                  callback: (str) {
                    data.defaultData.value = users.firstWhere((element) => element.name == str);
                  });
            }
          },
          showLine: true,
          required: data.required ?? false),
    );
  });
};

MappingComponentsCallback mappingSelectDepartmentBoxWidget = (Fields data, ITarget target) {
  if(data.hidden??false){
    return Container();
  }
  return Obx(() {
    String content = '';
    content = data.defaultData.value?.name??"";
    return Container(
      margin: EdgeInsets.only(
          left: (data.marginLeft ?? 0).h,
          right: (data.marginRight ?? 0).h,
          top: (data.marginTop ?? 0).h,
          bottom: (data.marginBottom ?? 0).h),
      child: CommonWidget.commonChoiceTile(
          data.title ?? "",content,
          onTap:(){
            if(!(data.readOnly??false)){
              List<ITarget> loadDepartments(List<IDepartment> departments) {
                List<ITarget> team = [];

                for (var value in departments) {
                  team.add(value);
                  if (value.children.isNotEmpty) {
                    team.addAll(loadDepartments(value.children));
                  }
                }
                return team;
              }

              List<ITarget> team = loadDepartments((target as Company).departments);
              PickerUtils.showListStringPicker(Get.context!,
                  titles: team.map((e) => e.metadata.name!).toList(),
                  callback: (str) {
                    data.defaultData.value =
                        team.firstWhere((element) => element.metadata.name == str).metadata;
                  });
            }
          },
          showLine: true,
          required: data.required ?? false),
    );
  });
};


MappingComponentsCallback mappingSelectGroupBoxWidget = (Fields data, ITarget target) {
  if(data.hidden??false){
    return Container();
  }
  return Obx(() {
    String content = '';
    content = data.defaultData.value?.name??"";
    return Container(
      margin: EdgeInsets.only(
          left: (data.marginLeft ?? 0).h,
          right: (data.marginRight ?? 0).h,
          top: (data.marginTop ?? 0).h,
          bottom: (data.marginBottom ?? 0).h),
      child: CommonWidget.commonChoiceTile(
          data.title ?? "",content,
          onTap:(){
            if(!(data.readOnly??false)){
              List<ITarget>  parentTarget =  (target as IBelong).parentTarget;
              PickerUtils.showListStringPicker(Get.context!, titles: parentTarget.map((e) => e.metadata.name!).toList(),
                  callback: (str) {
                    data.defaultData.value = parentTarget.firstWhere((element) => element.metadata.name == str).metadata;
                  });
            }
          },
          showLine: true,
          required: data.required ?? false),
    );
  });
};


MappingComponentsCallback mappingRouteWidget = (Fields data, ITarget target) {
  if(data.hidden??false){
    return Container();
  }
  return Obx(() {
    return CommonWidget.commonChoiceTile(
        data.title ?? "", data.defaultData.value?.name ?? "",
        required: data.required ?? false, onTap: () {
      if (!(data.readOnly ?? false)) {
        Get.toNamed(data.router!);
      }
    }, showLine: true);
  });
};

MappingComponentsCallback mappingSwitchWidget = (Fields data, ITarget target) {
  if (data.hidden ?? false) {
    return Container();
  }
  if( data.select!.isEmpty){
    return mappingTextWidget(data,target);
  }
  return Stack(
    children: [
      Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 0.5))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title ?? '',
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
              ),
              data.select!.isEmpty?SizedBox():Obx(() {
                List<Widget> children = [];
                data.select?.forEach((key, value) {
                  children.add(CommonWidget.commonRadioTextWidget<String>(
                      value, key, groupValue: data.defaultData.value,
                      onChanged: (v) {
                    if(!(data.readOnly??false)){
                      data.defaultData.value = v;
                    }
                  }, padding: EdgeInsets.symmetric(vertical: 5.h)));
                });

                return Row(children: children);
              }),
            ],
          ),
        ),
      ),
      Positioned(
        top: 5.h,
        left: 10.w,
        child: (data.required ?? false)
            ? const Text(
                "*",
                style: TextStyle(color: Colors.red),
              )
            : Container(),
      )
    ],
  );
};

MappingComponentsCallback mappingUploadWidget = (Fields data, ITarget target) {
  if (data.hidden ?? false) {
    return Container();
  }
  return Obx(() {
    String str = '';
    if (data.defaultData.value != null) {
      if (data.defaultData.value is String) {
        str = data.defaultData.value;
      } else {
        str = data.defaultData.value?.name;
      }
    }
    return CommonWidget.commonChoiceTile(data.title ?? "", str,
        required: data.required ?? false, onTap: () async {
      if (!(data.readOnly ?? false)) {
        FilePickerResult? result =
            await FilePicker.platform.pickFiles(type: FileType.any);
        if (result != null) {
          LoadingDialog.showLoading(Get.context!);
          var docDir = target.directory;
          PlatformFile file = result.files.first;
          var file1 = File(file.path!);
          var item = await docDir.createFile(file1);
          if (item != null) {
            data.defaultData.value = item.shareInfo();
          }
          LoadingDialog.dismiss(Get.context!);
        }
      }
    }, showLine: true);
  });
};
