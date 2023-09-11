import 'dart:convert';
import 'dart:typed_data';

import 'package:password_keeper/domain/models/encrypted_string.dart';

class PasswordItem {
  String? id;
  String? url;
  String? appName;
  Uint8List? appIcon;
  String? userId;
  EncryptedString? password;
  String? note;
  int? createdAt;
  int? updatedAt;

  PasswordItem({
    this.id,
    this.url,
    this.userId,
    this.password,
    this.note,
    this.appIcon,
    this.appName,
    this.createdAt,
    this.updatedAt,
  });

  PasswordItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    //  password = json['password'];

    password = json['password'] == null
        ? null
        : EncryptedString.fromString(encryptedString: json['password']);

    url = json['url'];

    userId = json['user_id'];
    note = json['note'];
    appName = json['app_name'];
    appIcon = json['app_icon'] == null ? null : base64.decode(json['app_icon']);

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (password != null) {
      data['password'] = password!.encryptedString;
    }
    data['url'] = url;
    data['user_id'] = userId;
    data['note'] = note;
    data['app_name'] = appName;
    if (appIcon != null) {
      data['app_icon'] = base64.encode(appIcon!.toList());
    }
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}
