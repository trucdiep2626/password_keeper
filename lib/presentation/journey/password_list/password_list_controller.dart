import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/domain/models/password_model.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/auto_fill_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/journey/home/home_controller.dart';
import 'package:password_keeper/presentation/widgets/snack_bar/app_snack_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PasswordListController extends GetxController with MixinController {
  Rx<LoadedType> rxLoadedList = LoadedType.finish.obs;
  RxList<PasswordItem> passwords = <PasswordItem>[].obs;
  RxList<PasswordItem> displayPasswords = <PasswordItem>[].obs;

  RxBool canLoadMore = true.obs;

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  int displayedItems = 0;
  int totalItems = 0;
  int pageSize = 10;

  final RefreshController passwordListController = RefreshController();
  final scrollController = ScrollController();

  final autofillController = Get.find<AutofillController>();

  PasswordUseCase passwordUseCase;
  AccountUseCase accountUseCase;

  PasswordItem? lastItem;

  PasswordListController({
    required this.accountUseCase,
    required this.passwordUseCase,
  });

  Future<void> getPasswordList() async {
    try {
      //check internet connection
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return;
      }

      final result = await passwordUseCase.getPasswordList(
        userId: accountUseCase.user?.uid ?? '',
        lastItem: lastItem,
        pageSize: pageSize,
      );

      lastItem = result.isEmpty ? null : result.last;

      displayedItems += result.length;
      canLoadMore.value = displayedItems < totalItems;
      pageSize =
          (totalItems - displayedItems) < 10 ? totalItems - displayedItems : 10;

      passwords.addAll(result);

      ///  _handleList();
    } catch (e) {
      logger(e.toString());
      showTopSnackBarError(context, e.toString());
    } finally {
      passwordListController.loadComplete();
    }
  }

  Future<void> getPasswordListLength() async {
    try {
      final result = await passwordUseCase.getPasswordListLength(
        userId: accountUseCase.user?.uid ?? '',
      );
      totalItems = result;
    } catch (e) {
      logger(e.toString());
      showTopSnackBarError(context, e.toString());
    }
  }

  Future<void> onRefresh() async {
    rxLoadedList.value = LoadedType.start;
    displayedItems = 0;
    pageSize = 10;
    lastItem = null;
    passwords.clear();
    await getPasswordListLength();
    await getPasswordList();
    await onSearch(searchController.text);
    passwordListController.refreshCompleted();
    rxLoadedList.value = LoadedType.finish;
  }

  Future<void> onSearch(String value) async {
    rxLoadedList.value = LoadedType.start;
    if (value.isNotEmpty) {
      List<PasswordItem> resultPassworrdList = [];
      for (PasswordItem passwordItem in passwords) {
        if ((passwordItem.signInLocation ?? '')
                .toUpperCase()
                .contains(value.toUpperCase()) ||
            (passwordItem.userId ?? '')
                .toUpperCase()
                .contains(value.toUpperCase())) {
          resultPassworrdList.add(passwordItem);
        }
      }
      displayPasswords.value = resultPassworrdList;
    } else {
      displayPasswords.value = passwords;
    }
    rxLoadedList.value = LoadedType.finish;
  }

  Future<void> onLoadMore() async {
    double oldPosition = scrollController.position.pixels;
    await getPasswordList();
    if (searchController.text.isNotEmpty) {
      await onSearch(searchController.text);
    }
    scrollController.position.jumpTo(oldPosition);
  }

  goToDetail(PasswordItem passwordItem) async {
    final result =
        await Get.toNamed(AppRoutes.passwordDetail, arguments: passwordItem);
    if (result is bool && result) {
      await onRefresh();
      await Get.find<HomeController>().initData();
    }
  }

  autofill(PasswordItem passwordItem) async {
    if (autofillController.forceInteractive ?? false) {
      autofillController.autofillInstantly(passwordItem);
    } else {
      autofillController.autofillWithListOfOneEntry(passwordItem);
    }
  }

  @override
  void onReady() async {
    await getPasswordListLength();
    await onRefresh();
    searchController.addListener(() {
      if (isNullEmpty(searchController.text.trim())) {
        displayPasswords.value = passwords;
      }
    });
  }
}
