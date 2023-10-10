import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/models/password_model.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/filtered_password_list/filtered_password_list_controller.dart';
import 'package:password_keeper/presentation/journey/settings/settings_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_appbar.dart';
import 'package:password_keeper/presentation/widgets/app_icon_widget.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class FilteredPasswordListScreen
    extends GetView<FilteredPasswordListController> {
  const FilteredPasswordListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Listener(
      onPointerDown: Get.find<SettingsController>().handleUserInteraction,
      child: Obx(
        () => Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBarWidget(
              showBackButton: true,
              title: controller.title.value,
            ),
            body: Padding(
              padding: EdgeInsets.all(AppDimens.space_16),
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: controller.type == FilteredType.reused
                    ? _buildReusedList(controller.reusedPasswords)
                    : [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return _buildItem(
                                passwordItem: controller.passwords[index],
                                index: index,
                              );
                            },
                            childCount: controller.passwords.length,
                          ),
                        ),
                      ],
              ),
            )),
      ),
    );
  }

  List<Widget> _buildReusedList(
      Map<String, List<PasswordItem>> reusedPasswords) {
    List<Widget> items = [];
    for (var element in reusedPasswords.values) {
      items.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: AppDimens.space_16),
            child: Text(
              '${element.length} ${TranslationConstants.signInLocationsApps.tr}',
              style: ThemeText.bodyMedium.grey600Color,
            ),
          ),
        ),
      );
      items.add(
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int i) {
              final index = controller.passwords.indexOf(element[i]);
              return _buildItem(
                passwordItem: element[i],
                index: index,
              );
            },
            childCount: element.length,
          ),
        ),
      );
    }
    return items;
  }

  Widget _buildItem({
    required PasswordItem passwordItem,
    required int index,
  }) {
    return Container(
      margin: EdgeInsets.only(
        bottom: AppDimens.space_16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.radius_12),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            offset: const Offset(0, 0),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: EdgeInsets.all(AppDimens.space_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getSignInLocation(passwordItem),
          SizedBox(
            height: AppDimens.space_12,
          ),
          Text(
            TranslationConstants.userId.tr,
            style: ThemeText.bodyRegular.s10.grey500Color,
          ),
          SizedBox(
            height: AppDimens.space_4,
          ),
          Text(
            passwordItem.userId ?? '',
            style: ThemeText.bodyMedium,
          ),
          SizedBox(
            height: AppDimens.space_12,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TranslationConstants.password.tr,
                    style: ThemeText.bodyRegular.s10.grey500Color,
                  ),
                  SizedBox(
                    height: AppDimens.space_4,
                  ),
                  Obx(() => Text(
                        controller.showPasswordInList.value[index]
                            ? passwordItem.password ?? ''
                            : '•••••••••••••',
                        style: ThemeText.bodyMedium,
                      )),
                ],
              ),
              const Spacer(),
              AppTouchable(
                onPressed: () => controller.onChangeShowPasswordInList(index),
                child: Obx(() => AppImageWidget(
                      fit: BoxFit.scaleDown,
                      size: AppDimens.space_24,
                      asset: controller.showPasswordInList.value[index]
                          ? Assets.images.svg.icEyeSlash
                          : Assets.images.svg.icEye,
                      color: AppColors.grey,
                    )),
              ),
            ],
          ),
          SizedBox(
            height: AppDimens.space_12,
          ),
          Center(
            child: AppTouchable(
              onPressed: () => controller.goToDetail(passwordItem),
              backgroundColor: AppColors.blue200.withOpacity(0.2),
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.space_12,
                vertical: AppDimens.space_8,
              ),
              child: Text(
                TranslationConstants.viewDetail.tr,
                style: ThemeText.bodyMedium.s12.blue400,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getSignInLocation(PasswordItem item) {
    return Row(
      children: [
        AppIconWidget(
          item: item,
        ),
        SizedBox(
          width: AppDimens.space_16,
        ),
        Text(
          item.signInLocation ?? '',
          style: ThemeText.bodyMedium,
        ),
      ],
    );
  }
}
