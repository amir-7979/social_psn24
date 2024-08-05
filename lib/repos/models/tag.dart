class Tag {
  final String? id;
  final String? title;
  final String? type;
  final String? typename;

  Tag({
    this.id,
    this.title,
    this.type,
    this.typename,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      typename: json['__typename'],
    );
  }
}
