class Creator {
  final int id;
  final String phone;
  final String photo;
  final String name;
  final String family;

  Creator({required this.id, required this.phone, required this.photo, required this.name, required this.family});

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'] as int,
      phone: json['phone'] as String,
      photo: json['photo'] as String,
      name: json['name'] as String,
      family: json['family'] as String,
    );
  }
}