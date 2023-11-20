import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseSetup {
  Future<void> setUp() async {
    await Firebase.initializeApp();

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );

    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
  }
}
