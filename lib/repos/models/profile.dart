class Profile {
  final int? id;
  final int? globalId;
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
  final List<String>? offices;
  bool? online;
  final int? allowNotification;
  int? currentUserNotificationEnabled;
  int? showActivity;
  final String? fullName;
  final bool? status;
  final List<Map<String, String>>? roles;
  final List<String>? permissions;


  Profile({
    this.id,
    this.globalId,
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
    this.fullName,
    this.status,
    this.roles,
    this.permissions,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    print(json['permissions'].toString());
    String? username = json['username'] as String?;
    if (username != null && username == '@') {
      username = null;
    } else if (username != null && username.startsWith('@')) {
      username = username.substring(1);
    }
    String? newDisplayName = json['display_name'] != null ? json['display_name'] as String? : json['roles'][0]['display_name'] as String?;

    return Profile(
      id: json['id'] as int?,
      globalId: json['global_id'] as int?,
      name: json['name'] as String?,
      family: json['family'] as String?,
      displayName: newDisplayName,
      username: username,
      photo: json['photo'],
      phone: json['phone'] as String?,
      commentsCreated: json['commentsCreated'] as int?,
      contentCreated: json['contentCreated'] as int?,
      upvotes: json['upvotes'] as int?,
      downvotes: json['downvotes'] as int?,
      field: json['field'] as String?,
      biography: json['biography'] as String?,
      experience: json['experience'] as String?,
      address: json['address'] as String?,
      offices: (json['offices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      online: json['online'] as bool?,
      allowNotification: json['allow_notification'] as int?,
      currentUserNotificationEnabled: json['current_user_notification_enabled'],
      showActivity: json['show_activity'] as int?,
      fullName: json['full_name'] as String?,
      status: json['status'] as bool?,
      roles: (json['roles'] as List<dynamic>?)
          ?.map((role) => {
        'name': role['name']?.toString() ?? '',
        'display_name': role['display_name']?.toString() ?? ''
      })
          .toList(),
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }
}
