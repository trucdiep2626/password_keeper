import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/injector/locators/app_locator.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/domain/models/generated_password_item.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/controllers/password_generation_controller.dart';
import 'package:password_keeper/presentation/widgets/snack_bar/app_snack_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GeneratedPasswordHistoryController extends GetxController
    with MixinController {
  Rx<LoadedType> rxLoadedHistory = LoadedType.finish.obs;
  RxList<GeneratedPasswordItem> history = <GeneratedPasswordItem>[].obs;
  int displayedItems = 0;
  RxBool canLoadMore = true.obs;
  int totalItems = 0;
  int pageSize = 10;

  final RefreshController historyController = RefreshController();
  final scrollController = ScrollController();

  PasswordUseCase passwordUseCase;
  AccountUseCase accountUseCase;

  GeneratedPasswordItem? lastItem;

  final PasswordGenerationController _passwordGenerationController =
      getIt<PasswordGenerationController>();

  GeneratedPasswordHistoryController({
    required this.accountUseCase,
    required this.passwordUseCase,
  });

  Future<void> getHistory() async {
    try {
      //check internet connection
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return;
      }

      final result = await passwordUseCase.getGeneratedPasswordHistory(
        userId: accountUseCase.user?.uid ?? '',
        lastItem: lastItem,
        pageSize: pageSize,
      );

      lastItem = result.isEmpty ? null : result.last;

      final decryptHistory =
          await _passwordGenerationController.decryptHistory(history: result);

      displayedItems += decryptHistory.length;
      canLoadMore.value = displayedItems < totalItems;
      pageSize =
          (totalItems - displayedItems) < 10 ? totalItems - displayedItems : 10;

      history.addAll(decryptHistory);
    } catch (e) {
      logger(e.toString());
      showTopSnackBarError(context, e.toString());
    } finally {
      historyController.loadComplete();
    }
  }

  Future<void> getHistoryLength() async {
    try {
      //check internet connection
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return;
      }

      final result = await passwordUseCase.getGeneratedPasswordHistoryLength(
        userId: accountUseCase.user?.uid ?? '',
      );
      totalItems = result;
    } catch (e) {
      logger(e.toString());
      showTopSnackBarError(context, e.toString());
    } finally {
      historyController.loadComplete();
    }
  }

  Future<void> onRefresh() async {
    rxLoadedHistory.value = LoadedType.start;
    displayedItems = 0;
    pageSize = 10;
    lastItem = null;
    history.clear();
    await getHistory();
    historyController.refreshCompleted();
    rxLoadedHistory.value = LoadedType.finish;
  }

  @override
  void onReady() async {
    await getHistoryLength();
    await onRefresh();
  }
}
