


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/market/model.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_utils.dart';

class Item extends StatelessWidget {

  final IProduct product;

  const Item({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.toNamed(Routers.applicationDetails,arguments: {"product":product});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200,width: 0.5),)
        ),
        padding: EdgeInsets.symmetric(
            vertical: 10.h, horizontal: 10.w),
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.w),
                  image: const DecorationImage(
                      image: NetworkImage(
                          "http://anyinone.com:888/img/logo/logo3.jpg"))),
            ),
            SizedBox(width: 20.w,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.prod.name??"",style: TextStyle(color: Colors.black,fontSize: 16.sp),maxLines: 1,overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 5.h,),
                  Text("备注:${product.prod.remark??""}",style: TextStyle(color: Colors.grey.shade400,fontSize: 14.sp,),maxLines: 1,overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 5.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("应用类型:${product.prod.typeName}",style:TextStyle(color: Colors.grey.shade500,fontSize: 14.sp,)),
                      Text(DateTime.tryParse(product.prod.createTime ?? "")!.format(format: "yyyy-MM-dd HH:mm"),style:TextStyle(color: Colors.grey.shade500,fontSize: 14.sp,))
                    ],
                  )
                ],
              ),
            ),
            SizedBox(width: 20.w,),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent,width: 1),
                borderRadius: BorderRadius.circular(16.w),
              ),
              padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 15.w),
              child: Text("更多",style: TextStyle(color: Colors.blueAccent,fontSize: 16.sp),),
            )
          ],
        ),
      ),
    );
  }
}
