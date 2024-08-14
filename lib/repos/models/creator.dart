class Creator {
  final int? id;
  final String? name;
  final String? family;
  final String? username;
  final String? photo;
  final bool? online;
  final String? displayName;
  final int? showActivity;
  final String url = 'https://media.psn24.ir/';

  Creator({
    this.id,
    this.name,
    this.family,
    this.username,
    this.photo,
    this.online,
    this.displayName,
    this.showActivity,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    String? photoUrl = json['photo'];
    if (photoUrl != null && photoUrl.isNotEmpty) {
      photoUrl = 'https://media.psn24.ir/$photoUrl';
    }

    return Creator(
      id: json['id'],
      name: json['name'],
      family: json['family'],
      username: json['username'],
      photo: photoUrl,
      online: json['online'],
      displayName: json['display_name'],
      showActivity: json['show_activity'],
    );
  }
}
