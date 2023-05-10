


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/thing/filesys/filesystem.dart';
import 'package:orginone/widget/file_image_widget.dart';

class Item extends StatelessWidget {
  final IFileSystemItem file;
  final VoidCallback? onTap;
  const Item({Key? key, required this.file, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.shade200,width: 0.5))
        ),
        padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
        child: Row(
          children: [
            FileImageWidget(file: file,size: 40.w,),
            SizedBox(width: 15.w,),
            Expanded(child: Text(file.metadata.name??"",maxLines: 1,overflow: TextOverflow.ellipsis,),),
            popupMenuButton(),
            more(),
          ],
        ),
      ),
    );
  }

  Widget more() {
    if (file.children?.isNotEmpty??false) {
      return Icon(
        Icons.navigate_next,
        size: 32.w,
      );
    }
    return const SizedBox();
  }

  Widget popupMenuButton(){
    List<PopupMenuItem> children = [];
    if(file.metadata.isDirectory??false){
      children = [
        const PopupMenuItem(value: "createDir",child: Text("新建文件夹"),),
        const PopupMenuItem(value: "refreshDir",child: Text("刷新文件夹"),),
        const PopupMenuItem(value: "uploadFile",child: Text("上传文件"),),
        const PopupMenuItem(value: "deleteDir",child: Text("删除文件夹"),),
      ];
    }else{
      children = [
        const PopupMenuItem(value: "deleteFile",child: Text("删除文件"),),
      ];
    }

    return PopupMenuButton(
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
