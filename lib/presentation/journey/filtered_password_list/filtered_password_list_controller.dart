import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/models/password_model.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';

class FilteredPasswordListController extends GetxController
    with MixinController {
  Rx<LoadedType> rxLoadedFiltered = LoadedType.finish.obs;

  FilteredType type = FilteredType.reused;

  RxList<PasswordItem> passwords = <PasswordItem>[].obs;
  RxMap<String, List<PasswordItem>> reusedPasswords =
      <String, List<PasswordItem>>{}.obs;
  RxString title = ''.obs;
  RxList<bool> showPasswordInList = <bool>[].obs;

  void onChangeShowPasswordInList(int index) {
    showPasswordInList[index] = !showPasswordInList[index];
  }

  goToDetail(PasswordItem passwordItem) async {
    final result =
        await Get.toNamed(AppRoutes.passwordDetail, arguments: passwordItem);
    if (result is bool && result) {
      Get.back(result: result);
    }
  }

  String getTitle(FilteredType type) {
    switch (type) {
      case FilteredType.reused:
        return TranslationConstants.reusedPasswords.tr;
      case FilteredType.weak:
        return TranslationConstants.weakPasswords.tr;
      case FilteredType.safe:
        return TranslationConstants.safePasswords.tr;
      default:
        return '';
    }
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    type = args['type'] ?? FilteredType.reused;
    title.value = getTitle(args['type'] ?? FilteredType.reused);
    reusedPasswords.addAll(args['reused_passwords'] ?? {});
    passwords.addAll(args['passwords'] ?? []);

    if (passwords.isNotEmpty) {
      showPasswordInList
          .addAll(List.generate(passwords.length, (index) => false));
    }
  }
}
