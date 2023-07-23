import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseSetup {
  late CollectionReference personalCollection;
  late CollectionReference scheduleCollection;
  late CollectionReference subjectCollection;
  late DocumentReference developDocument;

  Future<void> setUp() async {
    await Firebase.initializeApp();
    // scheduleCollection = FirebaseFirestore.instance
    //     .collection(DefaultEnv.scheduleTable)
    //     .doc(DefaultEnv.developDoc)
    //     .collection(DefaultEnv.schoolCollection);
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