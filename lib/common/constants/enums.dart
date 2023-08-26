import 'package:flutter/material.dart';
import 'package:password_keeper/presentation/theme/export.dart';

enum LoadedType { start, finish }

enum SnackBarType { done, error, warning }

enum NetworkMethod { get, post, delete, path, put }

enum PasswordStrengthLevel {
  veryWeak(color: AppColors.red, lineLength: 1 / 4),
  weak(color: AppColors.orange, lineLength: 2 / 4),
  good(color: AppColors.blue, lineLength: 3 / 4),
  strong(color: AppColors.green, lineLength: 4 / 4);

  const PasswordStrengthLevel({
    required this.color,
    required this.lineLength,
  });
  final Color color;
  final double lineLength;
}

enum CryptoHashAlgorithm { sha1, sha256, sha512, md5 }

enum EncryptionType {
  aesCbc256B64(0),
  aesCbc128HmacSha256B64(1),
  aesCbc256HmacSha256B64(2),
  rsa2048OaepSha256B64(3),
  rsa2048OaepSha1B64(4),
  rsa2048OaepSha256HmacSha256B64(5),
  rsa2048OaepSha1HmacSha256B64(6);

  const EncryptionType(this.id);
  final int id;
}

enum StorageLocation {
  both,
  disk,
  memory,
}

enum HkdfAlgorithm {
  sha256(1),
  sha512(2),
  ;

  const HkdfAlgorithm(this.id);
  final int id;
}

enum HashPurpose {
  serverAuthorization(1),
  localAuthorization(2);

  const HashPurpose(this.id);
  final int id;
}
