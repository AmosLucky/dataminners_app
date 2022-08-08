class MenuModel {
  String? id;
  String? title;
  String? url;
  String? icon;

  MenuModel({
    this.id,
    this.title,
    this.url,
    this.icon,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
        title: json["title"],
        url: json["url"],
        icon: json["icon"],
        id: json['id']);
  }
}
