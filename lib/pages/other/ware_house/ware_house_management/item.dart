


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/market/model.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/images.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/util/toast_utils.dart';

class ApplicationItem extends StatelessWidget {

  final IProduct product;

  const ApplicationItem({Key? key, required this.product}) : super(key: key);

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


class GbItem extends StatelessWidget {
  final ISpeciesItem item;

  final VoidCallback? next;

  final bool showPopupMenu;

  final VoidCallback? onTap;
  const GbItem(
      {Key? key,
        required this.item,
        this.next, this.showPopupMenu = true, this.onTap,
       })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(item.children.isNotEmpty){
          if(next!=null){
            next!();
          }
        }else{
          ToastUtils.showMsg(msg: "已经到底了");
        }
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 0.5)),
          ),
          child: Row(
            children: [
              Expanded(
                child: title(),
              ),
              popupMenuButton(),
              more(),
            ],
          ),
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      width: double.infinity,
      color: Colors.white,
      child: Text(
        item.name,
        style: TextStyle(fontSize: 18.sp, color: Colors.black),
      ),
    );
  }

  Widget more() {
    return GestureDetector(
      onTap: (){
        if(onTap!=null){
          onTap!();
        }else{
          Get.toNamed(Routers.thing,arguments: {"id":item.id,"title":item.name});
        }
      },
      child: Icon(
        Icons.navigate_next,
        size: 32.w,
      ),
    );
  }

  Widget popupMenuButton(){
    if(!showPopupMenu){
      return Container();
    }
    return PopupMenuButton(
      icon:Icon(
        Icons.more_vert_outlined,
        size: 32.w,
      ),
      itemBuilder: (BuildContext context){
        return [
          const PopupMenuItem(value: "createThing",child: Text("新建文件夹"),),
          const PopupMenuItem(value: "createThing",child: Text("刷新文件夹"),),
          const PopupMenuItem(value: "createThing",child: Text("上传文件"),),
          const PopupMenuItem(value: "createThing",child: Text("创建实体"),),
        ];
      },
    );
  }
}
