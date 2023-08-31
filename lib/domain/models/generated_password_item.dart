import 'package:hive/hive.dart';
import 'package:password_keeper/common/config/database/hive_type_constants.dart';

part 'generated_password_item.g.dart';

@HiveType(typeId: HiveTypeConstants.generatedPasswordKey)
class GeneratedPasswordItem {
  @HiveField(0)
  String? password;
  @HiveField(1)
  String? id;
  @HiveField(2)
  DateTime? createAt;
  GeneratedPasswordItem({
    this.password,
    this.id,
    this.createAt,
  });
}
