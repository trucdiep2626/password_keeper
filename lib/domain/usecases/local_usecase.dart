import 'package:password_keeper/data/local_repository.dart';

class LocalUseCase {
  LocalRepository localRepository;

  LocalUseCase({required this.localRepository});

  // dynamic getLocalValue({required String key}) =>
  //     localRepository.getLocalValue(key: key);
  //
  // Future<void> setLocalValue({required String key, dynamic value}) async {
  //   return await localRepository.setLocalValue(key: key, value: value);
  // }

  Future<void> saveDataInBiometricStorage({dynamic value}) async {
    await localRepository.saveDataInBiometricStorage(value: value);
  }

  Future<String?> getDataInBiometricStorage() async {
    return await localRepository.getDataInBiometricStorage();
  }

  Future saveSecureData({required String key, dynamic value}) async {
    await localRepository.saveSecureData(key: key, value: value);
  }

  Future<String?> getSecureData({required String key}) async {
    return await localRepository.getSecureData(key: key);
  }

  Future<void> deleteAllSecureData() async {
    await localRepository.deleteAllSecureData();
  }

  Future<void> clearBiometricStorage() async {
    await localRepository.clearBiometricStorage();
  }
}
