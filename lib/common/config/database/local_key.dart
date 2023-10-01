class LocalStorageKey {
  static const boxKey = 'hive_key';
  // static const passwordGenerationOptionKey = 'password_generation_option_key';
  // static const accountKey = 'account_key';
  // static const passwordKey = 'password_key';
  // static const generatedPasswordKey = 'generated_password_key';
  // static const userCredentialKey = 'user_credential_key';

  static const accountKey = "account";
  static const masterKeyEncryptedKey = "master_key_encrypted";
  static const masterKeyDecryptedKey = "master_key_decrypted";

  // static const encOrgKeysKey = "encOrgKeys";
  // static const encPrivateKeyKey = "encPrivateKey";
  static const encKeyKey = "enc_key";
  static const hashedMaterKeyKey = "hashed_master_key";
  static const biometricLocked = "biometric_locked";

  static const vaultTimeoutKey = "vaultTimeout";
  static const vaultTimeoutActionKey = "vaultTimeoutAction";
  static const ciphersKey = "ciphers";
  static const foldersKey = "folders";
  static const collectionsKey = "collections";
  static const organizationsKey = "organizations";
  static const localDataKey = "ciphersLocalData";
  static const neverDomainsKey = "neverDomains";
  static const sendsKey = "sends";
  static const policiesKey = "policies";

  static const pinProtectedKey = "pinProtectedKey";
  static const passGenOptionsKey = "passwordGenerationOptions";
  static const passGenHistoryKey = "generatedPasswordHistory";
  static const lastActiveTimeKey = "lastActiveTime";
  static const invalidUnlockAttemptsKey = "invalidUnlockAttempts";
  static const inlineAutofillEnabledKey = "inlineAutofillEnabled";
  static const autofillDisableSavePromptKey = "autofillDisableSavePrompt";
  static const autofillBlacklistedUrisKey = "autofillBlacklistedUris";
  static const clearClipboardKey = "clearClipboard";
  static const syncOnRefreshKey = "syncOnRefresh";
  static const defaultUriMatchKey = "defaultUriMatch";
  static const disableAutoTotpCopyKey = "disableAutoTotpCopy";
  static const previousPageKey = "previousPage";
  static const passwordRepromptAutofillKey = "passwordRepromptAutofillKey";
  static const passwordVerifiedAutofillKey = "passwordVerifiedAutofillKey";
  static const settingsKey = "settings";
  static const usesKeyConnectorKey = "usesKeyConnector";
  static const protectedPinKey = "protectedPin";
  static const lastSyncKey = "lastSync";
  static const biometricUnlockKey = "biometricUnlock";
  static String accountBiometricIntegrityValidKey(
          String systemBioIntegrityState) =>
      "accountBiometricIntegrityValid_$systemBioIntegrityState";
  static const approvePasswordlessLoginsKey = "approvePasswordlessLogins";
  static const usernameGenOptionsKey = "usernameGenerationOptions";
  static const pushLastRegistrationDateKey = "pushLastRegistrationDate";
  static const pushCurrentTokenKey = "pushCurrentToken";
  static const shouldConnectToWatchKey = "shouldConnectToWatch";
  static const screenCaptureAllowedKey = "screenCaptureAllowed";
}
