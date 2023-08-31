import 'package:get/get.dart';
import 'package:password_keeper/common/constants/enums.dart';

class EncryptionHelper {
  static EncryptionType? getEncryptionTypeFromId(int id) {
    return EncryptionType.values.firstWhereOrNull((e) => e.id == id);
  }
}
