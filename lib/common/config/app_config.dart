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
  static const String financeCollection = 'finance';
  static const String workflowCollection = 'workflow';
  static const String walletsCollection = 'wallets';
  static const String transactionCollection = 'transactions';
}