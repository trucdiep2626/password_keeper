import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_keeper/common/config/database/hive_type_constants.dart';

class HiveServices {
  late Box<dynamic> hiveBox;
  late Box<dynamic> generatedPasswordBox;

  Future<void> init() async {
    await Hive.initFlutter();

    hiveBox = await Hive.openBox(HiveKey.boxKey);
    generatedPasswordBox = await Hive.openBox(HiveKey.generatedPasswordKey);
  }

  void dispose() {
    // personalBox.compact();
    // scheduleBox.compact();
    generatedPasswordBox.compact();
    hiveBox.compact();
    Hive.close();
  }
}
