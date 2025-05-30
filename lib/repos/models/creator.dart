class Creator {
  final int? id;
  final int? globalId;
  final String? name;
  final String? family;
  final String? username;
  final String? photo;
  final bool? online;
  final String? displayName;
  final int? showActivity;

  Creator({
    this.id,
    this.globalId,
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
      photoUrl = photoUrl;
    }

    return Creator(
      id: json['id'],
      globalId: json['global_id'],
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
