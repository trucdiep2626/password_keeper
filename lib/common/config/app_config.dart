import 'package:flutter/material.dart';

class AppConfig {
  static late GlobalKey<NavigatorState> navigatorKey;

  /// Fonts
  static String googleSansFonts = 'GoogleSF';
  static String dancingScript = 'DancingScript';
  static String pacifico = 'Pacifico';

  static String defaultLocate = 'vi_VN';

  static String firebaseUid = '';

  static const String database = 'pimi_db';

  //firebase
  static const String userCollection = 'users';
  static const String profileCollection = 'profile';
  static const String passwordGenerationOptionCollection =
      'password_generation_option';
  static const String generatedPasswordsCollection = 'generated_passwords';
  static const String passwordsCollection = 'passwords';
}
