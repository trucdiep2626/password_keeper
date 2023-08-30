import 'package:password_keeper/common/config/database/hive_services.dart';
import 'package:password_keeper/common/config/database/hive_type_constants.dart';
import 'package:password_keeper/domain/models/password_generation_option.dart';

class PasswordRepository {
  final HiveServices hiveServices;

  PasswordRepository({required this.hiveServices});

  //Password Generation Option
  PasswordGenerationOptions? get getPasswordGenerationOptions =>
      PasswordGenerationOptions.fromJson(
        Map<String, dynamic>.from(hiveServices.hiveBox
            .get(HiveKey.passwordGenerationOptionKey) as Map),
      );

  Future<void> setPasswordGenerationOptions(
      {PasswordGenerationOptions? option}) async {
    return await hiveServices.hiveBox
        .put(HiveKey.passwordGenerationOptionKey, option?.toJson());
  }
}
