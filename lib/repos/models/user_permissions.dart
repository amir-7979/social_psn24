class UserPermissions {
  final String? role;
  final bool? isExpert;
  final List<Permission>? permissions;

  UserPermissions({this.role, this.isExpert, this.permissions});

  factory UserPermissions.fromJson(Map<String, dynamic> json) {
    return UserPermissions(
      role: json['role'] as String?,
      isExpert: json['is_expert'] as bool?,
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((item) => Permission.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Permission {
  final int id;
  final String name;

  Permission({required this.id, required this.name});

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}