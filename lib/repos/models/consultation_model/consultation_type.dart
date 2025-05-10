class ConsultationType {
  final String? name;
  final String? description;

  ConsultationType({this.name, this.description});

  factory ConsultationType.fromJson(Map<String, dynamic> json) {
    return ConsultationType(
      name: json['name'] as String?,
      description: json['description'] as String?,
    );
  }
}
