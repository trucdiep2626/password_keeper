
import 'package:flutter/material.dart';
import 'package:password_keeper/common/config/firebase_config.dart';
import 'package:password_keeper/common/constants/shared_preferences_constants.dart';
import 'package:password_keeper/common/injector/injector.dart';

import 'presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseSetup().setUp();
  configLocator();
 // final hiveSetUp = getIt<HiveConfig>();
 // await hiveSetUp.init();
  final pref = getIt<SharePreferencesConstants>();
  await pref.init();
//  await pref.clearDataOnReinstall();
  runApp(const App());
}