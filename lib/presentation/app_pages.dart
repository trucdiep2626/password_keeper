import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/injector/bindings/home_binding.dart';
import 'package:password_keeper/common/injector/bindings/main_binding.dart';
import 'package:password_keeper/common/injector/bindings/splash_binding.dart';
import 'package:password_keeper/presentation/journey/main/main_screen.dart';
import 'package:password_keeper/presentation/journey/splash/splash_screen.dart';


List<GetPage> myPages = [
  GetPage(name: AppRoutes.splash, page: () => const SplashScreen(), binding: SplashBinding()),
  GetPage(name: AppRoutes.main, page: () => const MainScreen(), bindings: [
    MainBinding(),
    HomeBinding(),
  ]),
];
