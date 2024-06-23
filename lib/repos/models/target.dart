class Target {
  final String? name;
  final String? family;
  final String? photo;
  final int? id;

  Target({
    this.name,
    this.family,
    this.photo,
    this.id,
  });

  factory Target.fromJson(Map<String, dynamic> json) {
    return Target(
      name: json['name'],
      family: json['family'],
      photo: json['photo'],
      id: json['id'],
    );
  }
}