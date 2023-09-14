import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/models/password_model.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/password_list/password_list_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_refresh_widget.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class PasswordListScreen extends GetView<PasswordListController> {
  const PasswordListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBar(
        backgroundColor: AppColors.blue400,
        title: Text(
          TranslationConstants.passwords.tr,
          style: ThemeText.bodySemibold.colorWhite.s16,
        ),
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
                  child:
                      // AzListView(
                      //   data: controller.displayPasswords,
                      //   itemCount: controller.displayPasswords.length,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return _buildItem(controller.displayPasswords[index]);
                      //   },
                      //   physics: NeverScrollableScrollPhysics(),
                      //   indexBarData: SuspensionUtil.getTagIndexList(
                      //       controller.displayPasswords),
                      //   indexHintBuilder: (context, hint) {
                      //     return Container(
                      //       alignment: Alignment.center,
                      //       width: 60.0,
                      //       height: 60.0,
                      //       decoration: BoxDecoration(
                      //         color: Colors.blue[700]!.withAlpha(200),
                      //         shape: BoxShape.circle,
                      //       ),
                      //       child: Text(hint,
                      //           style: TextStyle(
                      //               color: Colors.white, fontSize: 30.0)),
                      //     );
                      //   },
                      //   indexBarMargin: EdgeInsets.all(10),
                      //   indexBarOptions: IndexBarOptions(
                      //     needRebuild: true,
                      //     decoration: BoxDecoration(
                      //         color: AppColors.grey50,
                      //         borderRadius: BorderRadius.circular(20.0),
                      //         border: Border.all(
                      //             color: Colors.grey[300]!, width: .5)),
                      //     downDecoration: BoxDecoration(
                      //         color: AppColors.grey50,
                      //         borderRadius: BorderRadius.circular(20.0),
                      //         border: Border.all(
                      //             color: Colors.grey[300]!, width: .5)),
                      //   ),
                      // )
                      CustomScrollView(
                    controller: controller.scrollController,
                    shrinkWrap: true,
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            controller.rxLoadedList.value == LoadedType.start
                                ? _buildShimmerList()
                                : (controller.displayPasswords.isEmpty
                                    ? _buildEmptyList()
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
              borderRadius: BorderRadius.circular(AppDimens.radius_12)),
          child: ListTile(
            leading: _buildAppIcon(item),
            title: Text(
              item.signInLocation   ?? '',
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

  Widget _buildAppIcon(PasswordItem item) {
    if (item.appIcon != null) {
      return AppImageWidget(
        bytes: item.appIcon!,
        padding: EdgeInsets.all(AppDimens.space_2),
        backgroundColor: AppColors.white,
        size: AppDimens.space_36,
        margin: EdgeInsets.all(AppDimens.space_4),
        borderRadius: BorderRadius.circular(4),
      );
    }

    final firstLetter = (item.signInLocation ?? '').isURL
        ? (item.signInLocation ?? '').split('.').first[0]
        : (item.signInLocation ?? '')[0];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.all(AppDimens.space_2),
      margin: EdgeInsets.all(AppDimens.space_4),
      width: AppDimens.space_36,
      height: AppDimens.space_36,
      alignment: Alignment.center,
      child: Text(
        firstLetter,
        style: ThemeText.bodyStrong.s24.blue400,
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

  Widget _buildEmptyList() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: AppDimens.space_32, horizontal: AppDimens.space_16),
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
