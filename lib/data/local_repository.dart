import 'package:password_keeper/common/config/database/hive_services.dart';

class LocalRepository {
  final HiveServices hiveServices;

  LocalRepository({required this.hiveServices});

  dynamic getLocalValue({required String key}) => hiveServices.hiveBox.get(key);

  Future<void> setLocalValue({required String key, dynamic value}) async {
    return await hiveServices.hiveBox.put(key, value);
  }
}
