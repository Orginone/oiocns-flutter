/// 欢迎数据 Model
class WelcomeModel {
  /// 图片url
  String? image;

  /// 标题
  String? title;

  /// 说明
  String? desc;

  WelcomeModel({this.image, this.title, this.desc});

  factory WelcomeModel.fromJson(Map<String, dynamic> json) => WelcomeModel(
        image: json['image'] as String?,
        title: json['title'] as String?,
        desc: json['desc'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'image': image,
        'title': title,
        'desc': desc,
      };
}
