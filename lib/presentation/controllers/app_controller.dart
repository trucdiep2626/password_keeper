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
import 'package:receive_intent/receive_intent.dart';

class AppController extends SuperController with MixinController {
  // late String uid;
  //Instance of Flutter Connectivity
  final Connectivity _connectivity = Connectivity();

  //Stream to keep listening to network change state
  late StreamSubscription _streamSubscription;

  StreamSubscription? _receiveIntentSubscription;

//  late final Rx<User?> firebaseUser;
  late final GoogleSignInAccount googleUser;

  RxBool isOpenApp = true.obs;

  AccountUseCase accountUseCase;

  AppController({required this.accountUseCase});

  @override
  void onInit() {
    super.onInit();
    getConnectionType();
    if (GetPlatform.isAndroid) _initReceiveIntentSubscription();
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen(_updateState);
  }

  @override
  void onReady() {
    super.onReady();

    //   firebaseUser = Rx<User?>(accountUseCase.user);
    // firebaseUser.bindStream(accountUseCase.authState);
    // _navigateScreen(firebaseUser.value);
    //ever(firebaseUser, _navigateScreen);
  }

  void _initReceiveIntentSubscription() async {
    _receiveIntentSubscription =
        ReceiveIntent.receivedIntentStream.listen((Intent? intent) {
      logger('Received intent: $intent');
      if (Get.context == null) {
        logger(
            'Nav context unexpectedly missing. Autofill navigation is likely to fail in strange ways.');
        return;
      }
      final mode = intent?.extra?['autofill_mode'];
      if (mode?.startsWith('/autofill') ?? false) {
        // BlocProvider.of<AutofillCubit>(navContext).refresh();
      }
    }, onError: (err) {
      logger('intent error: $err');
    });
  }

  _navigateScreen(User? user) {
    // if (user == null) {
    //   Get.offAllNamed(AppRoutes.login);
    // }
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
    _updateState(connectivityResult!);
  }

  _updateState(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      showTopSnackBarError(Get.context!, TranslationConstants.offline.tr);
    } else {
      if (isOpenApp.value) {
        isOpenApp.value = false;
        return;
      }

      showTopSnackBar(
          type: SnackBarType.done,
          Get.context!,
          message: TranslationConstants.internetRestore.tr);
    }
  }

  @override
  void onClose() {
    super.onClose();
    if (GetPlatform.isAndroid) unawaited(_receiveIntentSubscription?.cancel());
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
    Get.offAllNamed(AppRoutes.splash);
  }

  @override
  void onPaused() {
    logger('---------App State onPaused');
    Get.offAllNamed(AppRoutes.splash);
  }

  @override
  void onResumed() async {
    // //check internet connection
    // final isConnected = await checkConnectivity();
    // if (!isConnected) {
    //   return;
    // }
    //
    // accountUseCase.authState.listen((User? user) {
    //   if (user != null) {
    //     if (!user.emailVerified && Get.currentRoute != AppRoutes.verifyEmail) {
    //       Get.offAndToNamed(AppRoutes.verifyEmail);
    //     } else if (Get.currentRoute == AppRoutes.splash) {
    //       Get.offAndToNamed(AppRoutes.verifyMasterPassword);
    //     }
    //   } else if (Get.currentRoute != AppRoutes.login) {
    //     Get.offAndToNamed(AppRoutes.login);
    //   }
    // });
    logger('---------App State onResumed');
  }
}
