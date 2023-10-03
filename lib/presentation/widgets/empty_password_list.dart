import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class EmptyPasswordList extends StatelessWidget {
  const EmptyPasswordList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppDimens.space_32,
        horizontal: AppDimens.space_16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppImageWidget(
            asset: Assets.images.svg.icEmpty,
            size: Get.width / 2,
            color: AppColors.grey400,
          ),
          SizedBox(
            height: AppDimens.space_24,
          ),
          Text(
            TranslationConstants.passwordListEmpty.tr,
            style: ThemeText.bodyMedium.grey400Color.s16,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
