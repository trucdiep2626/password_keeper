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
    final account = await localRepo.getLocalValue(key: LocalKey.accountKey);
    if (isNullEmpty(account)) {
      return null;
    }

    return Account.fromJson(jsonDecode(account));
  }

  Future<void> setAccount({Account? account}) async {
    return await localRepo.setLocalValue(
        key: LocalKey.accountKey, value: jsonEncode(account?.toJson()));
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
    await localRepo.clearLocalData();
    await localRepo.deleteAllSecureData();
  }

  Future<void> lock() async {
    await localRepo.clearLocalData();
    await localRepo.deleteSecureData(key: LocalKey.encKeyKey);
    await localRepo.deleteSecureData(key: LocalKey.accountKey);
    await localRepo.deleteSecureData(key: LocalKey.keyKey);
  }

  Future<void> deleteAccount() async {
    await accountRepo.deleteAccount();
  }

  Future createUser(AccountProfile profile) async {
    return await accountRepo.createUser(profile);
  }

  Future<void> editProfile(AccountProfile profile) async {
    await accountRepo.editProfile(profile);
  }

  Future<AccountProfile?> getProfile({required String userId}) async {
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
}
