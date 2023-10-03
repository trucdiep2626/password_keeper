import 'package:flutter/material.dart';
import 'package:password_keeper/presentation/theme/export.dart';

enum LoadedType { start, finish }

enum SnackBarType { done, error, warning }

enum NetworkMethod { get, post, delete, path, put }

enum PasswordStrengthLevel {
  veryWeak(id: 0, color: AppColors.red, lineLength: 1 / 4, value: 'Very weak'),
  weak(id: 1, color: AppColors.orange, lineLength: 2 / 4, value: 'Weak'),
  good(id: 2, color: AppColors.blue, lineLength: 3 / 4, value: 'Good'),
  strong(id: 3, color: AppColors.green, lineLength: 4 / 4, value: 'Strong');

  const PasswordStrengthLevel({
    required this.id,
    required this.color,
    required this.lineLength,
    required this.value,
  });

  final int id;
  final Color color;
  final double lineLength;
  final String value;
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

enum PasswordType {
  password,
  passphrase,
}

enum FilteredType {
  weak,
  safe,
  reused,
}
