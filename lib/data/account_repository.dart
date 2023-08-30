import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:password_keeper/common/config/app_config.dart';
import 'package:password_keeper/domain/models/account.dart';

class AccountRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore db;
  AccountRepository({required this.auth, required this.db});

  User get user => auth.currentUser!;

  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  Future<UserCredential> signUpWithEmail({
    required String fullname,
    required String email,
    required String password,
  }) async {
    final newUser = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await user.updateDisplayName(fullname);
    return newUser;
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (!user.emailVerified) {
      await sendEmailVerification();
    }
  }

  Future<void> sendEmailVerification() async {
    await auth.currentUser!.sendEmailVerification();
  }

  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');

      return await auth.signInWithPopup(googleProvider);
    } else {
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

        return userCredential;
      }
      return null;
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await auth.signOut();
  }

  Future<void> deleteAccount() async {
    await auth.currentUser!.delete();
  }

  Future createUser(AccountProfile profile) async {
    await db
            .collection(AppConfig.userCollection)
            .doc(profile.userId)
            .collection(AppConfig.profileCollection)
            .add(profile.toJson())
        //    .then((value) => value.snapshots().first.)
        ;
  }
}
