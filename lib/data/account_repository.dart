import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:password_keeper/common/config/app_config.dart';
import 'package:password_keeper/common/config/database/hive_services.dart';
import 'package:password_keeper/common/config/database/hive_type_constants.dart';
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
        (hiveServices.hiveBox.get(HiveKey.accountKey)
                as Map<String, dynamic>?) ??
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

  Future<AuthCredential?> signUpWithEmail({
    required String fullname,
    required String email,
    required String password,
  }) async {
    final newUser = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await user?.updateDisplayName(fullname);
    return newUser.credential;
  }

  Future<AuthCredential?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final result = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.credential;
  }

  Future<AuthCredential?> loginWithAuthCredential(
      {required AuthCredential authCredential}) async {
    final result = await auth.signInWithCredential(authCredential);
    return result.credential;
  }

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
    profileJson.addAll({'user_id': response.docs.first.id});
    profileJson.addAll(response.docs.first.data());

    return AccountProfile.fromJson(profileJson);
  }
}