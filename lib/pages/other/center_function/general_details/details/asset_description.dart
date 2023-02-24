


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/pages/other/center_function/general_details/state.dart';
import 'package:orginone/widget/custom_paint.dart';

class AssetDescription{
 static Widget transferDescription(GeneralDetailsState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      bottom:
                      BorderSide(color: Colors.grey.shade200, width: 0.5)),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 30.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 0.5),
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: NetworkImage(
                                "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/default-avatar1.png",
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 0.5,
                          height: 40.h,
                          color: Colors.blue,
                        ),
                        Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 0.5),
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: NetworkImage(
                                "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/default-avatar1.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "移交人",
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 16.sp),
                            ),
                            Text(
                              state.assetUse!.oldUserId??"",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "接收人",
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 16.sp),
                            ),
                            Text(
                              state.assetUse!.keeperId??"",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                // child: CustomPaint(
                //   painter: CustomAssetsListItemButton(Colors.deepOrangeAccent),
                //   size: Size(100.w, 40.h),
                //   child: Container(
                //     width: 100.w,
                //     height: 40.h,
                //     alignment: Alignment.center,
                //     child: Text(
                //       "退回",
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 24.sp,
                //       ),
                //     ),
                //   ),
                // ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h,),
        Row(
          children: [
            Text(
              "移交原因",
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              state.assetUse!.applyRemark??"",
              style: TextStyle(fontSize: 16.sp, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }


 static Widget handOverDescription(GeneralDetailsState state) {
   return Column(
     children: [
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Expanded(
             flex: 2,
             child: Container(
               decoration: BoxDecoration(
                 border: Border(
                     bottom:
                     BorderSide(color: Colors.grey.shade200, width: 0.5)),
               ),
               child: Row(
                 children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Container(
                         width: 30.w,
                         height: 30.h,
                         decoration: BoxDecoration(
                           border: Border.all(color: Colors.blue, width: 0.5),
                           shape: BoxShape.circle,
                           image: const DecorationImage(
                             image: NetworkImage(
                               "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/default-avatar1.png",
                             ),
                           ),
                         ),
                       ),
                       Container(
                         width: 0.5,
                         height: 40.h,
                         color: Colors.blue,
                       ),
                       Container(
                         width: 40.w,
                         height: 40.h,
                         decoration: BoxDecoration(
                           border: Border.all(color: Colors.blue, width: 0.5),
                           shape: BoxShape.circle,
                           image: const DecorationImage(
                             image: NetworkImage(
                               "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/default-avatar1.png",
                             ),
                           ),
                         ),
                       ),
                     ],
                   ),
                   SizedBox(
                     width: 10.w,
                   ),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             "交回人",
                             style: TextStyle(
                                 color: Colors.grey.shade300, fontSize: 16.sp),
                           ),
                           Text(
                             state.assetUse!.submitterName??"",
                             style: TextStyle(
                                 color: Colors.black,
                                 fontSize: 20.sp,
                                 fontWeight: FontWeight.w500),
                           ),
                         ],
                       ),
                       SizedBox(
                         height: 30.h,
                       ),
                       Column(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             "接收人",
                             style: TextStyle(
                                 color: Colors.grey.shade300, fontSize: 16.sp),
                           ),
                           Text(
                             state.assetUse!.userName??"",
                             style: TextStyle(
                                 color: Colors.black,
                                 fontSize: 20.sp,
                                 fontWeight: FontWeight.w500),
                           ),
                         ],
                       )
                     ],
                   ),
                 ],
               ),
             ),
           ),
           Expanded(
             child: Container(
               alignment: Alignment.centerRight,
               // child: CustomPaint(
               //   painter: CustomAssetsListItemButton(Colors.deepOrangeAccent),
               //   size: Size(100.w, 40.h),
               //   child: Container(
               //     width: 100.w,
               //     height: 40.h,
               //     alignment: Alignment.center,
               //     child: Text(
               //       "退回",
               //       style: TextStyle(
               //         color: Colors.white,
               //         fontSize: 24.sp,
               //       ),
               //     ),
               //   ),
               // ),
             ),
           ),
         ],
       ),
       SizedBox(height: 10.h,),
       Row(
         children: [
           Text(
             "交回原因",
             style: TextStyle(fontSize: 16.sp, color: Colors.grey),
           ),
           SizedBox(
             width: 5.w,
           ),
           Text(
             state.assetUse!.applyRemark??"",
             style: TextStyle(fontSize: 16.sp, color: Colors.black),
           ),
         ],
       ),
     ],
   );
 }


 static Widget claimDescription(GeneralDetailsState state) {
    return Row(
      children: [
        Text(
          "申请理由",
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
        SizedBox(
          width: 5.w,
        ),
        Text(
          state.assetUse?.applyRemark??"",
          style: TextStyle(fontSize: 16.sp, color: Colors.black),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            // child: CustomPaint(
            //   painter: CustomAssetsListItemButton(Colors.deepOrangeAccent),
            //   size: Size(100.w, 40.h),
            //   child: Container(
            //     width: 100.w,
            //     height: 40.h,
            //     alignment: Alignment.center,
            //     child: Text(
            //       "退回",
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 24.sp,
            //       ),
            //     ),
            //   ),
            // ),
          ),
        )
      ],
    );
  }

 static Widget disposeDescription(GeneralDetailsState state) {
   return Column(
     children: [
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Expanded(
             flex: 2,
             child: Container(
               padding: EdgeInsets.symmetric(vertical: 5.h),
               decoration: BoxDecoration(
                 border: Border(
                     bottom:
                     BorderSide(color: Colors.grey.shade200, width: 0.5)),
               ),
               child: Row(
                 children: [
                   Text("处置方式",style: TextStyle(color: Colors.grey,fontSize: 16.sp),),
                   SizedBox(width: 5.w,),
                   Text(DisposeTyep[state.assetUse!.way!],style: TextStyle(color: Colors.black,fontSize: 16.sp),),
                 ],
               ),
             ),
           ),
           Expanded(
             child: Container(
               alignment: Alignment.centerRight,
               // child: CustomPaint(
               //   painter: CustomAssetsListItemButton(Colors.deepOrangeAccent),
               //   size: Size(100.w, 40.h),
               //   child: Container(
               //     width: 100.w,
               //     height: 40.h,
               //     alignment: Alignment.center,
               //     child: Text(
               //       "退回",
               //       style: TextStyle(
               //         color: Colors.white,
               //         fontSize: 24.sp,
               //       ),
               //     ),
               //   ),
               // ),
             ),
           ),
         ],
       ),
       Row(
         children: [
           Text(
             "申请原因",
             style: TextStyle(fontSize: 16.sp, color: Colors.grey),
           ),
           SizedBox(
             width: 5.w,
           ),
           Text(
             state.assetUse!.applyRemark??"",
             style: TextStyle(fontSize: 16.sp, color: Colors.black),
           ),
         ],
       ),
     ],
   );
 }
}