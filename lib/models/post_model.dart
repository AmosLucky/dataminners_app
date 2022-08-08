class PostModel {
  String postId;
  String category;
  String type;
  String image;
  String url;
  String title;
  String content;
  String date;
  String commentCount;
  String likeCount;
  String shareCount;
  String? author;
  String? source;

  PostModel(
      {required this.postId,
      required this.category,
      required this.type,
      required this.image,
      required this.url,
      required this.title,
      required this.content,
      required this.date,
      required this.commentCount,
      required this.likeCount,
      required this.shareCount,
      this.author,
      this.source});
  factory PostModel.fromjson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'],
      category: json['category'],
      type: json['type'],
      image: json['image'],
      url: json['url'],
      title: json['title'],
      content: json['content'],
      date: json['postTime'],
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      shareCount: json['shareCount'],
      author: json['author'],
    );
  }
}
