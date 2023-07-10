import 'package:password_keeper/common/constants/shared_preferences_constants.dart';

class LocalRepository {
  Future<void> setPhone(String phone) async {
    await SharePreferencesConstants.prefs
        .setString(SharePreferencesConstants.phone, phone);
  }

  String getPhone() {
    return SharePreferencesConstants.prefs
            .getString(SharePreferencesConstants.phone) ??
        '';
  }
}
