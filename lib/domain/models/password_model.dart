import 'package:installed_apps/app_info.dart';

class PasswordModel {
  AppInfo? appInfo;
  String? url;
  String? userId;
  String? password;
  String? note;

  PasswordModel({
    required this.appInfo,
    required this.url,
    required this.userId,
    required this.password,
    required this.note,
  });
}
