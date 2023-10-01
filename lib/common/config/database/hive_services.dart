// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:password_keeper/common/config/database/local_key.dart';
//
// class HiveServices {
//   late Box<dynamic> hiveBox;
//   // late Box<dynamic> generatedPasswordBox;
//
//   Future<void> init() async {
//     await Hive.initFlutter();
//
//     hiveBox = await Hive.openBox(LocalStorageKey.boxKey);
//     //   generatedPasswordBox = await Hive.openBox(HiveKey.generatedPasswordKey);
//   }
//
//   void dispose() {
//     // personalBox.compact();
//     // scheduleBox.compact();
//     // generatedPasswordBox.compact();
//     hiveBox.compact();
//     Hive.close();
//   }
// }
