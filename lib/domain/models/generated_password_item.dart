class GeneratedPasswordItem {
  String? password;
  String? id;
  String? createAt;
  GeneratedPasswordItem({
    this.password,
    this.id,
    this.createAt,
  });

  GeneratedPasswordItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
    createAt = json['create_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['password'] = password;
    data['create_at'] = createAt;
    return data;
  }
}
