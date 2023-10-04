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
  bool? allowScreenCapture;
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
    this.allowScreenCapture,
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
    bool? allowScreenCapture,
    //  bool? biometricUnlockEnabled,
  }) =>
      Account(
        // biometricUnlockEnabled:
        //     biometricUnlockEnabled ?? this.biometricUnlockEnabled,
        name: name ?? this.name,
        allowScreenCapture: allowScreenCapture ?? this.allowScreenCapture,
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
    allowScreenCapture = json['allow_screen_capture'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['allow_screen_capture'] = allowScreenCapture ?? false;
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
