import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_keeper/common/config/database/hive_services.dart';

class LocalRepository {
  final HiveServices hiveServices;
  final FlutterSecureStorage prefs;

  LocalRepository({
    required this.hiveServices,
    required this.prefs,
  });

  dynamic getLocalValue({required String key}) => hiveServices.hiveBox.get(key);

  Future<void> setLocalValue({required String key, dynamic value}) async {
    return await hiveServices.hiveBox.put(key, value);
  }

  Future saveSecureData({required String key, dynamic value}) async {
    await prefs.write(key: key, value: value);
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

  Future<void> clearLocalData() async {
    await hiveServices.hiveBox.clear();
  }
}
