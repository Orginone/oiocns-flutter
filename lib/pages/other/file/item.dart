


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/thing/filesys/filesystem.dart';
import 'package:orginone/widget/file_image_widget.dart';

class Item extends BaseBreadcrumbNavItem<BaseBreadcrumbNavModel> {

  final PopupMenuItemSelected? onSelected;

  final VoidCallback? onNext;

  final VoidCallback? onTap;
  Item( {required super.item,this.onSelected,this.onNext, this.onTap,});

  @override
  Widget build(BuildContext context) {
    IFileSystemItem file = item.source;
    return GestureDetector(
      onTap: () {
        if (onNext != null) {
          onNext!();
        } else if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
        child: Row(
          children: [
            FileImageWidget(
              size: 60.w,
              file: file,
            ),
            Expanded(
              child: title(),
            ),
            popupMenuButton(file),
            more(),
          ],
        ),
      ),
    );
  }

  Widget popupMenuButton(IFileSystemItem file) {
    List<PopupMenuItem> children = [];
    if(file.metadata.isDirectory){
      children = [
        const PopupMenuItem(value: "createDir",child: Text("新建文件夹"),),
        const PopupMenuItem(value: "refreshDir",child: Text("刷新文件夹"),),
        const PopupMenuItem(value: "rename",child: Text("重命名文件"),),
        const PopupMenuItem(value: "uploadFile",child: Text("上传文件"),),
        const PopupMenuItem(value: "deleteDir",child: Text("删除文件夹"),),
      ];
    }else{
      children = [
        const PopupMenuItem(value: "rename",child: Text("重命名文件"),),
        const PopupMenuItem(value: "deleteFile",child: Text("删除文件"),),
      ];
    }

    return PopupMenuButton(
      onSelected: onSelected,
      icon:Icon(
        Icons.more_vert_outlined,
        size: 32.w,
      ),
      itemBuilder: (BuildContext context){
        return children;
      },
    );
  }
}
