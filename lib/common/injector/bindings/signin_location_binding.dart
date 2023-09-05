import 'package:get/get.dart';
import 'package:password_keeper/common/injector/injector.dart';
import 'package:password_keeper/presentation/journey/signin_location/signin_location_controller.dart';

class SignInLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(getIt<SignInLocationController>());
  }
}
