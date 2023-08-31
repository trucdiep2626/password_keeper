import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_keeper/common/config/app_config.dart';
import 'package:password_keeper/common/config/database/hive_services.dart';
import 'package:password_keeper/common/config/database/hive_type_constants.dart';
import 'package:password_keeper/domain/models/generated_password_item.dart';
import 'package:password_keeper/domain/models/password_generation_option.dart';

class PasswordRepository {
  final HiveServices hiveServices;
  final FirebaseFirestore db;

  PasswordRepository({
    required this.hiveServices,
    required this.db,
  });

  //Password Generation Option
  PasswordGenerationOptions? get getPasswordGenerationOptionsLocal =>
      PasswordGenerationOptions.fromJson(
        Map<String, dynamic>.from(hiveServices.hiveBox
            .get(HiveKey.passwordGenerationOptionKey) as Map),
      );

  Future<void> setPasswordGenerationOptionsLocal(
      {PasswordGenerationOptions? option}) async {
    return await hiveServices.hiveBox
        .put(HiveKey.passwordGenerationOptionKey, option?.toJson());
  }

  Future setPasswordGenerationOption({
    required String userId,
    required PasswordGenerationOptions option,
  }) async {
    await db
        .collection(AppConfig.userCollection)
        .doc(userId)
        .collection(AppConfig.passwordGenerationOptionCollection)
        .doc(AppConfig.passwordGenerationOptionCollection)
        .set(option.toJson());
  }

  Future<PasswordGenerationOptions?> getPasswordGenerationOption(
      {required String userId}) async {
    final result = await db
        .collection(AppConfig.userCollection)
        .doc(userId)
        .collection(AppConfig.passwordGenerationOptionCollection)
        .get();

    if (result.docs.isEmpty) {
      return null;
    } else {
      return PasswordGenerationOptions.fromJson(result.docs.first.data());
    }
  }

  Future addGeneratedPassword({
    required String userId,
    required GeneratedPasswordItem passwordItem,
  }) async {
    await db
        .collection(AppConfig.userCollection)
        .doc(userId)
        .collection(AppConfig.generatedPasswordsCollection)
        .doc(passwordItem.id)
        .set(passwordItem.toJson());
  }

  Future<List<GeneratedPasswordItem>> getGeneratedPasswordHistory(
      {required String userId}) async {
    final response = await db
        .collection(AppConfig.userCollection)
        .doc(userId)
        .collection(AppConfig.generatedPasswordsCollection)
        .get();

    if (response.docs.isEmpty) {
      return <GeneratedPasswordItem>[];
    } else {
      List<GeneratedPasswordItem> generatedPasswords = [];
      for (var item in response.docs) {
        Map<String, dynamic> password = {};
        password.addAll({'id': item.id});
        password.addAll(item.data());

        GeneratedPasswordItem generatedPasswordItem =
            GeneratedPasswordItem.fromJson(password);

        generatedPasswords.add(generatedPasswordItem);
      }

      return generatedPasswords;
    }
  }
}
