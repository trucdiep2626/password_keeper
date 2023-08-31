import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:password_keeper/common/config/database/hive_services.dart';
import 'package:password_keeper/common/constants/shared_preferences_constants.dart';
import 'package:password_keeper/data/account_repository.dart';
import 'package:password_keeper/data/local_repository.dart';
import 'package:password_keeper/data/password_repository.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/app_controller.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/state_controller.dart';
import 'package:password_keeper/presentation/journey/create_master_password/create_master_password_controller.dart';
import 'package:password_keeper/presentation/journey/home/home_controller.dart';
import 'package:password_keeper/presentation/journey/login/login_controller.dart';
import 'package:password_keeper/presentation/journey/main/main_controller.dart';
import 'package:password_keeper/presentation/journey/master_password/master_password_controller.dart';
import 'package:password_keeper/presentation/journey/password_generator/password_generator_controller.dart';
import 'package:password_keeper/presentation/journey/register/register_controller.dart';
import 'package:password_keeper/presentation/journey/splash/splash_controller.dart';
import 'package:password_keeper/presentation/journey/verify_email/verify_email_controller.dart';
import 'package:password_keeper/presentation/journey/verify_master_password/verify_master_password_controller.dart';

GetIt getIt = GetIt.instance;

void configLocator() {
  /// Controllers
  getIt.registerLazySingleton<AppController>(
      () => AppController(accountUseCase: getIt<AccountUseCase>()));
  getIt.registerFactory<SplashController>(() => SplashController());
  getIt.registerFactory<MainController>(() => MainController());
  getIt.registerFactory<HomeController>(
      () => HomeController(accountUsecase: getIt<AccountUseCase>()));
  getIt.registerFactory<PasswordGeneratorController>(() =>
      PasswordGeneratorController(passwordUsecase: getIt<PasswordUsecase>()));
  getIt.registerFactory<RegisterController>(
      () => RegisterController(accountUsecase: getIt<AccountUseCase>()));
  getIt.registerFactory<LoginController>(
      () => LoginController(accountUsecase: getIt<AccountUseCase>()));
  getIt.registerFactory<CreateMasterPasswordController>(() =>
      CreateMasterPasswordController(accountUsecase: getIt<AccountUseCase>()));
  getIt.registerFactory<MasterPasswordController>(
      () => MasterPasswordController(accountUsecase: getIt<AccountUseCase>()));
  getIt.registerFactory<VerifyMasterPasswordController>(() =>
      VerifyMasterPasswordController(accountUsecase: getIt<AccountUseCase>()));
  getIt.registerFactory<VerifyEmailController>(
      () => VerifyEmailController(accountUseCase: getIt<AccountUseCase>()));

  ///helper
  getIt.registerLazySingleton<CryptoController>(() => CryptoController());
  getIt.registerLazySingleton<StateController>(() => StateController());

  /// UseCases
  getIt.registerFactory<AccountUseCase>(() => AccountUseCase(
      accountRepo: getIt<AccountRepository>(),
      localRepo: getIt<LocalRepository>()));
  getIt.registerFactory<PasswordUsecase>(
      () => PasswordUsecase(passwordRepository: getIt<PasswordRepository>()));

  /// Repositories
  getIt.registerFactory<AccountRepository>(() => AccountRepository(
        auth: FirebaseAuth.instance,
        db: FirebaseFirestore.instance,
        hiveServices: getIt<HiveServices>(),
      ));
  getIt.registerFactory<PasswordRepository>(
      () => PasswordRepository(hiveServices: getIt<HiveServices>()));
  getIt.registerFactory<LocalRepository>(() => LocalRepository());

  getIt.registerFactory<SharePreferencesConstants>(
      () => SharePreferencesConstants());
  getIt.registerLazySingleton<HiveServices>(() => HiveServices());
}
