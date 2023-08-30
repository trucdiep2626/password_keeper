import 'package:dargon2_flutter/dargon2_flutter.dart';
import 'package:flutter/material.dart';
import 'package:password_keeper/common/config/database/firebase_config.dart';
import 'package:password_keeper/common/config/database/hive_services.dart';
import 'package:password_keeper/common/injector/injector.dart';

import 'presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseSetup().setUp();
  configLocator();
  final hiveSetUp = getIt<HiveServices>();
  await hiveSetUp.init();
  // final pref = getIt<SharePreferencesConstants>();
  // await pref.init();
//  await HiveServices.init();
//  await pref.clearDataOnReinstall();
  DArgon2Flutter.init();
  runApp(const App());
}
