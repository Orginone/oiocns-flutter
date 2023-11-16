// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:orginone/dart/base/model.dart';
// import 'package:orginone/pages/chat/widgets/info_item.dart';

// import 'file_detail.dart';
// import 'image_detail.dart';

// class UploadingDetail extends StatelessWidget {
//   final FileItemShare message;
//   final bool isSelf;

//   const UploadingDetail(
//       {super.key, required this.isSelf, required this.message});

//   @override
//   Widget build(BuildContext context) {
//     String extension = message.extension ?? "";
//     double progress = 0; //message.progress ?? 0;
//     Widget body;
//     if (imageExtension.contains(extension.toLowerCase())) {
//       body = ImageDetail(
//         isSelf: isSelf,
//         message: message,
//         showShadow: true,
//       );
//     } else {
//       body = FileDetail(
//         isSelf: isSelf,
//         message: message,
//         showShadow: true,
//       );
//     }

//     Widget gradient = Stack(
//       alignment: Alignment.center,
//       fit: StackFit.passthrough,
//       children: [
//         body,
//         Text(
//           '${(progress * 100).toStringAsFixed(0)}%',
//           style: TextStyle(color: Colors.white, fontSize: 24.sp),
//         ),
//       ],
//     );
//     return gradient;
//   }
// }
