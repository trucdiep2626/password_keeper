import 'package:password_keeper/domain/models/encrypted_string.dart';
import 'package:password_keeper/domain/models/symmetric_crypto_key.dart';

class EncKeyResult {
  SymmetricCryptoKey? key;
  EncryptedString? encKey;

  EncKeyResult({this.key, this.encKey});
}
