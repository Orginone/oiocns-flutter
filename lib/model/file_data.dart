class FileData {
  String? ossUrl;

  FileData({this.ossUrl});

  FileData.fromJson(Map<String, dynamic> json) {
    ossUrl = json['ossUrl'];
  }

  Map<String, dynamic> toJson() {
    return {"ossUrl": ossUrl};
  }
}
