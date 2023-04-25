import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/authority/iauthority.dart';
import 'package:orginone/dart/core/target/authority/iidentity.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/bottom_sheet_dialog.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/unified.dart';

import 'config.dart';

typedef IdentityChangeCallBack = Function(
    String name, String code, String remark);

typedef CreateDictChangeCallBack
    = Function(String name, String code, String remark, {bool? public});

typedef CreateOrganizationChangeCallBack = Function(String name, String code,
    String nickName, String identify, String remark, TargetType type);

typedef CreateIdentityCallBack = Function(
    String name, String code, String authID, String remark);

typedef CreateAttributeChangeCallBack = Function(
  String name,
  String code,
  String valueType,
  String remark,
);

SettingController get setting => Get.find();

Future<void> showEditIdentityDialog(IIdentity identity, BuildContext context,
    {IdentityChangeCallBack? callBack}) async {
  TextEditingController name = TextEditingController(text: identity.name);
  TextEditingController code =
      TextEditingController(text: identity.target.code);
  TextEditingController remark =
      TextEditingController(text: identity.target.remark);
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          alignment: Alignment.center,
          child: Builder(builder: (context) {
            return SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonWidget.commonHeadInfoWidget("编辑"),
                  CommonWidget.commonTextTile("角色名称", '',
                      controller: name, showLine: true, required: true),
                  CommonWidget.commonTextTile("角色编号", '',
                      controller: code, showLine: true, required: true),
                  CommonWidget.commonTextTile("角色简介", '',
                      controller: remark, showLine: true, maxLine: 4),
                  CommonWidget.commonMultipleSubmitWidget(onTap1: () {
                    Navigator.pop(context);
                  }, onTap2: () {
                    if (name.text.isEmpty) {
                      ToastUtils.showMsg(msg: "请输入角色名称");
                    } else if (code.text.isEmpty) {
                      ToastUtils.showMsg(msg: "请输入角色编号");
                    } else {
                      if (callBack != null) {
                        callBack(name.text, code.text, remark.text);
                      }
                      Navigator.pop(context);
                    }
                  }),
                ],
              ),
            );
          }));
    },
  );
}

Future<void> showCreateIdentityDialog(BuildContext context,List<IAuthority> authority,
    {CreateIdentityCallBack? onCreate}) async {



  List<IAuthority> allAuth = getAllAuthority(authority);

  TextEditingController name = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController remark = TextEditingController();

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
                    CommonWidget.commonHeadInfoWidget("新增"),
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
                    CommonWidget.commonChoiceTile("设置权限", selected?.name ?? "",
                        showLine: true, required: true, onTap: () {
                      PickerUtils.showListStringPicker(Get.context!,
                          titles: allAuth.map((e) => e.name).toList(),
                          callback: (str) {
                        state(() {
                          try {
                            selected = allAuth
                                .firstWhere((element) => element.name == str);
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
                      } else if (selected==null) {
                        ToastUtils.showMsg(msg: "请设置权限");
                      } else {
                        if (onCreate != null) {
                          onCreate(name.text, code.text,selected!.id,remark.text);
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
            Text("姓名:${item.team?.name}"),
            Text("手机号:${item.team?.code}"),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Text("座右铭:${item.team?.remark??""}"),
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
        Text("集团简介:${item.team?.remark??""}"),
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
    XTargetArray? xTargetArray;
    switch (targetType) {
      case TargetType.group:
        // xTargetArray = await setting.company?.searchGroup(code);
        break;
      case TargetType.person:
        xTargetArray = await setting.user.searchPerson(code);
        break;
      case TargetType.company:
      case TargetType.hospital:
      case TargetType.university:
        xTargetArray = await setting.user.searchCompany(code);
        break;
    }
    if (xTargetArray != null) {
      return xTargetArray.result ?? [];
    }
    return [];
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
    {CreateDictChangeCallBack? onCreate}) async {


  TextEditingController name = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController remark = TextEditingController();


  bool public = true;
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
                    CommonWidget.commonHeadInfoWidget("新增"),
                    CommonWidget.commonTextTile("字典名称", '',
                        controller: name,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    CommonWidget.commonTextTile("字典代码", '',
                        controller: code,
                        showLine: true,
                        required: true,
                        hint: "请输入"),
                    CommonWidget.commonChoiceTile("向下组织公开", public?"公开":'不公开',
                        showLine: true, required: true, onTap: () {
                          PickerUtils.showListStringPicker(Get.context!,
                              titles:['公开',"不公开"],
                              callback: (str) {
                                state(() {
                                  public =  str == "公开";
                                });
                              });
                        }, hint: "请选择"),
                    CommonWidget.commonTextTile("备注", '',
                        controller: remark,
                        showLine: true,
                        maxLine: 4,
                        hint: "请输入"),
                    CommonWidget.commonMultipleSubmitWidget(onTap1: () {
                      Navigator.pop(context);
                    }, onTap2: () {
                      if (name.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入名称");
                      } else if (code.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入字典代码");
                      } else {
                        if (onCreate != null) {
                          onCreate(name.text, code.text, remark.text,
                              public: public);
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
    {CreateAttributeChangeCallBack? onCreate,
    bool isEdit = false,
    String name = '',
    String code = '',
    String remark = '',String valueType = ''}) async {
  TextEditingController nameCtr = TextEditingController(text: name);
  TextEditingController codeCtr = TextEditingController(text: code);
  TextEditingController remarkCtr = TextEditingController(text: remark);

  String type = valueType;
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
                    CommonWidget.commonTextTile("字典代码", '',
                        controller: codeCtr,
                        showLine: true,
                        required: true,
                        hint: "请输入",enabled: !isEdit),
                    CommonWidget.commonChoiceTile("属性类型", type,
                        showLine: true, required: true, onTap: () {
                      PickerUtils.showListStringPicker(Get.context!,
                          titles: ValueType, callback: (str) {
                        state(() {
                          type = str;
                        });
                      });
                    }, hint: "请选择"),
                    CommonWidget.commonTextTile("属性定义", '',
                        controller: remarkCtr,
                        showLine: true,
                        maxLine: 4,
                        hint: "请输入"),
                    CommonWidget.commonMultipleSubmitWidget(onTap1: () {
                      Navigator.pop(context);
                    }, onTap2: () {
                      if (nameCtr.text.isEmpty) {
                        ToastUtils.showMsg(msg: "请输入名称");
                      } else if (codeCtr.text.isEmpty && !isEdit) {
                        ToastUtils.showMsg(msg: "请输入字典代码");
                      } else if(type.isEmpty){
                        ToastUtils.showMsg(msg: "请选择属性类型");
                      } else if(remarkCtr.text.isEmpty){
                        ToastUtils.showMsg(msg: "请选择属性类型");
                      } else{
                        if (onCreate != null) {
                          onCreate(nameCtr.text, codeCtr.text, type,remarkCtr.text);
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
