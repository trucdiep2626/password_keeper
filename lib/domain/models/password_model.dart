import 'dart:convert';
import 'dart:typed_data';

import 'package:azlistview/azlistview.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/password_helper.dart';

class PasswordItem extends ISuspensionBean {
  String? id;
  bool? isApp;
  String? signInLocation;
  Uint8List? appIcon;
  String? userId;
  String? password;
  String? note;
  int? createdAt;
  int? updatedAt;
  PasswordStrengthLevel? passwordStrengthLevel;
  String? tagIndex;

  PasswordItem({
    this.id,
    this.isApp = false,
    this.userId,
    this.password,
    this.note,
    this.appIcon,
    this.signInLocation,
    this.createdAt,
    this.updatedAt,
    this.passwordStrengthLevel,
    this.tagIndex,
  });

  PasswordItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    //  password = json['password'];

    password = json['password'];
    // == null
    // ? null
    // : EncryptedString.fromString(encryptedString: json['password']);

    isApp = json['is_app'];

    userId = json['user_id'];
    note = json['note'];
    signInLocation = json['sign_in_location'];
    appIcon = json['app_icon'] == null ? null : base64.decode(json['app_icon']);

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    passwordStrengthLevel = PasswordHelper.getPasswordStrengthFromId(
        json['password_strength_level']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    // data['id'] = id;
    //if (password != null) {
    data['password'] = password;
    //!.encryptedString;
    //   }
    data['is_app'] = isApp;
    data['user_id'] = userId;
    data['note'] = note;
    data['sign_in_location'] = signInLocation;
    if (appIcon != null) {
      data['app_icon'] = base64.encode(appIcon!.toList());
    }
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['password_strength_level'] = passwordStrengthLevel?.id;
    return data;
  }

  @override
  String getSuspensionTag() => tagIndex ?? '';

  PasswordItem copyWith({
    String? id,
    bool? isApp,
    String? signInLocation,
    Uint8List? appIcon,
    String? userId,
    String? password,
    String? note,
    int? createdAt,
    int? updatedAt,
    PasswordStrengthLevel? passwordStrengthLevel,
  }) =>
      PasswordItem(
        id: id ?? this.id,
        isApp: isApp ?? this.isApp,
        signInLocation: signInLocation ?? this.signInLocation,
        appIcon: appIcon ?? this.appIcon,
        userId: userId ?? this.userId,
        password: password ?? this.password,
        note: note ?? this.note,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        passwordStrengthLevel:
            passwordStrengthLevel ?? this.passwordStrengthLevel,
      );
}
