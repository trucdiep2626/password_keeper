import 'package:get/get.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/encryption_helper.dart';
import 'package:password_keeper/domain/models/symmetric_crypto_key.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';

class EncryptedString {
  String? decryptedValue;
  EncryptionType? encryptionType;
  String? encryptedString;
  String? iv;
  String? data;
  String? mac;

  final cryptoService = Get.find<CryptoController>();

  EncryptedString({
    this.encryptionType,
    required this.data,
    String? iv,
    String? mac,
  }) {
    if (data == null || (data ?? '').isEmpty) {
      throw ArgumentError("data cannot be null or empty.");
    }

    this.iv = iv;
    this.mac = mac;

    if (iv != null) {
      encryptedString = "${encryptionType?.id}.$iv|$data";
    } else {
      encryptedString = "${encryptionType?.id}.$data";
    }

    if (mac != null) {
      encryptedString = "$encryptedString|$mac";
    }
  }

  EncryptedString.fromJson(Map<String, dynamic> json) {
    decryptedValue = json['decrypted_value'];
    encryptedString = json['encrypted_string'];
    encryptionType = json['encryption_type'] != null
        ? EncryptionHelper.getEncryptionTypeFromId(json['encryption_type'])
        : null;
    iv = json['iv'];
    data = json['data'];
    mac = json['mac'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['decrypted_value'] = this.decryptedValue;
    data['encrypted_string'] = this.encryptedString;
    data['encryption_type'] = this.encryptionType?.id;
    data['iv'] = this.iv;
    data['data'] = this.data;
    data['mac'] = this.mac;
    return data;
  }

  EncryptedString.fromString({String? encryptedString}) {
    if (encryptedString == null || encryptedString.isEmpty) {
      throw ArgumentError("encryptedString cannot be null or empty.");
    }

    this.encryptedString = encryptedString;
    var headerPieces = encryptedString.split('.');
    List<String> encPieces;

    if (headerPieces.length == 2 && int.tryParse(headerPieces[0]) != null) {
      encryptionType = EncryptionType.values[int.parse(headerPieces[0])];
      encPieces = headerPieces[1].split('|');
    } else {
      encPieces = encryptedString.split('|');
      encryptionType = encPieces.length == 3
          ? EncryptionType.aesCbc128HmacSha256B64
          : EncryptionType.aesCbc256B64;
    }

    switch (encryptionType) {
      case EncryptionType.aesCbc128HmacSha256B64:
      case EncryptionType.aesCbc256HmacSha256B64:
        if (encPieces.length != 3) {
          return;
        }
        iv = encPieces[0];
        data = encPieces[1];
        mac = encPieces[2];
        break;
      case EncryptionType.aesCbc256B64:
        if (encPieces.length != 2) {
          return;
        }
        iv = encPieces[0];
        data = encPieces[1];
        break;
      case EncryptionType.rsa2048OaepSha256B64:
      case EncryptionType.rsa2048OaepSha1B64:
        if (encPieces.length != 1) {
          return;
        }
        data = encPieces[0];
        break;
      default:
        return;
    }
  }

  Future<String> decryptAsync({String? orgId, SymmetricCryptoKey? key}) async {
    if (decryptedValue != null) {
      return decryptedValue!;
    }

    // Replace the implementation of the cryptoService in Flutter with the actual decryption logic.
    // You may use a third-party library that provides encryption/decryption or call a native implementation via platform channels.
    // cryptoService.GetOrgKeyAsync() and cryptoService.DecryptToUtf8Async() methods should be replaced with actual implementations.
    try {
      // For demonstration purposes, we assume cryptoService is a valid object that can decrypt data.
      // Replace this part with your actual decryption logic.
      key ??= await cryptoService.getOrgKeyFromString(orgId: orgId);
      decryptedValue =
          await cryptoService.decryptToUtf8(encString: this, key: key);
    } catch (e) {
      decryptedValue = "[error: cannot decrypt]";
    }
    return decryptedValue ?? '';
  }
}
