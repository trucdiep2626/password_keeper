import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/injector/bindings/add_edit_password_binding.dart';
import 'package:password_keeper/common/injector/bindings/create_master_password_binding.dart';
import 'package:password_keeper/common/injector/bindings/generated_password_history_binding.dart';
import 'package:password_keeper/common/injector/bindings/home_binding.dart';
import 'package:password_keeper/common/injector/bindings/login_binding.dart';
import 'package:password_keeper/common/injector/bindings/main_binding.dart';
import 'package:password_keeper/common/injector/bindings/password_generator_binding.dart';
import 'package:password_keeper/common/injector/bindings/password_list_binding.dart';
import 'package:password_keeper/common/injector/bindings/register_binding.dart';
import 'package:password_keeper/common/injector/bindings/signin_location_binding.dart';
import 'package:password_keeper/common/injector/bindings/splash_binding.dart';
import 'package:password_keeper/common/injector/bindings/verify_email.dart';
import 'package:password_keeper/common/injector/bindings/verify_master_password_binding.dart';
import 'package:password_keeper/presentation/journey/add_edit_password/add_edit_password_screen.dart';
import 'package:password_keeper/presentation/journey/create_master_password/create_master_password_screen.dart';
import 'package:password_keeper/presentation/journey/generated_password_history/generated_password_history_screen.dart';
import 'package:password_keeper/presentation/journey/login/login_screen.dart';
import 'package:password_keeper/presentation/journey/main/main_screen.dart';
import 'package:password_keeper/presentation/journey/password_generator/password_generator_screen.dart';
import 'package:password_keeper/presentation/journey/register/register_screen.dart';
import 'package:password_keeper/presentation/journey/signin_location/signin_location_screen.dart';
import 'package:password_keeper/presentation/journey/splash/splash_screen.dart';
import 'package:password_keeper/presentation/journey/verify_email/verify_email_screen.dart';
import 'package:password_keeper/presentation/journey/verify_master_password/verify_master_password_screen.dart';

List<GetPage> myPages = [
  GetPage(
    name: AppRoutes.splash,
    page: () => const SplashScreen(),
    binding: SplashBinding(),
  ),
  GetPage(name: AppRoutes.main, page: () => MainScreen(), bindings: [
    MainBinding(),
    HomeBinding(),
    PasswordListBinding(),
    // AddEditPasswordBinding(),
    PasswordGeneratorBinding(),
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
  GetPage(
    name: AppRoutes.verifyMasterPassword,
    page: () => const VerifyMasterPasswordScreen(),
    binding: VerifyMasterPasswordBinding(),
  ),
  GetPage(
    name: AppRoutes.verifyEmail,
    page: () => const VerifyEmailScreen(),
    binding: VerifyEmailBinding(),
  ),
  GetPage(
    name: AppRoutes.history,
    page: () => const GeneratedPasswordHistoryScreen(),
    binding: GeneratedPasswordHistoryBinding(),
  ),
  GetPage(
    name: AppRoutes.signInLocation,
    page: () => const SignInLocationScreen(),
    binding: SignInLocationBinding(),
  ),
  GetPage(
    name: AppRoutes.addEditPassword,
    page: () => const AddEditPasswordScreen(),
    binding: AddEditPasswordBinding(),
  ),
  GetPage(
    name: AppRoutes.passwordGenerator,
    page: () => const PasswordGeneratorScreen(),
    binding: PasswordGeneratorBinding(),
  ),
  // GetPage(
  //   name: AppRoutes.passwordList,
  //   page: () => const PasswordListScreen(),
  //   binding: PasswordListBinding(),
  // ),
];
