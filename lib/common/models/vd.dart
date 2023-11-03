class ValueDesModel {
  int? value;
  String? desc;

  ValueDesModel({this.value, this.desc});

  factory ValueDesModel.fromJson(Map<String, dynamic> json) => ValueDesModel(
        value: json['value'] as int?,
        desc: json['desc'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'value': value,
        'desc': desc,
      };
}
