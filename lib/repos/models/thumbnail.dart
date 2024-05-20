class Thumbnail {
  final String? loc;
  final String? type;

  Thumbnail({this.loc, this.type});

  factory Thumbnail.fromJson(Map<String, dynamic> json) {
    return Thumbnail(
      loc: json['loc'] as String?,
      type: json['type'] as String?,
    );
  }
}