import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:password_keeper/common/config/app_config.dart';

class FirebaseSetup {
  late CollectionReference userCollection;
  // late CollectionReference scheduleCollection;
  // late CollectionReference subjectCollection;
  // late DocumentReference developDocument;

  Future<void> setUp() async {
    await Firebase.initializeApp();

    FirebaseDatabase database;
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000); // 10MB cache is enough

    userCollection =
        FirebaseFirestore.instance.collection(AppConfig.userCollection);
    // personalCollection = FirebaseFirestore.instance
    //     .collection(DefaultEnv.scheduleTable)
    //     .doc(DefaultEnv.developDoc)
    //     .collection(DefaultEnv.personalCollection);
    // subjectCollection =
    //     FirebaseFirestore.instance.collection(DefaultEnv.subjectTable);
    // developDocument = FirebaseFirestore.instance
    //     .collection(DefaultEnv.scheduleTable)
    //     .doc(DefaultEnv.developDoc);
  }
}
