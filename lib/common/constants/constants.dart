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

  static String vaultTimeoutKey(String userId) => "vaultTimeout_$userId";
  static String vaultTimeoutActionKey(String userId) =>
      "vaultTimeoutAction_$userId";
  static String ciphersKey(String userId) => "ciphers_$userId";
  static String foldersKey(String userId) => "folders_$userId";
  static String collectionsKey(String userId) => "collections_$userId";
  static String organizationsKey(String userId) => "organizations_$userId";
  static String localDataKey(String userId) => "ciphersLocalData_$userId";
  static String neverDomainsKey(String userId) => "neverDomains_$userId";
  static String sendsKey(String userId) => "sends_$userId";
  static String policiesKey(String userId) => "policies_$userId";
  static String keyKey(String userId) => "key_$userId";
  static String encOrgKeysKey(String userId) => "encOrgKeys_$userId";
  static String encPrivateKeyKey(String userId) => "encPrivateKey_$userId";
  static String encKeyKey(String userId) => "encKey_$userId";
  static String keyHashKey(String userId) => "keyHash_$userId";
  static String pinProtectedKey(String userId) => "pinProtectedKey_$userId";
  static String passGenOptionsKey(String userId) =>
      "passwordGenerationOptions_$userId";
  static String passGenHistoryKey(String userId) =>
      "generatedPasswordHistory_$userId";
  static String twoFactorTokenKey(String email) => "twoFactorToken_$email";
  static String lastActiveTimeKey(String userId) => "lastActiveTime_$userId";
  static String invalidUnlockAttemptsKey(String userId) =>
      "invalidUnlockAttempts_$userId";
  static String inlineAutofillEnabledKey(String userId) =>
      "inlineAutofillEnabled_$userId";
  static String autofillDisableSavePromptKey(String userId) =>
      "autofillDisableSavePrompt_$userId";
  static String autofillBlacklistedUrisKey(String userId) =>
      "autofillBlacklistedUris_$userId";
  static String clearClipboardKey(String userId) => "clearClipboard_$userId";
  static String syncOnRefreshKey(String userId) => "syncOnRefresh_$userId";
  static String defaultUriMatchKey(String userId) => "defaultUriMatch_$userId";
  static String disableAutoTotpCopyKey(String userId) =>
      "disableAutoTotpCopy_$userId";
  static String previousPageKey(String userId) => "previousPage_$userId";
  static String passwordRepromptAutofillKey(String userId) =>
      "passwordRepromptAutofillKey_$userId";
  static String passwordVerifiedAutofillKey(String userId) =>
      "passwordVerifiedAutofillKey_$userId";
  static String settingsKey(String userId) => "settings_$userId";
  static String usesKeyConnectorKey(String userId) =>
      "usesKeyConnector_$userId";
  static String protectedPinKey(String userId) => "protectedPin_$userId";
  static String lastSyncKey(String userId) => "lastSync_$userId";
  static String biometricUnlockKey(String userId) => "biometricUnlock_$userId";
  static String accountBiometricIntegrityValidKey(
          String userId, String systemBioIntegrityState) =>
      "accountBiometricIntegrityValid_${userId}_$systemBioIntegrityState";
  static String approvePasswordlessLoginsKey(String userId) =>
      "approvePasswordlessLogins_$userId";
  static String usernameGenOptionsKey(String userId) =>
      "usernameGenerationOptions_$userId";
  static String pushLastRegistrationDateKey(String userId) =>
      "pushLastRegistrationDate_$userId";
  static String pushCurrentTokenKey(String userId) =>
      "pushCurrentToken_$userId";
  static String shouldConnectToWatchKey(String userId) =>
      "shouldConnectToWatch_$userId";
  static String screenCaptureAllowedKey(String userId) =>
      "screenCaptureAllowed_$userId";
}
