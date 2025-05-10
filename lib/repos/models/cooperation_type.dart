class CooperationType {
  final int? id;
  final String? name;
  final String? description;
  final List<Requirement>? requirements;
  final bool? hasAllDocs;

  CooperationType({
    this.id,
    this.name,
    this.description,
    this.requirements,
    this.hasAllDocs,
  });

  factory CooperationType.fromJson(Map<String, dynamic> json) {
    return CooperationType(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      requirements: (json['requirements'] as List<dynamic>?)
          ?.map((e) => Requirement.fromJson(e))
          .toList(),
      hasAllDocs: json['has_all_docs'] as bool?,
    );
  }
}

class Requirement {
  final String? type;
  final bool? isUploaded;

  Requirement({
    this.type,
    this.isUploaded,
  });

  factory Requirement.fromJson(Map<String, dynamic> json) {
    return Requirement(
      type: json['type'] as String?,
      isUploaded: json['is_uploaded'] as bool?,
    );
  }
}
