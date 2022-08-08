class CommentModel {
  String? id;
  String? comment, username, commentDate;
  CommentModel(
      {required this.id,
      required this.comment,
      required this.username,
      required this.commentDate});

  factory CommentModel.fromjson(Map<String, dynamic> json) {
    return CommentModel(
        id: json['id'],
        comment: json['comment'],
        username: json['username'],
        commentDate: json['commentDate']);
  }
}
