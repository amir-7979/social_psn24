class User {
  final int? id;
  final String? name;
  final String? avatar;

  User({this.id, this.name, this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
    );
  }
}
