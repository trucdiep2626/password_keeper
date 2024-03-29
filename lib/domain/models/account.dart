import 'package:password_keeper/common/constants/constants.dart';
import 'package:password_keeper/common/utils/app_utils.dart';

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
  int? timeoutSetting;
  String? name;
  bool? allowScreenCapture;
  int? timingAlert;
  int? updatedMasterPasswordAt;
  int? updatedAt;
  int? createdAt;
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
    this.timeoutSetting,
    this.timingAlert,
    this.updatedMasterPasswordAt,
    this.updatedAt,
    this.createdAt,
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
    int? timeoutSetting,
    int? timingAlert,
    int? updatedMasterPasswordAt,
    int? updatedAt,
    int? createdAt,
  }) =>
      Account(
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
        timeoutSetting: timeoutSetting ?? this.timeoutSetting,
        timingAlert: timingAlert ?? this.timingAlert,
        updatedMasterPasswordAt:
            updatedMasterPasswordAt ?? this.updatedMasterPasswordAt,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
      );

  Account.fromJson(Map<String, dynamic> json) {
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
    timeoutSetting = json['timeout_setting'];
    timingAlert = json['timing_alert'] ?? Constants.timingAlert;
    updatedMasterPasswordAt = json['updated_master_password_at'];
    updatedAt = json['updated_at'];
    createdAt = json['create_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['timing_alert'] = timingAlert;
    data['updated_master_password_at'] = updatedMasterPasswordAt;
    data['allow_screen_capture'] = allowScreenCapture ?? false;
    data['email'] = email;
    data['hashed_master_password'] = hashedMasterPassword;
    data['master_password_hint'] = masterPasswordHint;
    data['key'] = key;
    data['kdf_iterations'] = kdfIterations;
    data['kdf_memory'] = kdfMemory;
    data['kdf_parallelism'] = kdfParallelism;
    data['name'] = name;
    data['timeout_setting'] = timeoutSetting;
    return data;
  }
}
