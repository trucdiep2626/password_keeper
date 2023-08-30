import 'package:password_keeper/data/password_repository.dart';
import 'package:password_keeper/domain/models/password_generation_option.dart';

class PasswordUsecase {
  final PasswordRepository passwordRepository;

  PasswordUsecase({required this.passwordRepository});

  //Password Generation Option
  PasswordGenerationOptions? get getPasswordGenerationOptions =>
      passwordRepository.getPasswordGenerationOptions;

  Future<void> setPasswordGenerationOptions(
      {PasswordGenerationOptions? option}) async {
    await passwordRepository.setPasswordGenerationOptions(option: option);
  }
}
