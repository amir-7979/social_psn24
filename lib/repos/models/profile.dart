class Profile {
  final int? id;
  final String? name;
  final String? family;
  final String? displayName;
  final String? username;
  final String? photo;
  final String? phone;
  final int? commentsCreated;
  final int? contentCreated;
  final int? upvotes;
  final int? downvotes;
  final String? field;
  final String? biography;
  final String? experience;
  final String? address;
  final List<dynamic>? offices;
  final bool? online;
  final int? allowNotification;
  final dynamic currentUserNotificationEnabled;
  final int? showActivity;
  String? fullName;

  Profile({
    this.id,
    this.name,
    this.family,
    this.displayName,
    this.username,
    this.photo,
    this.phone,
    this.commentsCreated,
    this.contentCreated,
    this.upvotes,
    this.downvotes,
    this.field,
    this.biography,
    this.experience,
    this.address,
    this.offices,
    this.online,
    this.allowNotification,
    this.currentUserNotificationEnabled,
    this.showActivity,
  }){
    fullName = '${name} ${family}';

  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    String? username = json['username'] as String?;
    if (username != null && username.startsWith('@')) {
      username = username.substring(1);
    }
    return Profile(
      id: json['id'] as int?,
      name: json['name'] as String?,
      family: json['family'] as String?,
      displayName: json['display_name'] as String?,
      username: username,
      photo: json['photo'] as String?,
      phone: json['phone'] as String?,
      commentsCreated: json['commentsCreated'] as int?,
      contentCreated: json['contentCreated'] as int?,
      upvotes: json['upvotes'] as int?,
      downvotes: json['downvotes'] as int?,
      field: json['field'] as String?,
      biography: json['biography'] as String?,
      experience: json['experience'] as String?,
      address: json['address'] as String?,
      offices: json['offices'] as List<dynamic>?,
      online: json['online'] as bool?,
      allowNotification: json['allow_notification'] as int?,
      currentUserNotificationEnabled: json['current_user_notification_enabled'],
      showActivity: json['show_activity'] as int?,
    );
  }
}