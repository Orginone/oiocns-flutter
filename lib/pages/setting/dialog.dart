import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/dict/dict.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/bottom_sheet_dialog.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/unified.dart';

import '../../dart/core/target/authority/authority.dart';
import '../../dart/core/target/base/target.dart';
import '../../dart/core/target/identity/identity.dart';
import 'config.dart';
import 'multiselect.dart';

typedef CreateDictChangeCallBack
    = Function(String name, String code, String remark);

typedef CreateOrganizationChangeCallBack = Function(String name, String code,
    String nickName, String identify, String remark, TargetType type);

typedef CreateIdentityCallBack = Function(
    String name, String code, String authID, String remark);

typedef CreateFormCallBack = Function(String name, String code, bool public);

typedef CreateAttributeCallBack = Function(
  String name,
  String code,
  String valueType,
  String remark,
  String? unit,
  IDict? dict,
);

typedef CreateAttrCallBack = Function(String name, String code, String remark,
    XProperty property, IAuthority authority, bool public);

typedef CreateWorkCallBack = Function(
    String name, String remark, bool isCreate, List<ISpeciesItem> thing);

typedef CreateAuthCallBack = Function(String name,String code,ITarget target,bool isPublic,String remark);

SettingController get setting => Get.find();

Future<void> showCreateIdentityDialog(
    BuildContext context, List<IAuthority> authority,
    {CreateIdentityCallBack? onCreate, IIdentity? identity}) async {
  List<IAuthority> allAuth = getAllAuthority(authority);

  TextEditingController name = TextEditingController(text: identity?.metadata.name);
  TextEditingController code =
      TextEditingController(text: identity?.metadata.code);
  TextEditingController remark =
      TextEditingController(text: identity?.metadata.remark);

  IAuthority? selected;
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          alignment: Alignment.center,
          child: Builder(builder: (context) {
            return StatefulBuilder(builder: (context, state) {
              return SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonWidget.commonHeadInfoWidget(
                        identity != null ? "编辑" : "新增"),
                    CommonWidget.commonTextTile("角色名称", '',
                        controller: name,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    CommonWidget.commonTextTile("角色编号", '',
                        controller: code,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    identity != null
                        ? const SizedBox()
                        : CommonWidget.commonChoiceTile(
                            "设置权限", selected?.metadata.name ?? "",
                            showLine: true, required: true, onTap: () {
                            PickerUtils.showListStringPicker(Get.context!,
                                titles: allAuth.map((e) => e.metadata.name??"").toList(),
                                callback: (str) {
                              state(() {
                                try {
                                  selected = allAuth.firstWhere(
                                      (element) => element.metadata.name == str);
                                } catch (e) {}
                              });
                            });
                          }, hint: "请选择"),
                    CommonWidget.commonTextTile("角色简介", '',
                        controller: remark,
                        showLine: true,
                        maxLine: 4,
                        hint: "请输入"),
                    CommonWidget.commonMultipleSubmitWidget(onTap1: () {
                      Navigator.pop(context);
                    }, onTap2: () {
                      if (name.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入角色名称");
                      } else if (code.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入角色编号");
                      } else if (selected == null && identity == null) {
                        ToastUtils.showMsg(msg: "请设置权限");
                      } else {
                        if (onCreate != null) {
                          onCreate(name.text, code.text, selected?.metadata.id ?? "",
                              remark.text);
                        }
                        Navigator.pop(context);
                      }
                    }),
                  ],
                ),
              );
            });
          }));
    },
  );
}

Future<void> showSearchDialog(BuildContext context, TargetType targetType,
    {String title = '', String hint = '',ValueChanged<List<XTarget>>? onSelected}) async {

  TextEditingController searchController = TextEditingController();

  List<XTarget> data = [];

  List<XTarget> selected = [];

  Widget item(XTarget item,{VoidCallback? onTap}) {
    bool isSelected = selected.contains(item);

    List<Widget> children = [];

    if(targetType == TargetType.person){
      children = [
        Row(
          children: [
            Text(item.name),
            SizedBox(
              width: 10.w,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 4.w),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                border: Border.all(color: Colors.blue,width: 0.5),
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Text("账号:${item.code}",style: TextStyle(fontSize: 14.sp,color: Colors.blue),),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("姓名:${item.name}"),
            Text("手机号:${item.code}"),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Text("座右铭:${item.remark??""}"),
      ];
    }
    if(targetType == TargetType.group || targetType == TargetType.company){
      children = [
        Row(
          children: [
            Text(item.name),
            SizedBox(
              width: 10.w,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 4.w),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                border: Border.all(color: Colors.blue,width: 0.5),
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Text("集团编码:${item.code}",style: TextStyle(fontSize: 14.sp,color: Colors.blue),),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Text("集团简介:${item.remark??""}"),
      ];
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        width: 400.w,
        decoration: BoxDecoration(
            color: isSelected?XColors.themeColor.withOpacity(0.2):Colors.white,
            borderRadius: BorderRadius.circular(4.w),
            border: Border.all(color: isSelected?XColors.themeColor:Colors.grey.shade400, width: 0.5)),
        padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }



  Future<List<XTarget>> search(String code) async {
    List<XTarget>? targets;
    switch (targetType) {
      case TargetType.group:
        // xTargetArray = await setting.company?.searchGroup(code);
        break;
      case TargetType.person:
        targets = await setting.user.searchTargets(code,[TargetType.person.label]);
        break;
      case TargetType.company:
      case TargetType.hospital:
      case TargetType.university:
      targets = await setting.user.searchTargets(code,[TargetType.company.label,TargetType.hospital.label,TargetType.university.label]);
        break;
    }
    return targets??[];
  }

  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          alignment: Alignment.center,
          child: Builder(builder: (context) {
            return StatefulBuilder(builder: (context, state) {
              return SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonWidget.commonHeadInfoWidget(title),
                    CommonWidget.commonSearchBarWidget(
                        controller: searchController,
                        onChanged: (code) async {
                          search(code).then((value) {
                            state(() {
                              data = value;
                            });
                          });
                        },hint: hint),
                    data.isEmpty
                        ? Container()
                        : SizedBox(
                           height: 400.h,
                            child: SingleChildScrollView(
                              child: Column(
                                children: data.map((e) {
                                  return item(e,onTap: (){
                                    state((){
                                         if(selected.contains(e)){
                                           selected.remove(e);
                                         }else{
                                           selected.add(e);
                                         }
                                    });
                                  });
                                }).toList(),
                              ),
                            ),
                          ),
                    CommonWidget.commonMultipleSubmitWidget(
                      onTap1: (){
                        Navigator.pop(context);
                      },
                      onTap2: (){
                        if(onSelected!=null){
                          onSelected(selected);
                        }
                        Navigator.pop(context);
                      }
                    ),
                  ],
                ),
              );
            });
          }));
    },
  );
}

Future<void> showCreateDictItemDialog(BuildContext context,
    {CreateDictChangeCallBack? onCreate,
    String name = '',
    String code = '',
    String remark = '',
    bool isEdit = false}) async {
  TextEditingController nameCtr = TextEditingController(text: name);
  TextEditingController codeCtr = TextEditingController(text: code);
  TextEditingController remarkCtr = TextEditingController(text: remark);

  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          alignment: Alignment.center,
          child: Builder(builder: (context) {
            return StatefulBuilder(builder: (context, state) {

              return SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonWidget.commonHeadInfoWidget(
                        "${isEdit ? "编辑" : "新增"}字典项"),
                    CommonWidget.commonTextTile("名称", '',
                        controller: nameCtr,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    CommonWidget.commonTextTile("值", '',
                        controller: codeCtr,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    CommonWidget.commonTextTile("备注", '',
                        controller: remarkCtr,
                        showLine: true,
                        maxLine: 4,
                        hint: "请输入"),
                    CommonWidget.commonMultipleSubmitWidget(onTap1: () {
                      Navigator.pop(context);
                    }, onTap2: () {
                      if (nameCtr.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入名称");
                      } else if (codeCtr.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入值");
                      } else {
                        if (onCreate != null) {
                          onCreate(nameCtr.text, codeCtr.text, remarkCtr.text);
                        }
                        Navigator.pop(context);
                      }
                    }),
                  ],
                ),
              );
            });
          }));
    },
  );
}

Future<void> showCreateDictDialog(BuildContext context,
    {CreateDictChangeCallBack? onCreate,bool isEdit = false,String name = '',String code = '',String remark = ''}) async {


  TextEditingController nameCtr = TextEditingController(text: name);
  TextEditingController codeCtr = TextEditingController(text: code);
  TextEditingController remarkCtr = TextEditingController(text: remark);


  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          alignment: Alignment.center,
          child: Builder(builder: (context) {
            return StatefulBuilder(builder: (context, state) {

              return SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonWidget.commonHeadInfoWidget(isEdit?"编辑":"新增"),
                    CommonWidget.commonTextTile("字典名称", '',
                        controller: nameCtr,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    CommonWidget.commonTextTile("字典代码", '',
                        controller: codeCtr,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    CommonWidget.commonTextTile("备注", '',
                        controller: remarkCtr,
                        showLine: true,
                        maxLine: 4,
                        hint: "请输入"),
                    CommonWidget.commonMultipleSubmitWidget(onTap1: () {
                      Navigator.pop(context);
                    }, onTap2: () {
                      if (nameCtr.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入名称");
                      } else if (codeCtr.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入字典代码");
                      } else {
                        if (onCreate != null) {
                          onCreate(nameCtr.text, codeCtr.text, remarkCtr.text);
                        }
                        Navigator.pop(context);
                      }
                    }),
                  ],
                ),
              );
            });
          }));
    },
  );
}

Future<void> showCreateFormDialog(BuildContext context,
    {CreateFormCallBack? onCreate,
    String name = '',
    String code = '',
    bool public = true,
    bool isEdit = false}) async {
  TextEditingController nameCrl = TextEditingController(text: name);
  TextEditingController codeCrl = TextEditingController(text: code);

  bool isPublic = public;
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          alignment: Alignment.center,
          child: Builder(builder: (context) {
            return StatefulBuilder(builder: (context, state) {
              return SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonWidget.commonHeadInfoWidget(isEdit ? "编辑" : "新增"),
                    CommonWidget.commonTextTile("字典名称", '',
                        controller: nameCrl,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    CommonWidget.commonTextTile("字典代码", '',
                        controller: codeCrl,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    CommonWidget.commonChoiceTile(
                        "向下组织公开", public ? "公开" : '不公开',
                        showLine: true, required: true, onTap: () {
                      PickerUtils.showListStringPicker(Get.context!,
                          titles: ['公开', "不公开"], callback: (str) {
                        state(() {
                          public = str == "公开";
                        });
                      });
                    }, hint: "请选择"),
                    CommonWidget.commonMultipleSubmitWidget(onTap1: () {
                      Navigator.pop(context);
                    }, onTap2: () {
                      if (nameCrl.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入名称");
                      } else if (codeCrl.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入字典代码");
                      } else {
                        if (onCreate != null) {
                          onCreate(nameCrl.text, codeCrl.text, isPublic);
                        }
                        Navigator.pop(context);
                      }
                    }),
                  ],
                ),
              );
            });
          }));
    },
  );
}

Future<void> showCreateOrganizationDialog(
    BuildContext context, List<TargetType> targetType,
    {String name = '',
    String code = '',
    String nickName = '',
    String identify = '',
    String remark = '',
    TargetType? type,CreateOrganizationChangeCallBack? callBack}) async {
  TextEditingController nameController = TextEditingController(text: name);
  TextEditingController codeController = TextEditingController(text: code);
  TextEditingController nickNameController =
      TextEditingController(text: nickName);
  TextEditingController identifyController =
      TextEditingController(text: identify);
  TextEditingController remarkController = TextEditingController(text: remark);

  TargetType selectedTarget = type ?? targetType.first;

  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          alignment: Alignment.center,
          child: Builder(builder: (context) {
            return StatefulBuilder(builder: (context, state) {
              return SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonWidget.commonHeadInfoWidget("新建"),
                    CommonWidget.commonTextTile("名称", '',
                        controller: nameController,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    CommonWidget.commonTextTile("代码", '',
                        controller: codeController,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    CommonWidget.commonTextTile("简称", '',
                        controller: nickNameController,
                        showLine: true,
                        hint: "请输入"),
                    CommonWidget.commonChoiceTile(
                        "选择制定组织", selectedTarget.label,
                        showLine: true, required: true, onTap: () {
                      PickerUtils.showListStringPicker(Get.context!,
                          titles: targetType.map((e) => e.label).toList(),
                          callback: (str) {
                        state(() {
                          try {
                            selectedTarget = targetType
                                .firstWhere((element) => element.label == str);
                          } catch (e) {}
                        });
                      });
                    }, hint: "请选择"),
                    CommonWidget.commonTextTile("标识", '',
                        controller: identifyController,
                        showLine: true,
                        hint: "请输入"),
                    CommonWidget.commonTextTile("备注", '',
                        controller: remarkController,
                        showLine: true,
                        maxLine: 4,
                        hint: "请输入"),
                    CommonWidget.commonMultipleSubmitWidget(onTap1: () {
                      Navigator.pop(context);
                    }, onTap2: () {
                      if (nameController.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入名称");
                      } else if (codeController.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入代码");
                      } else if (remarkController.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入简介");
                      } else {
                        if(callBack!=null){
                          callBack(nameController.text,codeController.text,nickNameController.text,identifyController.text,remarkController.text,selectedTarget);
                        }
                        Navigator.pop(context);
                      }
                    }),
                  ],
                ),
              );
            });
          }));
    },
  );
}

Future<void> showCreateAttributeDialog(BuildContext context,
    {CreateAttributeCallBack? onCreate,List<IDict> dictList =const [],
    bool isEdit = false,
    String name = '',
    String code = '',
    String remark = '',
    String valueType = '',String unit = '',Dict? dict}) async {
  TextEditingController nameCtr = TextEditingController(text: name);
  TextEditingController codeCtr = TextEditingController(text: code);
  TextEditingController unitCtr = TextEditingController(text: unit);
  TextEditingController remarkCtr = TextEditingController(text: remark);

  String type = valueType;
  IDict? dictValue = dict;

  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          alignment: Alignment.center,
          child: Builder(builder: (context) {
            return StatefulBuilder(builder: (context, state) {
              return SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonWidget.commonHeadInfoWidget(isEdit ? "编辑" : "新增"),
                    CommonWidget.commonTextTile("属性名称", '',
                        controller: nameCtr,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    CommonWidget.commonTextTile("属性代码", '',
                        controller: codeCtr,
                        showLine: true, enabled: true),
                    CommonWidget.commonChoiceTile("属性类型", type,
                        showLine: true, required: true, onTap: () {
                      PickerUtils.showListStringPicker(Get.context!,
                          titles: ValueType, callback: (str) {
                        state(() {
                          type = str;
                        });
                      });
                    }, hint: "请选择"),
                    type == "选择型"? CommonWidget.commonChoiceTile("选择枚举字典", dictValue?.metadata.name??"",
                        showLine: true, required: true, onTap: () {
                          PickerUtils.showListStringPicker(Get.context!,
                              titles: dictList.map((e) => e.metadata.name??"").toList(), callback: (str) {
                                state(() {
                                  dictValue = dictList.firstWhere((element) => element.metadata.name == str);
                                });
                              });
                        }, hint: "请选择"):const SizedBox(),
                    type == "数值型"? CommonWidget.commonTextTile("单位", '',
                        controller: unitCtr,
                        showLine: true,
                        required: true,
                        hint: "请输入"):const SizedBox(),
                    CommonWidget.commonTextTile("属性定义", '',
                        controller: remarkCtr,
                        showLine: true,
                        required: true,
                        maxLine: 4,
                        hint: "请输入"),
                    CommonWidget.commonMultipleSubmitWidget(onTap1: () {
                      Navigator.pop(context);
                    }, onTap2: () {
                      if (nameCtr.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入名称");
                      } else if(type.isEmpty){
                        ToastUtils.showMsg(msg: "请选择属性类型");
                      } else if(remarkCtr.text.isEmpty){
                        ToastUtils.showMsg(msg: "请输入属性定义");
                      } else if(type == "选择型" && dict == null){
                        ToastUtils.showMsg(msg: "请选择枚举字典");
                      } else if(type == "数值型" && unitCtr.text.isEmpty){
                        ToastUtils.showMsg(msg: "请输入单位");
                      }else{
                        if (onCreate != null) {
                          onCreate(nameCtr.text, codeCtr.text, type,remarkCtr.text,unitCtr.text,dictValue);
                        }
                        Navigator.pop(context);
                      }
                    }),
                  ],
                ),
              );
            });
          }));
    },
  );
}

Future<void> showCreateAttrDialog(BuildContext context,
    List<IAuthority> authoritys, List<XProperty> propertys,
    {CreateAttrCallBack? onCreate}) async {
  TextEditingController nameCtr = TextEditingController();
  TextEditingController codeCtr = TextEditingController();
  TextEditingController remarkCtr = TextEditingController();
  List<IAuthority> allAuth = getAllAuthority(authoritys);

  XProperty? property;
  IAuthority? authority;
  bool public = false;
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          alignment: Alignment.center,
          child: Builder(builder: (context) {
            return StatefulBuilder(builder: (context, state) {
              return SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonWidget.commonHeadInfoWidget("新增特性"),
                    CommonWidget.commonTextTile("特性名称", '',
                        controller: nameCtr,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    CommonWidget.commonTextTile("特性代码", '',
                        controller: codeCtr,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    CommonWidget.commonChoiceTile("选择属性", property?.name ?? "",
                        showLine: true, required: true, onTap: () {
                      PickerUtils.showListStringPicker(Get.context!,
                          titles: propertys.map((e) => e.name ?? "").toList(),
                          callback: (str) {
                        state(() {
                          property = propertys
                              .firstWhere((element) => element.name == str);
                        });
                      });
                    }, hint: "请选择"),
                    CommonWidget.commonChoiceTile(
                        "选择管理权限", authority?.metadata.name ?? "",
                        showLine: true, required: true, onTap: () {
                      PickerUtils.showListStringPicker(Get.context!,
                          titles: allAuth.map((e) => e.metadata.name ?? "").toList(),
                          callback: (str) {
                        state(() {
                          authority = authoritys
                              .firstWhere((element) => element.metadata.name == str);
                        });
                      });
                    }, hint: "请选择"),
                    CommonWidget.commonChoiceTile(
                        "向下组织公开", public ? "公开" : '不公开',
                        showLine: true, required: true, onTap: () {
                      PickerUtils.showListStringPicker(Get.context!,
                          titles: ['公开', "不公开"], callback: (str) {
                        state(() {
                          public = str == "公开";
                        });
                      });
                    }, hint: "请选择"),
                    CommonWidget.commonTextTile("特性定义", '',
                        controller: remarkCtr,
                        showLine: true,
                        maxLine: 4,
                        hint: "请输入"),
                    CommonWidget.commonMultipleSubmitWidget(onTap1: () {
                      Navigator.pop(context);
                    }, onTap2: () {
                      if (nameCtr.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入特性名称");
                      } else if (codeCtr.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入特性代码");
                      } else if (property == null) {
                        ToastUtils.showMsg(msg: "请选择属性");
                      } else if (authority == null) {
                        ToastUtils.showMsg(msg: "请选择管理权限");
                      } else {
                        if (onCreate != null) {
                          onCreate(nameCtr.text, codeCtr.text, remarkCtr.text,
                              property!, authority!, public);
                        }
                        Navigator.pop(context);
                      }
                    }),
                  ],
                ),
              );
            });
          }));
    },
  );
}

Future<void> showCreateWorkDialog(BuildContext context, List<ISpeciesItem> thing,
    {CreateWorkCallBack? onCreate,
    String name = '',
    String remark = '',
    bool create = false,
    List<String> selected = const [],
    bool isEdit = false}) async {
  TextEditingController nameCtr = TextEditingController(text: name);
  TextEditingController remarkCtr = TextEditingController(text: remark);


  List<ISpeciesItem> allThing = getAllSpecies(thing);
  bool isCreate = create;


  List<ISpeciesItem> selectedThing = [];

  if(selected.isNotEmpty){
    for (var value in selected) {
      selectedThing.add(allThing.firstWhere((element) => element.metadata.id == value));
    }
  }
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          alignment: Alignment.center,
          child: Builder(builder: (context) {
            return StatefulBuilder(builder: (context, state) {
              return SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonWidget.commonHeadInfoWidget(isEdit ? "编辑" : "新增"),
                    CommonWidget.commonTextTile("办事名称", '',
                        controller: nameCtr,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    isCreate?SizedBox():CommonWidget.commonChoiceTile(
                        "操作实体", selectedThing.map((e) => e.metadata.name).toList().join(','),
                        showLine: true, required: true, onTap: ()  {
                          showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MultiSelect(
                              items: allThing.map((e) => e.metadata.name).toList(), selected: selectedThing.map((e) => e.metadata.name).toList(),title: "选择操作实体",);
                        },
                      ).then((selectedStr){
                        if(selectedStr!=null){
                          state((){
                            selectedThing.clear();
                            for (var value in selectedStr) {
                              selectedThing.add(allThing.firstWhere((element) => element.metadata.name == value));
                            }
                          });
                        }
                      });

                    }, hint: "请选择操作实体"),
                    CommonWidget.commonChoiceTile(
                        "是否创建实体", isCreate ? "是" : '否',
                        showLine: true, required: true, onTap: () {
                      PickerUtils.showListStringPicker(Get.context!,
                          titles: ['是', "否"], callback: (str) {
                        state(() {
                          isCreate = str == "是";
                        });
                      });
                    }, hint: "请选择"),
                    CommonWidget.commonTextTile("备注", '',
                        controller: remarkCtr,
                        showLine: true,
                        maxLine: 4,
                        hint: "请输入"),
                    CommonWidget.commonMultipleSubmitWidget(onTap1: () {
                      Navigator.pop(context);
                    }, onTap2: () {
                      if (nameCtr.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入办事名称");
                      } else if (selectedThing.isEmpty && !isCreate) {
                        ToastUtils.showMsg(msg: "请选择操作实体");
                      } else {
                        if (onCreate != null) {
                          onCreate(nameCtr.text, remarkCtr.text, isCreate,
                              selectedThing);
                        }
                        Navigator.pop(context);
                      }
                    }),
                  ],
                ),
              );
            });
          }));
    },
  );
}

Future<void> showCreateAuthDialog(
    BuildContext context, List<ITarget> targets,
    {String name = '',
      String code = '',
      String remark = '',
      required ITarget target,bool public = false,bool isEdit = false,CreateAuthCallBack? callBack}) async {
  TextEditingController nameController = TextEditingController(text: name);
  TextEditingController codeController = TextEditingController(text: code);
  TextEditingController remarkController = TextEditingController(text: remark);

  bool isPublic = public;
  ITarget selectedTarget = target;

  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          alignment: Alignment.center,
          child: Builder(builder: (context) {
            return StatefulBuilder(builder: (context, state) {
              return SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonWidget.commonHeadInfoWidget("${isEdit?"编辑":"新增"}权限"),
                    CommonWidget.commonTextTile("名称", '',
                        controller: nameController,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    CommonWidget.commonTextTile("代码", '',
                        controller: codeController,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    CommonWidget.commonChoiceTile(
                        "选择制定组织", selectedTarget.metadata.name,
                        showLine: true, required: true, onTap: () {
                      PickerUtils.showListStringPicker(Get.context!,
                          titles: targets.map((e) => e.metadata.name).toList(),
                          callback: (str) {
                            state(() {
                              try {
                                selectedTarget = targets
                                    .firstWhere((element) => element.metadata.name == str);
                              } catch (e) {}
                            });
                          });
                    }, hint: "请选择"),
                    CommonWidget.commonChoiceTile(
                        "是否公开", isPublic ? "公开" : '不公开',
                        showLine: true, required: true, onTap: () {
                      PickerUtils.showListStringPicker(Get.context!,
                          titles: ['公开', "不公开"], callback: (str) {
                            state(() {
                              isPublic = str == "公开";
                            });
                          });
                    }, hint: "请选择"),
                    CommonWidget.commonTextTile("备注", '',
                        controller: remarkController,
                        showLine: true,
                        maxLine: 4,
                        hint: "请输入"),
                    CommonWidget.commonMultipleSubmitWidget(onTap1: () {
                      Navigator.pop(context);
                    }, onTap2: () {
                      if (nameController.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入名称");
                      } else if (codeController.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入代码");
                      } else if (remarkController.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入简介");
                      } else {
                        if(callBack!=null){
                          callBack(nameController.text,codeController.text,selectedTarget,isPublic,remarkController.text);
                        }
                        Navigator.pop(context);
                      }
                    }),
                  ],
                ),
              );
            });
          }));
    },
  );
}
