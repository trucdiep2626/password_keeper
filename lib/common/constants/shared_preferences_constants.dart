import 'package:shared_preferences/shared_preferences.dart';

class SharePreferencesConstants {
  static late SharedPreferences prefs;

  static String phone = 'phone';

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }
}