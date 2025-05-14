class PostMedia {
  final String? id;
  final String? loc;
  final String? type;
  final int? order;
  final String? typename;
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
      return (loc ?? '');
    } else if (type!.contains('video')) {
      return (loc ?? '');
    } else {
      return null;
    }
  }
}
