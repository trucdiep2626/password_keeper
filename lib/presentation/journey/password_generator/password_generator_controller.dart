import 'package:get/get.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';

class PasswordGeneratorController extends GetxController with MixinController {
  RxBool useUppercase = true.obs;
  RxBool useLowercase = true.obs;
  RxBool useNumbers = false.obs;
  RxBool useSpecial = false.obs;
  RxBool avoidAmbiguous = false.obs;

  RxInt pwdLength = 10.obs;
  RxInt minimumNumbers = 0.obs;
  RxInt minimumSpecial = 0.obs;

  RxString generatedPassword = 'gbadsghdrgfhsdhsdfbdcxbsdefrhdfhdsfnv'.obs;

  PasswordGeneratorController();

  void onChangedUseUppercase() {
    useUppercase.value = !useUppercase.value;
  }

  void onChangedUseLowercase() {
    useLowercase.value = !useLowercase.value;
  }

  void onChangedUseNumbers() {
    useNumbers.value = !useNumbers.value;
  }

  void onChangedUseSpecial() {
    useSpecial.value = !useSpecial.value;
  }

  void onChangedAvoidAmbiguous() {
    avoidAmbiguous.value = !avoidAmbiguous.value;
  }

  void onChangedPwdLength(int value) {
    pwdLength.value = value;
  }

  void increaseMinimumNumbers() {
    minimumNumbers.value = minimumNumbers.value + 1;
  }

  void decreaseMinimumNumbers() {
    if (minimumNumbers.value > 0) {
      minimumNumbers.value = minimumNumbers.value - 1;
    }
  }

  void decreaseMinimumSpecial() {
    if (minimumSpecial.value > 0) {
      minimumSpecial.value = minimumSpecial.value - 1;
    }
  }

  void increaseMinimumSpecial() {
    minimumSpecial.value = minimumSpecial.value + 1;
  }

  void generatePassword() {}
}
