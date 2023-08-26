import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class HiveConfig {
  // late Box<PersonalScheduleModel> personalBox;
  // late Box<StudentSchedule> scheduleBox;
  // late Box<StudentInfo> studentBox;
  // late Box<HiveScoresCell> hiveScoresCell;

  Future<void> init() async {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    // Hive.registerAdapter(PersonalScheduleModelAdapter());
    // Hive.registerAdapter(StudentScheduleAdapter());
    // Hive.registerAdapter(StudentInfoAdapter());
    // Hive.registerAdapter(HiveScoresCellAdapter());
    // personalBox = await Hive.openBox(HiveKey.personalCollection);
    // scheduleBox = await Hive.openBox(HiveKey.schoolCollection);
    // studentBox = await Hive.openBox(HiveKey.studentInfoCollection);
    // hiveScoresCell = await Hive.openBox(HiveKey.scoresCell);
  }

  void dispose() {
    // personalBox.compact();
    // scheduleBox.compact();
    Hive.close();
  }
}
