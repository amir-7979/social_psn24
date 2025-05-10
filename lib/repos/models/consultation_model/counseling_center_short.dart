class CounselingCenterShort {
  final int? id;
  final String? name;
  final String? address;

  CounselingCenterShort({this.id, this.name, this.address});

  factory CounselingCenterShort.fromJson(Map<String, dynamic> json) {
    return CounselingCenterShort(
      id: json['id'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
    );
  }
}
