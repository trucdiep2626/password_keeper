import 'dart:convert';
import 'dart:typed_data';

import 'package:password_keeper/common/constants/enums.dart';

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
}
