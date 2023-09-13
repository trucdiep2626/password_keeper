import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/injector/locators/app_locator.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/domain/models/password_model.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/controllers/password_generation_controller.dart';
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

  PasswordUseCase passwordUseCase;
  AccountUseCase accountUseCase;

  PasswordItem? lastItem;

  final CryptoController _cryptoController = Get.find<CryptoController>();
  final PasswordGenerationController _passwordGenerationController =
      getIt<PasswordGenerationController>();

  PasswordListController({
    required this.accountUseCase,
    required this.passwordUseCase,
  });

  Future<void> getPasswordList() async {
    try {
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
      _handleList();
    } catch (e) {
      logger(e.toString());
      showTopSnackBarError(context, e.toString());
    } finally {
      passwordListController.loadComplete();
    }
  }

  void _handleList() {
    if (passwords.isEmpty) return;
    for (int i = 0, length = passwords.length; i < length; i++) {
      String name = passwords[i].appName ?? passwords[i].url ?? '';
      String tag = name.substring(0, 1).toUpperCase();

      if (RegExp("[A-Z]").hasMatch(tag)) {
        passwords[i].tagIndex = tag;
      } else {
        passwords[i].tagIndex = "#";
      }
    }

    passwords.sort((a, b) {
      String aName = a.appName ?? a.url ?? '';
      String bName = b.appName ?? b.url ?? '';
      return aName.toUpperCase().compareTo(bName.toUpperCase());
    });

    // // A-Z sort.
    // SuspensionUtil.sortListBySuspensionTag(_contacts);
    //
    // // show sus tag.
    // SuspensionUtil.setShowSuspensionStatus(_contacts);
    //
    // // add header.
    // _contacts.insert(0, ContactInfo(name: 'header', tagIndex: '↑'));
    //
    // setState(() {});
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
        if ((passwordItem.appName ?? passwordItem.url ?? '')
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
    await Future.delayed(Duration(seconds: 5));

    double oldPosition = scrollController.position.pixels;
    await getPasswordList();
    if (searchController.text.isNotEmpty) {
      await onSearch(searchController.text);
    }
    scrollController.position.jumpTo(oldPosition);
  }

  goToDetail(PasswordItem passwordItem) async {
    // final result = await Get.toNamed(AppRoute.purchaseOrderDetail, arguments: {
    //   'id': purchaseOrderEntity.id,
    //   'order_number': purchaseOrderEntity.orderNumber,
    //   'status_id': purchaseOrderEntity.status
    // });
    // if (result['is_canceled'] || result['is_deposited']) {
    //   if (result['is_deposited']) {
    //     shouldRefresh.value = true;
    //   }
    //   await getPurchaseOrderList();
    // }
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