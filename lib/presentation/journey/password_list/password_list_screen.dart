import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/models/password_model.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/password_list/password_list_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_appbar.dart';
import 'package:password_keeper/presentation/widgets/app_icon_widget.dart';
import 'package:password_keeper/presentation/widgets/app_refresh_widget.dart';
import 'package:password_keeper/presentation/widgets/empty_password_list.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class PasswordListScreen extends GetView<PasswordListController> {
  const PasswordListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: TranslationConstants.passwords.tr,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppDimens.space_16),
        child: Column(
          children: [
            //  SizedBox(height: AppDimens.space_16),
            _buildSearchTextField(),
            SizedBox(height: AppDimens.space_16),
            Expanded(
              child: Obx(
                () => AppRefreshWidget(
                  enableLoadMore: controller.canLoadMore.value,
                  footer: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppDimens.space_4),
                    child: AppLoadingWidget(
                      width: Get.width / 5,
                    ),
                  ),
                  onLoadMore: () async => await controller.onLoadMore(),
                  onRefresh: controller.onRefresh,
                  controller: controller.passwordListController,
                  child: CustomScrollView(
                    controller: controller.scrollController,
                    shrinkWrap: true,
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            controller.rxLoadedList.value == LoadedType.start
                                ? _buildShimmerList()
                                : (controller.displayPasswords.isEmpty
                                    ? const EmptyPasswordList()
                                    : Column(
                                        children: controller.displayPasswords
                                            .map((e) => _buildItem(e))
                                            .toList(),
                                      )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTextField() {
    return AppTextField(
      prefixIcon: AppImageWidget(
        asset: Assets.images.svg.icSearch,
        color: AppColors.blue400,
      ),
      borderRadius: AppDimens.radius_12,
      hintText: TranslationConstants.search.tr,
      controller: controller.searchController,
      onChangedText: (value) => controller.onSearch(value),
      focusNode: controller.searchFocusNode,
    );
  }

  Widget _buildItem(PasswordItem item) {
    return AppTouchable(
      onPressed: () {
        FocusScope.of(controller.context).unfocus();
        controller.goToDetail(item);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimens.space_4),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimens.radius_12),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.05),
                offset: const Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ListTile(
            leading: AppIconWidget(item: item),
            title: Text(
              item.signInLocation ?? '',
              style: ThemeText.bodyMedium,
            ),
            subtitle: Text(
              item.userId ?? '',
              style: ThemeText.bodyRegular.s12.grey600Color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.space_4),
      child: ListTile(
        title: AppShimmer(
          height: AppDimens.space_8,
          width: AppDimens.space_72,
        ),
        subtitle: AppShimmer(
          height: AppDimens.space_8,
          width: AppDimens.space_48,
        ),
        leading: AppShimmer(
          height: AppDimens.space_36,
          width: AppDimens.space_36,
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Column(
      children: [
        _buildShimmerItem(),
        _buildShimmerItem(),
        _buildShimmerItem(),
        _buildShimmerItem(),
        _buildShimmerItem(),
        _buildShimmerItem(),
        _buildShimmerItem(),
        _buildShimmerItem(),
      ],
    );
  }
}
