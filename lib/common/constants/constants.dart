import 'package:password_keeper/common/utils/app_utils.dart';

class Constants {
  static const String verificationId = 'verificationId';
  static const String forceResendingToken = 'forceResendingToken';
  static const String phone = 'phone';

  static const String lastUserShouldConnectToWatchKey =
      "lastUserShouldConnectToWatch";
  static const String otpAuthScheme = "otpauth";
  static const String appLocaleKey = "appLocale";
  static const String clearSensitiveFields = "clearSensitiveFields";
  static const String forceUpdatePassword = "forceUpdatePassword";
  static const int selectFileRequestCode = 42;
  static const int selectFilePermissionRequestCode = 43;
  static const int saveFileRequestCode = 44;
  static const int totpDefaultTimer = 30;
  static const int passwordlessNotificationTimeoutInMinutes = 15;
  static const int pbkdf2Iterations = 600000;
  static const int argon2Iterations = 3;
  static const int argon2MemoryInMB = 64;
  static const int argon2Parallelism = 4;
  static const int masterPasswordMinimumChars = 12;
  static const String defaultFido2KeyType = "public-key";
  static const String defaultFido2KeyAlgorithm = "ECDSA";
  static const String defaultFido2KeyCurve = "P-256";

  static const String lowercaseCharSet = "abcdefghijkmnopqrstuvwxyz";
  static const String uppercaseCharSet = "ABCDEFGHJKLMNPQRSTUVWXYZ";
  static const String numCharSet = "23456789";
  static const String specialCharSet = "!@#\$%^&*";

  static const int maxGeneratedPasswordInHistory = 100;

  //default timeout is 20 minutes
  static const int timeout = 60 * 20;

  //defaul timing alert is 60 days
  static const int timingAlert = 60 * 24 * 60 * 60 * 1000;

  static const String notSetHintMailTitle =
      "Hint for Master Password is not set";
  static const String masterPasswordHintMailTitle = "Hint for Master Password!";
  static masterPasswordHintMailTemplate({required String masterPwd}) =>
      "<p>You created a hint for your master password. Use this hint to remind yourself of your master password. Your hint:</p>"
      "<p style=\"background-color:#e6e6e6;margin-bottom:20px;padding:10px;font-size:15px;color:#294661\">${masterPwd}</p>"
      "<p><strong>Important notice:</strong> Your master password is only"
      "yours. No one, even Password Keeper team, is able to see, access, or"
      "reset your master password.</p>"
      "<p>Stay secured! <br>Password Keeper team.</p>";

  static const String notSetMasterPasswordHintMailTemplate =
      "<p>You (or someone) recently requested your master password hint.</p>"
      "<p>Unfortunately, your account does not have a master password hint.</p>"
      "<p>If you did not request your master password hint you can safely ignore this email.</p>"
      "<p>Stay secured! <br>Password Keeper team.</p>";

  static const String storageFileName = "password_keeper";

  static const String changedMasterPasswordMailTitle =
      "Your master password has been changed";

  static changedMasterPasswordMailTemplate({
    required String account,
    required String updatedAt,
    required String name,
    required String device,
  }) =>
      "<p>Dear ${name},</p>"
      "<p>We are writing to let you know that your master password has been changed.</p>"
      "<p><strong>Account:</strong> ${account}</p>"
      "<p><strong>Time:</strong> ${updatedAt} (UTC+00)</p>"
      "<p><strong>Device:</strong> ${device}</p>"
      "<p>If you made this change, please ignore this message.</p>"
      "<p>Stay secured! <br>Password Keeper team.</p>";
}
