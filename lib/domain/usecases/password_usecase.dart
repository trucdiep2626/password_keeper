import 'package:password_keeper/data/password_repository.dart';
import 'package:password_keeper/domain/models/generated_password_item.dart';
import 'package:password_keeper/domain/models/password_generation_option.dart';
import 'package:password_keeper/domain/models/password_model.dart';

class PasswordUseCase {
  final PasswordRepository passwordRepository;

  PasswordUseCase({required this.passwordRepository});

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

  Future<void> addPasswordItem({
    required String userId,
    required PasswordItem passwordItem,
  }) async {
    return await passwordRepository.addPasswordItem(
      userId: userId,
      passwordItem: passwordItem,
    );
  }

  Future<void> editPasswordItem({
    required String userId,
    required PasswordItem passwordItem,
  }) async {
    return await passwordRepository.editPasswordItem(
      userId: userId,
      passwordItem: passwordItem,
    );
  }

  Future<List<PasswordItem>> getPasswordList({
    required String userId,
    PasswordItem? lastItem,
    int? pageSize,
  }) async {
    return await passwordRepository.getPasswordList(
      userId: userId,
      pageSize: pageSize,
      lastItem: lastItem,
    );
  }

  Future<int> getPasswordListLength({required String userId}) async {
    return await passwordRepository.getPasswordListLength(userId: userId);
  }

  Future<bool> deletePassword({
    required String userId,
    required String itemId,
  }) async {
    return await passwordRepository.deletePassword(
      userId: userId,
      itemId: itemId,
    );
  }

  Future<void> updatePasswordList({
    required String userId,
    required List<PasswordItem> passwords,
  }) async {
    await passwordRepository.updatePasswordList(
      userId: userId,
      passwords: passwords,
    );
  }
}
