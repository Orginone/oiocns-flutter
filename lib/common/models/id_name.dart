class IdName {
  String? id;
  String? name;

  IdName({this.id, this.name});

  factory IdName.fromJson(Map<String, dynamic> json) {
    return IdName(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
