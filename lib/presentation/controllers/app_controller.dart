import 'package:get/get.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';


class AppController extends SuperController with MixinController {
  late String uid;

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