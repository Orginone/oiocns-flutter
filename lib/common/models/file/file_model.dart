/// Model class for file
class FileModel {
  late String filePath;
  String? fileName;
  late FileType fileType;

  FileModel({required this.filePath, this.fileName, required this.fileType});

  FileModel.fromJson(Map<String, dynamic> json) {
    filePath = json['filePath'];
    fileName = json['fileName'];
    fileType = json['fileType'];
  }

  Map<String, dynamic> toJson() {
    return {"filePath": filePath, "fileName": fileName, "fileType": fileType};
  }
}

enum FileType {
  pdf,
  word,
  ppt,
  image,
}
