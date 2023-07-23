import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountRepository {
  final FirebaseAuth auth;
  AccountRepository({required this.auth});

  User get user => auth.currentUser!;

  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final user = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return user;
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

  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');

      await auth.signInWithPopup(googleProvider);
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
      }
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> deleteAccount() async {
    await auth.currentUser!.delete();
  }
}
