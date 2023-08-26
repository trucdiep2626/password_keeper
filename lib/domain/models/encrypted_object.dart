import 'dart:typed_data';

import 'package:password_keeper/domain/models/symmetric_crypto_key.dart';

class EncryptedObject {
  Uint8List? iv;
  Uint8List? data;
  Uint8List? mac;
  SymmetricCryptoKey? key;

  EncryptedObject({
    this.iv,
    this.data,
    this.mac,
    this.key,
  });
}
