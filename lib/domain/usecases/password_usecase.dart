import 'package:password_keeper/data/password_repository.dart';
import 'package:password_keeper/domain/models/generated_password_item.dart';
import 'package:password_keeper/domain/models/password_generation_option.dart';

class PasswordUseCase {
  final PasswordRepository passwordRepository;

  PasswordUseCase({required this.passwordRepository});

  //Password Generation Option
  PasswordGenerationOptions? get getPasswordGenerationOptionsLocal =>
      passwordRepository.getPasswordGenerationOptionsLocal;

  Future<void> setPasswordGenerationOptionsLocal(
      {PasswordGenerationOptions? option}) async {
    await passwordRepository.setPasswordGenerationOptionsLocal(option: option);
  }

  Future setPasswordGenerationOption({
    required String userId,
    required PasswordGenerationOptions option,
  }) async {
    await passwordRepository.setPasswordGenerationOption(
      userId: userId,
      option: option,
    );
  }

  Future<PasswordGenerationOptions?> getPasswordGenerationOption(
      {required String userId}) async {
    return await passwordRepository.getPasswordGenerationOption(userId: userId);
  }

  Future<void> addGeneratedPassword({
    required String userId,
    required GeneratedPasswordItem passwordItem,
  }) async {
    await passwordRepository.addGeneratedPassword(
      userId: userId,
      passwordItem: passwordItem,
    );
  }

  Future<List<GeneratedPasswordItem>> getGeneratedPasswordHistory({
    required String userId,
    GeneratedPasswordItem? lastItem,
    required int pageSize,
  }) async {
    return await passwordRepository.getGeneratedPasswordHistory(
      userId: userId,
      lastItem: lastItem,
      pageSize: pageSize,
    );
  }

  Future<int> getGeneratedPasswordHistoryLength(
      {required String userId}) async {
    return await passwordRepository.getGeneratedPasswordHistoryLength(
        userId: userId);
  }

  Future<bool> deleteOldestGeneratedHistory({required String userId}) async {
    return await passwordRepository.deleteOldestGeneratedHistory(
        userId: userId);
  }

  Future<GeneratedPasswordItem?> getLatestGeneratedHistory(
      {required String userId}) async {
    return await passwordRepository.getLatestGeneratedHistory(userId: userId);
  }
}
