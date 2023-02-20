

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/unified.dart';

class CheckDialog{
  static Future<void> showInventoryDialog(BuildContext context,{String title = "",ValueChanged<String>? onSubmit}){
    TextEditingController textEditingController = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.w)),
            child: SizedBox(
              height: 200.h,
              width: 150.w,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade200, width: 0.5)),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade200, width: 0.5)),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "备注",
                            style: TextStyle(
                                color: Colors.black, fontSize: 16.sp),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 8.w),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.shade200, width: 0.5),
                                borderRadius: BorderRadius.circular(4.w),
                              ),
                              child:  TextField(
                                controller: textEditingController,
                                maxLines: 4,
                                maxLength: 50,
                                decoration: const InputDecoration(
                                    isDense: true,
                                    hintText: "请输入备注",
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50.h,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text("取消"),
                            ),
                            onTap:(){
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Container(height: 50.h,width: 0.5,color: Colors.grey.shade200,),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              if(onSubmit!=null){
                                onSubmit(textEditingController.text);
                              }
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                  child: const Text(
                                    "确定",
                                    style:
                                    TextStyle(color: XColors.themeColor),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },);
  }


  static Future<void> showAllInventoryDialog(BuildContext context,{VoidCallback? onSubmit}) {
    return showDialog(context: context, builder: (context){
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.w)),
          child: SizedBox(
            height: 200.h,
            width: 150.w,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.shade200, width: 0.5)),
                  ),
                  child: Text(
                    "盘点信息确认",
                    style: TextStyle(color: Colors.black, fontSize: 20.sp),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade200, width: 0.5)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("盘存：11，未盘存：197"),
                        Text("未盘点将自动算为盘存"),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text("取消"),
                          ),
                          onTap:(){
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Container(height: 50.h,width: 0.5,color: Colors.grey.shade200,),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            if(onSubmit!=null){
                              onSubmit();
                            }
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: GestureDetector(
                                child: const Text(
                                  "确定",
                                  style:
                                  TextStyle(color: XColors.themeColor),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}