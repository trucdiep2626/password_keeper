import 'package:biometric_storage/biometric_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:password_keeper/common/constants/shared_preferences_constants.dart';
import 'package:password_keeper/data/account_repository.dart';
import 'package:password_keeper/data/local_repository.dart';
import 'package:password_keeper/data/password_repository.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/local_usecase.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/app_controller.dart';
import 'package:password_keeper/presentation/controllers/auto_fill_controller.dart';
import 'package:password_keeper/presentation/controllers/biometric_controller.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/password_generation_controller.dart';
import 'package:password_keeper/presentation/controllers/screen_capture_controller.dart';
import 'package:password_keeper/presentation/journey/add_edit_password/add_edit_password_controller.dart';
import 'package:password_keeper/presentation/journey/change_master_password/change_master_password_controller.dart';
import 'package:password_keeper/presentation/journey/create_master_password/create_master_password_controller.dart';
import 'package:password_keeper/presentation/journey/filtered_password_list/filtered_password_list_controller.dart';
import 'package:password_keeper/presentation/journey/generated_password_history/generated_password_history_controller.dart';
import 'package:password_keeper/presentation/journey/home/home_controller.dart';
import 'package:password_keeper/presentation/journey/login/login_controller.dart';
import 'package:password_keeper/presentation/journey/main/main_controller.dart';
import 'package:password_keeper/presentation/journey/password_detail/password_detail_controller.dart';
import 'package:password_keeper/presentation/journey/password_generator/password_generator_controller.dart';
import 'package:password_keeper/presentation/journey/password_list/password_list_controller.dart';
import 'package:password_keeper/presentation/journey/register/register_controller.dart';
import 'package:password_keeper/presentation/journey/reset_password/reset_password_controller.dart';
import 'package:password_keeper/presentation/journey/settings/settings_controller.dart';
import 'package:password_keeper/presentation/journey/signin_location/signin_location_controller.dart';
import 'package:password_keeper/presentation/journey/splash/splash_controller.dart';
import 'package:password_keeper/presentation/journey/verify_email/verify_email_controller.dart';
import 'package:password_keeper/presentation/journey/verify_master_password/verify_master_password_controller.dart';

GetIt getIt = GetIt.instance;

void configLocator() {
  /// Controllers
  getIt.registerLazySingleton<AppController>(() => AppController(
        accountUseCase: getIt<AccountUseCase>(),
        passwordUseCase: getIt<PasswordUseCase>(),
        fbMessaging: getIt<FirebaseMessaging>(),
        db: getIt<FirebaseFirestore>(),
      ));
  getIt.registerFactory<SplashController>(
      () => SplashController(accountUseCase: getIt<AccountUseCase>()));
  getIt.registerFactory<MainController>(() => MainController(
        accountUseCase: getIt<AccountUseCase>(),
        fbMessaging: getIt<FirebaseMessaging>(),
      ));
  getIt.registerFactory<HomeController>(() => HomeController(
        accountUsecase: getIt<AccountUseCase>(),
        passwordUseCase: getIt<PasswordUseCase>(),
      ));
  getIt.registerFactory<PasswordGeneratorController>(
      () => PasswordGeneratorController(
            passwordUseCase: getIt<PasswordUseCase>(),
            accountUseCase: getIt<AccountUseCase>(),
          ));
  getIt.registerFactory<RegisterController>(
      () => RegisterController(accountUsecase: getIt<AccountUseCase>()));
  getIt.registerFactory<LoginController>(() => LoginController(
        fbMessaging: getIt<FirebaseMessaging>(),
        accountUsecase: getIt<AccountUseCase>(),
        passwordUseCase: getIt<PasswordUseCase>(),
      ));
  getIt.registerFactory<CreateMasterPasswordController>(
      () => CreateMasterPasswordController(
            accountUsecase: getIt<AccountUseCase>(),
            passwordUseCase: getIt<PasswordUseCase>(),
            fbMessaging: getIt<FirebaseMessaging>(),
          ));
  getIt.registerFactory<ChangeMasterPasswordController>(
      () => ChangeMasterPasswordController(
            accountUsecase: getIt<AccountUseCase>(),
            passwordUseCase: getIt<PasswordUseCase>(),
            localUseCase: getIt<LocalUseCase>(),
          ));
  getIt.registerFactory<VerifyMasterPasswordController>(
      () => VerifyMasterPasswordController(
            fbMessaging: getIt<FirebaseMessaging>(),
            accountUseCase: getIt<AccountUseCase>(),
            localUseCase: getIt<LocalUseCase>(),
            passwordUseCase: getIt<PasswordUseCase>(),
          ));
  getIt.registerFactory<VerifyEmailController>(
      () => VerifyEmailController(accountUseCase: getIt<AccountUseCase>()));
  getIt.registerFactory<GeneratedPasswordHistoryController>(
      () => GeneratedPasswordHistoryController(
            passwordUseCase: getIt<PasswordUseCase>(),
            accountUseCase: getIt<AccountUseCase>(),
          ));
  getIt.registerFactory<SignInLocationController>(
      () => SignInLocationController());
  getIt.registerFactory<AddEditPasswordController>(
      () => AddEditPasswordController(
            passwordUseCase: getIt<PasswordUseCase>(),
            accountUseCase: getIt<AccountUseCase>(),
          ));
  getIt.registerFactory<PasswordListController>(() => PasswordListController(
        passwordUseCase: getIt<PasswordUseCase>(),
        accountUseCase: getIt<AccountUseCase>(),
      ));
  getIt
      .registerFactory<PasswordDetailController>(() => PasswordDetailController(
            passwordUseCase: getIt<PasswordUseCase>(),
            accountUseCase: getIt<AccountUseCase>(),
          ));
  getIt.registerFactory<SettingsController>(() => SettingsController(
        accountUseCase: getIt<AccountUseCase>(),
        localUseCase: getIt<LocalUseCase>(),
        passwordUseCase: getIt<PasswordUseCase>(),
      ));
  getIt.registerFactory<ResetPasswordController>(() => ResetPasswordController(
        accountUseCase: getIt<AccountUseCase>(),
      ));
  getIt.registerFactory<FilteredPasswordListController>(
      () => FilteredPasswordListController());

  ///helper
  getIt.registerLazySingleton<CryptoController>(() => CryptoController(
        accountUseCase: getIt<AccountUseCase>(),
        localUseCase: getIt<LocalUseCase>(),
      ));
  getIt.registerLazySingleton<PasswordGenerationController>(() =>
      PasswordGenerationController(passwordUseCase: getIt<PasswordUseCase>()));
  getIt.registerLazySingleton<BiometricController>(
      () => BiometricController(localUseCase: getIt<LocalUseCase>()));
  getIt.registerLazySingleton<ScreenCaptureController>(
      () => ScreenCaptureController(accountUseCase: getIt<AccountUseCase>()));
  getIt.registerLazySingleton<AutofillController>(() => AutofillController());

  /// UseCases
  getIt.registerFactory<AccountUseCase>(() => AccountUseCase(
        accountRepo: getIt<AccountRepository>(),
        localRepo: getIt<LocalRepository>(),
      ));
  getIt.registerFactory<PasswordUseCase>(
      () => PasswordUseCase(passwordRepository: getIt<PasswordRepository>()));
  getIt.registerFactory<LocalUseCase>(
      () => LocalUseCase(localRepository: getIt<LocalRepository>()));

  /// Repositories
  getIt.registerFactory<AccountRepository>(() => AccountRepository(
        auth: getIt<FirebaseAuth>(),
        db: getIt<FirebaseFirestore>(),
      ));
  getIt.registerFactory<PasswordRepository>(() => PasswordRepository(
        //hiveServices: getIt<HiveServices>(),
        db: getIt<FirebaseFirestore>(),
      ));
  getIt.registerFactory<LocalRepository>(() => LocalRepository(
        // hiveServices: getIt<HiveServices>(),
        prefs: getIt<FlutterSecureStorage>(),
        biometricStorage: getIt<BiometricStorage>(),
      ));

  //db
  getIt.registerFactory<SharePreferencesConstants>(
      () => SharePreferencesConstants());
  // getIt.registerLazySingleton<HiveServices>(() => HiveServices());
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseMessaging>(
      () => FirebaseMessaging.instance);
  getIt.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage());
  getIt.registerLazySingleton<BiometricStorage>(() => BiometricStorage());
}
