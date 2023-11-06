class GeneratedPasswordItem {
  String? password;
  String? id;
  int? createdAt;
  GeneratedPasswordItem({
    this.password,
    this.id,
    this.createdAt,
  });

  GeneratedPasswordItem copyWith({
    String? password,
    String? id,
    int? createdAt,
  }) =>
      GeneratedPasswordItem(
        password: password ?? this.password,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
      );

  GeneratedPasswordItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = id;
    data['password'] = password;
    data['created_at'] = createdAt;
    return data;
  }
}
