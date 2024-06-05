import 'permission.dart';

class UserPermissions {
  final int? id;
  final String? name;
  final String? displayName;
  final String? role;
  final List<Permission>? permissions;
  final List<dynamic>? settings; // Add this line

  UserPermissions({this.id, this.name, this.displayName, this.role, this.permissions, this.settings}); // Update this line

  factory UserPermissions.fromJson(Map<String, dynamic> json) {
    return UserPermissions(
      id: json['id'] as int?,
      name: json['name'] as String?,
      displayName: json['display_name'] as String?,
      role: json['role'] as String?,
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((item) => Permission.fromJson(item as Map<String, dynamic>))
          .toList(),
     /* settings: (json['settings'] as List<dynamic>?) // Add this line
          ?.map((item) => dynamic.fromJson(item as Map<String, dynamic>)) // Add this line
          .toList(),*/ // Add this line
    );
  }
}