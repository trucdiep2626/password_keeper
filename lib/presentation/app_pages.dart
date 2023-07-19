import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/injector/bindings/create_master_password_binding.dart';
import 'package:password_keeper/common/injector/bindings/home_binding.dart';
import 'package:password_keeper/common/injector/bindings/login_binding.dart';
import 'package:password_keeper/common/injector/bindings/main_binding.dart';
import 'package:password_keeper/common/injector/bindings/register_binding.dart';
import 'package:password_keeper/common/injector/bindings/splash_binding.dart';
import 'package:password_keeper/presentation/journey/create_master_password/create_master_password_screen.dart';
import 'package:password_keeper/presentation/journey/login/login_screen.dart';
import 'package:password_keeper/presentation/journey/main/main_screen.dart';
import 'package:password_keeper/presentation/journey/register/register_screen.dart';
import 'package:password_keeper/presentation/journey/splash/splash_screen.dart';

List<GetPage> myPages = [
  GetPage(
    name: AppRoutes.splash,
    page: () => const SplashScreen(),
    binding: SplashBinding(),
  ),
  GetPage(name: AppRoutes.main, page: () => MainScreen(), bindings: [
    MainBinding(),
    HomeBinding(),
  ]),
  GetPage(
    name: AppRoutes.register,
    page: () => const RegisterScreen(),
    binding: RegisterBinding(),
  ),
  GetPage(
    name: AppRoutes.login,
    page: () => const LogInScreen(),
    binding: LoginBinding(),
  ),
  GetPage(
    name: AppRoutes.createMasterPassword,
    page: () => const CreateMasterPasswordScreen(),
    binding: CreateMasterPasswordBinding(),
  ),
  // GetPage(
  //   name: AppRoutes.masterPassword,
  //   page: () => const  MasterPasswordScreen(),
  //   binding:  MasterPasswordBinding(),
  // ),
];
