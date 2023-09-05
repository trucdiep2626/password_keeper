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
}
