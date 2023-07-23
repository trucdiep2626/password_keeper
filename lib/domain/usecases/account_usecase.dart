import 'package:firebase_auth/firebase_auth.dart';
import 'package:password_keeper/data/local_repository.dart';
import 'package:password_keeper/data/remote/account_repository.dart';

class AccountUseCase {
  final AccountRepository accountRepo;
  final LocalRepository localRepo;

  AccountUseCase({required this.accountRepo, required this.localRepo});

  User get user => accountRepo.user;

  Stream<User?> get authState => accountRepo.authState;

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await accountRepo.signUpWithEmail(
      email: email,
      password: password,
    );
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    await accountRepo.loginWithEmail(email: email, password: password);
  }

  Future<void> sendEmailVerification() async {
    await accountRepo.sendEmailVerification();
  }

  Future<void> signInWithGoogle() async {
    await accountRepo.signInWithGoogle();
  }

  Future<void> signOut() async {
    await accountRepo.signOut();
  }

  Future<void> deleteAccount() async {
    await accountRepo.deleteAccount();
  }
}
