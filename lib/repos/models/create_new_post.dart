class CreateNewPost {
  final String? id;
  final String? typename;

  CreateNewPost({
    this.id,
    this.typename,
  });

  factory CreateNewPost.fromJson(Map<String, dynamic> json) {
    return CreateNewPost(
      id: json['id'] as String?,
      typename: json['__typename'] as String?,
    );
  }
}
