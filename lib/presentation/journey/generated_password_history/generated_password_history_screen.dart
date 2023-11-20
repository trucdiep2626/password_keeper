import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/models/generated_password_item.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/generated_password_history/generated_password_history_controller.dart';
import 'package:password_keeper/presentation/journey/settings/settings_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_appbar.dart';
import 'package:password_keeper/presentation/widgets/app_refresh_widget.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class GeneratedPasswordHistoryScreen
    extends GetView<GeneratedPasswordHistoryController> {
  const GeneratedPasswordHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Listener(
      onPointerDown: Get.find<SettingsController>().handleUserInteraction,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBarWidget(
          showBackButton: true,
          title: TranslationConstants.history.tr,
        ),
        body: Obx(
          () => AppRefreshWidget(
            enableLoadMore: controller.canLoadMore.value,
            footer: Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimens.space_4),
              child: AppLoadingWidget(
                width: Get.width / 5,
              ),
            ),
            onLoadMore: () async {
              double oldPosition = controller.scrollController.position.pixels;
              await controller.getHistory();
              controller.scrollController.position.jumpTo(oldPosition);
            },
            onRefresh: controller.onRefresh,
            controller: controller.historyController,
            child: Padding(
              padding: EdgeInsets.all(AppDimens.space_16),
              child: CustomScrollView(
                controller: controller.scrollController,
                shrinkWrap: true,
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        controller.rxLoadedHistory.value == LoadedType.start
                            ? _buildShimmerList()
                            : Column(
                                children: controller.history
                                    .map((e) => _buildItem(e))
                                    .toList(),
                              )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(GeneratedPasswordItem item) {
    return Container(
        padding: EdgeInsets.symmetric(
          vertical: AppDimens.space_12,
          horizontal: AppDimens.space_16,
        ),
        margin: EdgeInsets.symmetric(
          vertical: AppDimens.space_4,
        ),
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.password ?? '',
                    style: ThemeText.bodyMedium,
                  ),
                  SizedBox(
                    height: AppDimens.space_8,
                  ),
                  Text(
                    millisecondToDateTimeString(
                        millisecond: item.createdAt ?? 0),
                    style: ThemeText.bodyRegular.s12.grey600Color,
                  )
                ],
              ),
            ),
            SizedBox(
              width: AppDimens.space_16,
            ),
            AppTouchable(
              onPressed: () async {
                await copyText(text: item.password ?? '');
              },
              child: AppImageWidget(
                asset: Assets.images.svg.icCopy,
                size: AppDimens.space_30,
              ),
            ),
          ],
        ));
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
        trailing: AppShimmer(
          height: AppDimens.space_24,
          width: AppDimens.space_24,
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
