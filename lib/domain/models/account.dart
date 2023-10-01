// class Account {
//   AccountProfile? profile;
//   // AccountTokens? tokens;
//   // AccountSettings? settings;
//   AccountVolatileData? volatileData;
//
//   Account({
//     required this.profile,
//     //  required this.tokens
//   }) {
//     //  settings = AccountSettings();
//     volatileData = AccountVolatileData();
//   }
//
//   // Account.copy(Account account)
//   //     : profile = AccountProfile.copy(account.profile!),
//   //       // tokens = AccountTokens.copy(account.tokens!),
//   //       // settings = AccountSettings.copy(account.settings!),
//   //       volatileData = AccountVolatileData();
//
//   Account.fromJson(Map<String, dynamic> json) {
//     profile = json['profile'] != null
//         ? AccountProfile.fromJson(json['profile'])
//         : null;
//     volatileData = json['volatile_data'] != null
//         ? AccountVolatileData.fromJson(json['volatile_data'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (profile != null) {
//       data['profile'] = profile!.toJson();
//     }
//     if (volatileData != null) {
//       data['volatile_data'] = volatileData!.toJson();
//     }
//
//     return data;
//   }
// }

class Account {
  String? id;
  String? userId;
  String? email;
  String? hashedMasterPassword;
  String? masterPasswordHint;
  String? key;
  int? kdfIterations;
  int? kdfMemory;
  int? kdfParallelism;
  // bool? biometricUnlockEnabled;

  String? name;
//  String? stamp;
//  String? orgIdentifier;
//  String? avatarColor;
  // KdfType? kdfType;

  // bool? emailVerified;
  // bool? hasPremiumPersonally;
  // ForcePasswordResetReason? forcePasswordResetReason;

  Account({
    this.id,
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
    // this.biometricUnlockEnabled = false,
    // this.emailVerified,
    // this.hasPremiumPersonally,
    // this.forcePasswordResetReason
  });

  Account copyWith({
    String? id,
    String? userId,
    String? email,
    String? hashedMasterPassword,
    String? masterPasswordHint,
    String? key,
    int? kdfIterations,
    int? kdfMemory,
    int? kdfParallelism,
    String? name,
    //  bool? biometricUnlockEnabled,
  }) =>
      Account(
        // biometricUnlockEnabled:
        //     biometricUnlockEnabled ?? this.biometricUnlockEnabled,
        id: id ?? this.id,
        userId: userId ?? this.userId,
        email: email ?? this.email,
        hashedMasterPassword: hashedMasterPassword ?? this.hashedMasterPassword,
        masterPasswordHint: masterPasswordHint ?? this.masterPasswordHint,
        key: key ?? this.key,
        kdfIterations: kdfIterations ?? this.kdfIterations,
        kdfMemory: kdfMemory ?? this.kdfMemory,
        kdfParallelism: kdfParallelism ?? this.kdfParallelism,
      );

  Account.fromJson(Map<String, dynamic> json) {
    //  biometricUnlockEnabled = json['biometric_unlock_enabled'] ?? false;
    id = json['id'];
    email = json['email'];
    hashedMasterPassword = json['hashed_master_password'];
    masterPasswordHint = json['master_password_hint'];
    key = json['key'];
    kdfIterations = json['kdf_iterations'];
    kdfMemory = json['kdf_memory'];
    kdfParallelism = json['kdf_parallelism'];
    name = json['name'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['hashed_master_password'] = hashedMasterPassword;
    data['master_password_hint'] = masterPasswordHint;
    data['key'] = key;
    data['kdf_iterations'] = kdfIterations;
    data['kdf_memory'] = kdfMemory;
    data['kdf_parallelism'] = kdfParallelism;
    data['name'] = name;
    // data['biometric_unlock_enabled'] = biometricUnlockEnabled;
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

// class AccountVolatileData {
//   SymmetricCryptoKey? key;
//   EncryptedString? pinProtectedKey;
//   bool? biometricLocked;
//
//   AccountVolatileData({
//     this.key,
//     this.biometricLocked,
//     this.pinProtectedKey,
//   });
//
//   AccountVolatileData.fromJson(Map<String, dynamic> json) {
//     key = json['key'] != null ? SymmetricCryptoKey.fromJson(json['key']) : null;
//     pinProtectedKey = json['pin_protected_key'] != null
//         ? EncryptedString.fromJson(json['pin_protected_key'])
//         : null;
//     biometricLocked = json['biometric_locked'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (key != null) {
//       data['key'] = key!.toJson();
//     }
//     if (pinProtectedKey != null) {
//       data['pin_protected_key'] = pinProtectedKey!.toJson();
//     }
//
//     data['biometric_locked'] = biometricLocked;
//     return data;
//   }
// }
//
// class EnvironmentUrlData {
//   // Implement EnvironmentUrlData if needed
//   // ...
// }

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
