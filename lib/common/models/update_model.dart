class UpdateModel {
  String? title;
  String? content;
  String version;
  bool force;

  UpdateModel({
    this.title,
    this.content,
    required this.version,
    required this.force,
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json) => UpdateModel(
        title: json['title'] as String?,
        content: json['content'] as String?,
        version: json['version'] as String,
        force: json['force'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'version': version,
        'force': force,
      };
}
// class UpdateModel {
//   String? sysName;
//   String? sysDescription;
//   String? updateDescription;
//   String sysVersion;
//   String? loginIcon;
//   String? navigationIcon;
//   String? logoIcon;
//   String? appIcon;
//   int? forceUpdate;

//   UpdateModel({
//     this.sysName,
//     this.sysDescription,
//     this.updateDescription,
//     required this.sysVersion,
//     this.loginIcon,
//     this.navigationIcon,
//     this.logoIcon,
//     this.appIcon,
//     this.forceUpdate,
//   });

//   factory UpdateModel.fromJson(Map<String, dynamic> json) => UpdateModel(
//         sysName: json['sysName'] as String?,
//         forceUpdate: json['forceUpdate'] as int?,
//         sysDescription: json['sysDescription'] as String?,
//         updateDescription: json['updateDescription'] as String?,
//         sysVersion: json['sysVersion'] as String,
//         loginIcon: json['loginIcon'] as String?,
//         navigationIcon: json['navigationIcon'] as String?,
//         logoIcon: json['logoIcon'] as String?,
//         appIcon: json['appIcon'] as String?,
//       );

//   Map<String, dynamic> toJson() => {
//         'sysName': sysName,
//         'sysDescription': sysDescription,
//         'updateDescription': updateDescription,
//         'sysVersion': sysVersion,
//         'loginIcon': loginIcon,
//         'navigationIcon': navigationIcon,
//         'logoIcon': logoIcon,
//         'appIcon': appIcon,
//         'forceUpdate': forceUpdate,
//       };
// }
