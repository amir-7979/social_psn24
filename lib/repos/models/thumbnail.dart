class Thumbnail {
  final String? id;
  final String? loc;
  final String? type;

  Thumbnail({
    this.id,
    this.loc,
    this.type,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) {
    return Thumbnail(
      id: json['id'],
      loc: json['loc'],
      type: json['type'],
    );
  }
}