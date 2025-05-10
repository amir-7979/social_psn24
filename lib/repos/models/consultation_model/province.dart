class Province {
  final int? id;
  final String? name;

  Province({this.id, this.name});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }
}

typedef City = Province;
