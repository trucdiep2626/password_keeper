import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:password_keeper/common/config/database/local_key.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/data/account_repository.dart';
import 'package:password_keeper/data/local_repository.dart';
import 'package:password_keeper/domain/models/account.dart';

class AccountUseCase {
  final AccountRepository accountRepo;
  final LocalRepository localRepo;

  AccountUseCase({required this.accountRepo, required this.localRepo});

  User? get user => accountRepo.user;

  Stream<User?> get authState => accountRepo.authState;

  // SymmetricCryptoKey? get getUserKey => getAccount?.volatileData?.key;
  //
  // bool get hasUserKey => getUserKey != null;

  //Account
  Future<Account?> get getAccount async {
    final account =
        await localRepo.getSecureData(key: LocalStorageKey.accountKey);
    if (isNullEmpty(account)) {
      return null;
    }

    return account == null ? null : Account.fromJson(jsonDecode(account));
  }

  Future<void> setAccount({Account? account}) async {
    await localRepo.saveSecureData(
        key: LocalStorageKey.accountKey, value: jsonEncode(account?.toJson()));
  }

  // AuthCredential? getUserCredential() {
  //   return accountRepo.getUserCredential();
  // }

  // Future<void> setUserCredential({AuthCredential? authCredential}) async {
  //   return await accountRepo.setUserCredential(authCredential: authCredential);
  // }

  Future<void> signUpWithEmail({
    required String fullname,
    required String email,
    required String password,
  }) async {
    return await accountRepo.signUpWithEmail(
      email: email,
      password: password,
      fullname: fullname,
    );
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    await accountRepo.loginWithEmail(
      email: email,
      password: password,
    );
  }

  // Future<AuthCredential?> loginWithAuthCredential(
  //     {required AuthCredential authCredential}) async {
  //   return await accountRepo.loginWithAuthCredential(
  //       authCredential: authCredential);
  // }

  Future<void> sendEmailVerification() async {
    await accountRepo.sendEmailVerification();
  }

  Future<AuthCredential?> signInWithGoogle() async {
    return await accountRepo.signInWithGoogle();
  }

  Future<void> signOut() async {
    await accountRepo.signOut();
    await localRepo.deleteAllSecureData();
    await localRepo.clearBiometricStorage();
  }

  Future<void> forceLock() async {
    await localRepo.deleteAllSecureData();
    await localRepo.clearBiometricStorage();
  }

  Future<void> lock() async {
    //  await localRepo.clearLocalData();
    await localRepo.deleteSecureData(key: LocalStorageKey.encKeyKey);
    await localRepo.deleteSecureData(key: LocalStorageKey.accountKey);
    await localRepo.deleteSecureData(
        key: LocalStorageKey.masterKeyDecryptedKey);
    await localRepo.deleteSecureData(
        key: LocalStorageKey.masterKeyEncryptedKey);
  }

  Future<void> deleteAccount(String userId) async {
    await accountRepo.deleteAccount(userId);
    await localRepo.deleteAllSecureData();
    await localRepo.clearBiometricStorage();
  }

  Future createUser(Account account) async {
    return await accountRepo.createUser(account);
  }

  Future<void> editProfile(Account account) async {
    await accountRepo.editProfile(account);
  }

  Future<void> updateAllowScreenCapture({
    required String userId,
    required bool value,
  }) async {
    await accountRepo.updateAllowScreenCapture(
      userId: userId,
      value: value,
    );
  }

  Future<bool> getAllowScreenCapture({required String usedId}) async {
    return await accountRepo.getAllowScreenCapture(usedId: usedId);
  }

  Future<void> updateTimeoutSetting({
    required String userId,
    required int timeout,
  }) async {
    return accountRepo.updateTimeoutSetting(
      userId: userId,
      timeout: timeout,
    );
  }

  Future<int> getTimeoutSetting({required String usedId}) async {
    return accountRepo.getTimeoutSetting(usedId: usedId);
  }

  Future<void> updateAlertSetting({
    required String userId,
    required int time,
  }) async {
    return accountRepo.updateAlertSetting(
      userId: userId,
      time: time,
    );
  }

  Future<int> getAlertSetting({required String usedId}) async {
    return accountRepo.getAlertSetting(usedId: usedId);
  }

  Future<Account?> getProfile({required String userId}) async {
    return await accountRepo.getProfile(userId: userId);
  }

  Future<void> sendPasswordHint(
      {required String email, required String userId}) async {
    await accountRepo.sendPasswordHint(
      email: email,
      userId: userId,
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await accountRepo.sendPasswordResetEmail(email);
  }

  Future<void> sendChangedMasterPasswordNotice({
    required String account,
    required String name,
    required String updatedAt,
    required String device,
  }) async {
    await accountRepo.sendChangedMasterPasswordNotice(
      account: account,
      name: name,
      updatedAt: updatedAt,
      device: device,
    );
  }
}
