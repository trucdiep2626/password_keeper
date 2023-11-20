class LoggedInDevice {
  String? deviceId;
  bool? showChangedMasterPassword;

  LoggedInDevice({
    this.deviceId,
    this.showChangedMasterPassword = false,
  });

  LoggedInDevice copyWith({
    String? deviceId,
    bool? showChangedMasterPassword,
  }) =>
      LoggedInDevice(
        deviceId: deviceId ?? this.deviceId,
        showChangedMasterPassword:
        showChangedMasterPassword ?? this.showChangedMasterPassword,
      );

  LoggedInDevice.fromJson(Map<String, dynamic> json) {
    deviceId = json['device_id'];
    showChangedMasterPassword = json['show_changed_master_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
 //   data['device_id'] = deviceId;
    data['show_changed_master_password'] = showChangedMasterPassword;
    return data;
  }

  @override
  String toString() => toJson().toString();
}
