import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_keeper/common/config/app_config.dart';
import 'package:password_keeper/common/config/database/hive_services.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/domain/models/generated_password_item.dart';
import 'package:password_keeper/domain/models/password_generation_option.dart';
import 'package:password_keeper/domain/models/password_model.dart';

class PasswordRepository {
  final HiveServices hiveServices;
  final FirebaseFirestore db;

  PasswordRepository({
    required this.hiveServices,
    required this.db,
  });

  Future setPasswordGenerationOption({
    required String userId,
    required PasswordGenerationOptions option,
  }) async {
    await db
        .collection(AppConfig.userCollection)
        .doc(userId)
        .collection(AppConfig.passwordGenerationOptionCollection)
        .doc(AppConfig.passwordGenerationOptionCollection)
        .set(option.toJson());
  }

  Future<PasswordGenerationOptions?> getPasswordGenerationOption(
      {required String userId}) async {
    final result = await db
        .collection(AppConfig.userCollection)
        .doc(userId)
        .collection(AppConfig.passwordGenerationOptionCollection)
        .get();

    if (result.docs.isEmpty) {
      return null;
    } else {
      return PasswordGenerationOptions.fromJson(result.docs.first.data());
    }
  }

  Future<void> addGeneratedPassword({
    required String userId,
    required GeneratedPasswordItem passwordItem,
  }) async {
    await db
        .collection(AppConfig.userCollection)
        .doc(userId)
        .collection(AppConfig.generatedPasswordsCollection)
        //    .doc(passwordItem.id)
        .add(passwordItem.toJson());
  }

  Future<int> getGeneratedPasswordHistoryLength(
      {required String userId}) async {
    final response = await db
        .collection(AppConfig.userCollection)
        .doc(userId)
        .collection(AppConfig.generatedPasswordsCollection)
        .get();

    return response.docs.length;
  }

  Future<bool> deleteOldestGeneratedHistory({required String userId}) async {
    final oldestItem = await db
        .collection(AppConfig.userCollection)
        .doc(userId)
        .collection(AppConfig.generatedPasswordsCollection)
        .orderBy('created_at', descending: false)
        .limit(1)
        .get();

    if (oldestItem.docs.isEmpty) {
      return false;
    } else {
      await db
          .collection(AppConfig.userCollection)
          .doc(userId)
          .collection(AppConfig.generatedPasswordsCollection)
          .doc(oldestItem.docs.first.id)
          .delete();
    }

    return true;
  }

  Future<GeneratedPasswordItem?> getLatestGeneratedHistory(
      {required String userId}) async {
    final latest = await db
        .collection(AppConfig.userCollection)
        .doc(userId)
        .collection(AppConfig.generatedPasswordsCollection)
        .orderBy('created_at', descending: true)
        .limit(1)
        .get();

    if (latest.docs.isEmpty) {
      return null;
    }
    Map<String, dynamic> password = {};
    password.addAll({'id': latest.docs.first.id});
    password.addAll(latest.docs.first.data());
    GeneratedPasswordItem latestItem = GeneratedPasswordItem.fromJson(password);

    return latestItem;
  }

  Future<List<GeneratedPasswordItem>> getGeneratedPasswordHistory({
    required String userId,
    GeneratedPasswordItem? lastItem,
    required int pageSize,
  }) async {
    final response = lastItem == null
        ? await db
            .collection(AppConfig.userCollection)
            .doc(userId)
            .collection(AppConfig.generatedPasswordsCollection)
            .orderBy('created_at', descending: true)
            .limit(pageSize)
            .get()
        : await db
            .collection(AppConfig.userCollection)
            .doc(userId)
            .collection(AppConfig.generatedPasswordsCollection)
            .orderBy('created_at', descending: true)
            .startAfter([lastItem.createdAt])
            .limit(pageSize)
            .get();

    if (response.docs.isEmpty) {
      return <GeneratedPasswordItem>[];
    } else {
      List<GeneratedPasswordItem> generatedPasswords = [];
      for (var item in response.docs) {
        Map<String, dynamic> password = {};
        password.addAll({'id': item.id});
        password.addAll(item.data());
        GeneratedPasswordItem generatedPasswordItem =
            GeneratedPasswordItem.fromJson(password);
        generatedPasswords.add(generatedPasswordItem);
      }

      return generatedPasswords;
    }
  }

  Future<void> addPasswordItem({
    required String userId,
    required PasswordItem passwordItem,
  }) async {
    await db
        .collection(AppConfig.userCollection)
        .doc(userId)
        .collection(AppConfig.passwordsCollection)
        .add(passwordItem.toJson());
  }

  Future<void> editPasswordItem({
    required String userId,
    required PasswordItem passwordItem,
  }) async {
    await db
        .collection(AppConfig.userCollection)
        .doc(userId)
        .collection(AppConfig.passwordsCollection)
        .doc(passwordItem.id)
        .update(passwordItem.toJson());
  }

  Future<List<PasswordItem>> getPasswordList({
    required String userId,
    PasswordItem? lastItem,
    int? pageSize,
  }) async {
    DocumentSnapshot? startAfterDoc;
    if (lastItem != null) {
      // Get the document after which we want to start
      startAfterDoc = await db
          .collection(AppConfig.userCollection)
          .doc(userId)
          .collection(AppConfig.passwordsCollection)
          .doc(lastItem.id)
          .get();

      if (!startAfterDoc.exists) {
        throw Exception("Document doesn't exist");
      }
    }

    QuerySnapshot<Map<String, dynamic>> response;

    if (pageSize == null) {
      response = await db
          .collection(AppConfig.userCollection)
          .doc(userId)
          .collection(AppConfig.passwordsCollection)
          .get();
    } else {
      response = startAfterDoc == null
          ? await db
              .collection(AppConfig.userCollection)
              .doc(userId)
              .collection(AppConfig.passwordsCollection)
              .orderBy('sign_in_location', descending: false)
              .orderBy('user_id', descending: false)
              .limit(pageSize)
              .get()
          : await db
              .collection(AppConfig.userCollection)
              .doc(userId)
              .collection(AppConfig.passwordsCollection)
              .orderBy('sign_in_location', descending: false)
              .orderBy('user_id', descending: false)
              .startAfterDocument(startAfterDoc)
              .limit(pageSize)
              .get();
    }

    if (response.docs.isEmpty) {
      return <PasswordItem>[];
    } else {
      List<PasswordItem> passwords = [];
      for (var item in response.docs) {
        Map<String, dynamic> password = {};
        password.addAll({'id': item.id});
        password.addAll(item.data());
        PasswordItem passwordItem = PasswordItem.fromJson(password);
        passwords.add(passwordItem);
      }

      return passwords;
    }
  }

  Future<int> getPasswordListLength({required String userId}) async {
    final response = await db
        .collection(AppConfig.userCollection)
        .doc(userId)
        .collection(AppConfig.passwordsCollection)
        .get();

    return response.docs.length;
  }

  Future<bool> deletePassword({
    required String userId,
    required String itemId,
  }) async {
    if (isNullEmpty(userId) || isNullEmpty(itemId)) {
      return false;
    }

    await db
        .collection(AppConfig.userCollection)
        .doc(userId)
        .collection(AppConfig.passwordsCollection)
        .doc(itemId)
        .delete();
    return true;
  }

  Future<void> updatePasswordList({
    required String userId,
    required List<PasswordItem> passwords,
  }) async {
    final passwordsCollection = await db
        .collection(AppConfig.userCollection)
        .doc(userId)
        .collection(AppConfig.passwordsCollection)
        .get();
    final totalPwdDocs = passwordsCollection.docs.length;
    final batches =
        (totalPwdDocs / 500).ceil(); // Calculate how many batches needed

    for (var i = 0; i < batches; i++) {
      // Creating a new batch for each bunch of 500 documents
      final batch = db.batch();
      final docs = passwordsCollection.docs.skip(i * 500).take(500);

      for (final doc in docs) {
        final docRef = db
            .collection(AppConfig.userCollection)
            .doc(userId)
            .collection(AppConfig.passwordsCollection)
            .doc(doc.id);
        batch.update(docRef,
            passwords[i].toJson()); // Update the 'myField' of each document
      }

      await batch.commit(); // Committing after each 500 operations.
    }
  }
}
