

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/filesys/filesystem.dart';

class FileState extends BaseGetState{
   var file = Rxn<IFileSystemItem>();

   var selectedDir = <IFileSystemItem>[].obs;

   var title = ''.obs;

   TextEditingController searchController = TextEditingController();

   FileState(){
     file.value = Get.arguments?['file'];
   }
}