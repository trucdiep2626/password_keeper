import 'package:password_keeper/domain/models/encrypted_string.dart';
import 'package:password_keeper/domain/models/symmetric_crypto_key.dart';

class Account {
  AccountProfile? profile;
  // AccountTokens? tokens;
  // AccountSettings? settings;
  AccountVolatileData? volatileData;

  Account({
    required this.profile,
    //  required this.tokens
  }) {
    //  settings = AccountSettings();
    volatileData = AccountVolatileData();
  }

  Account.copy(Account account)
      : profile = AccountProfile.copy(account.profile!),
        // tokens = AccountTokens.copy(account.tokens!),
        // settings = AccountSettings.copy(account.settings!),
        volatileData = AccountVolatileData();

  Account.fromJson(Map<String, dynamic> json) {
    profile = json['profile'] != null
        ? AccountProfile.fromJson(json['profile'])
        : null;
    volatileData = json['volatile_data'] != null
        ? AccountVolatileData.fromJson(json['volatile_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    if (volatileData != null) {
      data['volatile_data'] = volatileData!.toJson();
    }

    return data;
  }
}

class AccountProfile {
  String? userId;
  String? email;
  String? hashedMasterPassword;
  String? masterPasswordHint;
  String? key;
  int? kdfIterations;
  int? kdfMemory;
  int? kdfParallelism;

  String? name;
  String? stamp;
  String? orgIdentifier;
  String? avatarColor;
  // KdfType? kdfType;

  bool? emailVerified;
  bool? hasPremiumPersonally;
  ForcePasswordResetReason? forcePasswordResetReason;

  AccountProfile({
    this.userId,
    this.email,
    this.masterPasswordHint,
    this.hashedMasterPassword,
    this.key,
    this.name,
    // this.stamp,
    // this.orgIdentifier,
    // this.avatarColor,
    this.kdfIterations,
    this.kdfMemory,
    this.kdfParallelism,
    // this.emailVerified,
    // this.hasPremiumPersonally,
    // this.forcePasswordResetReason
  });

  AccountProfile.copy(AccountProfile copy) {
    userId = copy.userId;
    email = copy.email;
    name = copy.name;
    stamp = copy.stamp;
    orgIdentifier = copy.orgIdentifier;
    avatarColor = copy.avatarColor;
    // kdfType = copy.kdfType;
    kdfIterations = copy.kdfIterations;
    kdfMemory = copy.kdfMemory;
    kdfParallelism = copy.kdfParallelism;
    emailVerified = copy.emailVerified;
    hasPremiumPersonally = copy.hasPremiumPersonally;
    forcePasswordResetReason = copy.forcePasswordResetReason;
  }

  AccountProfile.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    hashedMasterPassword = json['hashed_master_password'];
    masterPasswordHint = json['master_password_hint'];
    key = json['key'];
    kdfIterations = json['kdf_iterations'];
    kdfMemory = json['kdf_memory'];
    kdfParallelism = json['kdf_parallelism'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['hashed_master_password'] = this.hashedMasterPassword;
    data['master_password_hint'] = this.masterPasswordHint;
    data['key'] = this.key;
    data['kdf_iterations'] = this.kdfIterations;
    data['kdf_memory'] = this.kdfMemory;
    data['kdf_parallelism'] = this.kdfParallelism;
    data['name'] = this.name;
    return data;
  }
}

// class AccountTokens {
//   String? accessToken;
//   String? refreshToken;
//
//   AccountTokens();
//
//   AccountTokens.copy(AccountTokens copy) {
//     accessToken = copy.accessToken;
//     refreshToken = copy.refreshToken;
//   }
// }
//
// class AccountSettings {
//   EnvironmentUrlData? environmentUrls;
//   int? vaultTimeout;
//   VaultTimeoutAction? vaultTimeoutAction;
//   bool? screenCaptureAllowed;
//
//   AccountSettings();
//
//   AccountSettings.copy(AccountSettings copy) {
//     environmentUrls = copy.environmentUrls;
//     vaultTimeout = copy.vaultTimeout;
//     vaultTimeoutAction = copy.vaultTimeoutAction;
//     screenCaptureAllowed = copy.screenCaptureAllowed;
//   }
// }

class AccountVolatileData {
  SymmetricCryptoKey? key;
  EncryptedString? pinProtectedKey;
  bool? biometricLocked;

  AccountVolatileData({
    this.key,
    this.biometricLocked,
    this.pinProtectedKey,
  });

  AccountVolatileData.fromJson(Map<String, dynamic> json) {
    key = json['key'] != null ? SymmetricCryptoKey.fromJson(json['key']) : null;
    pinProtectedKey = json['pin_protected_key'] != null
        ? EncryptedString.fromJson(json['pin_protected_key'])
        : null;
    biometricLocked = json['biometric_locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (key != null) {
      data['key'] = key!.toJson();
    }
    if (pinProtectedKey != null) {
      data['pin_protected_key'] = pinProtectedKey!.toJson();
    }

    data['biometric_locked'] = this.biometricLocked;
    return data;
  }
}

class EnvironmentUrlData {
  // Implement EnvironmentUrlData if needed
  // ...
}

// enum KdfType {
//   // Implement KdfType enum if needed
//   // ...
// }

enum VaultTimeoutAction {
  lock,
  logout,
}

enum ForcePasswordResetReason {
  /// <summary>
  /// Occurs when an organization admin forces a user to reset their password.
  /// </summary>
  adminForcePasswordReset,

  /// <summary>
  /// Occurs when a user logs in with a master password that does not meet an organization's master password
  /// policy that is enforced on login.
  /// </summary>
  weakMasterPasswordOnLogin
}
