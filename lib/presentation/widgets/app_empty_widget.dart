// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:password_keeper/common/common_export.dart';
//
// import 'app_image_widget.dart';
//
// class AppEmptyWidget extends StatelessWidget {
//   final String? title;
//   final Widget? child;
//
//   const AppEmptyWidget({
//     Key? key,
//     this.title,
//     this.child,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           AppImageWidget(
//             width: Get.width / 3,
//             path: ImageConstants.empty,
//           ),
//           SizedBox(
//             height: AppDimens.space_8,
//           ),
//           Text(title ?? StringConstants.emptyData.tr),
//           SizedBox(
//             height: AppDimens.space_18,
//           ),
//           SizedBox(width: Get.width * 2/3, child: child ?? const SizedBox.shrink()),
//         ],
//       ),
//     );
//   }
// }
