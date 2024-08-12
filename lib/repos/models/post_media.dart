class PostMedia {
  final String? id;
  final String? loc;
  final String? type;
  final int? order;
  final String? typename;
  final String url = 'https://media.psn24.ir/';
  PostMedia({
    this.id,
    this.loc,
    this.type,
    this.order,
    this.typename,
  });

  factory PostMedia.fromJson(Map<String, dynamic> json) {
    return PostMedia(
      id: json['id'] as String?,
      loc: json['loc'] as String?,
      type: json['type'] as String?,
      order: json['order'] as int?,
      typename: json['__typename'] as String?,
    );
  }
  get mediaUrl {
    if (type!.contains('image') && loc != null) {
      return url + (loc ?? '');
    } else if (type!.contains('video')) {
      return url + (loc ?? '');
    } else {
      return null;
    }
  }
}
