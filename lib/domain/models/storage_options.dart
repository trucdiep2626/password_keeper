import 'package:password_keeper/common/constants/enums.dart';

class StorageOptions {
  final StorageLocation? storageLocation;
  final bool? useSecureStorage;
  final String? userId;
  final String? email;
  final bool? skipTokenStorage;

  StorageOptions({
    this.storageLocation,
    this.useSecureStorage,
    this.userId,
    this.email,
    this.skipTokenStorage,
  });

  StorageOptions copyWith(
          {StorageLocation? storageLocation,
          bool? useSecureStorage,
          String? userId,
          String? email,
          bool? skipTokenStorage}) =>
      StorageOptions(
          userId: userId ?? this.userId,
          email: email ?? this.email,
          storageLocation: storageLocation ?? this.storageLocation,
          useSecureStorage: useSecureStorage ?? this.useSecureStorage,
          skipTokenStorage: skipTokenStorage ?? this.skipTokenStorage);
}
