



import 'package:get/get.dart';
import 'package:orginone/dart/core/store/filesys.dart';
import 'package:orginone/dart/core/store/ifilesys.dart';

class StoreController {
  String currentKey = '';
  IObjectItem? _home;
  IFileSystemItem _root = getFileSysItemRoot;
  constructor() async{
    if(_home == null){
      _home = await _root.create('主目录');
    }
  }
  /** 根目录 */
  IFileSystemItem get root{
  return _root;
  }
  IObjectItem? get home{
     return _home;
  }
}