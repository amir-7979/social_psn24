class Creator {
  final int? id;
  final String? name;
  final String? family;
  final String? username;
  final String? photo;
  final bool? online;
  final String? displayName;
  final int? showActivity;

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
    return Creator(
      id: json['id'],
      name: json['name'],
      family: json['family'],
      username: '@' + json['username'],
      photo: json['photo'],
      online: json['online'],
      displayName: json['display_name'],
      showActivity: json['show_activity'],
    );
  }
}