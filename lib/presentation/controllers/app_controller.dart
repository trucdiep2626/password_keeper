import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:password_keeper/common/config/app_config.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/domain/models/logged_in_device.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/auto_fill_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:receive_intent/receive_intent.dart';

class AppController extends SuperController with MixinController {
  // late String uid;
  //Instance of Flutter Connectivity
  final Connectivity _connectivity = Connectivity();

  //Stream to keep listening to network change state
  late StreamSubscription _streamSubscription;

  StreamSubscription? _receiveIntentSubscription;

  StreamSubscription? _changedMasterPwdSubscription;

  late final Rx<User?> firebaseUser;
  late final GoogleSignInAccount googleUser;

  User? get user => accountUseCase.user;

  RxBool isOpenApp = true.obs;

  AccountUseCase accountUseCase;
  PasswordUseCase passwordUseCase;
  FirebaseFirestore db;
  FirebaseMessaging fbMessaging;

  AppController({
    required this.accountUseCase,
    required this.passwordUseCase,
    required this.fbMessaging,
    required this.db,
  });

  final _autofillController = Get.find<AutofillController>();

  DateTime? stopAt;

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

    firebaseUser = Rx<User?>(accountUseCase.user);
    firebaseUser.bindStream(accountUseCase.authState);
    _handleChangeMasterPwd(firebaseUser.value);
    ever(firebaseUser, _handleChangeMasterPwd);
  }

  void _initReceiveIntentSubscription() async {
    logger('initReceiveIntentSubscription');
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
        _autofillController
            .refreshAutofilll()
            .then((value) => navigateWhenVerified());
      }
    }, onError: (err) {
      logger('intent error: $err');
    });
  }

  Future<void> navigateWhenVerified() async {
    final autofillController = Get.find<AutofillController>();
    logger(
        '--------------${autofillController.autofillState.value} ------${autofillController.enableAutofillService.value}----${(autofillController.forceInteractive ?? false)}');

    if (autofillController.isAutofillSaving()) {
      Get.toNamed(AppRoutes.addEditPassword);
    } else {
      Get.offAllNamed(AppRoutes.main);
    }
  }

  _handleChangeMasterPwd(User? user) async {
    if (user != null && user.emailVerified) {
      log('init changed master pwd subscription');
      final deviceId = await fbMessaging.getToken();
      _changedMasterPwdSubscription = db
          .collection(AppConfig.userCollection)
          .doc(user.uid)
          .collection(AppConfig.devicesCollection)
          .doc(deviceId)
          .snapshots()
          .listen((event) async {
        final data = event.data();
        if (!isNullEmpty(data) && data!['show_changed_master_password']) {
          log('  changed master pwd  ');
          await accountUseCase.forceLock();
          await passwordUseCase.updateLoggedInDevice(
            userId: user.uid,
            loggedInDevice: LoggedInDevice(
                deviceId: deviceId ?? '', showChangedMasterPassword: false),
          );
          if (Get.currentRoute != AppRoutes.verifyMasterPassword) {
            Get.offAllNamed(AppRoutes.verifyMasterPassword);
          }
        }
      });
    } else if (user == null) {
      _changedMasterPwdSubscription?.cancel();
    }
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
    //    if (result == ConnectivityResult.none) {
    //      showTopSnackBarError(Get.context!, TranslationConstants.offline.tr);
    //    } else {
    //      if (isOpenApp.value) {
    //        isOpenApp.value = false;
    //        return;
    //      }
    //
    // if(Get.context != null)
    //   {
    //     showTopSnackBar(
    //         type: SnackBarType.done,
    //         Get.context!,
    //         message: TranslationConstants.internetRestore.tr);
    //   }
    //   }
  }

  @override
  void onClose() {
    super.onClose();
    if (GetPlatform.isAndroid) unawaited(_receiveIntentSubscription?.cancel());
    //stop listening to network state when app is closed
    _streamSubscription.cancel();
    _changedMasterPwdSubscription?.cancel();
  }

  @override
  void onDetached() {
    logger('---------App State onDetached');
  }

  @override
  void onInactive() {
    logger('---------App State onInactive');
    // Get.offAllNamed(AppRoutes.splash);
    stopAt = DateTime.now();
  }

  @override
  void onPaused() {
    logger('---------App State onPaused');
    //  Get.offAllNamed(AppRoutes.splash);
    stopAt = DateTime.now();
  }

  @override
  void onResumed() async {
    // if (stopAt != null) {
    //   final diff = DateTime.now().difference(stopAt!);
    //   if (diff.inSeconds > 10) {
    //     log('lockkkk');
    //     Get.offAllNamed(AppRoutes.splash);
    //   }
    // }
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
