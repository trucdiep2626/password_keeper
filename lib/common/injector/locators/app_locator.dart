import 'package:get_it/get_it.dart';
import 'package:password_keeper/data/local_repository.dart';
import 'package:password_keeper/data/remote/account_repository.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/presentation/controllers/app_controller.dart';
import 'package:password_keeper/presentation/journey/home/home_controller.dart';
import 'package:password_keeper/presentation/journey/main/main_controller.dart';
import 'package:password_keeper/presentation/journey/splash/splash_controller.dart';

GetIt getIt = GetIt.instance;

void configLocator() {
  /// Controllers
  getIt.registerLazySingleton<AppController>(() => AppController());
  getIt.registerFactory<SplashController>(() => SplashController());
  getIt.registerFactory<MainController>(() => MainController());
  getIt.registerFactory<HomeController>(() => HomeController());

  /// UseCases
  getIt.registerFactory<AccountUseCase>(() => AccountUseCase(
      accountRepo: getIt<AccountRepository>(),
      localRepo: getIt<LocalRepository>()));

  /// Repositories
  getIt.registerFactory<AccountRepository>(() => AccountRepository( ));
  getIt.registerFactory<LocalRepository>(() => LocalRepository());
}
