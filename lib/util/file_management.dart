



import 'package:orginone/dart/core/store/filesys.dart';
import 'package:orginone/dart/core/store/ifilesys.dart';

class FileManagement{
  static final FileManagement _instance = FileManagement._();

  factory FileManagement() => _instance;

  FileManagement._();

  IFileSystemItem?  _directory;

  IFileSystemItem? get directory => _directory;

  Future<void>  initFileDir() async{
     IFileSystemItem _root = getFileSysItemRoot;
     _directory = await _root.create("主目录");
     if(_directory!=null){
       await loadSubFileDir(_directory!);
     }
  }

  Future<void> loadSubFileDir(IFileSystemItem item) async{
     await item.loadChildren();
     if(item.children!=null && item.children!.isNotEmpty){
       for (var element in item.children!) {
         await loadSubFileDir(element);
       }
     }
  }
}