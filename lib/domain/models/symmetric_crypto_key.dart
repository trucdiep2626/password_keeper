import 'dart:convert';
import 'dart:typed_data';

import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/encryption_helper.dart';

class SymmetricCryptoKey {
  Uint8List? key;
  Uint8List? encKey;
  Uint8List? macKey;
  EncryptionType? encType;
  String? keyB64;
  String? encKeyB64;
  String? macKeyB64;

  SymmetricCryptoKey({Uint8List? key, EncryptionType? encType}) {
    if (key == null) {
      throw Exception("Must provide key.");
    }

    if (encType == null) {
      if (key.length == 32) {
        encType = EncryptionType.aesCbc256B64;
      } else if (key.length == 64) {
        encType = EncryptionType.aesCbc256HmacSha256B64;
      } else {
        throw Exception("Unable to determine encType.");
      }
    }

    this.key = key;
    this.encType = encType;

    if (encType == EncryptionType.aesCbc256B64 && key.length == 32) {
      encKey = key;
      macKey = null;
    } else if (encType == EncryptionType.aesCbc128HmacSha256B64 &&
        key.length == 32) {
      encKey = key.sublist(0, 16);
      macKey = key.sublist(16, 32);
    } else if (encType == EncryptionType.aesCbc256HmacSha256B64 &&
        key.length == 64) {
      encKey = key.sublist(0, 32);
      macKey = key.sublist(32, 64);
    } else {
      throw Exception("Unsupported encType/key length.");
    }

    keyB64 = base64Encode(key);
    encKeyB64 = base64Encode(encKey!);
    macKeyB64 = macKey != null ? base64Encode(macKey!) : '';
  }

  SymmetricCryptoKey.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    encKey = json['enc_key'];
    macKey = json['mac_key'];
    encType = json['enc_type'] != null
        ? EncryptionHelper.getEncryptionTypeFromId(json['enc_type'])
        : null;
    keyB64 = json['key_b64'];
    encKeyB64 = json['enc_key_b64'];
    macKeyB64 = json['mac_key_b64'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['enc_key'] = this.encKey;
    data['mac_key'] = this.macKey;
    data['enc_type'] = this.encType?.id;
    data['key_b64'] = this.keyB64;
    data['enc_key_b64'] = this.encKeyB64;
    data['mac_key_b64'] = this.macKeyB64;
    return data;
  }
}
