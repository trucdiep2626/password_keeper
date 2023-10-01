import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_keeper/common/constants/constants.dart';

class LocalRepository {
  // final HiveServices hiveServices;
  final FlutterSecureStorage prefs;
  final BiometricStorage biometricStorage;

  LocalRepository({
    //  required this.hiveServices,
    required this.prefs,
    required this.biometricStorage,
  });

  Future<BiometricStorageFile>? _storageFileCached;

  Future<BiometricStorageFile> get _storageFile =>
      _storageFileCached ??= biometricStorage.getStorage(
        Constants.storageFileName,
        options: StorageFileInitOptions(
          authenticationValidityDurationSeconds: 60,
        ),
      );

  Future<void> saveDataInBiometricStorage({dynamic value}) async {
    final storage = await _storageFile;
    await storage.write(value);
  }

  Future<String?> getDataInBiometricStorage() async {
    final storage = await _storageFile;
    return await storage.read();
  }

  // dynamic getLocalValue({required String key}) => hiveServices.hiveBox.get(key);
  //
  // Future<void> setLocalValue({required String key, dynamic value}) async {
  //   return await hiveServices.hiveBox.put(key, value);
  // }

  Future saveSecureData({required String key, dynamic value}) async {
    await prefs.write(key: key, value: value);

    final result = getSecureData(key: key);
  }

  Future<String?> getSecureData({required String key}) async {
    try {
      return await prefs.read(key: key);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteAllSecureData() async {
    await prefs.deleteAll();
  }

  Future<void> deleteSecureData({required String key}) async {
    await prefs.delete(key: key);
  }

  // Future<void> clearLocalData() async {
  //   await hiveServices.hiveBox.clear();
  // }

  Future<void> clearBiometricStorage() async {
    await _storageFile.then((value) => value.delete());
    _storageFileCached = null;
  }
}
