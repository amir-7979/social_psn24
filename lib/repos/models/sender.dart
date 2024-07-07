class Sender {
  final int? id;
  final String? name;
  final String? family;
  final String? photo;
  final String? username;

  Sender({this.id, this.name, this.family, this.photo, this.username});

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['id'],
      name: json['name'],
      family: json['family'],
      photo: json['photo'],
      username: json['username'] == '@' ? null : json['username'],
    );
  }
}