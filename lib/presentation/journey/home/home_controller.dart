import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/domain/models/password_model.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/journey/main/main_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController with MixinController {
  AccountUseCase accountUsecase;
  PasswordUseCase passwordUseCase;

  Rx<LoadedType> rxLoadedHome = LoadedType.finish.obs;

  final _cryptoController = Get.find<CryptoController>();

  HomeController({
    required this.accountUsecase,
    required this.passwordUseCase,
  });

  User? get user => accountUsecase.user;

  RxInt totalPasswords = 0.obs;
  RxInt totalWeakPasswords = 0.obs;
  RxInt totalSafePasswords = 0.obs;
  RxInt totalReusePasswords = 0.obs;

  RxList<PasswordItem> allPasswords = <PasswordItem>[].obs;
  RxList<PasswordItem> recentUsedPasswords = <PasswordItem>[].obs;

  Map<String, int> passwordCounts = {};

  final RefreshController refreshController = RefreshController();

  @override
  Future<void> onReady() async {
    super.onReady();
    await initData();
  }

  Future<void> initData() async {
    //check internet connection
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      return;
    }

    try {
      rxLoadedHome.value = LoadedType.start;
      await getPasswordListLength();

      await getAllPasswords();

      await getRecentUsedPasswords();

      totalWeakPasswords.value = allPasswords
          .where((element) =>
              element.passwordStrengthLevel == PasswordStrengthLevel.weak ||
              element.passwordStrengthLevel == PasswordStrengthLevel.veryWeak)
          .length;

      totalSafePasswords.value =
          totalPasswords.value - totalWeakPasswords.value;

      totalReusePasswords.value = countReusedPasswords(allPasswords);
    } catch (e) {
      debugPrint(e.toString());
      showErrorMessage();
    } finally {
      refreshController.refreshCompleted();
      rxLoadedHome.value = LoadedType.finish;
    }
  }

  Future<void> goToWeakPasswords() async {
    final weakPasswords = allPasswords
        .where((element) =>
            element.passwordStrengthLevel == PasswordStrengthLevel.weak ||
            element.passwordStrengthLevel == PasswordStrengthLevel.veryWeak)
        .toList();
    await goToDetail(
      type: FilteredType.weak,
      passwords: weakPasswords,
    );
  }

  Future<void> goToSafePasswords() async {
    final safePasswords = allPasswords
        .where((element) =>
            element.passwordStrengthLevel == PasswordStrengthLevel.strong ||
            element.passwordStrengthLevel == PasswordStrengthLevel.good)
        .toList();
    await goToDetail(
      type: FilteredType.safe,
      passwords: safePasswords,
    );
  }

  Future<void> goToReusedPasswords() async {
    Map<String, List<PasswordItem>> reusedPasswords =
        <String, List<PasswordItem>>{};
    for (var item in passwordCounts.keys.toList()) {
      final reused =
          allPasswords.where((element) => element.password == item).toList();
      if (reused.length > 1) reusedPasswords.addAll({item: reused});
    }

    await goToDetail(
      type: FilteredType.reused,
      reusedPasswords: reusedPasswords,
      passwords:
          reusedPasswords.values.toList().expand((element) => element).toList(),
    );
  }

  void goToAllPasswords() {
    Get.find<MainController>().onChangedNav(1);
  }

  Future<void> goToDetail({
    required FilteredType type,
    List<PasswordItem>? passwords,
    Map<String, List<PasswordItem>>? reusedPasswords,
  }) async {
    final result =
        await Get.toNamed(AppRoutes.filteredPasswordList, arguments: {
      'type': type,
      'passwords': passwords,
      'reused_passwords': reusedPasswords,
    });
    if (result is bool && result) {
      await initData();
    }
  }

  Future<void> getPasswordListLength() async {
    totalPasswords.value =
        await passwordUseCase.getPasswordListLength(userId: user?.uid ?? '');
  }

  Future<void> getAllPasswords() async {
    final result = await passwordUseCase.getPasswordList(
      userId: user?.uid ?? '',
      pageSize: totalPasswords.value,
    );
    final decryptedList = await _cryptoController.decryptPasswordList(result);
    allPasswords.clear();
    allPasswords.addAll(decryptedList);
  }

  int countReusedPasswords(List<PasswordItem> passwordList) {
    passwordCounts.clear();
    for (var i = 0; i < passwordList.length; i++) {
      String password = passwordList[i].password ?? '';
      if (!passwordCounts.containsKey(password)) {
        passwordCounts.addAll({password: 1});
      } else if (passwordCounts.containsKey(password)) {
        passwordCounts[password] = (passwordCounts[password]! + 1);
      }
    }
    int reusedPasswords = 0;
    passwordCounts.values
        .forEach((count) => {if (count > 1) reusedPasswords += count});
    return reusedPasswords;
  }

  Future<void> getRecentUsedPasswords() async {
    // //check internet connection
    // final isConnected = await checkConnectivity();
    // if (!isConnected) {
    //   return;
    // }

    rxLoadedHome.value = LoadedType.start;

    try {
      final result = await passwordUseCase.getRecentUsedList(
        userId: user?.uid ?? '',
      );
      recentUsedPasswords.clear();
      recentUsedPasswords.addAll(result);
    } catch (e) {
      debugPrint(e.toString());
      showErrorMessage();
    } finally {
      rxLoadedHome.value = LoadedType.finish;
    }
  }

  Future<void> goToPasswordDetail(PasswordItem passwordItem) async {
    final result =
        await Get.toNamed(AppRoutes.passwordDetail, arguments: passwordItem);
    if (result is bool && result) {
      await Get.find<HomeController>().initData();
    }
  }
}
