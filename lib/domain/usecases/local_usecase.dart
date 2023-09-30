import 'package:password_keeper/data/local_repository.dart';

class LocalUseCase {
  LocalRepository localRepository;

  LocalUseCase({required this.localRepository});

  dynamic getLocalValue({required String key}) =>
      localRepository.getLocalValue(key: key);

  Future<void> setLocalValue({required String key, dynamic value}) async {
    return await localRepository.setLocalValue(key: key, value: value);
  }

  Future saveSecureData({required String key, dynamic value}) async {
    await localRepository.saveSecureData(key: key);
  }

  Future<String?> getSecureData({required String key}) async {
    return await localRepository.getSecureData(key: key);
  }
}
