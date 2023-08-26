import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class AppController extends SuperController with MixinController {
  late String uid;
  //Instance of Flutter Connectivity
  final Connectivity _connectivity = Connectivity();

  //Stream to keep listening to network change state
  late StreamSubscription _streamSubscription;

  late final Rx<User?> firebaseUser;
  late final GoogleSignInAccount googleUser;

  AccountUseCase accountUseCase;

  AppController({required this.accountUseCase});

  @override
  void onInit() {
    super.onInit();
    getConnectionType();
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen(_updateState);
  }

  @override
  void onReady() {
    firebaseUser = Rx<User?>(accountUseCase.user);
    firebaseUser.bindStream(accountUseCase.authState);
    _navigateScreen(firebaseUser.value);
    //ever(firebaseUser, _navigateScreen);
  }

  _navigateScreen(User? user) {
    if (user == null) {
      Get.offAllNamed(AppRoutes.login);
    }
    // else if (!user.emailVerified) {
    //   Get.offAllNamed(AppRoutes.verifyEmail);
    // }
  }

  // a method to get which connection result, if you we connected to internet or no if yes then which network
  Future<void> getConnectionType() async {
    ConnectivityResult? connectivityResult;
    try {
      connectivityResult = await (_connectivity.checkConnectivity());
    } on PlatformException catch (e) {
      log(e.toString());
    }
    return _updateState(connectivityResult!);
  }

  _updateState(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      showTopSnackBarError(Get.context!, TranslationConstants.offline.tr);
    } else {
      showTopSnackBar(
          type: SnackBarType.done,
          Get.context!,
          message: TranslationConstants.internetRestore.tr);
    }
  }

  @override
  void onClose() {
    super.onClose();
    //stop listening to network state when app is closed
    _streamSubscription.cancel();
  }

  @override
  void onDetached() {
    logger('---------App State onDetached');
  }

  @override
  void onInactive() {
    logger('---------App State onInactive');
  }

  @override
  void onPaused() {
    logger('---------App State onPaused');
  }

  @override
  void onResumed() {
    logger('---------App State onResumed');
  }
}
