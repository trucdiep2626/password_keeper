import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:password_keeper/common/config/app_config.dart';
import 'package:password_keeper/common/constants/constants.dart';
import 'package:password_keeper/domain/models/account.dart';

class AccountRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore db;

  AccountRepository({
    required this.auth,
    required this.db,
  });

  User? get user => auth.currentUser;

  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  Future<void> signUpWithEmail({
    required String fullname,
    required String email,
    required String password,
  }) async {
    final newUser = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await user?.updateDisplayName(fullname);
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Future<AuthCredential?> loginWithAuthCredential(

  Future<void> sendEmailVerification() async {
    await auth.currentUser!.sendEmailVerification();
  }

  Future<AuthCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await auth.signInWithCredential(credential);

      // if you want to do specific task like storing information in firestore
      // only for new users using google sign in (since there are no two options
      // for google sign in and google sign up, only one as of now),
      // do the following:

      // if (userCredential.user != null) {
      //   if (userCredential.additionalUserInfo!.isNewUser) {}
      // }

      return userCredential.credential;
    }
    //   return null;
    // }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await auth.signOut();
  }

  Future<void> deleteAccount(String userId) async {
    await auth.currentUser!.delete();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future createUser(Account account) async {
    await db
        .collection(AppConfig.userCollection)
        .doc(account.userId)
        .collection(AppConfig.profileCollection)
        .add(account.toJson());
  }

  Future<void> editProfile(Account account) async {
    await db
        .collection(AppConfig.userCollection)
        .doc(account.userId)
        .collection(AppConfig.profileCollection)
        .doc(account.id)
        .update(account.toJson());
  }

  Future<void> updateAllowScreenCapture({
    required String userId,
    required bool value,
  }) async {
    final account = await getProfile(userId: userId);

    if (account != null) {
      await editProfile(account.copyWith(allowScreenCapture: value));
    }
  }

  Future<bool> getAllowScreenCapture({required String usedId}) async {
    final account = await getProfile(userId: usedId);

    return account?.allowScreenCapture ?? false;
  }

  Future<void> updateTimeoutSetting({
    required String userId,
    required int timeout,
  }) async {
    final account = await getProfile(userId: userId);

    if (account != null) {
      await editProfile(account.copyWith(timeoutSetting: timeout));
    }
  }

  Future<int> getTimeoutSetting({required String usedId}) async {
    final account = await getProfile(userId: usedId);

    return account?.timeoutSetting ?? Constants.timeout;
  }

  Future<Account?> getProfile({required String userId}) async {
    final response = await db
        .collection(AppConfig.userCollection)
        .doc(userId)
        .collection(AppConfig.profileCollection)
        .get();

    if (response.docs.isEmpty) {
      return null;
    }

    Map<String, dynamic> profileJson = {};
    profileJson
        .addAll({'id': response.docs.first.id, 'user_id': user?.uid ?? ''});
    profileJson.addAll(response.docs.first.data());

    return Account.fromJson(profileJson);
  }

  Future<String?> getPasswordHint({required String userId}) async {
    final profile = await getProfile(userId: userId);
    return profile?.masterPasswordHint;
  }

  Future<void> sendPasswordHint(
      {required String email, required String userId}) async {
    final masterPasswordHint = await getPasswordHint(userId: userId);

    if (masterPasswordHint == null) {
      await db.collection(AppConfig.mailCollection).add({
        "to": email,
        "message": {
          "subject": Constants.notSetHintMailTitle,
          "html": Constants.notSetMasterPasswordHintMailTemplate,
        },
      });
    } else {
      await db.collection(AppConfig.mailCollection).add({
        "to": email,
        "message": {
          "subject": Constants.masterPasswordHintMailTitle,
          "html": Constants.masterPasswordHintMailTemplate(
              masterPwd: masterPasswordHint),
        },
      });
    }
  }
}
