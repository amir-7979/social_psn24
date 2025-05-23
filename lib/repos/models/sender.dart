class Sender {
  final int? id;
  final int? globalId;
  final String? name;
  final String? family;
  final String? photo;
  final String? username;

  Sender({this.id, this.globalId, this.name, this.family, this.photo, this.username});

  factory Sender.fromJson(Map<String, dynamic> json) {
    String? photoUrl = json['photo'];
    if (photoUrl != null && photoUrl.isNotEmpty) {
      photoUrl = photoUrl;
    }
    return Sender(
      id: json['id'],
      globalId: json['global_id'],

      name: json['name'],
      family: json['family'],
      photo: photoUrl,
      username: json['username'] == '@' ? null : json['username'],
    );
  }
}