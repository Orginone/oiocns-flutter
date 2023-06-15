import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/model/asset_creation_config.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/util/production_order_utils.dart';
import 'package:orginone/widget/common_widget.dart';

typedef MappingComponentsCallback = Widget Function(Fields data, ITarget target);

Map<String, MappingComponentsCallback> testMappingComponents = {
  "text": mappingTextWidget,
  "input": mappingInputWidget,
  "select": mappingSelectBoxWidget,
  "selectDate": mappingSelectDateBoxWidget,
  "selectPerson":mappingSelectPersonBoxWidget,
  "selectDepartment":mappingSelectDepartmentBoxWidget,
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
  TextEditingController controller = TextEditingController(text: data.defaultData.value?.toString()??"");
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
        controller: controller,
        onChanged: (str){
          data.defaultData.value = str;
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
    String content = data.defaultData.value?.values?.first.toString() ?? "";
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
              data.function(target);
            }
          },
          showLine: true,
          required: data.required ?? false),
    );
  });
};

MappingComponentsCallback mappingSelectDateBoxWidget = (Fields data, ITarget target) {
  if(data.hidden??false){
    return Container();
  }
  return Obx(() {
    String content = '';
    content = data.defaultData.value??"";
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
              data.function(target);
            }
          },
          showLine: true,
          required: data.required ?? false),
    );
  });
};


MappingComponentsCallback mappingSelectPersonBoxWidget = (Fields data, ITarget target) {
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
          onTap: (){
            if(!(data.readOnly??false)){
              data.function(target);
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
    content = data.defaultData.value?.teamName??"";
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
              data.function(target);
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
        data.title??"", data.defaultData.value?.name ?? "",
        required: data.required??false, onTap: (){
      if(!(data.readOnly??false)){
        data.function(target);
      }
    }, showLine: true);
  });
};

MappingComponentsCallback mappingUploadWidget = (Fields data, ITarget target) {
  if(data.hidden??false){
    return Container();
  }
  return Obx(() {
    String str = '';
    if(data.defaultData.value!=null){
      if(data.defaultData.value is String){
        str = data.defaultData.value;
      }else{
        str = data.defaultData.value?.name;
      }
    }
    return CommonWidget.commonChoiceTile(
        data.title??"", str,
        required: data.required??false, onTap: (){
          if(!(data.readOnly??false)){
            data.function(target);
          }
    }, showLine: true);
  });
};
