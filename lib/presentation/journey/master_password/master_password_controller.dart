import 'package:get/get.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';

class MasterPasswordController extends GetxController with MixinController{
  AccountUseCase accountUsecase;

  RxBool showMasterPwd = false.obs;
  RxBool showConfirmMasterPwd = false.obs;

   MasterPasswordController({required this.accountUsecase});
}