import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:password_keeper/common/config/app_config.dart';
import 'package:password_keeper/common/config/database/hive_services.dart';
import 'package:password_keeper/common/config/database/hive_type_constants.dart';
import 'package:password_keeper/common/constants/constants.dart';
import 'package:password_keeper/domain/models/account.dart';

class AccountRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore db;
  final HiveServices hiveServices;
  AccountRepository({
    required this.auth,
    required this.db,
    required this.hiveServices,
  });

  User? get user => auth.currentUser;

  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  //Account
  Account? get getAccount => Account.fromJson(
        json.decode(json.encode(hiveServices.hiveBox.get(HiveKey.accountKey)))
                as Map<String, dynamic> ??
            {},
      );

  Future<void> setAccount({Account? account}) async {
    return await hiveServices.hiveBox
        .put(HiveKey.accountKey, account?.toJson());
  }

  //AuthCredential
  AuthCredential? getUserCredential() {
    final mapCredential =
        hiveServices.hiveBox.get(HiveKey.userCredentialKey) as Map?;
    return mapCredential == null
        ? null
        : AuthCredential(
            providerId: mapCredential['providerId'],
            signInMethod: mapCredential['signInMethod'],
            token: mapCredential['token'],
            accessToken: mapCredential['accessToken']);
  }

  Future<void> setUserCredential({AuthCredential? authCredential}) async {
    return await hiveServices.hiveBox
        .put(HiveKey.userCredentialKey, authCredential?.asMap());
  }

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
  //     {required AuthCredential authCredential}) async {
  //   final result = await auth.signInWithCredential(authCredential);
  //   return result.credential;
  // }

  Future<void> sendEmailVerification() async {
    await auth.currentUser!.sendEmailVerification();
  }

  Future<AuthCredential?> signInWithGoogle() async {
    // if (kIsWeb) {
    //   GoogleAuthProvider googleProvider = GoogleAuthProvider();
    //
    //   googleProvider
    //       .addScope('https://www.googleapis.com/auth/contacts.readonly');
    //
    //   return await auth.signInWithPopup(googleProvider);
    // } else {
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
    await hiveServices.hiveBox.clear();
  }

  Future<void> lock() async => await hiveServices.hiveBox.clear();

  Future<void> deleteAccount() async {
    await auth.currentUser!.delete();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future createUser(AccountProfile profile) async {
    await db
        .collection(AppConfig.userCollection)
        .doc(profile.userId)
        .collection(AppConfig.profileCollection)
        .add(profile.toJson());
  }

  Future<void> editProfile(AccountProfile profile) async {
    await db
        .collection(AppConfig.userCollection)
        .doc(profile.userId)
        .collection(AppConfig.profileCollection)
        .doc(profile.id)
        .update(profile.toJson());
  }

  Future<AccountProfile?> getProfile({required String userId}) async {
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

    return AccountProfile.fromJson(profileJson);
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
