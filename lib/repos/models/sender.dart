class Sender {
  final int? id;
  final String? name;
  final String? family;
  final String? photo;
  final String? username;
  final String url = 'https://media.psn24.ir/';

  Sender({this.id, this.name, this.family, this.photo, this.username});

  factory Sender.fromJson(Map<String, dynamic> json) {
    String? photoUrl = json['photo'];
    if (photoUrl != null && photoUrl.isNotEmpty) {
      photoUrl = 'https://media.psn24.ir/$photoUrl';
    }
    return Sender(
      id: json['id'],
      name: json['name'],
      family: json['family'],
      photo: photoUrl,
      username: json['username'] == '@' ? null : json['username'],
    );
  }
}